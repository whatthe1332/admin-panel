// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $shellRouteData,
    ];

RouteBase get $shellRouteData => StatefulShellRouteData.$route(
      factory: $ShellRouteDataExtension._fromState,
      branches: [
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/',
              factory: $DashboardRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/customers',
              factory: $CustomersPageRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: ':customerId',
                  factory: $CustomerPageRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/products',
              factory: $ProductsPageRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: ':productId',
                  factory: $ProductPageRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/productCategories',
              factory: $ProductCategoriesPageRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: ':productCategoryId',
                  factory: $ProductCategoryPageRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/genderCategories',
              factory: $GenderCategoriesPageRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: ':genderCategoryId',
                  factory: $GenderCategoryPageRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/sizeProduct',
              factory: $SizeProductsPageRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: ':sizeProductId',
                  factory: $SizeProductPageRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/availableSizeProduct',
              factory: $AvailableSizeProductsPageRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: ':availableSizeProductId',
                  factory: $AvailableSizeProductPageRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/paymentMethod',
              factory: $PaymentMethodsPageRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: ':paymentMethodId',
                  factory: $PaymentMethodPageRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/discount',
              factory: $DiscountsPageRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: ':discountId',
                  factory: $DiscountPageRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/order',
              factory: $OrdersPageRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: ':orderId',
                  factory: $OrderPageRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
      ],
    );

extension $ShellRouteDataExtension on ShellRouteData {
  static ShellRouteData _fromState(GoRouterState state) =>
      const ShellRouteData();
}

extension $DashboardRouteExtension on DashboardRoute {
  static DashboardRoute _fromState(GoRouterState state) =>
      const DashboardRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CustomersPageRouteExtension on CustomersPageRoute {
  static CustomersPageRoute _fromState(GoRouterState state) =>
      const CustomersPageRoute();

  String get location => GoRouteData.$location(
        '/customers',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CustomerPageRouteExtension on CustomerPageRoute {
  static CustomerPageRoute _fromState(GoRouterState state) =>
      CustomerPageRoute(customerId: state.pathParameters['customerId']!);

  String get location => GoRouteData.$location(
        '/customers/${customerId}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProductsPageRouteExtension on ProductsPageRoute {
  static ProductsPageRoute _fromState(GoRouterState state) =>
      const ProductsPageRoute();

  String get location => GoRouteData.$location(
        '/products',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProductPageRouteExtension on ProductPageRoute {
  static ProductPageRoute _fromState(GoRouterState state) =>
      ProductPageRoute(productId: state.pathParameters['productId']!);

  String get location => GoRouteData.$location(
        '/products/${productId}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProductCategoriesPageRouteExtension on ProductCategoriesPageRoute {
  static ProductCategoriesPageRoute _fromState(GoRouterState state) =>
      const ProductCategoriesPageRoute();

  String get location => GoRouteData.$location(
        '/productCategories',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProductCategoryPageRouteExtension on ProductCategoryPageRoute {
  static ProductCategoryPageRoute _fromState(GoRouterState state) =>
      ProductCategoryPageRoute(
          productCategoryId: state.pathParameters['productCategoryId']!);

  String get location => GoRouteData.$location(
        '/productCategories/${productCategoryId}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $GenderCategoriesPageRouteExtension on GenderCategoriesPageRoute {
  static GenderCategoriesPageRoute _fromState(GoRouterState state) =>
      const GenderCategoriesPageRoute();

  String get location => GoRouteData.$location(
        '/genderCategories',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $GenderCategoryPageRouteExtension on GenderCategoryPageRoute {
  static GenderCategoryPageRoute _fromState(GoRouterState state) =>
      GenderCategoryPageRoute(
          genderCategoryId: state.pathParameters['genderCategoryId']!);

  String get location => GoRouteData.$location(
        '/genderCategories/${genderCategoryId}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SizeProductsPageRouteExtension on SizeProductsPageRoute {
  static SizeProductsPageRoute _fromState(GoRouterState state) =>
      const SizeProductsPageRoute();

  String get location => GoRouteData.$location(
        '/sizeProduct',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SizeProductPageRouteExtension on SizeProductPageRoute {
  static SizeProductPageRoute _fromState(GoRouterState state) =>
      SizeProductPageRoute(
          sizeProductId: state.pathParameters['sizeProductId']!);

  String get location => GoRouteData.$location(
        '/sizeProduct/${sizeProductId}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AvailableSizeProductsPageRouteExtension
    on AvailableSizeProductsPageRoute {
  static AvailableSizeProductsPageRoute _fromState(GoRouterState state) =>
      const AvailableSizeProductsPageRoute();

  String get location => GoRouteData.$location(
        '/availableSizeProduct',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AvailableSizeProductPageRouteExtension
    on AvailableSizeProductPageRoute {
  static AvailableSizeProductPageRoute _fromState(GoRouterState state) =>
      AvailableSizeProductPageRoute(
          availableSizeProductId:
              state.pathParameters['availableSizeProductId']!);

  String get location => GoRouteData.$location(
        '/availableSizeProduct/${availableSizeProductId}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $PaymentMethodsPageRouteExtension on PaymentMethodsPageRoute {
  static PaymentMethodsPageRoute _fromState(GoRouterState state) =>
      const PaymentMethodsPageRoute();

  String get location => GoRouteData.$location('/paymentMethod');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $PaymentMethodPageRouteExtension on PaymentMethodPageRoute {
  static PaymentMethodPageRoute _fromState(GoRouterState state) =>
      PaymentMethodPageRoute(
          paymentMethodId: state.pathParameters['paymentMethodId']!);

  String get location =>
      GoRouteData.$location('/paymentMethod/${paymentMethodId}');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DiscountsPageRouteExtension on DiscountsPageRoute {
  static DiscountsPageRoute _fromState(GoRouterState state) =>
      const DiscountsPageRoute();

  String get location => GoRouteData.$location('/discount');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DiscountPageRouteExtension on DiscountPageRoute {
  static DiscountPageRoute _fromState(GoRouterState state) =>
      DiscountPageRoute(discountId: state.pathParameters['discountId']!);

  String get location => GoRouteData.$location('/discount/${discountId}');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $OrdersPageRouteExtension on OrdersPageRoute {
  static OrdersPageRoute _fromState(GoRouterState state) =>
      const OrdersPageRoute();

  String get location => GoRouteData.$location('/order');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $OrderPageRouteExtension on OrderPageRoute {
  static OrderPageRoute _fromState(GoRouterState state) =>
      OrderPageRoute(orderId: state.pathParameters['orderId']!);

  String get location => GoRouteData.$location('/order/${orderId}');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
