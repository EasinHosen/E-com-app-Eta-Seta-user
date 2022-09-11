import 'package:etaseta_user/providers/order_provider.dart';
import 'package:etaseta_user/utils/constants.dart';
import 'package:etaseta_user/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyOrdersPage extends StatelessWidget {
  static const String routeName = '/my_order_page';
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<OrderProvider>(context, listen: false).getOrderByUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My orders'),
      ),
      body: Consumer<OrderProvider>(builder: (context, provider, _) {
        return provider.orderList.isNotEmpty
            ? ListView.builder(
                itemCount: provider.orderList.length,
                itemBuilder: (context, index) {
                  final orderM = provider.orderList[index];
                  return ListTile(
                    title: Text(
                      getFormattedDateTime(
                          orderM.orderPlaceDate.timestamp.toDate(),
                          'dd/MM/yyyy hh:mm:ss a'),
                    ),
                    subtitle: Text(orderM.orderSt),
                    trailing:
                        Text('$currencySymbol${orderM.grandTotal.round()}'),
                  );
                },
              )
            : const Center(
                child: Text('Your order list is empty!'),
              );
      }),
    );
  }
}
