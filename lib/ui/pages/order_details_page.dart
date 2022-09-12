import 'package:etaseta_user/models/order_model.dart';
import 'package:etaseta_user/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({Key? key}) : super(key: key);
  static const String routeName = '/order_details_page';

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as OrderModel;
    Provider.of<OrderProvider>(context, listen: false)
        .getOrderByOrderId(order.oId!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, provider, _) {
          return Column(
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
                        children: provider.orderedProductList
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
                                '$currencySymbol ${provider.getOrderSubtotal()}'),
                          ),
                          ListTile(
                            leading: const Text("Delivery Charge"),
                            trailing: Text('${order.deliveryCharge}'),
                          ),
                          ListTile(
                            leading: const Text("Discount(%)"),
                            trailing: Text("$currencySymbol ${order.discount}"),
                          ),
                          ListTile(
                            leading: const Text("Vat(%)"),
                            trailing: Text("$currencySymbol ${order.discount}"),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Text("Grand total:"),
                            trailing: Text(
                              "$currencySymbol ${order.grandTotal.round()}",
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
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text('Street:'),
                            trailing: Text(order.deliveryAddress.streetAddress),
                          ),
                          ListTile(
                            title: const Text('Area:'),
                            trailing: Text(order.deliveryAddress.area),
                          ),
                          ListTile(
                            title: const Text('City:'),
                            trailing: Text(order.deliveryAddress.city),
                          ),
                          ListTile(
                            title: const Text('Zipcode:'),
                            trailing:
                                Text(order.deliveryAddress.zipCode.toString()),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Payment Method: ",
                            style: Theme.of(context).textTheme.headline6,
                            textAlign: TextAlign.center,
                          ),
                          Text(order.paymentMethode)
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order status: ",
                            style: Theme.of(context).textTheme.headline6,
                            textAlign: TextAlign.center,
                          ),
                          Text(order.orderSt)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
