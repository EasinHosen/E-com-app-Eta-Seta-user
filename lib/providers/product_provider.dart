import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../db/db_helper.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> productList = [];
  List<ProductModel> featuredProductList = [];
  List<PurchaseModel> purchaseListOfSpecificProduct = [];
  List<CategoryModel> categoryList = [];
  List<String> categoryNameList = [];

  getAllCategories() {
    DBHelper.getAllCategories().listen((event) {
      categoryList = List.generate(event.docs.length,
          (index) => CategoryModel.fromMap(event.docs[index].data()));

      categoryNameList = List.generate(categoryList.length, (index) => categoryList[index].name!);
      categoryNameList.insert(0, 'All');
      notifyListeners();
    });
  }

  getAllProducts() {
    DBHelper.getAllProducts().listen((event) {
      productList = List.generate(event.docs.length,
          (index) => ProductModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  getAllProductsByCategory(String category) {
    DBHelper.getAllProductsByCategory(category).listen((event) {
      productList = List.generate(event.docs.length,
              (index) => ProductModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  getAllFeaturedProduct() {
    DBHelper.getAllFeaturedProducts().listen((event) {
      featuredProductList = List.generate(event.docs.length,
              (index) => ProductModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProductById(String id) =>
      DBHelper.getProductById(id);

  getPurchaseByProduct(String id) {
    DBHelper.getAllPurchaseByProductId(id).listen((event) {
      purchaseListOfSpecificProduct = List.generate(event.docs.length,
          (index) => PurchaseModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }


  CategoryModel getCategoryModelByCategoryName(String name) {
    return categoryList.firstWhere((element) => element.name == name);
  }

  Future<String> updateImage(XFile xFile) async {
    final imageName = DateTime.now().microsecondsSinceEpoch.toString();
    final photoRef =
        FirebaseStorage.instance.ref().child('pictures/$imageName');

    final uploadTask = photoRef.putFile(File(xFile.path));

    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }
}
