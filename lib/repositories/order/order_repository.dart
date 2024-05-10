import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ltdddoan/model/orderdetail_model.dart';
import '../../model/order_model.dart';

class OrderRepository {
  final CollectionReference _ordersCollection =
      FirebaseFirestore.instance.collection('orders');
  final CollectionReference _orderDetailsCollection =
      FirebaseFirestore.instance.collection('orderdetails');

  Future<List<OrderModel>> getAllOrders() async {
    try {
      QuerySnapshot querySnapshot = await _ordersCollection.get();

      List<OrderModel> orders = querySnapshot.docs.map((doc) {
        return OrderModel(
          orderId: doc['orderId'],
          note: doc['note'],
          isSuccess: doc['isSuccess'],
          isCancel: doc['isCancel'],
          isReturn: doc['isReturn'],
          isPay: doc['isPay'],
          isConfirm: doc['isConfirm'],
          isShip: doc['isShip'],
          status: doc['status'],
          totalPayment: doc['totalPayment'],
          createDate: (doc['createDate'] as Timestamp).toDate(),
          // confirmDate: (doc['confirmDate'] as Timestamp).toDate(),
          // shipDate: (doc['shipDate'] as Timestamp).toDate(),
          // successDate: (doc['successDate'] as Timestamp).toDate(),
          // cancelDate: (doc['cancelDate'] as Timestamp).toDate(),
          // returnDate: (doc['returnDate'] as Timestamp).toDate(),
          paymentMethodId: doc['paymentMethodId'],
          userId: doc['userId'],
          discountId: doc['discountId'],
          customerAddressId: doc['customerAddressId'],
        );
      }).toList();

      return orders;
    } catch (e) {
      throw Exception("Failed to get all orders: $e");
    }
  }

  Future<List<OrderDetail>> getAllOrderDetailsByOrderId(String orderId) async {
    try {
      QuerySnapshot querySnapshot = await _orderDetailsCollection
          .where('orderId', isEqualTo: orderId)
          .get();

      List<OrderDetail> orderDetails = querySnapshot.docs.map((doc) {
        return OrderDetail(
          orderId: doc['orderId'],
          availableSizeProductId: doc['availableSizeProductId'],
          price: doc['price'],
          quantity: doc['quantity'],
        );
      }).toList();

      return orderDetails;
    } catch (e) {
      throw Exception("Failed to get all order details by orderId: $e");
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      // Xóa đơn hàng từ collection 'orders' với orderId tương ứng
      await _ordersCollection.doc(orderId).delete();

      // Xóa các chi tiết đơn hàng từ collection 'orderdetails' với orderId tương ứng
      QuerySnapshot orderDetailsQuerySnapshot = await _orderDetailsCollection
          .where('orderId', isEqualTo: orderId)
          .get();

      // Lặp qua danh sách các chi tiết đơn hàng và xóa chúng
      for (DocumentSnapshot doc in orderDetailsQuerySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      // Xử lý khi có lỗi xảy ra
      throw Exception("Failed to delete order: $e");
    }
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      DocumentSnapshot orderSnapshot =
          await _ordersCollection.doc(orderId).get();

      if (orderSnapshot.exists) {
        OrderModel order = OrderModel(
          orderId: orderSnapshot['orderId'],
          note: orderSnapshot['note'],
          isSuccess: orderSnapshot['isSuccess'],
          isCancel: orderSnapshot['isCancel'],
          isReturn: orderSnapshot['isReturn'],
          isPay: orderSnapshot['isPay'],
          isConfirm: orderSnapshot['isConfirm'],
          isShip: orderSnapshot['isShip'],
          status: orderSnapshot['status'],
          totalPayment: orderSnapshot['totalPayment'],
          createDate: (orderSnapshot['createDate'] as Timestamp).toDate(),
          // confirmDate: (orderSnapshot['confirmDate'] as Timestamp).toDate(),
          // shipDate: (orderSnapshot['shipDate'] as Timestamp).toDate(),
          // successDate: (orderSnapshot['successDate'] as Timestamp).toDate(),
          // cancelDate: (orderSnapshot['cancelDate'] as Timestamp).toDate(),
          // returnDate: (orderSnapshot['returnDate'] as Timestamp).toDate(),
          paymentMethodId: orderSnapshot['paymentMethodId'],
          userId: orderSnapshot['userId'],
          discountId: orderSnapshot['discountId'],
          customerAddressId: orderSnapshot['customerAddressId'],
        );

        return order;
      } else {
        // Nếu không tìm thấy đơn hàng, trả về null
        return null;
      }
    } catch (e) {
      // Xử lý khi có lỗi xảy ra
      throw Exception("Failed to get order by id: $e");
    }
  }

