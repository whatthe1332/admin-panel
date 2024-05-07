import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/model/paymentmethod_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PaymentMethodRepository {
  final CollectionReference _paymentMethodCollection =
      FirebaseFirestore.instance.collection('paymentmethods');

  Future<List<PaymentMethod>> getPaymentMethods() async {
    List<PaymentMethod> paymentMethods = [];

    try {
      QuerySnapshot snapshot = await _paymentMethodCollection.get();

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        PaymentMethod paymentMethod = PaymentMethod(
          paymentMethodId: doc.id,
          name: doc['name'],
          isActive: doc['isActive'],
          createdBy: doc['createdBy'],
          createDate: doc['createDate'].toDate(),
          updatedDate: doc['updatedDate'].toDate(),
          updatedBy: doc['updatedBy'],
          description: doc['description'],
          icon: '',
        );

        List<String> iconUrls =
            await getImageUrls(paymentMethod.paymentMethodId!);
        if (iconUrls.isNotEmpty) {
          paymentMethod.icon = iconUrls.first;
        }

        paymentMethods.add(paymentMethod);
      }

      return paymentMethods;
    } catch (error) {
      // Xử lý khi gặp lỗi
      print('Error getting payment methods: $error');
      return [];
    }
  }

  Future<void> updatePaymentMethod(
      PaymentMethod updatedPaymentMethod, String imagePath) async {
    try {
      await _paymentMethodCollection
          .doc(updatedPaymentMethod.paymentMethodId)
          .update({
        'name': updatedPaymentMethod.name,
        'description': updatedPaymentMethod.description,
        'isActive': updatedPaymentMethod.isActive,
        'updatedDate': updatedPaymentMethod.updatedDate,
        'updatedBy': updatedPaymentMethod.updatedBy,
      });

      if (imagePath != '') {
        await uploadImage(updatedPaymentMethod.paymentMethodId!, imagePath);
      }

      print('Payment method updated: ${updatedPaymentMethod.name}');
    } catch (error) {
      print('Error updating payment method: $error');
      throw error;
    }
  }

  Future<void> addPaymentMethod(
      PaymentMethod newPaymentMethod, String imagePath) async {
    try {
      // Thêm dữ liệu phương thức thanh toán vào Firestore
      DocumentReference docRef = await _paymentMethodCollection.add({
        'name': newPaymentMethod.name,
        'description': newPaymentMethod.description,
        'isActive': newPaymentMethod.isActive,
        'createdBy': newPaymentMethod.createdBy,
        'createDate': newPaymentMethod.createDate,
        'updatedDate': newPaymentMethod.updatedDate,
        'updatedBy': newPaymentMethod.updatedBy,
      });

      // Lấy ID của phương thức thanh toán vừa được thêm
      String paymentMethodId = docRef.id;

      // Upload hình ảnh lên Firebase Storage
      if (imagePath != '') await uploadImage(paymentMethodId, imagePath);

      print('Payment method added: ${newPaymentMethod.name}');
    } catch (error) {
      print('Error adding payment method: $error');
      throw error;
    }
  }

  Future<void> uploadImage(String documentId, String imagePath) async {
    try {
      String storagePath = 'paymentmethods_images/$documentId';
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(storagePath);

      // Upload các hình mới
      for (int i = 0; i < 1; i++) {
        final imageName = 'image_$i.png';

        // Tải hình ảnh từ URL
        final http.Response response = await http.get(Uri.parse(imagePath));
        if (response.statusCode == 200) {
          // Lấy dữ liệu hình ảnh từ phản hồi HTTP
          final List<int> imageData = response.bodyBytes;

          // Tạo Uint8List từ dữ liệu hình ảnh
          final Uint8List uint8ImageData = Uint8List.fromList(imageData);

          // Tạo metadata cho hình ảnh
          final metadata =
              firebase_storage.SettableMetadata(contentType: 'image/png');

          // Tạo upload task và tải lên Firebase Storage
          await ref.child(imageName).putData(uint8ImageData, metadata);

          print('Uploaded $imageName');
        } else {
          print('Failed to load image from URL: imagePath');
        }
      }

      print('Upload image URLs completed');
    } catch (e) {
      print('Error uploading image URLs: $e');
    }
  }

  Future<PaymentMethod?> getPaymentMethodById(String paymentMethodId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _paymentMethodCollection.doc(paymentMethodId).get();
      if (docSnapshot.exists) {
        return PaymentMethod(
          paymentMethodId: docSnapshot.id,
          name: docSnapshot['name'],
          isActive: docSnapshot['isActive'],
          createdBy: docSnapshot['createdBy'],
          createDate: docSnapshot['createDate'].toDate(),
          updatedDate: docSnapshot['updatedDate'].toDate(),
          updatedBy: docSnapshot['updatedBy'],
          description: docSnapshot['description'],
          icon: docSnapshot['icon'],
        );
      } else {
        return null;
      }
    } catch (error) {
      print('Error getting payment method by ID: $error');
      throw error;
    }
  }

  Future<void> deletePaymentMethod(String paymentMethodId) async {
    try {
      await _paymentMethodCollection.doc(paymentMethodId).delete();
      await deleteProductImages(paymentMethodId);
      print('Payment method deleted: $paymentMethodId');
    } catch (error) {
      print('Error deleting payment method: $error');
      throw error;
    }
  }

  Future<void> deleteProductImages(String documentId) async {
    try {
      String storagePath = 'paymentmethods_images/$documentId';
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(storagePath);

      // Lấy danh sách các hình ảnh trong thư mục
      final firebase_storage.ListResult result = await ref.listAll();

      // Xóa từng hình ảnh trong thư mục
      for (final item in result.items) {
        await item.delete();
      }

      print('Deleted all images for payment method $documentId');
    } catch (e) {
      print('Error deleting payment method images: $e');
    }
  }

  Future<List<String>> getImageUrls(String documentId) async {
    try {
      // Xây dựng đường dẫn đến thư mục trong Storage dựa trên documentId
      String storagePath = 'paymentmethods_images/$documentId';

      // Lấy tham chiếu đến thư mục trong Cloud Storage
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(storagePath);

      // Lấy danh sách các hình ảnh trong thư mục
      final ListResult result = await ref.listAll();

      // Lưu danh sách URL của các hình ảnh vào một danh sách
      List<String> imageUrls = [];
      for (final item in result.items) {
        final imageUrl = await item.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      return imageUrls;
    } catch (e) {
      print('Error getting image URLs: $e');
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  Future<void> deleteImageUrl(String documentId, String imageName) async {
    try {
      String storagePath = 'paymentmethods_images/$documentId/$imageName';
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(storagePath);

      // Xóa hình ảnh từ Firebase Storage
      await ref.delete();

      print('Image $imageName deleted');
    } catch (e) {
      print('Error deleting image: $e');
    }
  }
}
