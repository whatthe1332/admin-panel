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
          name: doc['Name'],
          isActive: doc['IsActive'],
          createdBy: doc['CreateBy'],
          createDate: doc['CreateDate'] != null
              ? (doc['CreateDate'] as Timestamp).toDate()
              : DateTime.now(),
          updatedDate: doc['UpdateDate'] != null
              ? (doc['UpdateDate'] as Timestamp).toDate()
              : DateTime.now(),
          updatedBy: doc['UpdateBy'],
        );
      }).toList();
    } catch (error) {
      print('Error getting size products: $error');
    }
    return sizeProducts;
  }

  Future<void> addSizeProduct(SizeProduct newSizeProduct) async {
    try {
      await _sizeProductCollection.add({
        'Name': newSizeProduct.name,
        'IsActive': newSizeProduct.isActive,
        'CreateBy': newSizeProduct.createdBy,
        'CreateDate': newSizeProduct.createDate,
        'UpdatedDate': newSizeProduct.updatedDate,
        'UpdateBy': newSizeProduct.updatedBy,
      });
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
        'Name': updatedSizeProduct.name,
        'IsActive': updatedSizeProduct.isActive,
        'UpdatedDate': updatedSizeProduct.updatedDate,
        'UpdateBy': updatedSizeProduct.updatedBy,
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
          name: snapshot['Name'],
          isActive: snapshot['IsActive'],
          createdBy: snapshot['CreateBy'],
          createDate: snapshot['CreateDate'] != null
              ? (snapshot['CreateDate'] as Timestamp).toDate()
              : DateTime.now(),
          updatedDate: snapshot['UpdateDate'] != null
              ? (snapshot['UpdateDate'] as Timestamp).toDate()
              : DateTime.now(),
          updatedBy: snapshot['UpdateBy'],
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
