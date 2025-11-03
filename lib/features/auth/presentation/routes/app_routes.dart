import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rizqmartadmin/features/auth/data/model/add_product_model.dart';
import 'package:rizqmartadmin/features/auth/data/repository/forgot_pass_impliment/auth_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/data/repository/login%20account/login_auth_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/data/repository/main/brand_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/data/repository/main/category_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/data/repository/main/product_repository_impl.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/auth/send_password_rest.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/auth/login_acc_use_cases.dart';
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
import 'package:rizqmartadmin/features/auth/domain/usecases/main/product/add_product_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/product/delete_product_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/product/get_product_usecase.dart';
import 'package:rizqmartadmin/features/auth/domain/usecases/main/product/update_product_usecase.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/forgot%20password%20bloc/auth_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/login%20bloc/auth_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/forgotpassword_screen.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/brand/brand_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/category/category_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/product/product_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/brand/brand_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/category/category_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/dashboard_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/login_screen.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/navigations/main_pages.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/products/add_product.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/products/products_page.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/onboarding/splash_screen.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/onboarding/welcome_screen.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/repository_providers_page.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(initialLocation: '/', routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
        path: '/welcomePage', builder: (context, state) => const WelcomePage()),
    GoRoute(
      path: '/loginPage',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => LoginBloc(
              loginAccUseCases: LoginAccUseCases(sl<LoginRepositoryImpl>())),
          child: const LoginScreen(),
        );
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
          return MainPages(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashBoard',
            builder: (context, state) => DashboardPage(),
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
                    builder: (context) => ProductsPage(),
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
                ],
                child: AddProduct(
                  model: product,
                ),
              );
            },
          ),
          // GoRoute(
          //   path: '/Addcategory',
          //   builder: (context, state) {
          //     return BlocProvider(
          //       create: (_) => CategoryBloc(
          //            getCategoryUsecases: GetCategoryUsecases(sl<CategoryRepositoryImpl>()),
          //           addCategoryUsecases: AddCategoryUsecases(sl<CategoryRepositoryImpl>()),
          //           addVariantUsecase: AddVariantUsecase(sl<CategoryRepositoryImpl>()),
          //           updateCategoryUsecase: UpdateCategoryUsecase(sl<CategoryRepositoryImpl>()),
          //           deleteCategoryUsecase: DeleteCategoryUsecase(sl<CategoryRepositoryImpl>()),
          //           deleteVariantusecase: DeleteVariantUsecase(sl<CategoryRepositoryImpl>()),),
          //       child: AddCategoryBottomSheet(),
          //     );
          //   },
          // ),
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
                child: CategoryPage(),
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
                      addBrandUsecase: AddBrandUsecase(sl<BrandRepositoryImpl>()),
                      updateBrandUsecase:
                          UpdateBrandUsecase(sl<BrandRepositoryImpl>()),
                      deleteBrandUsecase:
                          DeleteBrandUsecase(sl<BrandRepositoryImpl>())),
                  
                ),
                ],
                child: BrandPage(),
              );
            },
          ),
          // GoRoute(
          //   path: '/addBrand',
          //   builder: (context,state){
          //     return BlocProvider(create: (_)=>BrandBloc(  getBrandUsecase: GetBrandUsecases(sl<BrandRepositoryImpl>()),
          //             addBrandUsecase: AddBrandUsecase(sl<BrandRepositoryImpl>()),
          //             updateBrandUsecase: UpdateBrandUsecase(sl<BrandRepositoryImpl>()),
          //             deleteBrandUsecase:  DeleteBrandUsecase(sl<BrandRepositoryImpl>())),child:const BrandCardWeb( ),);

          //   }
          //    )
        ])
  ]);
}
