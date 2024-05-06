import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ProductNotFoundPage extends StatelessWidget {
  const ProductNotFoundPage({Key? key, required this.productId})
      : super(key: key);

  final String productId;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toFilePath();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Page not found: $location',
              style: Theme.of(context).textTheme.headline6,
            ),
            const Gap(8),
            Text('[$productId] is not found'),
          ],
        ),
      ),
    );
  }
}
