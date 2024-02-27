import 'package:nguyen_manh_dung/models/product.dart';

class Cart extends Product {
  Cart({
    required this.userId,
    required this.productId,
    required super.productName,
    required super.productPrice,
    required super.productThumbnail,
    required this.quantity,
    required this.size,
  });

  final int quantity;
  final String? userId;
  final String? productId;
  final String size;

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_price': productPrice,
      'product_thumbnail': productThumbnail,
      'user_id': userId,
      'quantity': quantity,
      'size': size,
    };
  }
}
