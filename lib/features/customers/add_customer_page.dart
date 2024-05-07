import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/customer_model.dart';
import 'package:flutter_ltdddoan/repositories/customer/customer_repository.dart';
import 'package:gap/gap.dart';

import '../../widgets/widgets.dart';

class AddCustomerPage extends StatefulWidget {
  const AddCustomerPage({Key? key}) : super(key: key);

  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isActive = false;
  late final CustomerRepository _customerRepository;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _customerRepository = CustomerRepository();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ContentView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const Gap(16),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const Gap(16),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          const Gap(16),
          Row(
            children: [
              Text('Is Active:'),
              Checkbox(
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value!;
                  });
                },
              ),
            ],
          ),
          const Gap(16),
          Row(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Thêm'),
                onPressed: () async {
                  final newCustomer = Customer(
                    customerName: _nameController.text,
                    customerEmail: _emailController.text,
                    customerPassword: _passwordController.text,
                    isActive: _isActive,
                    customerGender: '',
                    customerBirthDay: null,
                    createdBy: 'admin',
                    createDate: DateTime.now(),
                    updatedDate: DateTime.now(),
                    updatedBy: 'admin',
                    customerAvatar: '',
                  );

                  await _customerRepository.addCustomer(newCustomer);

                  Navigator.of(context).pop(true);
                },
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.navigate_before),
                label: const Text('Quay lại'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
