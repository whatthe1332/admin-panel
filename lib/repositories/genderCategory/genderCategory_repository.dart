import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/model/gendercategory_model.dart';

class GenderCategoryRepository {
  final CollectionReference _genderCategoryCollection =
      FirebaseFirestore.instance.collection('gendercategory');

  Future<List<GenderCategory>> getAllGenderCategories() async {
    List<GenderCategory> genderCategories = [];
    try {
      QuerySnapshot snapshot = await _genderCategoryCollection.get();
      genderCategories = snapshot.docs.map((doc) {
        return GenderCategory(
          genderCategoryId: doc.id,
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
      print('Error getting gender categories: $error');
    }
    return genderCategories;
  }

  Future<void> addGenderCategory(GenderCategory newGenderCategory) async {
    try {
      await _genderCategoryCollection.add({
        'Name': newGenderCategory.name,
        'IsActive': newGenderCategory.isActive,
        'CreateBy': newGenderCategory.createdBy,
        'CreateDate': newGenderCategory.createDate,
        'UpdatedDate': newGenderCategory.updatedDate,
        'UpdateBy': newGenderCategory.updatedBy,
      });
    } catch (error) {
      print('Error adding gender category: $error');
      throw error;
    }
  }

  Future<void> editGenderCategory(GenderCategory updatedGenderCategory) async {
    try {
      await _genderCategoryCollection
          .doc(updatedGenderCategory.genderCategoryId)
          .update({
        'Name': updatedGenderCategory.name,
        'IsActive': updatedGenderCategory.isActive,
        'UpdatedDate': updatedGenderCategory.updatedDate,
        'UpdateBy': updatedGenderCategory.updatedBy,
      });
    } catch (error) {
      print('Error editing gender category: $error');
      throw error;
    }
  }

  Future<void> deleteGenderCategory(String categoryId) async {
    try {
      await _genderCategoryCollection.doc(categoryId).delete();
    } catch (error) {
      print('Error deleting gender category: $error');
      throw error;
    }
  }

  Future<GenderCategory?> getGenderCategoryById(String categoryId) async {
    try {
      DocumentSnapshot snapshot =
          await _genderCategoryCollection.doc(categoryId).get();
      if (snapshot.exists) {
        return GenderCategory(
          genderCategoryId: snapshot.id,
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
      print('Error getting gender category by ID: $error');
      return null;
    }
  }
}
