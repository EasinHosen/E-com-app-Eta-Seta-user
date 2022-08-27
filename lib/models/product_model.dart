const String productId = 'id';
const String productName = 'name';
const String productCategory = 'category';
const String productDescription = 'description';
const String productImageUrl = 'imageUrl';
const String productSalesPrice = 'salesPrice';
const String productFeatured = 'featured';
const String productAvailable = 'available';
const String productStock = 'stock';

class ProductModel {
  String? id, name, category, description, imageUrl;
  num salesPrice, stock;
  bool featured, available;

  ProductModel({
    this.id,
    this.name,
    this.category,
    this.description,
    this.imageUrl,
    required this.salesPrice,
    this.stock = 10,
    this.featured = true,
    this.available = true,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map[productId],
      name: map[productName],
      category: map[productCategory],
      description: map[productDescription],
      imageUrl: map[productImageUrl],
      salesPrice: map[productSalesPrice],
      featured: map[productFeatured],
      available: map[productAvailable],
      stock: map[productStock] ?? 10,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      productId: id,
      productName: name,
      productCategory: category,
      productDescription: description,
      productImageUrl: imageUrl,
      productSalesPrice: salesPrice,
      productFeatured: featured,
      productAvailable: available,
      productStock: stock
    };
  }

  @override
  String toString() {
    return 'ProductModel{id: $id, name: $name, category: $category, description: $description, imageUrl: $imageUrl, salesPrice: $salesPrice, stock: $stock, featured: $featured, available: $available}';
  }
}
