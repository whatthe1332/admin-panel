import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/model/productcategory_model.dart';

class ProductCategoryRepository {
  final CollectionReference _productCategoryCollection =
      FirebaseFirestore.instance.collection('productcategory');

  Future<List<ProductCategory>> getAllProductCategories() async {
    List<ProductCategory> productCategories = [];
    try {
      QuerySnapshot snapshot = await _productCategoryCollection.get();
      productCategories = snapshot.docs.map((doc) {
        return ProductCategory(
          productCategoryId: doc.id,
          name: doc['Name'],
          isActive: doc['IsActive'],
          createdBy: doc['CreateBy'],
          createDate: doc['CreateDate'] != null
              ? (doc['CreateDate'] as Timestamp).toDate()
              : DateTime.now(),
          updatedDate: doc['UpdatedDate'] != null
              ? (doc['UpdatedDate'] as Timestamp).toDate()
              : DateTime.now(),
          updatedBy: doc['UpdateBy'],
        );
      }).toList();
    } catch (error) {
      print('Error getting product categories: $error');
    }
    return productCategories;
  }

  Future<void> addProductCategory(ProductCategory newProductCategory) async {
    try {
      await _productCategoryCollection.add({
        'Name': newProductCategory.name,
        'IsActive': newProductCategory.isActive,
        'CreateBy': newProductCategory.createdBy,
        'CreateDate': newProductCategory.createDate,
        'UpdatedDate': newProductCategory.updatedDate,
        'UpdateBy': newProductCategory.updatedBy,
      });
    } catch (error) {
      print('Error adding product category: $error');
      throw error;
    }
  }

  Future<void> editProductCategory(
      ProductCategory updatedProductCategory) async {
    try {
      await _productCategoryCollection
          .doc(updatedProductCategory.productCategoryId)
          .update({
        'Name': updatedProductCategory.name,
        'IsActive': updatedProductCategory.isActive,
        'UpdatedDate': updatedProductCategory.updatedDate,
        'UpdateBy': updatedProductCategory.updatedBy,
      });
    } catch (error) {
      print('Error editing product category: $error');
      throw error;
    }
  }

  Future<void> deleteProductCategory(String categoryId) async {
    try {
      await _productCategoryCollection.doc(categoryId).delete();
    } catch (error) {
      print('Error deleting product category: $error');
      throw error;
    }
  }

  Future<ProductCategory?> getProductCategoryById(String categoryId) async {
    try {
      DocumentSnapshot snapshot =
          await _productCategoryCollection.doc(categoryId).get();
      if (snapshot.exists) {
        return ProductCategory(
          productCategoryId: snapshot.id,
          name: snapshot['Name'],
          isActive: snapshot['IsActive'],
          createdBy: snapshot['CreateBy'],
          createDate: snapshot['CreateDate'] != null
              ? (snapshot['CreateDate'] as Timestamp).toDate()
              : DateTime.now(),
          updatedDate: snapshot['UpdatedDate'] != null
              ? (snapshot['UpdatedDate'] as Timestamp).toDate()
              : DateTime.now(),
          updatedBy: snapshot['UpdateBy'],
        );
      } else {
        print('Product category with ID $categoryId does not exist');
        return null;
      }
    } catch (error) {
      print('Error getting product category by ID: $error');
      return null;
    }
  }
}
