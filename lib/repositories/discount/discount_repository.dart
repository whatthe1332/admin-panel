import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/model/discount_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class DiscountRepository {
  final CollectionReference _discountCollection =
      FirebaseFirestore.instance.collection('discount');

  Future<List<Discount>> getDiscounts() async {
    List<Discount> discounts = [];

    try {
      QuerySnapshot snapshot = await _discountCollection.get();

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Discount discount = Discount(
          discountId: doc.id,
          name: doc['name'],
          isActive: doc['isActive'],
          createdBy: doc['createdBy'],
          createDate: doc['createDate'].toDate(),
          updatedDate: doc['updatedDate'].toDate(),
          updatedBy: doc['updatedBy'],
          description: doc['description'],
          value: doc['value'],
          quantity: doc['quantity'],
          price: doc['price'],
          image: '',
        );

        List<String> imageUrls = await getImageUrls(discount.discountId!);
        if (imageUrls.isNotEmpty) {
          discount.image = imageUrls.first;
        }

        discounts.add(discount);
      }

      return discounts;
    } catch (error) {
      print('Error getting discounts: $error');
      return [];
    }
  }

  Future<void> updateDiscount(
      Discount updatedDiscount, String imagePath) async {
    try {
      await _discountCollection.doc(updatedDiscount.discountId).update({
        'name': updatedDiscount.name,
        'description': updatedDiscount.description,
        'isActive': updatedDiscount.isActive,
        'updatedDate': updatedDiscount.updatedDate,
        'updatedBy': updatedDiscount.updatedBy,
      });

      if (imagePath != '') {
        await uploadImage(updatedDiscount.discountId!, imagePath);
      }

      print('Discount updated: ${updatedDiscount.name}');
    } catch (error) {
      print('Error updating discount: $error');
      throw error;
    }
  }

  Future<void> addDiscount(Discount newDiscount, String imagePath) async {
    try {
      DocumentReference docRef = await _discountCollection.add({
        'name': newDiscount.name,
        'description': newDiscount.description,
        'isActive': newDiscount.isActive,
        'createdBy': newDiscount.createdBy,
        'createDate': newDiscount.createDate,
        'updatedDate': newDiscount.updatedDate,
        'updatedBy': newDiscount.updatedBy,
        'value': newDiscount.value,
        'quantity': newDiscount.quantity,
        'price': newDiscount.price,
      });

      String discountId = docRef.id;

      if (imagePath != '') await uploadImage(discountId, imagePath);

      print('Discount added: ${newDiscount.name}');
    } catch (error) {
      print('Error adding discount: $error');
      throw error;
    }
  }

  Future<void> uploadImage(String documentId, String imagePath) async {
    try {
      String storagePath = 'discounts_images/$documentId';
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(storagePath);

      final imageName = 'image.png';

      final http.Response response = await http.get(Uri.parse(imagePath));
      if (response.statusCode == 200) {
        final List<int> imageData = response.bodyBytes;
        final Uint8List uint8ImageData = Uint8List.fromList(imageData);
        final metadata =
            firebase_storage.SettableMetadata(contentType: 'image/png');
        await ref.child(imageName).putData(uint8ImageData, metadata);
        print('Uploaded $imageName');
      } else {
        print('Failed to load image from URL: imagePath');
      }

      print('Upload image URLs completed');
    } catch (e) {
      print('Error uploading image URLs: $e');
    }
  }

  Future<List<String>> getImageUrls(String documentId) async {
    try {
      String storagePath = 'discounts_images/$documentId';
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(storagePath);
      final firebase_storage.ListResult result = await ref.listAll();
      List<String> imageUrls = [];
      for (final item in result.items) {
        final imageUrl = await item.getDownloadURL();
        imageUrls.add(imageUrl);
      }
      return imageUrls;
    } catch (e) {
      print('Error getting image URLs: $e');
      return [];
    }
  }

  Future<void> deleteDiscount(String discountId) async {
    try {
      await _discountCollection.doc(discountId).delete();
      await deleteDiscountImages(discountId);
      print('Discount deleted: $discountId');
    } catch (error) {
      print('Error deleting discount: $error');
      throw error;
    }
  }

  Future<void> deleteDiscountImages(String documentId) async {
    try {
      String storagePath = 'discounts_images/$documentId';
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(storagePath);
      final firebase_storage.ListResult result = await ref.listAll();
      for (final item in result.items) {
        await item.delete();
      }
      print('Deleted all images for discount $documentId');
    } catch (e) {
      print('Error deleting discount images: $e');
    }
  }

  Future<void> deleteImageUrl(String documentId, String imageName) async {
    try {
      String storagePath = 'discounts_images/$documentId/$imageName';
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(storagePath);

      // Xóa hình ảnh từ Firebase Storage
      await ref.delete();

      print('Image $imageName deleted');
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  Future<Discount?> getDiscountById(String discountId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _discountCollection.doc(discountId).get();
      if (docSnapshot.exists) {
        return Discount(
          discountId: docSnapshot.id,
          name: docSnapshot['name'],
          isActive: docSnapshot['isActive'],
          createdBy: docSnapshot['createdBy'],
          createDate: docSnapshot['createDate'].toDate(),
          updatedDate: docSnapshot['updatedDate'].toDate(),
          updatedBy: docSnapshot['updatedBy'],
          description: docSnapshot['description'],
          price: docSnapshot['price'],
          quantity: docSnapshot['quantity'],
          value: docSnapshot['value'],
          image: '',
        );
      } else {
        return null;
      }
    } catch (error) {
      print('Error getting payment method by ID: $error');
      throw error;
    }
  }
}
