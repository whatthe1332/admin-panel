import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ltdddoan/features/customers/customer_not_found_page.dart';
import 'package:flutter_ltdddoan/model/customer_model.dart';
import 'package:flutter_ltdddoan/repositories/customer/customer_repository.dart';
import 'package:go_router/go_router.dart';

import 'features/dashboard/dashbord_page.dart';
import 'features/customers/customer_page.dart';
import 'features/customers/customers_page.dart';
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
          return CircularProgressIndicator();
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
