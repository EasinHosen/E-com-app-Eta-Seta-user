

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etaseta_user/auth/auth_services.dart';
import 'package:etaseta_user/models/user_model.dart';
import 'package:etaseta_user/providers/order_provider.dart';
import 'package:etaseta_user/providers/user_provider.dart';
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
  String groupValue = "COD";

  @override
  void didChangeDependencies() {
    cartProvider = Provider.of<CartProvider>(context);
    orderProvider = Provider.of<OrderProvider>(context);
    userProvider = Provider.of<UserProvider>(context);

    orderProvider.getOrderConstants();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(8),
              children: [
                Text(
                  "Product Info",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
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
                SizedBox(
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
                        trailing: Text('$currencySymbol ${cartProvider.getCartSubtotal()}'),
                      ),
                      ListTile(
                        leading: Text("Delivery Charge"),
                        trailing: Text('${orderProvider.orderConstantsModel.deliveryCharge}'),
                      ),
                      ListTile(
                        leading: Text("Discount(${orderProvider.orderConstantsModel.discount}%)"),
                        trailing: Text("$currencySymbol ${orderProvider.getDiscount(cartProvider.getCartSubtotal())}"),
                      ),
                      ListTile(
                        leading: Text("Vat(${orderProvider.orderConstantsModel.vat}%)"),
                        trailing: Text("$currencySymbol ${orderProvider.getVatAmount(cartProvider.getCartSubtotal())}"),
                      ),
                      Divider(),
                      ListTile(
                        leading: Text("Grand total:"),
                        trailing: Text("$currencySymbol ${orderProvider.getGrandTotal(cartProvider.getCartSubtotal())}",
                          style: TextStyle(
                            fontSize: 20,
                          ),),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Delivery Address",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),

                Card(
                  child: ListTile(
                    title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: userProvider.getUserByUid(AuthService.user!.uid),
                      builder:(context, snapshot)
                      {
                        if(snapshot.hasData){
                          final userM = UserModel.fromMap(snapshot.data!.data()!);
                          final addressM = userM.addressModel;
                          return Text( addressM == null ? 'No address found!' : '${addressM.streetAddress}\n${addressM.area}\n${addressM.city}\n${addressM.zipCode}');
                        }
                        if(snapshot.hasError){
                          return const Text('Error fetching data!');
                        }
                        return const Text('Fetching data...');
                      },
                    ),
                    trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        onPressed: () {},
                        child: Text("Set")),
                  ),
                ),
                SizedBox(
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
                        title: Text("COD"),
                        leading: Radio<String>(
                            value: "COD",
                            groupValue: groupValue,
                            fillColor: MaterialStateColor.resolveWith(
                                    (states) => groupValue == "COD"
                                    ? Colors.red
                                    : Colors.grey),
                            onChanged: (value) {
                              setState(() {
                                groupValue = value as String;
                              });
                            }),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text("Online"),
                        leading: Radio<String>(
                          value: "Online",
                          groupValue: groupValue,
                          fillColor: MaterialStateColor.resolveWith((states) =>
                          groupValue == "Online" ? Colors.red : Colors.grey),
                          onChanged: (value) {
                            setState(() {
                              groupValue = value as String;
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
              // style: ElevatedButton.styleFrom(
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(15))),
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
