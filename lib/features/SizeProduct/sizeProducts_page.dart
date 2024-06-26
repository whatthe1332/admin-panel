import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/features/SizeProduct/add_sizeProduct_page.dart';
import 'package:flutter_ltdddoan/features/SizeProduct/sizeProduct_page.dart';
import 'package:flutter_ltdddoan/repositories/sizeProduct/sizeProduct_repository.dart';
import 'package:gap/gap.dart';
import 'package:flutter_ltdddoan/model/sizeproduct_model.dart';
import '../../widgets/widgets.dart';

class SizeProductsPage extends StatefulWidget {
  const SizeProductsPage({Key? key});

  @override
  _SizeProductsPageState createState() => _SizeProductsPageState();
}

class _SizeProductsPageState extends State<SizeProductsPage> {
  late final SizeProductRepository sizeProductRepository;

  @override
  void initState() {
    super.initState();
    sizeProductRepository = SizeProductRepository();
  }

  Future<void> _updateSizeProductList() async {
    setState(() {}); // Trigger rebuild to update size product list
  }

  Future<bool?> _showDeleteConfirmationDialog(
      BuildContext context,
      SizeProduct sizeProduct,
      List<SizeProduct> sizeProducts,
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
                Text('Bạn có chắc muốn xóa kích thước sản phẩm này không?'),
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
                await sizeProductRepository
                    .deleteSizeProduct(sizeProduct.sizeProductId);
                // Xóa khỏi danh sách kích thước sản phẩm
                setState(() {
                  sizeProducts.removeAt(index);
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
                'Kích thước sản phẩm',
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
                      builder: (context) => AddSizeProductPage(),
                    ),
                  );

                  if (result != null && result == true) {
                    // Reload size product list
                    await _updateSizeProductList();
                  }
                },
                child: Text('Thêm'),
              ),
            ],
          ),
          const Gap(16),
          Expanded(
            child: FutureBuilder<List<SizeProduct>>(
              future: sizeProductRepository.getAllSizeProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<SizeProduct> sizeProducts = snapshot.data!;
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListView.separated(
                      itemCount: sizeProducts.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final sizeProduct = sizeProducts[index];
                        return Dismissible(
                          key: Key(sizeProduct.sizeProductId),
                          direction: DismissDirection.startToEnd,
                          confirmDismiss: (direction) async {
                            // Hiển thị hộp thoại xác nhận và chờ kết quả
                            return await _showDeleteConfirmationDialog(
                                context, sizeProduct, sizeProducts, index);
                          },
                          background: Container(
                            alignment: Alignment.centerLeft,
                            color:
                                Colors.red, // Background color of delete button
                            child: Icon(Icons.delete),
                          ),
                          child: ListTile(
                            title: Text(
                              sizeProduct.name,
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SizeProductPage(sizeProduct: sizeProduct),
                                ),
                              );

                              if (result != null && result == true) {
                                // Reload size product list
                                await _updateSizeProductList();
                              }
                            },
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