  Future<void> updateOrder(OrderModel order) async {
    try {
      await _ordersCollection.doc(order.orderId).update({
        'note': order.note,
        'isSuccess': order.isSuccess,
        'isCancel': order.isCancel,
        'isReturn': order.isReturn,
        'isPay': order.isPay,
        'isConfirm': order.isConfirm,
        'isShip': order.isShip,
        'status': order.status,
        'totalPayment': order.totalPayment,
        'createDate': order.createDate,
        'confirmDate': order.confirmDate,
        'shipDate': order.shipDate,
        'successDate': order.successDate,
        'cancelDate': order.cancelDate,
        'returnDate': order.returnDate,
        'paymentMethodId': order.paymentMethodId,
        'userId': order.userId,
        'discountId': order.discountId,
        'customerAddressId': order.customerAddressId,
      });
    } catch (error) {
      print('Error updating order: $error');
      throw error;
    }
  }

  Future<List<OrderModel>> getOrdersByTabName(String tabName) async {
    try {
      List<OrderModel> orders = [];
      QuerySnapshot querySnapshot;

      switch (tabName) {
        case 'Mới':
          querySnapshot = await _ordersCollection
              .where('isConfirm', isEqualTo: false)
              .where('isSuccess', isEqualTo: false)
              .where('isCancel', isEqualTo: false)
              .where('isReturn', isEqualTo: false)
              .get();
          break;
        case 'Đã xác nhận':
          querySnapshot = await _ordersCollection
              .where('isConfirm', isEqualTo: true)
              .where('isShip', isEqualTo: false)
              .where('isSuccess', isEqualTo: false)
              .where('isCancel', isEqualTo: false)
              .where('isReturn', isEqualTo: false)
              .get();
          break;
        case 'Đã giao':
          querySnapshot = await _ordersCollection
              .where('isShip', isEqualTo: true)
              .where('isSuccess', isEqualTo: false)
              .where('isCancel', isEqualTo: false)
              .where('isReturn', isEqualTo: false)
              .get();
          break;
        case 'Hoàn thành':
          querySnapshot = await _ordersCollection
              .where('isSuccess', isEqualTo: true)
              .where('isCancel', isEqualTo: false)
              .where('isReturn', isEqualTo: false)
              .get();
          break;
        case 'Hủy':
          querySnapshot = await _ordersCollection
              .where('isCancel', isEqualTo: true)
              .where('isReturn', isEqualTo: false)
              .get();
          break;
        case 'Hoàn trả':
          querySnapshot =
              await _ordersCollection.where('isReturn', isEqualTo: true).get();
          break;
        default:
          throw Exception('Invalid tab name');
      }

      // Add orders to the list if they meet the conditions
      for (var doc in querySnapshot.docs) {
        if (tabName == 'Mới') {
          if (!(doc['isConfirm'] ||
              doc['isSuccess'] ||
              doc['isCancel'] ||
              doc['isReturn'])) {
            orders.add(OrderModel(
              orderId: doc['orderId'],
              note: doc['note'],
              isSuccess: doc['isSuccess'],
              isCancel: doc['isCancel'],
              isReturn: doc['isReturn'],
              isPay: doc['isPay'],
              isConfirm: doc['isConfirm'],
              isShip: doc['isShip'],
              status: doc['status'],
              totalPayment: doc['totalPayment'],
              createDate: (doc['createDate'] as Timestamp).toDate(),
              paymentMethodId: doc['paymentMethodId'],
              userId: doc['userId'],
              discountId: doc['discountId'],
              customerAddressId: doc['customerAddressId'],
            ));
          }
        } else {
          orders.add(OrderModel(
            orderId: doc['orderId'],
            note: doc['note'],
            isSuccess: doc['isSuccess'],
            isCancel: doc['isCancel'],
            isReturn: doc['isReturn'],
            isPay: doc['isPay'],
            isConfirm: doc['isConfirm'],
            isShip: doc['isShip'],
            status: doc['status'],
            totalPayment: doc['totalPayment'],
            createDate: (doc['createDate'] as Timestamp).toDate(),
            paymentMethodId: doc['paymentMethodId'],
            userId: doc['userId'],
            discountId: doc['discountId'],
            customerAddressId: doc['customerAddressId'],
          ));
        }
      }

      return orders;
    } catch (e) {
      throw Exception("Failed to get orders by tab name: $e");
    }
  }
}
