
import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/order_constants_model.dart';

class OrderProvider extends ChangeNotifier {
  OrderConstantsModel orderConstantsModel = OrderConstantsModel();

  Future<void> getOrderConstants() async{
    final snapshot = await DBHelper.getOrderConstants();
    orderConstantsModel = OrderConstantsModel.fromMap(snapshot.data()!);
    notifyListeners();
  }

  num getDiscount(num subtotal){
    return (subtotal * orderConstantsModel.discount)/100;
  }

  num getVatAmount(num subtotal){
    final priceAfterDiscount = subtotal - getDiscount(subtotal);
    return (priceAfterDiscount *orderConstantsModel.vat)/100;
  }

  num getGrandTotal(num subtotal){
    return (subtotal - getDiscount(subtotal)) + getVatAmount(subtotal) + orderConstantsModel.deliveryCharge;
  }

}
