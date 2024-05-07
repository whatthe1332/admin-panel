import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/features/GenderCategory/add_genderCategory_page.dart';
import 'package:flutter_ltdddoan/features/GenderCategory/genderCategory_not_found_page.dart';
import 'package:flutter_ltdddoan/features/GenderCategory/genderCategory_page.dart';
import 'package:flutter_ltdddoan/model/gendercategory_model.dart';
import 'package:flutter_ltdddoan/repositories/genderCategory/genderCategory_repository.dart';
import 'package:gap/gap.dart';
import '../../widgets/widgets.dart';

class GenderCategoriesPage extends StatefulWidget {
  const GenderCategoriesPage({Key? key});

  @override
  _GenderCategoriesPageState createState() => _GenderCategoriesPageState();
}

class _GenderCategoriesPageState extends State<GenderCategoriesPage> {
  late final GenderCategoryRepository genderCategoryRepository;

  @override
  void initState() {
    super.initState();
    genderCategoryRepository = GenderCategoryRepository();
  }

  Future<void> _updateGenderCategoryList() async {
    setState(() {}); // Trigger rebuild to update gender category list
  }

  Future<bool?> _showDeleteConfirmationDialog(
      BuildContext context,
      GenderCategory genderCategory,
      List<GenderCategory> genderCategories,
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
                Text('Bạn có chắc muốn xóa danh mục giới tính này không?'),
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
                await genderCategoryRepository
                    .deleteGenderCategory(genderCategory.genderCategoryId!);
                // Xóa khỏi danh sách danh mục giới tính
                setState(() {
                  genderCategories.removeAt(index);
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
                'Danh mục giới tính',
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
                      builder: (context) => AddGenderCategoryPage(),
                    ),
                  );

                  if (result != null && result == true) {
                    // Reload gender category list
                    await _updateGenderCategoryList();
                  }
                },
                child: Text('Thêm'),
              ),
            ],
          ),
          const Gap(16),
          Expanded(
            child: FutureBuilder<List<GenderCategory>>(
              future: genderCategoryRepository.getAllGenderCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<GenderCategory> genderCategories = snapshot.data!;
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListView.separated(
                      itemCount: genderCategories.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final genderCategory = genderCategories[index];
                        return Dismissible(
                          key: Key(genderCategory.genderCategoryId!),
                          direction: DismissDirection.startToEnd,
                          confirmDismiss: (direction) async {
                            // Hiển thị hộp thoại xác nhận và chờ kết quả
                            return await _showDeleteConfirmationDialog(context,
                                genderCategory, genderCategories, index);
                          },
                          background: Container(
                            alignment: Alignment.centerLeft,
                            color:
                                Colors.red, // Background color of delete button
                            child: Icon(Icons.delete),
                          ),
                          child: ListTile(
                            title: Text(
                              genderCategory.name,
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GenderCategoryPage(
                                      genderCategory: genderCategory),
                                ),
                              );

                              if (result != null && result == true) {
                                // Reload gender category list
                                await _updateGenderCategoryList();
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
