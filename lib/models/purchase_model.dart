

import 'date_model.dart';

const String purchaseId = 'id';
const String purchaseProductId = 'productId';
const String purchasePrice = 'price';
const String purchaseQuantity = 'quantity';
const String purchaseDateModel = 'dateModel';

class PurchaseModel {
  String? id, productId;
  DateModel dateModel;
  num price, quantity;

  PurchaseModel({
    this.id,
    this.productId,
    required this.dateModel,
    required this.price,
    required this.quantity,
  });

  factory PurchaseModel.fromMap(Map<String, dynamic> map) {
    return PurchaseModel(
      id: map[purchaseId],
      productId: map[purchaseProductId],
      dateModel: DateModel.fromMap(map[purchaseDateModel]),
      price: map[purchasePrice],
      quantity: map[purchaseQuantity],
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      purchaseId: id,
      purchaseProductId: productId,
      purchaseDateModel: dateModel.toMap(),
      purchasePrice: price,
      purchaseQuantity: quantity,
    };
  }

  @override
  String toString() {
    return 'PurchaseModel{id: $id, productId: $productId, dateModel: $dateModel, price: $price, quantity: $quantity}';
  }
}
