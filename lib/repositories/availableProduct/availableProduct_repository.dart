import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/model/available_product_sizes.dart';

class AvailableSizeProductRepository {
  final CollectionReference _availableSizeProductCollection =
      FirebaseFirestore.instance.collection('availablesizeproduct');

  Future<List<AvailableSizeProduct>> getAllAvailableSizeProducts() async {
    List<AvailableSizeProduct> availableSizeProducts = [];
    try {
      QuerySnapshot snapshot = await _availableSizeProductCollection.get();
      availableSizeProducts = snapshot.docs.map((doc) {
        return AvailableSizeProduct(
          id: doc.id,
          productId: doc['ProductId'],
          sizeProductId: doc['SizeProductId'],
          quantity: doc['Quantity'],
        );
      }).toList();
    } catch (error) {
      print('Error getting available size products: $error');
    }
    return availableSizeProducts;
  }

  Future<void> addAvailableSizeProduct(
      AvailableSizeProduct newAvailableSizeProduct) async {
    try {
      await _availableSizeProductCollection.add({
        'ProductId': newAvailableSizeProduct.productId,
        'SizeProductId': newAvailableSizeProduct.sizeProductId,
        'Quantity': newAvailableSizeProduct.quantity,
      });
    } catch (error) {
      print('Error adding available size product: $error');
      throw error;
    }
  }

  Future<void> editAvailableSizeProduct(
      AvailableSizeProduct updatedAvailableSizeProduct) async {
    try {
      await _availableSizeProductCollection
          .doc(updatedAvailableSizeProduct.id)
          .update({
        'ProductId': updatedAvailableSizeProduct.productId,
        'SizeProductId': updatedAvailableSizeProduct.sizeProductId,
        'Quantity': updatedAvailableSizeProduct.quantity,
      });
    } catch (error) {
      print('Error editing available size product: $error');
      throw error;
    }
  }

  Future<void> deleteAvailableSizeProduct(String availableSizeProductId) async {
    try {
      await _availableSizeProductCollection
          .doc(availableSizeProductId)
          .delete();
    } catch (error) {
      print('Error deleting available size product: $error');
      throw error;
    }
  }

  Future<AvailableSizeProduct?> getAvailableSizeProductById(
      String availableSizeProductId) async {
    try {
      DocumentSnapshot snapshot = await _availableSizeProductCollection
          .doc(availableSizeProductId)
          .get();
      if (snapshot.exists) {
        return AvailableSizeProduct(
          id: snapshot.id,
          productId: snapshot['ProductId'],
          sizeProductId: snapshot['SizeProductId'],
          quantity: snapshot['Quantity'],
        );
      } else {
        return null;
      }
    } catch (error) {
      print('Error getting available size product by ID: $error');
      return null;
    }
  }
}
