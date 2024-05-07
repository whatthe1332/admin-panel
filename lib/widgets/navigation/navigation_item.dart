import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

enum NavigationItem {
  dashboard(iconData: Icons.dashboard_outlined),
  customers(iconData: Icons.list_outlined),
  products(iconData: Icons.shopping_bag),
  productCategories(iconData: Icons.pages),
  genderCategories(iconData: Icons.male),
  sizeProduct(iconData: Icons.minimize),
  availableSizeProduct(iconData: Icons.event_available),
  paymentMethod(iconData: Icons.money);

  const NavigationItem({required this.iconData});
  final IconData iconData;
  String get label => name.pascalCase;
}
