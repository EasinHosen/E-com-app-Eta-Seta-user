import 'package:etaseta_user/models/cart_model.dart';
import 'package:etaseta_user/utils/constants.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final CartModel cartModel;
  final num priceWithQty;
  final VoidCallback onInc, onDec, onDel;
  const CartItem({Key? key,
    required this.cartModel,
    required this.priceWithQty,
    required this.onInc,
    required this.onDec,
    required this.onDel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(cartModel.pImage!),
              ),
              title: Text(cartModel.pName!),
              subtitle: Text('$currencySymbol${cartModel.pPrice}'),
              trailing: Text(
                '$currencySymbol $priceWithQty',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
              child: Row(
                children: [
                  IconButton(onPressed: onDec, icon: const Icon(Icons.remove_circle, size: 32,), color: Theme.of(context).primaryColor),
                  Text('${cartModel.pQty}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  IconButton(onPressed: onInc, icon: const Icon(Icons.add_circle, size: 32,), color: Theme.of(context).primaryColor),
                  const Spacer(),
                  IconButton(onPressed: onDel, icon: const Icon(Icons.delete_forever, size: 32,), color: Theme.of(context).errorColor),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
