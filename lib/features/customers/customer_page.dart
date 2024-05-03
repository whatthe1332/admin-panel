import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/customer_model.dart';
import 'package:flutter_ltdddoan/repositories/customer/customer_repository.dart';
import 'package:gap/gap.dart';

import '../../widgets/widgets.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({Key? key, required this.customer}) : super(key: key);

  final Customer customer;

  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isActive = false;
  CustomerRepository customerRepository = CustomerRepository();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer.customerName);
    _emailController =
        TextEditingController(text: widget.customer.customerEmail);
    _passwordController =
        TextEditingController(text: widget.customer.customerPassword);
    _isActive = widget.customer.isActive;
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
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                onPressed: () async {
                  final updatedCustomer = Customer(
                    customerId: widget.customer.customerId,
                    customerName: _nameController.text,
                    customerEmail: _emailController.text,
                    customerPassword: _passwordController.text,
                    isActive: _isActive,
                    createdBy: widget.customer.createdBy,
                    createDate: widget.customer.createDate,
                    updatedDate: DateTime.now(),
                    updatedBy: widget.customer.updatedBy,
                    customerAvatar: widget.customer.customerAvatar,
                    customerGender: widget.customer.customerGender,
                    customerBirthDay: widget.customer.customerBirthDay,
                  );

                  await customerRepository.updateCustomer(updatedCustomer);

                  // Trả về kết quả khi cập nhật thành công
                  Navigator.of(context).pop(true);
                },
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.navigate_before),
                label: const Text('Back'),
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
