import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/features/order/order_page.dart';
import 'package:flutter_ltdddoan/model/order_model.dart';
import 'package:flutter_ltdddoan/repositories/order/order_repository.dart';
import 'package:gap/gap.dart';
import '../../widgets/widgets.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late final OrderRepository orderRepository;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    orderRepository = OrderRepository();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _updateOrderList() async {
    setState(() {}); // Kích hoạt việc rebuild để cập nhật danh sách đơn hàng
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context,
      OrderModel order, List<OrderModel> orders, int index) async {
    return await showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc muốn xóa đơn hàng này không?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Không
              },
              child: Text('Không'),
            ),
            TextButton(
              onPressed: () async {
                // Xác nhận xóa
                await orderRepository.deleteOrder(order.orderId!);
                // Xóa khỏi danh sách đơn hàng
                setState(() {
                  orders.removeAt(index);
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

  Widget _buildOrderList(List<OrderModel> orders) {
    final theme = Theme.of(context);

    return ListView.separated(
      itemCount: orders.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final order = orders[index];
        return Dismissible(
          key: Key(order.orderId!),
          direction: DismissDirection.startToEnd,
          confirmDismiss: (direction) async {
            // Show confirmation dialog and await result
            return await _showDeleteConfirmationDialog(
                context, order, orders, index);
          },
          background: Container(
            alignment: Alignment.centerLeft,
            color: Colors.red, // Background color of delete button
            child: Icon(Icons.delete),
          ),
          child: ListTile(
            title: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('customeraddress')
                  .doc(order.customerAddressId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final customerData = snapshot.data!;
                final customerName = customerData['name'];

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('paymentmethods')
                      .doc(order.paymentMethodId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    final paymentMethodData = snapshot.data!;
                    final paymentMethodDes = paymentMethodData['description'];

                    return Text(
                      'Customer Name: $customerName\n'
                      'Payment Method: $paymentMethodDes\n'
                      'Status: ${order.status}\n',
                      style: theme.textTheme.bodyMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    );
                  },
                );
              },
            ),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderPage(order: order),
                ),
              );

              if (result != null && result == true) {
                // Reload order list
                await _updateOrderList();
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContentView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Đơn hàng',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Mới'),
              Tab(text: 'Đã xác nhận'),
              Tab(text: 'Đã giao'),
              Tab(text: 'Hoàn thành'),
              Tab(text: 'Hủy'),
              Tab(text: 'Hoàn trả'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                FutureBuilder<List<OrderModel>>(
                  future: orderRepository.getOrdersByTabName('Mới'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Lỗi: ${snapshot.error}'));
                    } else {
                      List<OrderModel> orders = snapshot.data!;
                      return _buildOrderList(orders);
                    }
                  },
                ),
                FutureBuilder<List<OrderModel>>(
                  future: orderRepository.getOrdersByTabName('Đã xác nhận'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Lỗi: ${snapshot.error}'));
                    } else {
                      List<OrderModel> orders = snapshot.data!;
                      return _buildOrderList(orders);
                    }
                  },
                ),
                FutureBuilder<List<OrderModel>>(
                  future: orderRepository.getOrdersByTabName('Đã giao'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Lỗi: ${snapshot.error}'));
                    } else {
                      List<OrderModel> orders = snapshot.data!;
                      return _buildOrderList(orders);
                    }
                  },
                ),
                FutureBuilder<List<OrderModel>>(
                  future: orderRepository.getOrdersByTabName('Hoàn thành'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Lỗi: ${snapshot.error}'));
                    } else {
                      List<OrderModel> orders = snapshot.data!;
                      return _buildOrderList(orders);
                    }
                  },
                ),
                FutureBuilder<List<OrderModel>>(
                  future: orderRepository.getOrdersByTabName('Hủy'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Lỗi: ${snapshot.error}'));
                    } else {
                      List<OrderModel> orders = snapshot.data!;
                      return _buildOrderList(orders);
                    }
                  },
                ),
                FutureBuilder<List<OrderModel>>(
                  future: orderRepository.getOrdersByTabName('Hoàn trả'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Lỗi: ${snapshot.error}'));
                    } else {
                      List<OrderModel> orders = snapshot.data!;
                      return _buildOrderList(orders);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
