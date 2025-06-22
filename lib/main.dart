import 'dart:async';
import 'dart:io';

import 'package:client_app/core/services/location_service.dart';
import 'package:client_app/core/utilities/app_themes.dart';
import 'package:client_app/data/local/local_data.dart';
import 'package:client_app/features/auth/cubit/auth_cubit.dart';
import 'package:client_app/features/auth/presentation/pages/home_page.dart';
import 'package:client_app/features/auth/presentation/pages/login_page.dart';
import 'package:client_app/features/splash/splash.dart';
import 'package:client_app/injections.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInj();
  await LocationService.initialize();

  // Clear authentication data on app start to force fresh login
  await LocalData.logout();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  HttpOverrides.global = MyHttpOverrides();
  FlutterError.onError = (FlutterErrorDetails details) {};

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Client App',
      theme: AppThemes.theme,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // Handle state changes if needed
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const SplashPage();
          } else if (state is AuthSuccess) {
            return const HomePage();
          } else {
            // Always show login page for initial state or any other state
            return const LoginPage();
          }
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
