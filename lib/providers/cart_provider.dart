import 'package:etaseta_user/auth/auth_services.dart';
import 'package:etaseta_user/db/db_helper.dart';
import 'package:flutter/foundation.dart';

import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> cartList = [];
  final uid = AuthService.user!.uid;

  int get totalCartItem => cartList.length;

  getAllCartItems() {
    DBHelper.getAllCartItems(uid).listen((event) {
      cartList = List.generate(event.docs.length,
          (index) => CartModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  Future<void> addToCart(CartModel cartModel) =>
      DBHelper.addToCart(uid, cartModel);

  Future<void> removeFromCart(String pId) => DBHelper.removeFromCart(uid, pId);

  bool isInCart(String productId) {
    bool flag = false;

    for (var cart in cartList) {
      if (cart.pId == productId) {
        flag = true;
        break;
      }
    }
    return flag;
  }

  num itemPriceWithQty(CartModel cartModel) => cartModel.pPrice * cartModel.pQty;

  num getCartSubtotal() {
    num total = 0;
    for(var cartM in cartList){
      total += cartM.pPrice * cartM.pQty;
    }
    return total;
  }

  incQty(CartModel cartModel)async{
    await DBHelper.updateCartItemQty(uid, cartModel.pId!, cartModel.pQty+1);
  }

  decQty(CartModel cartModel)async{
    if(cartModel.pQty > 1){
      await DBHelper.updateCartItemQty(uid, cartModel.pId!, cartModel.pQty - 1);
    }
  }
}
