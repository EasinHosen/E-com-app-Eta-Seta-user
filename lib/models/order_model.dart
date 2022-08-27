import 'package:etaseta_user/models/address_model.dart';

import 'date_model.dart';

const String orderId = 'oId';
const String orderUserId = 'userId';
const String orderStatus = 'orderSt';
const String orderPaymentMethode = 'paymentMethode';
const String orderDeliveryAddress = 'deliveryAddress';
const String orderDate = 'orderPlaceDate';
const String orderGrandTotal = 'grandTotal';
const String orderDiscount = 'discount';
const String orderVat = 'vat';
const String orderDeliveryCharge = 'deliveryCharge';

class OrderModel {
  String? oId, userId;
  String orderSt, paymentMethode;
  AddressModel deliveryAddress;
  DateModel orderPlaceDate;
  num grandTotal, discount, vat, deliveryCharge;

  OrderModel(
      {this.oId,
      this.userId,
      required this.orderSt,
      required this.paymentMethode,
      required this.deliveryAddress,
      required this.orderPlaceDate,
      required this.grandTotal,
      required this.discount,
      required this.vat,
      required this.deliveryCharge});

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      oId: map[orderId],
      userId: map[orderUserId],
      orderSt: map[orderStatus],
      paymentMethode: map[orderPaymentMethode],
      deliveryAddress: AddressModel.fromMap(map[orderDeliveryAddress]),
      orderPlaceDate: DateModel.fromMap(map[orderDate]),
      grandTotal: map[orderGrandTotal],
      discount: map[orderDiscount],
      vat: map[orderVat],
      deliveryCharge: map[orderDeliveryCharge],
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      orderId: oId,
      orderUserId: userId,
      orderStatus: orderSt,
      orderPaymentMethode: paymentMethode,
      orderDeliveryAddress: deliveryAddress.toMap(),
      orderDate: orderPlaceDate.toMap(),
      orderGrandTotal: grandTotal,
      orderDiscount: discount,
      orderVat: vat,
      orderDeliveryCharge: deliveryCharge,
    };
  }

  @override
  String toString() {
    return 'OrderModel{oId: $oId, userId: $userId, orderSt: $orderSt, paymentMethode: $paymentMethode, deliveryAddress: $deliveryAddress, orderPlaceDate: $orderPlaceDate, grandTotal: $grandTotal, discount: $discount, vat: $vat, deliveryCharge: $deliveryCharge}';
  }
}
