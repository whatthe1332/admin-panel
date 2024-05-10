import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/model/sizeproduct_model.dart';

class SizeProductRepository {
  final CollectionReference _sizeProductCollection =
      FirebaseFirestore.instance.collection('sizeproduct');

  Future<List<SizeProduct>> getAllSizeProducts() async {
    List<SizeProduct> sizeProducts = [];
    try {
      QuerySnapshot snapshot = await _sizeProductCollection.get();
      sizeProducts = snapshot.docs.map((doc) {
        return SizeProduct(
          sizeProductId: doc.id,
          name: doc['name'],
          isActive: doc['isActive'],
          createdBy: doc['createdBy'],
          createDate: doc['createDate'] != null
              ? (doc['createDate'] as Timestamp).toDate()
              : DateTime.now(),
          updatedDate: doc['updatedDate'] != null
              ? (doc['updatedDate'] as Timestamp).toDate()
              : DateTime.now(),
          updatedBy: doc['updatedBy'],
        );
      }).toList();
    } catch (error) {
      print('Error getting size products: $error');
    }
    return sizeProducts;
  }

  Future<void> addSizeProduct(SizeProduct newSizeProduct) async {
    try {
      DocumentReference docRef = await _sizeProductCollection.add({
        'name': newSizeProduct.name,
        'isActive': newSizeProduct.isActive,
        'createdBy': newSizeProduct.createdBy,
        'createDate': newSizeProduct.createDate,
        'updatedDate': newSizeProduct.updatedDate,
        'updatedBy': newSizeProduct.updatedBy,
      });

      // Cập nhật trường SizeProductId của tài liệu Firestore với giá trị mới
      await docRef.update({'sizeProductId': docRef.id});

      print('Size product added successfully.');
    } catch (error) {
      print('Error adding size product: $error');
      throw error;
    }
  }

  Future<void> editSizeProduct(SizeProduct updatedSizeProduct) async {
    try {
      await _sizeProductCollection
          .doc(updatedSizeProduct.sizeProductId)
          .update({
        'name': updatedSizeProduct.name,
        'isActive': updatedSizeProduct.isActive,
        'updatedDate': updatedSizeProduct.updatedDate,
        'updatedBy': updatedSizeProduct.updatedBy,
      });
    } catch (error) {
      print('Error editing size product: $error');
      throw error;
    }
  }

  Future<void> deleteSizeProduct(String productId) async {
    try {
      await _sizeProductCollection.doc(productId).delete();
    } catch (error) {
      print('Error deleting size product: $error');
      throw error;
    }
  }

  Future<SizeProduct?> getSizeProductById(String productId) async {
    try {
      DocumentSnapshot snapshot =
          await _sizeProductCollection.doc(productId).get();
      if (snapshot.exists) {
        return SizeProduct(
          sizeProductId: snapshot.id,
          name: snapshot['name'],
          isActive: snapshot['isActive'],
          createdBy: snapshot['createdBy'],
          createDate: snapshot['createDate'] != null
              ? (snapshot['createDate'] as Timestamp).toDate()
              : DateTime.now(),
          updatedDate: snapshot['updatedDate'] != null
              ? (snapshot['updatedDate'] as Timestamp).toDate()
              : DateTime.now(),
          updatedBy: snapshot['updatedBy'],
        );
      } else {
        return null;
      }
    } catch (error) {
      print('Error getting size product by ID: $error');
      return null;
    }
  }
}
