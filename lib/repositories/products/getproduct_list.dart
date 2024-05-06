import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';

class ProductRepository {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('products');

  Future<List<Product>> getAllProducts() async {
    List<Product> products = [];

    try {
      QuerySnapshot productSnapshot = await _productCollection
          .where('isActive', isEqualTo: true)
          .where('isSoldOut', isEqualTo: false)
          .get();

      for (QueryDocumentSnapshot doc in productSnapshot.docs) {
        Product product = Product.fromDocument(doc);
        List<String> imageUrls = await getImageUrls(doc.id);
        product.imageUrls = imageUrls;
        products.add(product);
      }

      return products;
    } catch (e) {
      print('Error getting new active products: $e');
      return [];
    }
  }

  Future<List<Product>> getHotProducts() async {
    List<Product> products = [];

    try {
      QuerySnapshot productSnapshot = await _productCollection
          .where('isHot', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .where('isSoldOut', isEqualTo: false)
          .get();

      for (QueryDocumentSnapshot doc in productSnapshot.docs) {
        Product product = Product.fromDocument(doc);
        List<String> imageUrls = await getImageUrls(doc.id);
        product.imageUrls = imageUrls;
        products.add(product);
      }

      return products;
    } catch (e) {
      print('Error getting new active products: $e');
      return [];
    }
  }

  Future<List<Product>> getSaleProductDocumentIds() async {
    List<Product> products = [];

    try {
      QuerySnapshot productSnapshot = await _productCollection
          .where('isSale', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .where('isSoldOut', isEqualTo: false)
          .get();

      for (QueryDocumentSnapshot doc in productSnapshot.docs) {
        Product product = Product.fromDocument(doc);
        List<String> imageUrls = await getImageUrls(doc.id);
        product.imageUrls = imageUrls;
        products.add(product);
      }

      return products;
    } catch (e) {
      print('Error getting new active products: $e');
      return [];
    }
  }

  Future<List<Product>> getNewProductsWithImages() async {
    List<Product> products = [];

    try {
      QuerySnapshot productSnapshot = await _productCollection
          .where('isNew', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .where('isSoldOut', isEqualTo: false)
          .orderBy('createDate', descending: true)
          .get();

      for (QueryDocumentSnapshot doc in productSnapshot.docs) {
        Product product = Product.fromDocument(doc);
        List<String> imageUrls = await getImageUrls(doc.id);
        product.imageUrls = imageUrls;
        products.add(product);
      }

      return products;
    } catch (e) {
      print('Error getting new active products: $e');
      return [];
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

  Future<void> deleteProduct(String productId) async {
    try {
      // Xóa sản phẩm từ Firestore
      await _productCollection.doc(productId).delete();

      // Xóa các hình ảnh liên quan từ Firebase Storage
      await deleteProductImages(productId);

      print('Product with ID $productId deleted');
    } catch (error) {
      print('Error deleting product: $error');
      throw error;
    }
  }

  Future<void> deleteProductImages(String documentId) async {
    try {
      String storagePath = 'products_images/$documentId';
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(storagePath);

      // Lấy danh sách các hình ảnh trong thư mục
      final firebase_storage.ListResult result = await ref.listAll();

      // Xóa từng hình ảnh trong thư mục
      for (final item in result.items) {
        await item.delete();
      }

      print('Deleted all images for product $documentId');
    } catch (e) {
      print('Error deleting product images: $e');
    }
  }
}
