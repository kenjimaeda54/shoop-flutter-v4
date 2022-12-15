import "package:flutter/material.dart";
import 'package:shopp/Exception/AuthException.dart';
import 'package:shopp/providers/AuthProvider.dart';
import "package:provider/provider.dart";
import 'package:shopp/utils/ConstantsRoutes.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

enum TypeAuth {
  signIn,
  signUp,
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  //global key não pode ficar dentro do build(BuildContext context)
  //https://stackoverflow.com/questions/51320692/flutter-keyboard-disappears-immediately-when-editing-my-text-fields
  final formKey = GlobalKey<FormState>();
  TypeAuth typeAuth = TypeAuth.signIn;
  bool isLoading = false;

  //maneira de criar manualmente animação
  AnimationController? animationController;

  // Animation<Size>? heightAnimation;
  Animation<double>? opacitAnimation;
  Animation<Offset>? slideAnimaiton;

  //para comparar se o as senhas são iguais
  final passwordController = TextEditingController();
  final formData = <String, Object>{};

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    opacitAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      //e argument type 'AnimationController?' can't be assigned to the parameter type 'Animation<double>'
      //precisa forcar o animated animationController
      CurvedAnimation(parent: animationController!, curve: Curves.linear),
    );

    slideAnimaiton =
        Tween<Offset>(begin: const Offset(0, -1.5), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(parent: animationController!, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController?.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   //essa classe implementei o mixin SingleTickerProviderStateMixin
  //   animationController = AnimationController(
  //       vsync: this,
  //       duration: const Duration(
  //         milliseconds: 300,
  //       ));
  //   heightAnimation = Tween(
  //           begin: const Size(double.infinity, 330),
  //           end: const Size(double.infinity, 400))
  //       .animate(CurvedAnimation(
  //           parent: animationController!, curve: Curves.linear));
  //   animationController?.addListener(() => setState(() {}));
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   animationController?.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of(context);
    final deviceSize = MediaQuery.of(context).size;

    void showError(e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(), child: Text("Ok"))
          ],
        ),
      );
    }

    void handleSubmit() async {
      setState(() {
        isLoading = true;
      });
      final validate = formKey.currentState?.validate() ?? false;

      if (!validate) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      formKey.currentState?.save();

      try {
        if (typeAuth == TypeAuth.signIn) {
          await authProvider
              .signIn(
                  email: formData["email"] as String,
                  password: formData["password"] as String)
              .then(
                (value) => setState(() {
                  isLoading = false;
                  Navigator.of(context)
                      .pushReplacementNamed(ConstantRoutes.middleRoute);
                }),
              );
          // entrar
        } else {
          await authProvider
              .signUp(
                  email: formData["email"] as String,
                  password: formData["password"] as String)
              .then((value) => setState(() {
                    isLoading = false;
                    Navigator.of(context)
                        .pushReplacementNamed(ConstantRoutes.middleRoute);
                  }));
        }
      } on AuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        showError(e);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        showError(e);
      }
    }

    String? validatorPasswordIsEqual(String? password) {
      if (password != passwordController.text) {
        return "Senhas precisam ser iguais";
      }
      return null;
    }

    String? validatorPassword(String? password) {
      final text = password ?? "";
      if (text.isEmpty && text.length < 5) {
        return "Senha precisa ser preenchida";
      }
      return null;
    }

    void handleSave({String? text, required String field}) {
      formData[field] = text ?? "";
    }

    String? validatorString(String? email) {
      final text = email ?? "";
      if (text.isEmpty && text.length < 4) {
        return "Email precisa ser preenchidos";
      }
      return null;
    }

    void toggleAuth(TypeAuth auth) {
      setState(() => typeAuth = auth);
      if (auth == TypeAuth.signUp) {
        //estou saindo do menor indo para maior
        //isso e essencial para controller funcionar
        animationController?.forward();
        return;
      }
      animationController?.reverse();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
      // height: heightAnimation?.value.height ??
      //     (typeAuth == TypeAuth.signUp ? 400 : 330),
      height: typeAuth == TypeAuth.signUp ? 400 : 330,
      width: deviceSize.width * 0.78,
      padding: const EdgeInsets.only(top: 20),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 8,
        child: Form(
          key: formKey,
          child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              children: [
                TextFormField(
                  textInputAction: TextInputAction.next,
                  validator: validatorString,
                  onSaved: (text) => handleSave(text: text, field: "email"),
                  decoration: const InputDecoration(label: Text("E-mail")),
                ),
                TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  onSaved: (text) => handleSave(text: text, field: "password"),
                  validator: validatorPassword,
                  decoration: const InputDecoration(
                    label: Text("Senha"),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear,
                  constraints: BoxConstraints(
                    maxHeight: typeAuth == TypeAuth.signIn ? 0 : 120,
                    minHeight: typeAuth == TypeAuth.signIn ? 0 : 60,
                  ),
                  child: FadeTransition(
                    //The argument type 'Animation<double>?' can't be assigned to the parameter type 'Animation<double>'
                    //precisa do !
                    opacity: opacitAnimation!,
                    child: SlideTransition(
                      position: slideAnimaiton!,
                      child: TextFormField(
                        obscureText: true,
                        onSaved: (text) =>
                            handleSave(text: text, field: "confirmPassword"),
                        decoration: const InputDecoration(
                            label: Text("Confirmar senha")),
                        validator: validatorPasswordIsEqual,
                      ),
                    ),
                  ),
                ),
                isLoading
                    //para diminuir um tamanho pode usar o tranform
                    ? Transform.scale(
                        scaleY: 0.6,
                        scaleX: 0.1,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor),
                            ),
                            onPressed: handleSubmit,
                            child: const Text("Entrar")),
                      ),
                typeAuth == TypeAuth.signUp
                    ? TextButton(
                        onPressed: () => toggleAuth(TypeAuth.signIn),
                        child: Text(
                          "Deseja realizar login?",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ))
                    : TextButton(
                        onPressed: () => toggleAuth(TypeAuth.signUp),
                        child: Text(
                          "Deseja registrar?",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ))
              ]),
        ),
      ),
    );
  }
}
