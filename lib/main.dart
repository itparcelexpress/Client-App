import 'dart:async';
import 'dart:io';

import 'package:client_app/core/cubit/permission_cubit.dart';
import 'package:client_app/core/services/global_auth_manager.dart';
import 'package:client_app/core/services/location_service.dart';
import 'package:client_app/core/utilities/app_themes.dart';
import 'package:client_app/core/widgets/app_version_wrapper.dart';
import 'package:client_app/core/widgets/environment_banner.dart';
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

  // Note: Removed automatic permission request from main()
  // Permissions will now be handled through the PermissionCubit and UI

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

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  void _loadSavedLanguage() {
    final savedLanguageCode = LocalData.languageCode;
    setState(() {
      _locale = Locale(savedLanguageCode);
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    // Save the language preference
    LocalData.setLanguageCode(locale.languageCode);
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
      home: MultiBlocProvider(
        providers: [
          BlocProvider<PermissionCubit>(
            create: (context) => PermissionCubit()..initializePermissions(),
          ),
        ],
        child: const AppVersionWrapper(child: AuthWrapper()),
      ),
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
  late AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = getIt<AuthCubit>();

    // Set up the GlobalAuthManager to use this AuthCubit instance
    GlobalAuthManager.instance.setLogoutCallback(() {
      if (!_authCubit.isClosed) {
        _authCubit.clearAuthState();
      }
    });
  }

  @override
  void dispose() {
    // Clear the logout callback when the widget is disposed
    GlobalAuthManager.instance.clearLogoutCallback();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _authCubit,
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
    // First check permissions
    return BlocConsumer<PermissionCubit, PermissionState>(
      listener: (context, permissionState) {
        // Handle permission state changes if needed
      },
      builder: (context, permissionState) {
        // If permissions are being checked or requested, show loading
        if (permissionState is PermissionChecking ||
            permissionState is PermissionRequesting) {
          return const SplashPage();
        }

        // If permissions are permanently denied, show a message but continue
        if (permissionState is PermissionPermanentlyDenied) {
          final localizations = AppLocalizations.of(context)!;
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning, size: 64, color: Colors.orange),
                    const SizedBox(height: 16),
                    Text(
                      localizations.permissionsRequiredMessage,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<PermissionCubit>().openAppSettings();
                      },
                      child: Text(localizations.openSettings),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        context.read<PermissionCubit>().skipPermissions();
                      },
                      child: Text(localizations.continueAnyway),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Permissions are handled, now check authentication
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
      },
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
