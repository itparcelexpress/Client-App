import 'dart:async';
import 'dart:io';

import 'package:client_app/core/services/location_service.dart';
import 'package:client_app/core/utilities/app_themes.dart';
import 'package:client_app/core/widgets/environment_banner.dart';
import 'package:client_app/features/auth/cubit/auth_cubit.dart';
import 'package:client_app/features/auth/presentation/pages/home_page.dart';
import 'package:client_app/features/auth/presentation/pages/login_page.dart';
import 'package:client_app/features/splash/splash.dart';
import 'package:client_app/injections.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInj();
  await LocationService.initialize();

  // Note: Removed automatic logout on app start for better UX
  // Authentication state will be checked in AuthWrapper

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  HttpOverrides.global = MyHttpOverrides();
  FlutterError.onError = (FlutterErrorDetails details) {};

  runApp(
    MyApp(), // Wrap your app
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>();

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale _locale = const Locale('ar'); // Default to Arabic

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  String _getAppTitle() {
    // Always return Arabic title as default
    return 'تطبيق العميل';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: _getAppTitle(),
      theme: AppThemes.theme,
      locale: _locale,
      localeResolutionCallback: (locale, supportedLocales) {
        // Always default to Arabic regardless of system locale
        return const Locale('ar');
      },
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _hasCheckedAuth = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // Handle state changes if needed
          if (state is AuthInitial) {
            // User has been logged out - the builder will automatically show LoginPage
            // No additional navigation needed since we're already in the AuthWrapper
          }
        },
        builder: (context, state) {
          // Check authentication status when the app starts (only once)
          if (state is AuthInitial && !_hasCheckedAuth) {
            _hasCheckedAuth = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<AuthCubit>().checkAuthStatus();
            });
          }

          return Scaffold(
            body: Column(
              children: [
                const EnvironmentBanner(),
                Expanded(child: _buildBody(state)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(AuthState state) {
    if (state is AuthLoading) {
      return const SplashPage();
    } else if (state is AuthSuccess) {
      return const HomePage();
    } else if (state is AuthCheckSuccess) {
      // If user is authenticated, show home page
      if (state.isAuthenticated) {
        return const HomePage();
      } else {
        // If not authenticated, show login page
        return const LoginPage();
      }
    } else {
      // Always show login page for initial state or any other state
      return const LoginPage();
    }
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
