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
          customerBirthDay: doc['customerBirthDay'] != null
              ? doc['customerBirthDay'].toDate()
              : null,
          isActive: doc['isActive'],
          createdBy: doc['createdBy'],
          createDate:
              doc['createDate'] != null ? doc['createDate'].toDate() : null,
          updatedDate:
              doc['updatedDate'] != null ? doc['updatedDate'].toDate() : null,
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

  Future<void> updateCustomer(Customer updatedCustomer) async {
    try {
      await _customerCollection.doc(updatedCustomer.customerId).update({
        'customerName': updatedCustomer.customerName,
        'customerEmail': updatedCustomer.customerEmail,
        'customerPassword': updatedCustomer.customerPassword,
        'isActive': updatedCustomer.isActive,
        'updatedDate': updatedCustomer.updatedDate,
        'updatedBy': updatedCustomer.updatedBy,
        'customerAvatar': updatedCustomer.customerAvatar,
        'customerGender': updatedCustomer.customerGender,
        'customerBirthDay': updatedCustomer.customerBirthDay,
      });
    } catch (error) {
      print('Error updating customer: $error');
      throw error;
    }
  }

  Future<void> addCustomer(Customer newCustomer) async {
    try {
      DocumentReference docRef = await _customerCollection.add({
        'customerName': newCustomer.customerName,
        'customerEmail': newCustomer.customerEmail,
        'customerPassword': newCustomer.customerPassword,
        'isActive': newCustomer.isActive,
        'createdBy': newCustomer.createdBy,
        'createDate': newCustomer.createDate,
        'updatedDate': newCustomer.updatedDate,
        'updatedBy': newCustomer.updatedBy,
        'customerAvatar': newCustomer.customerAvatar,
        'customerGender': newCustomer.customerGender,
        'customerBirthDay': newCustomer.customerBirthDay,
      });

      // Update CustomerId with the document id
      await docRef.update({'customerId': docRef.id});
    } catch (error) {
      print('Error adding customer: $error');
      throw error;
    }
  }

  Future<void> deleteCustomer(String customerId) async {
    try {
      await _customerCollection.doc(customerId).delete();
    } catch (error) {
      print('Error deleting customer: $error');
      throw error;
    }
  }
}
