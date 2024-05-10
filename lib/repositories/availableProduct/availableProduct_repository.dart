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
          availableSizeProductId: doc.id,
          productId: doc['productId'],
          sizeProductId: doc['sizeProductId'],
          quantity: doc['quantity'],
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
      DocumentReference docRef = await _availableSizeProductCollection.add({
        'productId': newAvailableSizeProduct.productId,
        'sizeProductId': newAvailableSizeProduct.sizeProductId,
        'quantity': newAvailableSizeProduct.quantity,
      });

      await docRef.update({'id': docRef.id});

      print('Available size product added successfully.');
    } catch (error) {
      print('Error adding available size product: $error');
      throw error;
    }
  }

  Future<void> editAvailableSizeProduct(
      AvailableSizeProduct updatedAvailableSizeProduct) async {
    try {
      await _availableSizeProductCollection
          .doc(updatedAvailableSizeProduct.availableSizeProductId)
          .update({
        'productId': updatedAvailableSizeProduct.productId,
        'sizeProductId': updatedAvailableSizeProduct.sizeProductId,
        'quantity': updatedAvailableSizeProduct.quantity,
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
          availableSizeProductId: snapshot.id,
          productId: snapshot['productId'],
          sizeProductId: snapshot['sizeProductId'],
          quantity: snapshot['quantity'],
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
