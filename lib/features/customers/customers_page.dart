import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/customer_model.dart';
import 'package:flutter_ltdddoan/repositories/customer/customer_repository.dart';
import 'package:flutter_ltdddoan/features/customers/customer_page.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ContentView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danh sách Customers',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
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
                        return ListTile(
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
