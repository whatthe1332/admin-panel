import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/order_model.dart';
import 'package:flutter_ltdddoan/model/orderdetail_model.dart';
import 'package:flutter_ltdddoan/repositories/order/order_repository.dart';
import 'package:gap/gap.dart';

import '../../widgets/widgets.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key, required this.order}) : super(key: key);

  final OrderModel order;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late final TextEditingController _noteController;
  late final OrderRepository _orderRepository;
  late List<OrderDetail> _orderDetails = [];
  late String? _statusValue;
  bool _isPay = false;
  late String _productName = '';
  late String _sizeName = '';

  @override
  void initState() {
    super.initState();
    _statusValue = null;
    _noteController = TextEditingController(text: widget.order.note);
    _orderRepository = OrderRepository();
    _loadOrderDetails();
    _isPay = widget.order.isPay!;

    if ([
      'Chờ vận chuyển',
      'Đang vận chuyển',
      'Đã hủy',
      'Hoàn thành',
      'Trả hàng'
    ].contains(widget.order.status)) {
      _statusValue = widget.order.status!;
    }
  }

  Future<void> _loadOrderDetails() async {
    try {
      List<OrderDetail> orderDetails = await _orderRepository
          .getAllOrderDetailsByOrderId(widget.order.orderId!);
      setState(() {
        _orderDetails = orderDetails;
      });
    } catch (e) {
      print('Error loading order details: $e');
      setState(() {
        _orderDetails = [];
      });
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveOrder() async {
    bool isConfirm = false;
    bool isShip = false;
    bool isCancel = false;
    bool isSuccess = false;
    bool isReturn = false;
    DateTime? confirmDate;
    DateTime? shipDate;
    DateTime? cancelDate;
    DateTime? successDate;
    DateTime? returnDate;

    if (_statusValue == 'Chờ vận chuyển') {
      isConfirm = true;
      confirmDate = DateTime.now();
    } else if (_statusValue == 'Đang vận chuyển') {
      isShip = true;
      shipDate = DateTime.now();
    } else if (_statusValue == 'Đã hủy') {
      isCancel = true;
      cancelDate = DateTime.now();
    } else if (_statusValue == 'Hoàn thành') {
      isSuccess = true;
      successDate = DateTime.now();
    } else if (_statusValue == 'Trả hàng') {
      isReturn = true;
      returnDate = DateTime.now();
    } else {
      _statusValue = 'Chờ xác nhận';
    }

    final updatedOrder = OrderModel(
      orderId: widget.order.orderId,
      note: _noteController.text,
      isSuccess: isSuccess,
      isCancel: isCancel,
      isReturn: isReturn,
      isPay: _isPay,
      isConfirm: isConfirm,
      isShip: isShip,
      status: _statusValue,
      totalPayment: widget.order.totalPayment,
      createDate: widget.order.createDate,
      confirmDate: confirmDate,
      shipDate: shipDate,
      successDate: successDate,
      cancelDate: cancelDate,
      returnDate: returnDate,
      paymentMethodId: widget.order.paymentMethodId,
      userId: widget.order.userId,
      discountId: widget.order.discountId,
      customerAddressId: widget.order.customerAddressId,
    );

    try {
      await _orderRepository.updateOrder(updatedOrder);
      Navigator.of(context).pop(true);
    } catch (e) {
      print('Error saving order: $e');
    }
  }

  Future<void> _loadProductAndSizeInfo(String availableSizeProductId) async {
    try {
      // Lấy thông tin sản phẩm từ cơ sở dữ liệu
      DocumentSnapshot availableSizeProductSnapshot = await FirebaseFirestore
          .instance
          .collection('availablesizeproduct')
          .doc(availableSizeProductId)
          .get();
      Map<String, dynamic> availableSizeProductData =
          availableSizeProductSnapshot.data() as Map<String, dynamic>;
      String productId = availableSizeProductData['productId'];
      String sizeProductId = availableSizeProductData['sizeProductId'];
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();
      Map<String, dynamic> productData =
          productSnapshot.data() as Map<String, dynamic>;
      String productName = productData['name'];

      DocumentSnapshot sizeSnapshot = await FirebaseFirestore.instance
          .collection('sizeproduct')
          .doc(sizeProductId)
          .get();
      Map<String, dynamic> sizeData =
          sizeSnapshot.data() as Map<String, dynamic>;
      String sizeName = sizeData['name'];

      setState(() {
        _productName = productName;
        _sizeName = sizeName;
      });
    } catch (e) {
      print('Error loading product and size info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContentView(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: _orderDetails.length,
              itemBuilder: (context, index) {
                if (_orderDetails.isNotEmpty) {
                  _loadProductAndSizeInfo(
                      _orderDetails[index].availableSizeProductId!);
                } else {
                  _productName = '';
                  _sizeName = '';
                }
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Detail ${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Product Name: $_productName',
                          style: TextStyle(fontSize: 10),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Size Name: $_sizeName',
                          style: TextStyle(fontSize: 10),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Price: ${_orderDetails[index].price}',
                          style: TextStyle(fontSize: 10),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Quantity: ${_orderDetails[index].quantity}',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Gap(16),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
              ),
            ),
            const Gap(16),
            DropdownButtonFormField<String>(
              value: _statusValue,
              onChanged: (String? value) {
                setState(() {
                  _statusValue = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: <String>[
                'Chờ vận chuyển',
                'Đang vận chuyển',
                'Đã hủy',
                'Hoàn thành',
                'Trả hàng',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const Gap(16),
            Row(
              children: [
                Text('Is Pay:'),
                Checkbox(
                  value: _isPay,
                  onChanged: (value) {
                    setState(() {
                      _isPay = value!;
                    });
                  },
                ),
              ],
            ),
            const Gap(16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _saveOrder,
                  child: const Text('Lưu'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Quay lại'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
