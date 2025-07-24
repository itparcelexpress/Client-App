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
import 'package:client_app/l10n/app_localizations.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Client App',
      theme: AppThemes.theme,
      locale: _locale,
      localeResolutionCallback: (locale, supportedLocales) {
        // Return the app's current locale
        return _locale;
      },
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
          if (state is AuthInitial) {
            // User has been logged out - the builder will automatically show LoginPage
            // No additional navigation needed since we're already in the AuthWrapper
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: _buildBody(state),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Toggle between Arabic and English
                final currentLocale = Localizations.localeOf(context);
                final newLocale =
                    currentLocale.languageCode == 'ar'
                        ? const Locale('en')
                        : const Locale('ar');
                MyApp.of(context)?.setLocale(newLocale);
              },
              backgroundColor: Colors.blue.shade400,
              child: Icon(Icons.language, color: Colors.white),
              mini: true,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
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
