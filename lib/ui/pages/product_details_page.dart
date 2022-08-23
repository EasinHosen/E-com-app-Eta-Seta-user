import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helper_function.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({Key? key}) : super(key: key);
  static const String routeName = '/product_details_page';

  @override
  Widget build(BuildContext context) {
    final pid = ModalRoute.of(context)!.settings.arguments as String;
    final provider = Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: provider.getProductById(pid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final product = ProductModel.fromMap(snapshot.data!.data()!);
              provider.getPurchaseByProduct(pid);
              return ListView(
                children: [
                  FadeInImage.assetNetwork(
                    placeholder: 'images/img.png',
                    image: product.imageUrl!,
                    fadeInCurve: Curves.bounceInOut,
                    fadeInDuration: const Duration(seconds: 3),
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  ListTile(
                    title: Text(product.name!),
                  ),
                  ListTile(
                    title: Text(
                        '$currencySymbol ${product.salesPrice.toString()}'),
                  ),
                  ListTile(
                    title: Text(product.description!),
                  ),
                ],
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Failed'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
    );
  }

  void _showPurchaseHistory(BuildContext context) {
    final purchaseModel =
        context.read<ProductProvider>().purchaseListOfSpecificProduct;

    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: purchaseModel.length,
        itemBuilder: (context, index) {
          final item = purchaseModel[index];
          return ListTile(
            title: Text(getFormattedDateTime(
                item.dateModel.timestamp.toDate(), 'dd/MM/yyyy')),
            subtitle: Text('Quantity: ${item.quantity}'),
            trailing: Text('$currencySymbol ${item.price.toString()}'),
          );
        },
      ),
    );
  }

}
