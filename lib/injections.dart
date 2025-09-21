import 'package:client_app/core/cubit/app_version_cubit.dart';
import 'package:client_app/core/services/app_version_service.dart';
import 'package:client_app/core/services/auth_error_handler.dart';
import 'package:client_app/core/utilities/app_endpoints.dart';
import 'package:client_app/features/address_book/cubit/address_book_cubit.dart';
import 'package:client_app/features/address_book/data/repositories/address_book_repository.dart';
import 'package:client_app/features/auth/cubit/auth_cubit.dart';
import 'package:client_app/features/auth/data/repositories/auth_repository.dart';
import 'package:client_app/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:client_app/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:client_app/features/finance/cubit/finance_cubit.dart';
import 'package:client_app/features/finance/data/repositories/finance_repository.dart';
import 'package:client_app/features/guest/cubit/guest_cubit.dart';
import 'package:client_app/features/guest/data/repositories/guest_repository.dart';
import 'package:client_app/features/invoices/cubit/invoice_cubit.dart';
import 'package:client_app/features/notifications/cubit/notification_cubit.dart';
import 'package:client_app/features/notifications/data/repositories/notification_repository.dart';
import 'package:client_app/features/pricing/cubit/pricing_cubit.dart';
import 'package:client_app/features/pricing/data/repositories/pricing_repository.dart';
import 'package:client_app/features/profile/cubit/client_settings_cubit.dart';
import 'package:client_app/features/profile/data/repositories/client_settings_repository.dart';
import 'package:client_app/features/shipment/cubit/shipment_cubit.dart';
import 'package:client_app/features/shipment/data/repositories/order_repository.dart';
import 'package:client_app/features/map/cubit/map_cubit.dart';
import 'package:client_app/features/map/data/repositories/map_repository.dart';
import 'package:client_app/features/map/data/repositories/map_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> initInj() async {
  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Register Dio
  final dio = Dio();
  dio.options.baseUrl = AppEndPoints.baseUrl;
  dio.options.connectTimeout = const Duration(seconds: 100);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  dio.options.sendTimeout = const Duration(seconds: 100);

  // Add headers for better compatibility
  dio.options.headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  // Add PrettyDioLogger interceptor
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
      enabled: kDebugMode,
      filter: (options, args) {
        // don't print requests with uris containing '/posts'
        if (options.path.contains('/posts')) {
          return false;
        }
        // don't print responses with unit8 list data
        return !args.isResponse || !args.hasUint8ListData;
      },
    ),
  );

  // Add error interceptor for better error handling
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        if (kDebugMode) {
          print('🔴 DioError: ${error.type}');
          print('🔴 Message: ${error.message}');
          print('🔴 URL: ${error.requestOptions.uri}');

          if (error.type == DioExceptionType.connectionError) {
            print('🔴 Network connection error - check internet connectivity');
            print('🔴 Try switching between WiFi and mobile data');
          }
        }

        // Handle 401 authentication errors globally
        if (error.response?.statusCode == 401) {
          await AuthErrorHandler.instance.handleAuthError(error);
        }

        handler.next(error);
      },
    ),
  );

  getIt.registerSingleton<Dio>(dio);

  // Register AppVersionService
  final appVersionService = AppVersionService();
  await appVersionService.initialize(dio);
  getIt.registerSingleton<AppVersionService>(appVersionService);

  // Register repositories
  getIt.registerLazySingleton<AddressBookRepository>(
    () => AddressBookRepositoryImpl(),
  );
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<OrderRepository>(() => OrderRepository());
  getIt.registerLazySingleton<DashboardRepository>(() => DashboardRepository());
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepository(),
  );
  getIt.registerLazySingleton<ClientSettingsRepository>(
    () => ClientSettingsRepository(),
  );
  getIt.registerLazySingleton<PricingRepository>(() => PricingRepository());
  getIt.registerLazySingleton<MapRepository>(() => MapRepositoryImpl());
  getIt.registerLazySingleton<FinanceRepository>(() => FinanceRepositoryImpl());

  // Register cubits
  getIt.registerFactory<AddressBookCubit>(
    () => AddressBookCubit(getIt<AddressBookRepository>()),
  );
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));
  getIt.registerFactory<ShipmentCubit>(
    () => ShipmentCubit(getIt<OrderRepository>()),
  );
  getIt.registerFactory<DashboardCubit>(
    () => DashboardCubit(getIt<DashboardRepository>()),
  );
  getIt.registerFactory<InvoiceCubit>(() => InvoiceCubit());
  getIt.registerFactory<NotificationCubit>(
    () => NotificationCubit(getIt<NotificationRepository>()),
  );
  getIt.registerFactory<ClientSettingsCubit>(
    () => ClientSettingsCubit(getIt<ClientSettingsRepository>()),
  );
  getIt.registerFactory<PricingCubit>(
    () => PricingCubit(getIt<PricingRepository>()),
  );
  getIt.registerFactory<AppVersionCubit>(
    () => AppVersionCubit(appVersionService: getIt<AppVersionService>()),
  );
  getIt.registerFactory<MapCubit>(() => MapCubit(getIt<MapRepository>()));
  getIt.registerFactory<FinanceCubit>(
    () => FinanceCubit(getIt<FinanceRepository>()),
  );

  // Guest Feature
  getIt.registerFactory(() => GuestCubit(getIt()));
  getIt.registerLazySingleton(() => GuestRepository());
}
