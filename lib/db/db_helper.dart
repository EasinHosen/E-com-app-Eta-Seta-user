import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etaseta_user/models/cart_model.dart';
import 'package:etaseta_user/models/order_model.dart';
import 'package:etaseta_user/models/product_model.dart';

import '../models/category_model.dart';
import '../models/purchase_model.dart';
import '../models/user_model.dart';

class DBHelper {
  static const String collectionAdmin = 'admins';
  static const String collectionCategory = 'categories';
  static const String collectionProducts = 'products';
  static const String collectionPurchase = 'purchase';
  static const String collectionCart = 'cart';
  static const String collectionUser = 'EtaSetaUsers';
  static const String collectionOrder = 'order';
  static const String collectionOrderDetails = 'orderDetails';
  static const String collectionOrderSettings = 'settings';
  static const String documentOrderConstant = 'orderConstant';
  static const String collectionCities = 'cities';

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() => _db
      .collection(collectionProducts)
      .where(productAvailable, isEqualTo: true)
      .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProductsByCategory(
          String category) =>
      _db
          .collection(collectionProducts)
          .where(productCategory, isEqualTo: category)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllFeaturedProducts() =>
      _db
          .collection(collectionProducts)
          .where(productFeatured, isEqualTo: true)
          .snapshots();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getProductById(
          String id) =>
      _db.collection(collectionProducts).doc(id).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllPurchaseByProductId(
          String id) =>
      _db
          .collection(collectionPurchase)
          .where(purchaseProductId, isEqualTo: id) //can do multiple where
          .snapshots();

  static Future<void> addUser(UserModel userModel) =>
      _db.collection(collectionUser).doc(userModel.uid).set(userModel.toMap());

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserByUid(
          String uid) =>
      _db.collection(collectionUser).doc(uid).snapshots();

  static Future<void> updateProfile(String uid, Map<String, dynamic> map) =>
      _db.collection(collectionUser).doc(uid).update(map);

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCartItems(
          String uid) =>
      _db
          .collection(collectionUser)
          .doc(uid)
          .collection(collectionCart)
          .snapshots();

  static Future<void> addToCart(String uid, CartModel cartModel) {
    return _db
        .collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(cartModel.pId)
        .set(cartModel.toMap());
  }

  static Future<void> updateCartItemQty(String uid, String pId, num qty) {
    return _db
        .collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(pId)
        .update({cartProductQuantity: qty});
  }

  static Future<void> removeFromCart(String uid, String pId) {
    return _db
        .collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(pId)
        .delete();
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getOrderConstants() =>
      _db.collection(collectionOrderSettings).doc(documentOrderConstant).get();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCities() =>
      _db.collection(collectionCities).snapshots();

  static Future<void> addNewOrder(
      OrderModel orderModel, List<CartModel> cartList) {
    final wb = _db.batch();
    final orderDoc = _db.collection(collectionOrder).doc();
    orderModel.oId = orderDoc.id;

    wb.set(orderDoc, orderModel.toMap());
    for (var cartM in cartList) {
      final cartDoc =
          orderDoc.collection(collectionOrderDetails).doc(cartM.pId);
      wb.set(cartDoc, cartM.toMap());
    }
    return wb.commit();
  }

  static Future<void> updateProductStock(List<CartModel> cartList) {
    final wb = _db.batch();
    for (var cartM in cartList) {
      final productDoc = _db.collection(collectionProducts).doc(cartM.pId);
      wb.update(productDoc, {productStock: cartM.pStock - cartM.pQty});
    }
    return wb.commit();
  }

  static Future<void> updateCategoryProductCount(
      List<CartModel> cartList, List<CategoryModel> categoryList) {
    final wb = _db.batch();
    for (var cartM in cartList) {
      final categoryM =
          categoryList.firstWhere((element) => element.name == cartM.pCategory);
      final catDoc = _db.collection(collectionCategory).doc(categoryM.id);
      wb.update(
          catDoc, {categoryProductCount: categoryM.productCount - cartM.pQty});
    }
    return wb.commit();
  }

  static Future<void> clearUserCartItems(String uid, List<CartModel> cartList) {
    final wb = _db.batch();

    final userDoc = _db.collection(collectionUser).doc(uid);
    for (var cartM in cartList) {
      final cartDoc = userDoc.collection(collectionCart).doc(cartM.pId);
      wb.delete(cartDoc);
    }
    return wb.commit();
  }
}
