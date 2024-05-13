import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/features/AvailableSizeProduct/add_availableSizeProduct_page.dart';
import 'package:flutter_ltdddoan/features/AvailableSizeProduct/availableSizeProduct_page.dart';
import 'package:flutter_ltdddoan/model/available_product_sizes.dart';
import 'package:flutter_ltdddoan/repositories/availableProduct/availableProduct_repository.dart';
import 'package:gap/gap.dart';
import '../../widgets/widgets.dart';

class AvailableSizeProductsPage extends StatefulWidget {
  const AvailableSizeProductsPage({Key? key});

  @override
  _AvailableSizeProductsPageState createState() =>
      _AvailableSizeProductsPageState();
}

class _AvailableSizeProductsPageState extends State<AvailableSizeProductsPage> {
  late final AvailableSizeProductRepository _availableSizeProductRepository;
  late List<AvailableSizeProduct> _availableSizeProducts = [];
  late List<AvailableSizeProduct> _filteredAvailableSizeProducts = [];
  late Map<String, String> _productIdToProductNameMap = {};
  @override
  void initState() {
    super.initState();
    _availableSizeProductRepository = AvailableSizeProductRepository();
    _updateAvailableSizeProductList();
  }

  Future<void> _updateAvailableSizeProductList({String? searchKeyword}) async {
    final List<AvailableSizeProduct> allProducts =
        await _availableSizeProductRepository.getAllAvailableSizeProducts();

    setState(() {
      _availableSizeProducts = allProducts;
    });

    // Lặp qua danh sách sản phẩm để truy vấn thông tin về productName và cập nhật vào Map
    for (var product in allProducts) {
      final productData = await FirebaseFirestore.instance
          .collection('products')
          .doc(product.productId)
          .get();
      final productName =
          productData['name']; // Lấy thông tin productName từ Firestore
      _productIdToProductNameMap[product.productId] =
          productName; // Ánh xạ productId -> productName trong Map
    }

    setState(() {
      _filteredAvailableSizeProducts =
          _applyFilter(searchKeyword, _availableSizeProducts);
    });
  }

  List<AvailableSizeProduct> _applyFilter(
      String? searchKeyword, List<AvailableSizeProduct> products) {
    if (searchKeyword == null || searchKeyword.isEmpty) {
      return products;
    }
    return products.where((product) {
      final productName =
          _productIdToProductNameMap[product.productId]?.toLowerCase() ??
              ''; // Lấy tên sản phẩm từ Map
      final keyword = searchKeyword.toLowerCase();
      return productName.contains(keyword);
    }).toList();
  }

  Future<bool?> _showDeleteConfirmationDialog(
      BuildContext context,
      AvailableSizeProduct availableSizeProduct,
      List<AvailableSizeProduct> availableSizeProducts,
      int index) async {
    return await showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc muốn xóa sản phẩm này không?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Không xóa
              },
              child: Text('Không'),
            ),
            TextButton(
              onPressed: () async {
                // Xác nhận xóa
                await _availableSizeProductRepository
                    .deleteAvailableSizeProduct(
                        availableSizeProduct.availableSizeProductId!);
                // Xóa khỏi danh sách sản phẩm
                setState(() {
                  availableSizeProducts.removeAt(index);
                });
                Navigator.of(context).pop(true); // Xác nhận xóa
              },
              child: Text('Có'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ContentView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sản phẩm có sẵn',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddAvailableSizeProductPage(),
                    ),
                  );

                  if (result != null && result == true) {
                    // Reload product category list
                    await _updateAvailableSizeProductList();
                  }
                },
                child: Text('Thêm'),
              ),
            ],
          ),
          const Gap(16),
          TextField(
            onChanged: (value) {
              _updateAvailableSizeProductList(searchKeyword: value);
            },
            decoration: InputDecoration(
              labelText: 'Tìm kiếm sản phẩm có sẵn',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const Gap(16),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: ListView.separated(
                itemCount: _filteredAvailableSizeProducts.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final availableSizeProduct =
                      _filteredAvailableSizeProducts[index];
                  return Dismissible(
                    key: Key(availableSizeProduct.availableSizeProductId!),
                    direction: DismissDirection.startToEnd,
                    confirmDismiss: (direction) async {
                      // Hiển thị hộp thoại xác nhận và chờ kết quả
                      return await _showDeleteConfirmationDialog(context,
                          availableSizeProduct, _availableSizeProducts, index);
                    },
                    background: Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.red, // Background color of delete button
                      child: Icon(Icons.delete),
                    ),
                    child: ListTile(
                      title: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('products')
                            .doc(availableSizeProduct.productId)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text('Loading...');
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          final productData = snapshot.data!;
                          final productName = productData['name'];

                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('sizeproduct')
                                .doc(availableSizeProduct.sizeProductId)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text('Loading...');
                              }
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              final sizeProductData = snapshot.data!;
                              final sizeProductName = sizeProductData['name'];

                              return Text(
                                'Product Name: $productName\n'
                                'Size Product Name: $sizeProductName\n'
                                'Quantity: ${availableSizeProduct.quantity}',
                                style: theme.textTheme.bodyMedium!
                                    .copyWith(fontWeight: FontWeight.w600),
                              );
                            },
                          );
                        },
                      ),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AvailableSizeProductPage(
                              availableSizeProduct: availableSizeProduct,
                            ),
                          ),
                        );

                        if (result != null && result == true) {
                          // Reload available size product list
                          await _updateAvailableSizeProductList();
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
