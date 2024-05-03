import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/customer_model.dart';
import 'package:flutter_ltdddoan/repositories/customer/customer_repository.dart';
import 'package:flutter_ltdddoan/router.dart';
import 'package:gap/gap.dart';

import '../../widgets/widgets.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customerRepository = CustomerRepository();

    return ContentView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Customers',
            description: 'List of customers who can sign in to this dashboard.',
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
                          onTap: () {
                            CustomerPageRoute(customerId: customer.customerId!)
                                .go(context);
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
