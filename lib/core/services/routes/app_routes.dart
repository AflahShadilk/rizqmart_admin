import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rizqmartadmin/features/auth/data/model/add_product_model.dart';
import 'package:rizqmartadmin/features/auth/data/repository/forgot_pass_impliment/auth_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/data/repository/main/brand_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/data/repository/main/category_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/data/repository/main/product_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/data/repository/main/units_repository_imple.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/auth/send_password_rest.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/brand/add_brand_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/brand/delete_brand_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/brand/get_brand_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/brand/update_brand_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/category/add_category_usecases.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/category/add_variant_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/category/delete_category_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/category/delete_variant_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/category/get_category_usecases.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/category/update_category_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/order/get_new_order_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/order/get_order_by_status_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/order/mark_order_received_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/order/update_order_status_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/order/refill_order_stock_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/payment/get_all_payments_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/payment/get_payment_analitics_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/payment/get_payment_by_order_id_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/payment/get_payment_by_status_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/payment/refund_payment_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/product/add_product_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/product/delete_product_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/product/get_product_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/product/update_product_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/unit/add_unit_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/unit/delete_unit_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/unit/get_units_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/unit/update_unit_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/user/delete_user_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/user/get_all_users_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/user/get_users_by_role_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/user/update_user_status_usecase.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/forgot%20password%20bloc/auth_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/login%20bloc/auth_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/login%20bloc/auth_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/forgotpassword_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/navigation/drawyer_selected_index_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/order/order_received_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/payment/payment_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/sales_report/sales_report_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/status/status_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/unit/unit_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/users/users_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/brand/brand_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/category/category_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/dashboard/dashboard_bloc.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/dashboard/get_dashboard_stats_usecase.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/dashboard/dashboard_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/login_screen.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/report/sales_report_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/navigations/main_pages.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/order/order_received_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/payment/payment_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/products/add_product.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/products/products_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/units/units_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/user/users_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/onboarding/splash_screen.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/onboarding/welcome_screen.dart';
import 'package:rizqmartadmin/core/services/repository_providers_page.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/sales_report/get_sales_report_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/sales_report/get_top_selling_products_usecase.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/sales_report/top_selling_products/top_selling_products_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/coupons/coupons_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/coupon_bloc.dart';
import 'package:rizqmartadmin/features/auth/data/repository/main/coupon_repository_impl.dart';

