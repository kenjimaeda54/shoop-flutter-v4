# Shoop
Versão 4 do aplicativo de (loja)(https://github.com/kenjimaeda54/shoop-flutter-v1)  </br>
Toque final do aplicativo, finalizei com animações


## Feature
- Abaixo alguns exemplos de animações que e possível fazer no flutter
- Para criar animações com controller precisa implementar o mixin SingleTickerProviderStateMixin

```dart
  AnimationController? animationController;
  Animation<Size>? heightAnimation;
  Animation<double>? opacitAnimation;
  Animation<Offset>? slideAnimaiton;



@override
  void initState() {
    super.initState();
    //essa classe implementei o mixin SingleTickerProviderStateMixin
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 300,
        ));
    heightAnimation = Tween(
            begin: const Size(double.infinity, 330),
            end: const Size(double.infinity, 400))
        .animate(CurvedAnimation(
            parent: animationController!, curve: Curves.linear));
    animationController?.addListener(() => setState(() {}));
     opacitAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
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



```

##
- Flutter também disponibiliza um widget para animação, no exemplo abaixo, estou realizando abertura dos detalhes de um card de maneira suave
- Para evitar overflow precisei aplicar no container pai e no componente que expande quando clicado
- Com um widget não preciso implmentar mixin


```flutter
AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
      height: isExpanded ? heightItensCard() + 85 : 85,
      child: Card(
        elevation: 5,
        child: Column(children: [
          ListTile(
              title: Text("R\$ ${widget.order.total.toStringAsFixed(2)}"),
              subtitle: Text(
                  DateFormat("dd/MM/yyyy  HH:mm").format(widget.order.date)),
              trailing: IconButton(
                  onPressed: handleExpanded,
                  icon: const Icon(Icons.expand_more))),
          //precisa também colocar aqui para evitar overflow
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            height: isExpanded ? heightItensCard() : 0,
            child: ListView(
              children: widget.order.products
                  .map((it) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            it.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${it.quantity}x ${it.price.toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.grey),
                          )
                        ],
                      ))
                  .toList(),
            ),
          ),
        ]),
      ),
    );



```

## 
- Outra animação interessante e usar o Hero
- Com ele consigo aplica um efeito a partir da imagem de origin indo  até  imagem de destino
- Hero obriga o uso de uma tag única, tanto na  origin quanto destino


```flutter
//componente de origin
Hero(
        tag: product.id,
        child: FadeInImage.assetNetwork(
        placeholder: "assets/images/product-placeholder.png",
        image: product.imageUrl,
        fit: BoxFit.cover,
  ),


//componente de destino
 Hero(
      tag: product.id,
      child: Image.network(product.imageUrl, fit: BoxFit.cover),
   ),



```

## 
- CustomScroolView e um componente interessante, permite adicionarmos uma imagem no navigation bar
- Pinned igual a verdadeiro a imagem fica fixa e conforme scrolla a barra fica apenas o titulo
- CustonScroolView utiliza slivers para trabalhar

```flutter
Scaffold( 
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          //background color sera do app bar
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(
            color: Colors.black87,
          ),
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              product.title,
              style: const TextStyle(color: Colors.white),
            ),
            background: Stack(
              //para expandir a foto dentro da stack
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: product.id,
                  child: Image.network(product.imageUrl, fit: BoxFit.cover),
                ),
                //para criar um container decoration
                const DecoratedBox(
                    decoration: BoxDecoration(
                  gradient: LinearGradient(
                      end: Alignment(0, 0),
                      begin: Alignment(0, 0.6),
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0.6),
                        Color.fromRGBO(0, 0, 0, 0)
                      ]),
                ))
              ],
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          const SizedBox(
            height: 20,
          ),
          Text(
            "R\$ ${product.price.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            product.description,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ]))
      ],
    ));

```

##
- Por fim apliquei fade nas transições de telas ,nessa abordagem precisa criar uma classe para extender PageTransitionsBuilder

```flutter
//FadeTransitionRoute
class FadeTransitionRoute extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(PageRoute<T> route, BuildContext context,
      Animation<double> animation, Animation<double> secondaryAnimation,
      Widget child) {
    //como cancelar animação rota especifica
    if (route.settings.name == "/") {
      return child;
    }
    return FadeTransition(opacity: animation, child: child);
  }

}

////main.dart
ThemeData(
     primarySwatch: Colors.blue,
     primaryColor: Colors.purple,
     fontFamily: "Lato",
     colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.deepOrange,
     ),
  ageTransitionsTheme: const PageTransitionsTheme(builders: {
  TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
  TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
})),



```



