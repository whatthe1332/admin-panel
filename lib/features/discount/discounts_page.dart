import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/features/discount/add_discount_page.dart';
import 'package:flutter_ltdddoan/features/discount/discount_page.dart';
import 'package:flutter_ltdddoan/repositories/discount/discount_repository.dart';
import 'package:gap/gap.dart';

import '../../widgets/widgets.dart';
import 'package:flutter_ltdddoan/model/discount_model.dart';

class DiscountsPage extends StatefulWidget {
  const DiscountsPage({Key? key});

  @override
  _DiscountsPageState createState() => _DiscountsPageState();
}

class _DiscountsPageState extends State<DiscountsPage> {
  late final DiscountRepository discountRepository;

  @override
  void initState() {
    super.initState();
    // Initialize the repository instance
    discountRepository = DiscountRepository();
  }

  Future<void> _updateDiscountList() async {
    setState(() {});
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context,
      Discount discount, List<Discount> discounts, int index) async {
    return await showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc muốn xóa ưu đãi này không?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Không'),
            ),
            TextButton(
              onPressed: () async {
                await discountRepository.deleteDiscount(discount.discountId!);
                setState(() {
                  discounts.removeAt(index);
                });
                Navigator.of(context).pop(true);
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
                'Khuyến mãi',
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
                      builder: (context) => AddDiscountPage(),
                    ),
                  );

                  if (result != null && result == true) {
                    // Reload discount list
                    await _updateDiscountList();
                  }
                },
                child: Text('Thêm'),
              ),
            ],
          ),
          const Gap(16),
          Expanded(
            child: FutureBuilder<List<Discount>>(
              future: discountRepository.getDiscounts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Discount> discounts = snapshot.data!;
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListView.separated(
                      itemCount: discounts.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final discount = discounts[index];
                        return Dismissible(
                          key: Key(discount.discountId!),
                          direction: DismissDirection.startToEnd,
                          confirmDismiss: (direction) async {
                            // Show confirmation dialog and wait for result
                            return await _showDeleteConfirmationDialog(
                                context, discount, discounts, index);
                          },
                          background: Container(
                            alignment: Alignment.centerLeft,
                            color: Colors.red,
                            child: Icon(Icons.delete),
                          ),
                          child: ListTile(
                            leading: Image.network(
                              discount.image.isNotEmpty
                                  ? discount.image
                                  : 'assets/images/default_product.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return Image.asset(
                                  'assets/images/default_product.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                            title: Text(
                              discount.name,
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              discount.description,
                              style: theme.textTheme.labelMedium,
                            ),
                            trailing: const Icon(Icons.navigate_next_outlined),
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DiscountPage(
                                    discount: discount,
                                  ),
                                ),
                              );

                              if (result != null && result == true) {
                                // Reload discount list
                                await _updateDiscountList();
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
