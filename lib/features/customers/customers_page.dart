import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/customer_model.dart';
import 'package:flutter_ltdddoan/repositories/customer/customer_repository.dart';
import 'package:flutter_ltdddoan/features/customers/customer_page.dart';
import 'package:flutter_ltdddoan/features/customers/add_customer_page.dart';
import 'package:gap/gap.dart';

import '../../widgets/widgets.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({Key? key});

  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  late final CustomerRepository customerRepository;
  late List<Customer> _customers = [];
  late List<Customer> _filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    customerRepository = CustomerRepository();
    _updateCustomerList(); // Load initial data
  }

  Future<void> _updateCustomerList({String? searchKeyword}) async {
    final List<Customer> allCustomers = await customerRepository.getCustomers();

    setState(() {
      _customers = allCustomers;
      // Apply filtering if searchKeyword is provided
      _filteredCustomers = _applyFilter(searchKeyword, _customers);
    });
  }

  List<Customer> _applyFilter(String? searchKeyword, List<Customer> customers) {
    if (searchKeyword == null || searchKeyword.isEmpty) {
      return customers;
    }
    return customers.where((customer) {
      final customerEmail = customer.customerEmail.toLowerCase();
      final keyword = searchKeyword.toLowerCase();
      return customerEmail.contains(keyword);
    }).toList();
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
                  _filteredCustomers.removeWhere(
                      (element) => element.customerId == customer.customerId);
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
          TextField(
            onChanged: (value) {
              _updateCustomerList(searchKeyword: value);
            },
            decoration: InputDecoration(
              labelText: 'Tìm kiếm khách hàng',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const Gap(16),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: ListView.separated(
                itemCount: _filteredCustomers.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final customer = _filteredCustomers[index];
                  return Dismissible(
                    key: Key(customer.customerId.toString()),
                    direction: DismissDirection.startToEnd,
                    confirmDismiss: (direction) async {
                      // Hiển thị hộp thoại xác nhận và chờ kết quả
                      return await _showDeleteConfirmationDialog(
                          context, customer, _customers, index);
                    },
                    background: Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.red, // Background color of delete button
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
            ),
          ),
        ],
      ),
    );
  }
}
