import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/customer_model.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/widgets.dart';

class CustomerPage extends StatelessWidget {
  const CustomerPage({super.key, required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ContentView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            customer.customerEmail,
            style: theme.textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text('Password: ${customer.customerPassword}'),
          Text('Is Active: ${customer.isActive}'),
          const Gap(16),
          ElevatedButton.icon(
            icon: const Icon(Icons.navigate_before),
            label: const Text('Quay lại'),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
