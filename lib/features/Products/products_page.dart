import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/features/Products/add_product_page.dart';
import 'package:flutter_ltdddoan/features/Products/product_page.dart';
import 'package:flutter_ltdddoan/model/product_model.dart';
import 'package:flutter_ltdddoan/repositories/products/getproduct_list.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../widgets/widgets.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final ProductRepository productRepository;
  late List<Product> _products = [];
  late List<Product> _filteredProducts = [];
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'vi_VN', symbol: '');

  @override
  void initState() {
    super.initState();
    productRepository = ProductRepository();
    _updateProductList(); // Load initial data
  }

  Future<void> _updateProductList({String? searchKeyword}) async {
    final List<Product> allProducts = await productRepository.getAllProducts();

    setState(() {
      _products = allProducts;
      // Apply filtering if searchKeyword is provided
      _filteredProducts = _applyFilter(searchKeyword, _products);
    });
  }

  List<Product> _applyFilter(String? searchKeyword, List<Product> products) {
    if (searchKeyword == null || searchKeyword.isEmpty) {
      return products;
    }
    return products.where((product) {
      final productName = product.name.toLowerCase();
      final keyword = searchKeyword.toLowerCase();
      return productName.contains(keyword);
    }).toList();
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context,
      Product product, List<Product> products, int index) async {
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
                await productRepository.deleteProduct(product.productId);
                // Xóa khỏi danh sách sản phẩm
                setState(() {
                  products.removeAt(index);
                  _filteredProducts.removeWhere(
                      (element) => element.productId == product.productId);
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
                'Sản phẩm',
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
                      builder: (context) => AddProductPage(),
                    ),
                  );

                  if (result != null && result == true) {
                    await _updateProductList();
                  }
                },
                child: Text('Thêm'),
              ),
            ],
          ),
          const Gap(16),
          TextField(
            onChanged: (value) {
              // Gọi hàm để cập nhật danh sách khi có sự thay đổi trong trường tìm kiếm
              _updateProductList(searchKeyword: value);
            },
            decoration: InputDecoration(
              labelText: 'Tìm kiếm sản phẩm',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const Gap(16),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: ListView.separated(
                itemCount: _filteredProducts.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return Dismissible(
                    key: Key(product.productId),
                    direction: DismissDirection.startToEnd,
                    confirmDismiss: (direction) async {
                      // Hiển thị hộp thoại xác nhận và chờ kết quả
                      return await _showDeleteConfirmationDialog(
                          context, product, _products, index);
                    },
                    background: Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.red, // Background color of delete button
                      child: Icon(Icons.delete),
                    ),
                    child: ListTile(
                      leading: Image.network(
                        product.imageUrls.isNotEmpty
                            ? product.imageUrls.first
                            : 'assets/images/default_product.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        product.name,
                        style: theme.textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${currencyFormat.format(product.price)} VNĐ',
                        style: theme.textTheme.labelMedium,
                      ),
                      trailing: const Icon(Icons.navigate_next_outlined),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductPage(product: product),
                          ),
                        );

                        if (result != null && result == true) {
                          // Reload product list
                          await _updateProductList();
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
