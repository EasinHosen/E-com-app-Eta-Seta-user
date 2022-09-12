import 'package:etaseta_user/providers/cart_provider.dart';
import 'package:etaseta_user/providers/order_provider.dart';
import 'package:etaseta_user/ui/pages/checkout_page.dart';
import 'package:etaseta_user/utils/constants.dart';
import 'package:etaseta_user/utils/helper_function.dart';
import 'package:etaseta_user/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);
  static const String routeName = '/cart_page';

  @override
  Widget build(BuildContext context) {
    final cartM = Provider.of<CartProvider>(context, listen: false);
    final cartList = cartM.cartList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My cart'),
        actions: [
          Consumer<OrderProvider>(
            builder: (context, ordProvider, _) => IconButton(
              onPressed: () {
                cartList.isNotEmpty
                    ? showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Clear cart?'),
                          content: const Text(
                              'Do you really want to clear your cart?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                ordProvider.clearUserCartItems(cartList);
                                Navigator.pop(context);
                                EasyLoading.showToast('Cart cleared!');
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      )
                    : EasyLoading.showToast('Your cart is empty!!');
              },
              icon: const Icon(Icons.clear),
            ),
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: provider.cartList.length,
                itemBuilder: (context, index) {
                  final cartModel = provider.cartList[index];
                  return CartItem(
                    cartModel: cartModel,
                    priceWithQty: provider.itemPriceWithQty(cartModel),
                    onInc: () {
                      provider.incQty(cartModel);
                    },
                    onDec: () {
                      provider.decQty(cartModel);
                    },
                    onDel: () {
                      provider.removeFromCart(cartModel.pId!);
                      showMsg(context, 'Item removed from cart');
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Subtotal: $currencySymbol ${provider.getCartSubtotal()}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      ElevatedButton(
                          onPressed: provider.totalCartItem == 0
                              ? null
                              : () {
                                  Navigator.of(context)
                                      .pushNamed(CheckoutPage.routeName);
                                },
                          child: const Text('Checkout'))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
