import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/customer_model.dart';
import 'package:flutter_ltdddoan/repositories/customer/customer_repository.dart';
import 'package:flutter_ltdddoan/features/customers/customer_page.dart';
import 'package:flutter_ltdddoan/features/customers/add_customer_page.dart'; // Import trang thêm khách hàng
import 'package:gap/gap.dart';

import '../../widgets/widgets.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({Key? key});

  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  late final CustomerRepository customerRepository;

  @override
  void initState() {
    super.initState();
    customerRepository = CustomerRepository();
  }

  Future<void> _updateCustomerList() async {
    setState(() {}); // Trigger rebuild to update customer list
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context,
      Customer customer, List<Customer> customers, int index) async {
    return await showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc muốn xóa khách hàng này không?'),
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
                await customerRepository.deleteCustomer(customer.customerId!);
                // Xóa khỏi danh sách khách hàng
                setState(() {
                  customers.removeAt(index);
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
                'Khách hàng',
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
                      builder: (context) => AddCustomerPage(),
                    ),
                  );

                  if (result != null && result == true) {
                    // Reload customer list
                    await _updateCustomerList();
                  }
                },
                child: Text('Thêm'),
              ),
            ],
          ),
          const Gap(16),
          Expanded(
            child: FutureBuilder<List<Customer>>(
              future: customerRepository.getCustomers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Customer> lstCustomers = snapshot.data!;
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListView.separated(
                      itemCount: lstCustomers.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final customer = lstCustomers[index];
                        return Dismissible(
                          key: Key(customer.customerId.toString()),
                          direction: DismissDirection.startToEnd,
                          confirmDismiss: (direction) async {
                            // Hiển thị hộp thoại xác nhận và chờ kết quả
                            return await _showDeleteConfirmationDialog(
                                context, customer, lstCustomers, index);
                          },
                          background: Container(
                            alignment: Alignment.centerLeft,
                            color:
                                Colors.red, // Background color of delete button
                            child: Icon(Icons.delete),
                          ),
                          child: ListTile(
                            title: Text(
                              customer.customerEmail,
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              customer.customerPassword,
                              style: theme.textTheme.labelMedium,
                            ),
                            trailing: const Icon(Icons.navigate_next_outlined),
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CustomerPage(customer: customer),
                                ),
                              );

                              if (result != null && result == true) {
                                // Reload customer list
                                await _updateCustomerList();
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
