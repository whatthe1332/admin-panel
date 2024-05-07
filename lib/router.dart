import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/features/AvailableSizeProduct/availableSizeProduct_not_found_page.dart';
import 'package:flutter_ltdddoan/features/AvailableSizeProduct/availableSizeProduct_page.dart';
import 'package:flutter_ltdddoan/features/AvailableSizeProduct/availableSizeProducts_page.dart';
import 'package:flutter_ltdddoan/features/GenderCategory/genderCategories_page.dart';
import 'package:flutter_ltdddoan/features/GenderCategory/genderCategory_not_found_page.dart';
import 'package:flutter_ltdddoan/features/GenderCategory/genderCategory_page.dart';
import 'package:flutter_ltdddoan/features/PaymentMethod/PaymentMethods_page.dart';
import 'package:flutter_ltdddoan/features/PaymentMethod/paymentMethod_not_found_page.dart';
import 'package:flutter_ltdddoan/features/PaymentMethod/paymentMethod_page.dart';
import 'package:flutter_ltdddoan/features/ProductCategory/productCategories_page.dart';
import 'package:flutter_ltdddoan/features/ProductCategory/productCategory_not_found_page.dart';
import 'package:flutter_ltdddoan/features/ProductCategory/productCategory_page.dart';
import 'package:flutter_ltdddoan/features/Products/product_not_found_page.dart';
import 'package:flutter_ltdddoan/features/SizeProduct/SizeProduct_not_found_page.dart';
import 'package:flutter_ltdddoan/features/SizeProduct/SizeProducts_page.dart';
import 'package:flutter_ltdddoan/features/SizeProduct/sizeProduct_page.dart';
import 'package:flutter_ltdddoan/features/customers/customer_not_found_page.dart';
import 'package:flutter_ltdddoan/model/available_product_sizes.dart';
import 'package:flutter_ltdddoan/model/customer_model.dart';
import 'package:flutter_ltdddoan/model/gendercategory_model.dart';
import 'package:flutter_ltdddoan/model/paymentmethod_model.dart';
import 'package:flutter_ltdddoan/model/product_model.dart';
import 'package:flutter_ltdddoan/model/productcategory_model.dart';
import 'package:flutter_ltdddoan/model/sizeproduct_model.dart';
import 'package:flutter_ltdddoan/repositories/availableProduct/availableProduct_repository.dart';
import 'package:flutter_ltdddoan/repositories/customer/customer_repository.dart';
import 'package:flutter_ltdddoan/repositories/genderCategory/genderCategory_repository.dart';
import 'package:flutter_ltdddoan/repositories/payment/paymentmethod_repository.dart';
import 'package:flutter_ltdddoan/repositories/productCategory/productCategory_repository.dart';
import 'package:flutter_ltdddoan/repositories/products/product_detail.dart';
import 'package:flutter_ltdddoan/repositories/sizeProduct/sizeProduct_repository.dart';
import 'package:go_router/go_router.dart';

import 'features/dashboard/dashbord_page.dart';
import 'features/customers/customer_page.dart';
import 'features/customers/customers_page.dart';
import 'features/Products/product_page.dart';
import 'features/Products/products_page.dart';
import 'widgets/widgets.dart';

part 'router.g.dart';

const routerInitialLocation = '/';

final router = GoRouter(
  routes: $appRoutes,
  debugLogDiagnostics: kDebugMode,
  initialLocation: routerInitialLocation,
);

@TypedStatefulShellRoute<ShellRouteData>(
  branches: [
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<DashboardRoute>(
          path: routerInitialLocation,
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<CustomersPageRoute>(
          path: '/customers',
          routes: [
            TypedGoRoute<CustomerPageRoute>(
              path: ':customerId',
            ),
          ],
        ),
        TypedGoRoute<ProductsPageRoute>(
          path: '/products',
          routes: [
            TypedGoRoute<ProductPageRoute>(
              path: ':productId',
            ),
          ],
        ),
        TypedGoRoute<ProductCategoriesPageRoute>(
          path: '/productCategories',
          routes: [
            TypedGoRoute<ProductCategoryPageRoute>(
              path: ':productCategoryId',
            ),
          ],
        ),
        TypedGoRoute<GenderCategoriesPageRoute>(
          path: '/genderCategories',
          routes: [
            TypedGoRoute<GenderCategoryPageRoute>(
              path: ':genderCategoryId',
            ),
          ],
        ),
        TypedGoRoute<SizeProductsPageRoute>(
          path: '/sizeProduct',
          routes: [
            TypedGoRoute<SizeProductPageRoute>(
              path: ':sizeProductId',
            ),
          ],
        ),
        TypedGoRoute<AvailableSizeProductsPageRoute>(
          path: '/availableSizeProduct',
          routes: [
            TypedGoRoute<AvailableSizeProductPageRoute>(
              path: ':id',
            ),
          ],
        ),
        TypedGoRoute<PaymentMethodsPageRoute>(
          path: '/paymentMethod',
          routes: [
            TypedGoRoute<PaymentMethodPageRoute>(
              path: ':paymentMethodId',
            ),
          ],
        ),
      ],
    ),
  ],
)
class ShellRouteData extends StatefulShellRouteData {
  const ShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return SelectionArea(
      child: ScaffoldWithNavigation(
        navigationShell: navigationShell,
      ),
    );
  }
}

