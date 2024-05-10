import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/repositories/payment/paymentmethod_repository.dart';
import 'package:gap/gap.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../widgets/widgets.dart';
import 'add_paymentMethod_page.dart';
import 'paymentMethod_page.dart';
import 'package:flutter_ltdddoan/model/paymentmethod_model.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({Key? key});

  @override
  _PaymentMethodsPageState createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  // Declare the repository instance
  late final PaymentMethodRepository paymentMethodRepository;

  @override
  void initState() {
    super.initState();
    // Initialize the repository instance
    paymentMethodRepository = PaymentMethodRepository();
  }

  Future<void> _updatePaymentMethodList() async {
    setState(() {}); // Trigger rebuild to update payment method list
  }

  Future<String> _getImageUrl(String imagePath) async {
    if (imagePath.isNotEmpty) {
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      final url = await ref.getDownloadURL();
      return url;
    } else {
      return '';
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(
      BuildContext context,
      PaymentMethod paymentMethod,
      List<PaymentMethod> paymentMethods,
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
                Text('Bạn có chắc muốn xóa phương thức thanh toán này không?'),
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
                await paymentMethodRepository
                    .deletePaymentMethod(paymentMethod.paymentMethodId!);
                setState(() {
                  paymentMethods.removeAt(index);
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
                'Phương thức thanh toán',
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
                      builder: (context) => AddPaymentMethodPage(),
                    ),
                  );

                  if (result != null && result == true) {
                    // Reload payment method list
                    await _updatePaymentMethodList();
                  }
                },
                child: Text('Thêm'),
              ),
            ],
          ),
          const Gap(16),
          Expanded(
            child: FutureBuilder<List<PaymentMethod>>(
              future: paymentMethodRepository.getPaymentMethods(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<PaymentMethod> paymentMethods = snapshot.data!;
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListView.separated(
                      itemCount: paymentMethods.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final paymentMethod = paymentMethods[index];
                        return Dismissible(
                          key: Key(paymentMethod.paymentMethodId!),
                          direction: DismissDirection.startToEnd,
                          confirmDismiss: (direction) async {
                            // Show confirmation dialog and wait for result
                            return await _showDeleteConfirmationDialog(
                                context, paymentMethod, paymentMethods, index);
                          },
                          background: Container(
                            alignment: Alignment.centerLeft,
                            color:
                                Colors.red, // Background color of delete button
                            child: Icon(Icons.delete),
                          ),
                          child: ListTile(
                            leading: Image.network(
                              paymentMethod.icon.isNotEmpty
                                  ? paymentMethod.icon
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
                              paymentMethod.name,
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              paymentMethod.description,
                              style: theme.textTheme.labelMedium,
                            ),
                            trailing: const Icon(Icons.navigate_next_outlined),
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentMethodPage(
                                    paymentMethod: paymentMethod,
                                  ),
                                ),
                              );

                              if (result != null && result == true) {
                                // Reload payment method list
                                await _updatePaymentMethodList();
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
