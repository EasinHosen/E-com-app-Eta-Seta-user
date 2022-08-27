const String cartProductId = 'pId';
const String cartProductName = 'pName';
const String cartProductImage = 'pImage';
const String cartProductPrice = 'pPrice';
const String cartProductQuantity = 'pQty';
const String cartProductCategory = 'pCategory';
const String cartProductStock = 'pStock';

class CartModel {
  String? pId, pName, pImage, pCategory;
  num pPrice, pQty, pStock;

  CartModel(
      {this.pId,
      this.pName,
      this.pImage,
      required this.pPrice,
      this.pQty = 1,
      this.pCategory,
      required this.pStock});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      cartProductId: pId,
      cartProductName: pName,
      cartProductImage: pImage,
      cartProductPrice: pPrice,
      cartProductQuantity: pQty,
      cartProductCategory: pCategory,
      cartProductStock: pStock
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) => CartModel(
        pId: map[cartProductId],
        pName: map[cartProductName],
        pImage: map[cartProductImage],
        pPrice: map[cartProductPrice],
        pQty: map[cartProductQuantity],
        pCategory: map[cartProductCategory],
        pStock: map[cartProductStock],
      );
}
