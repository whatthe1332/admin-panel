import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/features/ProductCategory/add_productCategory_page.dart';
import 'package:flutter_ltdddoan/features/ProductCategory/productCategory_not_found_page.dart';
import 'package:flutter_ltdddoan/features/ProductCategory/productCategory_page.dart';
import 'package:flutter_ltdddoan/model/productcategory_model.dart';
import 'package:flutter_ltdddoan/repositories/productCategory/productCategory_repository.dart';
import 'package:gap/gap.dart';
import '../../widgets/widgets.dart';

class ProductCategoriesPage extends StatefulWidget {
  const ProductCategoriesPage({Key? key});

  @override
  _ProductCategoriesPageState createState() => _ProductCategoriesPageState();
}

class _ProductCategoriesPageState extends State<ProductCategoriesPage> {
  late final ProductCategoryRepository productCategoryRepository;

  @override
  void initState() {
    super.initState();
    productCategoryRepository = ProductCategoryRepository();
  }

  Future<void> _updateProductCategoryList() async {
    setState(() {}); // Trigger rebuild to update product category list
  }

  Future<bool?> _showDeleteConfirmationDialog(
      BuildContext context,
      ProductCategory productCategory,
      List<ProductCategory> productCategories,
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
                Text('Bạn có chắc muốn xóa danh mục sản phẩm này không?'),
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
                await productCategoryRepository
                    .deleteProductCategory(productCategory.productCategoryId!);
                // Xóa khỏi danh sách danh mục sản phẩm
                setState(() {
                  productCategories.removeAt(index);
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
                'Danh mục sản phẩm',
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
                      builder: (context) => AddProductCategoryPage(),
                    ),
                  );

                  if (result != null && result == true) {
                    // Reload product category list
                    await _updateProductCategoryList();
                  }
                },
                child: Text('Thêm'),
              ),
            ],
          ),
          const Gap(16),
          Expanded(
            child: FutureBuilder<List<ProductCategory>>(
              future: productCategoryRepository.getAllProductCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<ProductCategory> productCategories = snapshot.data!;
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListView.separated(
                      itemCount: productCategories.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final productCategory = productCategories[index];
                        return Dismissible(
                          key: Key(productCategory.productCategoryId!),
                          direction: DismissDirection.startToEnd,
                          confirmDismiss: (direction) async {
                            // Hiển thị hộp thoại xác nhận và chờ kết quả
                            return await _showDeleteConfirmationDialog(context,
                                productCategory, productCategories, index);
                          },
                          background: Container(
                            alignment: Alignment.centerLeft,
                            color:
                                Colors.red, // Background color of delete button
                            child: Icon(Icons.delete),
                          ),
                          child: ListTile(
                            title: Text(
                              productCategory.name,
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductCategoryPage(
                                      productCategory: productCategory),
                                ),
                              );

                              if (result != null && result == true) {
                                // Reload product category list
                                await _updateProductCategoryList();
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
