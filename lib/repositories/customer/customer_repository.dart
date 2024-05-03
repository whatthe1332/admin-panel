import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/model/customer_model.dart';

class CustomerRepository {
  final CollectionReference _customerCollection =
      FirebaseFirestore.instance.collection('customers');

  Future<List<Customer>> getCustomers() async {
    List<Customer> customers = [];
    try {
      QuerySnapshot snapshot = await _customerCollection.get();
      customers = snapshot.docs.map((doc) {
        return Customer(
          customerId: doc.id,
          customerName: doc['customerName'],
          customerEmail: doc['customerEmail'],
          customerPassword: doc['customerPassword'],
          customerGender: doc['customerGender'],
          customerBirthDay: doc['customerBirthDay'].toDate(),
          isActive: doc['isActive'],
          createdBy: doc['createdBy'],
          createDate: doc['createDate'].toDate(),
          updatedDate: doc['updatedDate'].toDate(),
          updatedBy: doc['updatedBy'],
          customerAvatar: doc['customerAvatar'],
        );
      }).toList();
    } catch (error) {
      print('Error getting payment methods: $error');
    }
    return customers;
  }

  Future<int> getCustomerCount() async {
    try {
      QuerySnapshot snapshot = await _customerCollection.get();
      return snapshot.size;
    } catch (error) {
      print('Error getting customer count: $error');
      return 0;
    }
  }

  Future<Customer?> getCustomerById(String customerId) async {
    try {
      DocumentSnapshot snapshot =
          await _customerCollection.doc(customerId).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return Customer(
          customerId: snapshot.id,
          customerName: data['customerName'],
          customerEmail: data['customerEmail'],
          customerPassword: data['customerPassword'],
          customerGender: data['customerGender'],
          customerBirthDay: data['customerBirthDay'].toDate(),
          isActive: data['isActive'],
          createdBy: data['createdBy'],
          createDate: data['createDate'].toDate(),
          updatedDate: data['updatedDate'].toDate(),
          updatedBy: data['updatedBy'],
          customerAvatar: data['customerAvatar'],
        );
      } else {
        print('Customer with ID $customerId not found.');
        return null;
      }
    } catch (error) {
      print('Error getting customer: $error');
      return null;
    }
  }
}
