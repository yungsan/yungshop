class Product {
  Product({
    required this.productName,
    required this.productPrice,
    required this.productThumbnail,
    this.productDescription = '',
  });
  final String productName;
  final int productPrice;
  final String productThumbnail;
  final String productDescription;
}
