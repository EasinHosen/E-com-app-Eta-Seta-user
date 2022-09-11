import 'package:etaseta_user/models/cart_model.dart';
import 'package:etaseta_user/models/product_model.dart';
import 'package:etaseta_user/ui/pages/product_details_page.dart';
import 'package:etaseta_user/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class ProductItem extends StatefulWidget {
  final ProductModel productModel;
  const ProductItem({Key? key, required this.productModel}) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, ProductDetailsPage.routeName,
            arguments: widget.productModel.id),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.productModel.imageUrl == null ||
                          widget.productModel.imageUrl!.isEmpty
                      ? Image.asset('assets/images/img.png')
                      : Image.network(
                          widget.productModel.imageUrl!,
                          width: double.infinity,
                          fit: BoxFit.fill,
                          height: 100,
                        ),
                ),
                ListTile(
                  title: Text(
                    widget.productModel.name!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    // style: const TextStyle(fontSize: 12),
                  ),
                  subtitle: Text(
                    '$currencySymbol ${widget.productModel.salesPrice.toStringAsFixed(0)}',
                    // style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 10,
              right: 0,
              child: Consumer<CartProvider>(
                builder: (context, provider, child) {
                  final product = widget.productModel;
                  final isInCart = provider.isInCart(product.id!);
                  final cartItem = CartModel(
                    pId: product.id!,
                    pName: product.name!,
                    pPrice: product.salesPrice,
                    pImage: product.imageUrl,
                    pStock: product.stock,
                    pCategory: product.category,
                  );
                  return IconButton(
                    onPressed: widget.productModel.available
                        ? () {
                            if (isInCart) {
                              provider.removeFromCart(product.id!);
                              EasyLoading.showToast(
                                'Removed from cart',
                              );
                            } else {
                              provider.addToCart(cartItem);
                              EasyLoading.showToast(
                                'Added to cart!',
                              );
                            }
                          }
                        : null,
                    icon: Icon(
                      isInCart
                          ? Icons.remove_shopping_cart_outlined
                          : Icons.add_shopping_cart_outlined,
                    ),
                  );
                },
              ),
            ),
            if (widget.productModel.stock == 0)
              Container(
                alignment: Alignment.center,
                color: Colors.white70,
                child: const Text(
                  'Out of Stock',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