class DashboardRoute extends GoRouteData {
  const DashboardRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DashBoardPage();
  }
}

class CustomersPageRoute extends GoRouteData {
  const CustomersPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CustomersPage();
  }
}

class CustomerPageRoute extends GoRouteData {
  const CustomerPageRoute({required this.customerId});
  final String customerId;
  @override
  Widget build(BuildContext context, GoRouterState state) {
    CustomerRepository customerRepository = CustomerRepository();
    return FutureBuilder<Customer?>(
      future: customerRepository.getCustomerById(customerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          final customer = snapshot.data;
          return customer == null
              ? CustomerNotFoundPage(customerId: customerId)
              : CustomerPage(customer: customer);
        }
      },
    );
  }
}

class ProductsPageRoute extends GoRouteData {
  const ProductsPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProductsPage();
  }
}

class ProductPageRoute extends GoRouteData {
  const ProductPageRoute({required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FutureBuilder<Product?>(
      future: ProductRepository().getProductById(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          final product = snapshot.data;
          return product == null
              ? ProductNotFoundPage(productId: productId)
              : ProductPage(product: product);
        }
      },
    );
  }
}

class ProductCategoriesPageRoute extends GoRouteData {
  const ProductCategoriesPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProductCategoriesPage();
  }
}

class ProductCategoryPageRoute extends GoRouteData {
  final String productCategoryId;

  const ProductCategoryPageRoute({required this.productCategoryId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FutureBuilder<ProductCategory?>(
      future:
          ProductCategoryRepository().getProductCategoryById(productCategoryId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          final productCategory = snapshot.data;
          return productCategory == null
              ? ProductCategoryNotFoundPage()
              : ProductCategoryPage(productCategory: productCategory);
        }
      },
    );
  }
}

class GenderCategoriesPageRoute extends GoRouteData {
  const GenderCategoriesPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GenderCategoriesPage();
  }
}

class GenderCategoryPageRoute extends GoRouteData {
  final String genderCategoryId;

  const GenderCategoryPageRoute({required this.genderCategoryId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FutureBuilder<GenderCategory?>(
      future:
          GenderCategoryRepository().getGenderCategoryById(genderCategoryId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          final genderCategory = snapshot.data;
          return genderCategory == null
              ? GenderCategoryNotFoundPage()
              : GenderCategoryPage(genderCategory: genderCategory);
        }
      },
    );
  }
}

class SizeProductsPageRoute extends GoRouteData {
  const SizeProductsPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SizeProductsPage();
  }
}

class SizeProductPageRoute extends GoRouteData {
  final String sizeProductId;

  const SizeProductPageRoute({required this.sizeProductId});

  @override
  Widget builder(BuildContext context, GoRouterState state) {
    return FutureBuilder<SizeProduct?>(
      future: SizeProductRepository().getSizeProductById(sizeProductId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          final sizeProduct = snapshot.data;
          return sizeProduct == null
              ? SizeProductNotFoundPage()
              : SizeProductPage(sizeProduct: sizeProduct);
        }
      },
    );
  }
}

class AvailableSizeProductsPageRoute extends GoRouteData {
  const AvailableSizeProductsPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AvailableSizeProductsPage();
  }
}

class AvailableSizeProductPageRoute extends GoRouteData {
  final String id;

  const AvailableSizeProductPageRoute({required this.id});

  @override
  Widget builder(BuildContext context, GoRouterState state) {
    return FutureBuilder<AvailableSizeProduct?>(
      future: AvailableSizeProductRepository().getAvailableSizeProductById(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          final availableSizeProduct = snapshot.data;
          return availableSizeProduct == null
              ? AvailableSizeProductNotFoundPage()
              : AvailableSizeProductPage(
                  availableSizeProduct: availableSizeProduct);
        }
      },
    );
  }
}

class PaymentMethodsPageRoute extends GoRouteData {
  const PaymentMethodsPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PaymentMethodsPage();
  }
}

class PaymentMethodPageRoute extends GoRouteData {
  final String paymentMethodId;

  const PaymentMethodPageRoute({required this.paymentMethodId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FutureBuilder<PaymentMethod?>(
      future: PaymentMethodRepository().getPaymentMethodById(paymentMethodId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          final paymentMethod = snapshot.data;
          return paymentMethod == null
              ? PaymentMethodNotFoundPage()
              : PaymentMethodPage(paymentMethod: paymentMethod);
        }
      },
    );
  }
}