import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/chat/chat_list_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/chat/chat_details_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/chat/chat_bloc.dart';
import 'package:rizqmartadmin/features/auth/data/repository/main/chat_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/settings/settings_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/notification/notification_bell_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/notification/notifications_page.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(initialLocation: '/', routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
        path: '/welcomePage', builder: (context, state) => const WelcomePage()),
    GoRoute(
      name: 'loginPage',
      path: '/loginPage',
      builder: (context, state) {
        return const LoginScreen();
      },
    ),

    GoRoute(
      path: '/forgotPasswordPage',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => ForgotPasswordBloc(
              forgotPasswordUseCase:
                  ForgotPasswordUseCase(sl<ForgotAuthRepositoryImpl>())),
          child: const ForgotpasswordScreen(),
        );
      },
    ),

    //Main routes
    ShellRoute(
        builder: (context, state, child) {
          return BlocListener<LoginBloc, LoginState>(
            listener: (context, state) async {
              if (state is AuthUnauthenticated) {
                final pref = await SharedPreferences.getInstance();
                await pref.setBool('isLoggedIn', false); 
                if (context.mounted) {
                   context.goNamed('loginPage');
                }
              }
            },
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => DrawerSelectedIndexCubit(),
                ),
                BlocProvider(
                  create: (context) => NotificationBellCubit(),
                ),
                BlocProvider(
                  create: (_) => ChatBloc(sl<ChatRepositoryImpl>()),
                ),
              ],
              child: MainPages(child: child),
            ),
          );
        },
        routes: [
                    GoRoute(
            path: '/dashBoard',
            builder: (context, state) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => DashboardBloc(
                      getDashboardStatsUseCase: GetDashboardStatsUseCase(repository: sl()),
                    ),
                  ),
                  BlocProvider(
                     create: (_) => OrderReceivedBloc(
                          getNewOrdersUseCase:
                              GetNewOrdersUseCase(repository: sl()),
                          getOrdersByStatusUseCase:
                              GetOrdersByStatusUseCase(repository: sl()),
                          updateOrderStatusUseCase:
                              UpdateOrderStatusUseCase(repository: sl()),
                          markOrderReceivedUseCase:
                              MarkOrderReceivedUseCase(repository: sl()),
                          getPaymentByOrderIdUseCase:
                              GetPaymentByOrderIdUseCase(repository: sl()),
                          refundPaymentUseCase:
                              RefundPaymentUseCase(repository: sl()),
                          refillOrderStockUseCase:
                              RefillOrderStockUseCase(repository: sl<ProductRepositoryImpl>()))),
                ],
                child: const DashboardPage(),
              );
            },
          ),
          GoRoute(
            path: '/products',
            builder: (context, state) {
              return MultiBlocProvider(providers: [
                BlocProvider<ProductBloc>(
                  create: (_) => ProductBloc(
                    getProductUsecase:
                        GetProductUsecase(sl<ProductRepositoryImpl>()),
                    addProductUsecase:
                        AddProductUsecase(sl<ProductRepositoryImpl>()),
                    updateProductUsecase:
                        UpdateProductUsecase(sl<ProductRepositoryImpl>()),
                    deleteProductUsecase:
                        DeleteProductUsecase(sl<ProductRepositoryImpl>()),
                  ),
                  child: Builder(
                    builder: (context) => const ProductsPage(),
                  ),
                ),
                BlocProvider<CategoryBloc>(
                  create: (_) => CategoryBloc(
                    getCategoryUsecases:
                        GetCategoryUsecases(sl<CategoryRepositoryImpl>()),
                    addCategoryUsecases:
                        AddCategoryUsecases(sl<CategoryRepositoryImpl>()),
                    addVariantUsecase:
                        AddVariantUsecase(sl<CategoryRepositoryImpl>()),
                    updateCategoryUsecase:
                        UpdateCategoryUsecase(sl<CategoryRepositoryImpl>()),
                    deleteCategoryUsecase:
                        DeleteCategoryUsecase(sl<CategoryRepositoryImpl>()),
                    deleteVariantusecase:
                        DeleteVariantUsecase(sl<CategoryRepositoryImpl>()),
                  ),
                ),
                BlocProvider<BrandBloc>(
                  create: (_) => BrandBloc(
                      getBrandUsecase:
                          GetBrandUsecases(sl<BrandRepositoryImpl>()),
                      addBrandUsecase:
                          AddBrandUsecase(sl<BrandRepositoryImpl>()),
                      updateBrandUsecase:
                          UpdateBrandUsecase(sl<BrandRepositoryImpl>()),
                      deleteBrandUsecase:
                          DeleteBrandUsecase(sl<BrandRepositoryImpl>())),
                ),
              ], child: const ProductsPage());
            },
          ),
          GoRoute(
            path: '/Addproducts',
            builder: (context, state) {
              final product = state.extra as ProductModel?;
              return MultiBlocProvider(
                providers: [
                  BlocProvider<ProductBloc>(
                    create: (_) => ProductBloc(
                      getProductUsecase:
                          GetProductUsecase(sl<ProductRepositoryImpl>()),
                      addProductUsecase:
                          AddProductUsecase(sl<ProductRepositoryImpl>()),
                      updateProductUsecase:
                          UpdateProductUsecase(sl<ProductRepositoryImpl>()),
                      deleteProductUsecase:
                          DeleteProductUsecase(sl<ProductRepositoryImpl>()),
                    ),
                  ),
                  BlocProvider<CategoryBloc>(
                    create: (_) => CategoryBloc(
                      getCategoryUsecases:
                          GetCategoryUsecases(sl<CategoryRepositoryImpl>()),
                      addCategoryUsecases:
                          AddCategoryUsecases(sl<CategoryRepositoryImpl>()),
                      addVariantUsecase:
                          AddVariantUsecase(sl<CategoryRepositoryImpl>()),
                      updateCategoryUsecase:
                          UpdateCategoryUsecase(sl<CategoryRepositoryImpl>()),
                      deleteCategoryUsecase:
                          DeleteCategoryUsecase(sl<CategoryRepositoryImpl>()),
                      deleteVariantusecase:
                          DeleteVariantUsecase(sl<CategoryRepositoryImpl>()),
                    ),
                  ),
                  BlocProvider<BrandBloc>(
                    create: (_) => BrandBloc(
                        getBrandUsecase:
                            GetBrandUsecases(sl<BrandRepositoryImpl>()),
                        addBrandUsecase:
                            AddBrandUsecase(sl<BrandRepositoryImpl>()),
                        updateBrandUsecase:
                            UpdateBrandUsecase(sl<BrandRepositoryImpl>()),
                        deleteBrandUsecase:
                            DeleteBrandUsecase(sl<BrandRepositoryImpl>())),
                  ),
                  BlocProvider<UnitBloc>(
                    create: (_) => UnitBloc(
                        getUnitsUsecase:
                            GetUnitsUsecase(sl<UnitsRepositoryImple>()),
                        addUnitUsecase:
                            AddUnitUsecase(sl<UnitsRepositoryImple>()),
                        updateUnitUsecase:
                            UpdateUnitUsecase(sl<UnitsRepositoryImple>()),
                        deleteUnitUsecase:
                            DeleteUnitUsecase(sl<UnitsRepositoryImple>())),
                  ),
                  BlocProvider<StatusCubit>(create: (_) => StatusCubit()),
                ],
                child: AddProduct(
                  model: product,
                ),
              );
            },
          ),
          GoRoute(
            path: '/category',
            builder: (context, state) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<ProductBloc>(
                    create: (_) => ProductBloc(
                      getProductUsecase:
                          GetProductUsecase(sl<ProductRepositoryImpl>()),
                      addProductUsecase:
                          AddProductUsecase(sl<ProductRepositoryImpl>()),
                      updateProductUsecase:
                          UpdateProductUsecase(sl<ProductRepositoryImpl>()),
                      deleteProductUsecase:
                          DeleteProductUsecase(sl<ProductRepositoryImpl>()),
                    ),
                  ),
                  BlocProvider<CategoryBloc>(
                    create: (_) => CategoryBloc(
                      getCategoryUsecases:
                          GetCategoryUsecases(sl<CategoryRepositoryImpl>()),
                      addCategoryUsecases:
                          AddCategoryUsecases(sl<CategoryRepositoryImpl>()),
                      addVariantUsecase:
                          AddVariantUsecase(sl<CategoryRepositoryImpl>()),
                      updateCategoryUsecase:
                          UpdateCategoryUsecase(sl<CategoryRepositoryImpl>()),
                      deleteCategoryUsecase:
                          DeleteCategoryUsecase(sl<CategoryRepositoryImpl>()),
                      deleteVariantusecase:
                          DeleteVariantUsecase(sl<CategoryRepositoryImpl>()),
                    ),
                  ),
                ],
                child: const CategoryPage(),
              );
            },
          ),
          GoRoute(
            path: '/brand',
            builder: (context, state) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<ProductBloc>(
                    create: (_) => ProductBloc(
                      getProductUsecase:
                          GetProductUsecase(sl<ProductRepositoryImpl>()),
                      addProductUsecase:
                          AddProductUsecase(sl<ProductRepositoryImpl>()),
                      updateProductUsecase:
                          UpdateProductUsecase(sl<ProductRepositoryImpl>()),
                      deleteProductUsecase:
                          DeleteProductUsecase(sl<ProductRepositoryImpl>()),
                    ),
                  ),
                  BlocProvider(
                    create: (_) => BrandBloc(
                        getBrandUsecase:
                            GetBrandUsecases(sl<BrandRepositoryImpl>()),
                        addBrandUsecase:
                            AddBrandUsecase(sl<BrandRepositoryImpl>()),
                        updateBrandUsecase:
                            UpdateBrandUsecase(sl<BrandRepositoryImpl>()),
                        deleteBrandUsecase:
                            DeleteBrandUsecase(sl<BrandRepositoryImpl>())),
                  ),
                ],
                child: const BrandPage(),
              );
            },
          ),
          GoRoute(
            path: '/unitPage',
            builder: (context, state) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<ProductBloc>(
                    create: (_) => ProductBloc(
                      getProductUsecase:
                          GetProductUsecase(sl<ProductRepositoryImpl>()),
                      addProductUsecase:
                          AddProductUsecase(sl<ProductRepositoryImpl>()),
                      updateProductUsecase:
                          UpdateProductUsecase(sl<ProductRepositoryImpl>()),
                      deleteProductUsecase:
                          DeleteProductUsecase(sl<ProductRepositoryImpl>()),
                    ),
                  ),
                  BlocProvider<CategoryBloc>(
                    create: (_) => CategoryBloc(
                      getCategoryUsecases:
                          GetCategoryUsecases(sl<CategoryRepositoryImpl>()),
                      addCategoryUsecases:
                          AddCategoryUsecases(sl<CategoryRepositoryImpl>()),
                      addVariantUsecase:
                          AddVariantUsecase(sl<CategoryRepositoryImpl>()),
                      updateCategoryUsecase:
                          UpdateCategoryUsecase(sl<CategoryRepositoryImpl>()),
                      deleteCategoryUsecase:
                          DeleteCategoryUsecase(sl<CategoryRepositoryImpl>()),
                      deleteVariantusecase:
                          DeleteVariantUsecase(sl<CategoryRepositoryImpl>()),
                    ),
                  ),
                  BlocProvider<UnitBloc>(
                    create: (_) => UnitBloc(
                        getUnitsUsecase:
                            GetUnitsUsecase(sl<UnitsRepositoryImple>()),
                        addUnitUsecase:
                            AddUnitUsecase(sl<UnitsRepositoryImple>()),
                        updateUnitUsecase:
                            UpdateUnitUsecase(sl<UnitsRepositoryImple>()),
                        deleteUnitUsecase:
                            DeleteUnitUsecase(sl<UnitsRepositoryImple>())),
                  ),
                ],
                child: const UnitsPage(),
              );
            },
          ),
          GoRoute(
              path: '/order',
              builder: (context, state) {
                return MultiBlocProvider(providers: [
                  BlocProvider<OrderReceivedBloc>(
                      create: (_) => OrderReceivedBloc(
                          getNewOrdersUseCase:
                              GetNewOrdersUseCase(repository: sl()),
                          getOrdersByStatusUseCase:
                              GetOrdersByStatusUseCase(repository: sl()),
                          updateOrderStatusUseCase:
                              UpdateOrderStatusUseCase(repository: sl()),
                          markOrderReceivedUseCase:
                              MarkOrderReceivedUseCase(repository: sl()),
                          getPaymentByOrderIdUseCase:
                              GetPaymentByOrderIdUseCase(repository: sl()),
                          refundPaymentUseCase:
                              RefundPaymentUseCase(repository: sl()),
                          refillOrderStockUseCase:
                              RefillOrderStockUseCase(repository: sl<ProductRepositoryImpl>()))),
                ], child: const OrderReceivedPage());
              }),
          GoRoute(
            path: '/payment',
            builder: (context, state) {
              return MultiBlocProvider(providers: [
                BlocProvider(
                    create: (_) => PaymentBloc(
                        getAllPaymentsUseCase:
                            GetAllPaymentsUseCase(repository: sl()),
                        getPaymentsByStatusUseCase:
                            GetPaymentsByStatusUseCase(repository: sl()),
                        getPaymentAnalyticsUseCase:
                            GetPaymentAnalyticsUseCase(repository: sl()),
                        refundPaymentUseCase:
                            RefundPaymentUseCase(repository: sl())))
              ], child: const PaymentPage());
            },
          ),
          GoRoute(
            path: '/users',
            builder: (context, state) {
              return BlocProvider(
                create: (_) => UsersBloc(
                    getAllUsersUseCase: GetAllUsersUseCase(sl()),
                    getUsersByRoleUseCase: GetUsersByRoleUseCase(sl()),
                    updateUserStatusUseCase: UpdateUserStatusUseCase(sl()),
                    deleteUserUseCase: DeleteUserUseCase(sl())),
                child: const UsersPage(),
              );
            },
          ),
          GoRoute(
            path: '/salesReport',
            builder: (context, state) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => SalesReportBloc(
                      getSalesReportUseCase: GetSalesReportUseCase(sl()),
                    ),
                  ),
                  BlocProvider(
                    create: (_) => TopSellingProductsBloc(
                      getTopSellingProductsUseCase: GetTopSellingProductsUseCase(sl()),
                    ),
                  ),
                ],
                child: const SalesReportPage(),
              );
            },
          ),
          GoRoute(
            path: '/coupons',
            builder: (context, state) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => CouponBloc(
                      couponsRepository: sl<CouponRepositoryImpl>(),
                    ),
                  ),
                  BlocProvider<ProductBloc>(
                    create: (_) => ProductBloc(
                      getProductUsecase:
                          GetProductUsecase(sl<ProductRepositoryImpl>()),
                      addProductUsecase:
                          AddProductUsecase(sl<ProductRepositoryImpl>()),
                      updateProductUsecase:
                          UpdateProductUsecase(sl<ProductRepositoryImpl>()),
                      deleteProductUsecase:
                          DeleteProductUsecase(sl<ProductRepositoryImpl>()),
                    ),
                  ),
                ],
                child: const CouponsPage(),
              );
            },
          ),


          GoRoute(
            path: '/chat',
            builder: (context, state) {
              return const ChatListPage();
            },
          ),
           GoRoute(
            path: '/chat_details',
            builder: (context, state) {
               final extra = state.extra as Map<String, dynamic>? ?? {};
               return ChatDetailsPage(
                chatId: extra['chatId'] ?? '',
                productName: extra['productName'] ?? '',
                userId: extra['userId'] ?? '',
              );
            },
           ),

          GoRoute(
            path: '/settings',
            builder: (context, state) {
              return const SettingsPage();
            },
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) {
              return const NotificationsPage();
            },
          ),

        ]),
  ]);
}
