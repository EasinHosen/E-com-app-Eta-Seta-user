import 'package:etaseta_user/auth/auth_services.dart';
import 'package:etaseta_user/models/order_model.dart';
import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/cart_model.dart';
import '../models/category_model.dart';
import '../models/order_constants_model.dart';

class OrderProvider extends ChangeNotifier {
  OrderConstantsModel orderConstantsModel = OrderConstantsModel();

  Future<void> getOrderConstants() async {
    final snapshot = await DBHelper.getOrderConstants();
    orderConstantsModel = OrderConstantsModel.fromMap(snapshot.data()!);
    notifyListeners();
  }

  num getDiscount(num subtotal) {
    return (subtotal * orderConstantsModel.discount) / 100;
  }

  num getVatAmount(num subtotal) {
    final priceAfterDiscount = subtotal - getDiscount(subtotal);
    return (priceAfterDiscount * orderConstantsModel.vat) / 100;
  }

  num getGrandTotal(num subtotal) {
    return (subtotal - getDiscount(subtotal)) +
        getVatAmount(subtotal) +
        orderConstantsModel.deliveryCharge;
  }

  Future<void> addOrder(OrderModel orderModel, List<CartModel> cartList) =>
      DBHelper.addNewOrder(orderModel, cartList);

  Future<void> updateStock(List<CartModel> cartList) =>
      DBHelper.updateProductStock(cartList);

  Future<void> updateCategoryProductCount(
          List<CartModel> cartList, List<CategoryModel> categoryList) =>
      DBHelper.updateCategoryProductCount(cartList, categoryList);

  Future<void> clearUserCartItems(List<CartModel> cartList) =>
      DBHelper.clearUserCartItems(AuthService.user!.uid, cartList);
}
