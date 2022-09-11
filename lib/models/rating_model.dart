const String ratingUserId = 'userId';
const String ratingProductId = 'productId';
const String ratingValue = 'rating';

class RatingModel {
  String? userId, productId;
  double rating;

  RatingModel({this.userId, this.productId, this.rating = 0.0});

  Map<String, dynamic> toMap() {
    return {
      ratingUserId: userId,
      ratingProductId: productId,
      ratingValue: rating,
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
      userId: map[ratingUserId],
      productId: map[ratingProductId],
      rating: double.parse(map[ratingValue]),
    );
  }
}
