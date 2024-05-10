class OrderDetail {
  final String? orderId;
  final String? availableSizeProductId;
  final double price;
  final int quantity;

  OrderDetail({
    required this.orderId,
    required this.availableSizeProductId,
    required this.price,
    required this.quantity,
  });
}
