// import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class ProductRepository {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('products');

  Future<Product?> getProductById(String productId) async {
    try {
      DocumentSnapshot productSnapshot =
          await _productCollection.doc(productId).get();

      if (productSnapshot.exists) {
        Product product = Product.fromDocument(productSnapshot);
        List<String> imageUrls = await getImageUrls(productId);
        product.imageUrls = imageUrls;
        return product;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting product by ID: $e');
      return null;
    }
  }

  Future<List<String>> getImageUrls(String documentId) async {
    try {
      // Xây dựng đường dẫn đến thư mục trong Storage dựa trên documentId
      String storagePath = 'products_images/$documentId';

      // Lấy tham chiếu đến thư mục trong Cloud Storage
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(storagePath);

      // Lấy danh sách các hình ảnh trong thư mục
      final firebase_storage.ListResult result = await ref.listAll();

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

  Future<void> addProduct(Product newProduct, List<String> imageFiles) async {
    try {
      // Thêm sản phẩm mới vào Firestore
      await _productCollection.add({
        'name': newProduct.name,
        'description': newProduct.description,
        'price': newProduct.price,
        'priceSale': newProduct.priceSale,
        'quantity': newProduct.quantity,
        'isNew': newProduct.isNew,
        'isSale': newProduct.isSale,
        'isHot': newProduct.isHot,
        'isSoldOut': newProduct.isSoldOut,
        'isActive': newProduct.isActive,
        'createdBy': newProduct.createdBy,
        'createDate': newProduct.createDate,
        'updatedDate': newProduct.updatedDate,
        'rating': newProduct.rating,
        'sizeProductId': newProduct.sizeProductId,
        'genderCategoryId': newProduct.genderCategoryId,
        'productCategoryId': newProduct.productCategoryId,
        'discountId': newProduct.discountId,
      }).then((DocumentReference docRef) async {
        // Lấy ID của sản phẩm đã thêm
        final productId = docRef.id;

        // Upload hình ảnh
        //await _uploadImages(productId, imageFiles);
        await uploadImageUrls(productId, imageFiles);
        print('Product added with ID: $productId');
      });
    } catch (error) {
      print('Error adding product: $error');
      throw error;
    }
  }

  Future<void> updatedProduct(Product updatedProduct) async {
    try {
      _productCollection.doc(updatedProduct.productId).update({
        'name': updatedProduct.name,
        'description': updatedProduct.description,
        'price': updatedProduct.price,
        'priceSale': updatedProduct.priceSale,
        'quantity': updatedProduct.quantity,
        'isNew': updatedProduct.isNew,
        'isSale': updatedProduct.isSale,
        'isHot': updatedProduct.isHot,
        'isSoldOut': updatedProduct.isSoldOut,
        'isActive': updatedProduct.isActive,
        'createdBy': updatedProduct.createdBy,
        'createDate': updatedProduct.createDate,
        'updatedDate': updatedProduct.updatedDate,
        'rating': updatedProduct.rating,
        'sizeProductId': updatedProduct.sizeProductId,
        'genderCategoryId': updatedProduct.genderCategoryId,
        'productCategoryId': updatedProduct.productCategoryId,
        'discountId': updatedProduct.discountId,
      });
    } catch (error) {
      print('Error updating product: $error');
      throw error;
    }
  }

  Future<void> uploadImageUrls(
      String documentId, List<String> imageUrls) async {
    try {
      String storagePath = 'products_images/$documentId';
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(storagePath);

      // Upload các hình mới
      for (int i = 0; i < imageUrls.length; i++) {
        final imageUrl = imageUrls[i];
        final imageName = 'image_$i.png';

        // Tải hình ảnh từ URL
        final http.Response response = await http.get(Uri.parse(imageUrl));
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
          print('Failed to load image from URL: $imageUrl');
        }
      }

      print('Upload image URLs completed');
    } catch (e) {
      print('Error uploading image URLs: $e');
    }
  }

  Future<void> deleteImageUrl(String documentId, String imageName) async {
    try {
      String storagePath = 'products_images/$documentId/$imageName';
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
