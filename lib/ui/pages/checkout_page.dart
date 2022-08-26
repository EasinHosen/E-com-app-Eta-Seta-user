import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etaseta_user/auth/auth_services.dart';
import 'package:etaseta_user/models/user_model.dart';
import 'package:etaseta_user/providers/order_provider.dart';
import 'package:etaseta_user/providers/user_provider.dart';
import 'package:etaseta_user/ui/pages/user_address_page.dart';
import 'package:etaseta_user/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';

class CheckoutPage extends StatefulWidget {
  static const routeName = "checkout_page";
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late CartProvider cartProvider;
  late OrderProvider orderProvider;
  late UserProvider userProvider;
  bool isFirst = true;
  String paymentGroupValue = "COD";

  @override
  void didChangeDependencies() {
    if (isFirst) {
      cartProvider = Provider.of<CartProvider>(context);
      orderProvider = Provider.of<OrderProvider>(context);
      userProvider = Provider.of<UserProvider>(context, listen: false);
      orderProvider.getOrderConstants();
      isFirst = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Text(
                  "Product Info",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  child: Column(
                    children: cartProvider.cartList
                        .map((cartModel) => ListTile(
                              title: Text(cartModel.pName!),
                              trailing: Text(
                                  "${cartModel.pQty} * ৳${cartModel.pPrice}"),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Payment Info",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Text("Subtotal"),
                        trailing: Text(
                            '$currencySymbol ${cartProvider.getCartSubtotal()}'),
                      ),
                      ListTile(
                        leading: const Text("Delivery Charge"),
                        trailing: Text(
                            '${orderProvider.orderConstantsModel.deliveryCharge}'),
                      ),
                      ListTile(
                        leading: Text(
                            "Discount(${orderProvider.orderConstantsModel.discount}%)"),
                        trailing: Text(
                            "$currencySymbol ${orderProvider.getDiscount(cartProvider.getCartSubtotal())}"),
                      ),
                      ListTile(
                        leading: Text(
                            "Vat(${orderProvider.orderConstantsModel.vat}%)"),
                        trailing: Text(
                            "$currencySymbol ${orderProvider.getVatAmount(cartProvider.getCartSubtotal())}"),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Text("Grand total:"),
                        trailing: Text(
                          "$currencySymbol ${orderProvider.getGrandTotal(cartProvider.getCartSubtotal()).round()}",
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Delivery Address",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                Card(
                  child: ListTile(
                    title:
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: userProvider.getUserByUid(AuthService.user!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final userM =
                              UserModel.fromMap(snapshot.data!.data()!);
                          final addressM = userM.address;
                          return Text(addressM == null
                              ? 'No address found!'
                              : '${addressM.streetAddress},'
                                  '\n${addressM.area},'
                                  '\n${addressM.city},'
                                  '\n${addressM.zipCode}.');
                        }
                        if (snapshot.hasError) {
                          return const Text('Error fetching data!');
                        }
                        return const Text('Fetching data...');
                      },
                    ),
                    trailing: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                            context, UserAddressPage.routeName),
                        child: const Text('Change')),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Payment Method",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text("COD"),
                        leading: Radio<String>(
                            value: "COD",
                            groupValue: paymentGroupValue,
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => paymentGroupValue == "COD"
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey),
                            onChanged: (value) {
                              setState(() {
                                paymentGroupValue = value!;
                              });
                            }),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text("Online"),
                        leading: Radio<String>(
                          value: "Online",
                          groupValue: paymentGroupValue,
                          fillColor: MaterialStateColor.resolveWith((states) =>
                              paymentGroupValue == "Online"
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey),
                          onChanged: (value) {
                            setState(() {
                              paymentGroupValue = value!;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Place order"),
              ))
        ],
      ),
    );
  }
}
