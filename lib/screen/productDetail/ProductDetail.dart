import 'package:flutter/material.dart';
import 'package:shopp/models/ProductModel.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as ProductModel;

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          iconTheme: const IconThemeData(
            color: Colors.black87,
          ),
          flexibleSpace: FlexibleSpaceBar(
            title: Text(product.title,
                style: const TextStyle(
                  color: Colors.black,
                )),
            background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                )),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          const SizedBox(height: 20),
          Text(
            "R\$ ${product.price.toStringAsFixed(2)},",
            textAlign: TextAlign.center,
          ),
          Text(
            product.description,
            textAlign: TextAlign.center,
          )
        ]))
      ],
    ));
  }
}
