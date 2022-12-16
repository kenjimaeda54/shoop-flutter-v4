import 'package:flutter/material.dart';
import 'package:shopp/models/ProductModel.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as ProductModel;

    return Scaffold(
        //com customScroolView consigo colocar uma imagem no topo do app bar
        //tambem consigo assim que arrastar ficar so aparecendo o titulo some a imagem se usar pined
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
  }
}
