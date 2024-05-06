import 'package:cloud_firestore/cloud_firestore.dart';

class AvailableSizeProduct {
  final String? id;
  final String productId;
  final String sizeProductId;
  int quantity;

  AvailableSizeProduct({
    required this.id,
    required this.productId,
    required this.sizeProductId,
    required this.quantity,
  });

  factory AvailableSizeProduct.fromDocument(DocumentSnapshot doc) {
    return AvailableSizeProduct(
      id: doc.id,
      productId: doc['productId'],
      sizeProductId: doc['sizeProductId'],
      quantity: doc['quantity'],
    );
  }

  // Định nghĩa phương thức toJson() để chuyển đổi đối tượng thành Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'sizeProductId': sizeProductId,
      'quantity': quantity,
    };
  }
}
