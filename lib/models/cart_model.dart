const String cartProductId = 'pId';
const String cartProductName = 'pName';
const String cartProductImage = 'pImage';
const String cartProductPrice = 'pPrice';
const String cartProductQuantity = 'pQty';

class CartModel {
  String? pId, pName, pImage;
  num pPrice, pQty;

  CartModel(
      {this.pId, this.pName, this.pImage, required this.pPrice, this.pQty = 1});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      cartProductId: pId,
      cartProductName: pName,
      cartProductImage: pImage,
      cartProductPrice: pPrice,
      cartProductQuantity: pQty,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) => CartModel(
        pId: map[cartProductId],
        pName: map[cartProductName],
        pImage: map[cartProductImage],
        pPrice: map[cartProductPrice],
        pQty: map[cartProductQuantity],
      );
}
