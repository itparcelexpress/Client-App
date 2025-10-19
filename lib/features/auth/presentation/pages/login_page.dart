import 'dart:io';
import 'package:client_app/core/utilities/responsive_utils.dart';
import 'package:client_app/core/widgets/app_footer.dart';
import 'package:client_app/features/auth/cubit/auth_cubit.dart';
import 'package:client_app/features/auth/presentation/pages/home_page.dart';
import 'package:client_app/injections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:client_app/core/utilities/taost_service.dart';
import 'package:client_app/features/auth/util/login_error_mapper.dart';
import 'package:client_app/core/utilities/validators.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:client_app/core/utilities/app_strings.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _emailFieldTouched = false;
  bool _passwordFieldTouched = false;

  @override
  void initState() {
    super.initState();
    // Debug placeholders removed - no automatic field population
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Helper method for consistent system fonts
  TextStyle _systemFont({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
    );
  }

  // Clear sensitive data from form fields
  void _clearSensitiveData() {
    // Clear password field for security
    _passwordController.clear();
    // Keep email field for user convenience
  }

  // Handle login attempt with better validation
  void _handleLogin(BuildContext context) {
    // Mark all fields as touched to enable validation
    setState(() {
      _emailFieldTouched = true;
      _passwordFieldTouched = true;
    });

    if (_formKey.currentState!.validate()) {
      // Don't reset form fields - let user retry if login fails

      // Perform login with localized messages
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        pleaseEnterBothMessage:
            AppLocalizations.of(context)!.pleaseEnterBothEmailAndPassword,
        emailAndPasswordRequiredMessage:
            AppLocalizations.of(context)!.emailAndPasswordRequired,
        loginFailedMessage: AppLocalizations.of(context)!.loginFailedGeneric,
        networkErrorMessage:
            AppLocalizations.of(context)!.networkConnectionError,
        internetCheckMessage:
            AppLocalizations.of(context)!.pleaseCheckInternetConnection,
        timeoutMessage: AppLocalizations.of(context)!.requestTimeout,
        timeoutDetailMessage: AppLocalizations.of(context)!.requestTookTooLong,
        unexpectedErrorMessage:
            AppLocalizations.of(context)!.unexpectedErrorOccurred,
        tryAgainLaterMessage: AppLocalizations.of(context)!.pleaseTryAgainLater,
      );
    }
  }

  // Show exit confirmation dialog
  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.exitApp),
                content: Text(
                  AppLocalizations.of(context)!.exitAppConfirmation,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(AppLocalizations.of(context)!.stay),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      AppLocalizations.of(context)!.exit,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }

  // Handle back button press
  Future<bool> _onWillPop(BuildContext context) async {
    final shouldExit = await _showExitConfirmationDialog(context);
    if (shouldExit) {
      // Exit the app
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    }
    return false; // Always return false to prevent default pop behavior
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (!didPop) {
            await _onWillPop(context);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: SafeArea(
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    setState(() {
                      _isLoading = false;
                    });
                    // Clear sensitive data from controllers
                    _clearSensitiveData();

                    // Show success message
                    ToastService.showSuccess(
                      context,
                      AppLocalizations.of(context)!.loginSuccess,
                    );

                    // Navigate to home page
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  } else if (state is AuthFailure) {
                    setState(() {
                      _isLoading = false;
                    });
                    // Don't clear fields on failure - let user retry with same credentials
                    final key = mapLoginErrorToKey(
                      message: state.message,
                      errors: state.errors,
                    );
                    ToastService.showError(context, key);
                  } else if (state is AuthLoading) {
                    setState(() {
                      _isLoading = true;
                    });
                  } else {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding:
                              ResponsiveUtils.getResponsivePaddingEdgeInsets(
                                context,
                                const EdgeInsets.all(24.0),
                              ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: ResponsiveUtils.getResponsivePadding(
                                  context,
                                  40,
                                ),
                              ),
                              _buildHeader(),
                              SizedBox(
                                height: ResponsiveUtils.getResponsivePadding(
                                  context,
                                  60,
                                ),
                              ),
                              _buildLoginForm(context, state),
                              SizedBox(
                                height: ResponsiveUtils.getResponsivePadding(
                                  context,
                                  40,
                                ),
                              ),
                              _buildLoginButton(context, state),
                              SizedBox(
                                height: ResponsiveUtils.getResponsivePadding(
                                  context,
                                  20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Footer at the bottom
                      const SimpleAppFooter(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 8.0,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 60)),
        Container(
          height: ResponsiveUtils.getResponsiveHeight(context, 112),
          width: ResponsiveUtils.getResponsiveWidth(context, 112),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: ClipOval(
            child: Image.asset(AppStrings.appLogo, fit: BoxFit.contain),
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 32)),
        Text(
          AppLocalizations.of(context)!.appTitle,
          style: _systemFont(
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 28),
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade900,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 8)),
        Text(
          AppLocalizations.of(context)!.welcomeMessage,
          style: _systemFont(
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthState state) {
    return Container(
      padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
        context,
        const EdgeInsets.all(32),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          children: [
            _buildEmailField(),
            SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 24)),
            _buildPasswordField(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autovalidateMode:
          _emailFieldTouched
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
      onChanged: (value) {
        if (!_emailFieldTouched) {
          setState(() {
            _emailFieldTouched = true;
          });
        }
      },
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.email,
        prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: (value) => Validators.email(value, context: context),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      keyboardType: TextInputType.visiblePassword,
      autovalidateMode:
          _passwordFieldTouched
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
      onChanged: (value) {
        if (!_passwordFieldTouched) {
          setState(() {
            _passwordFieldTouched = true;
          });
        }
      },
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.password,
        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey.shade600,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator:
          (value) => Validators.minLength(
            context: context,
            value,
            6,
            fieldName: AppLocalizations.of(context)!.password,
          ),
    );
  }

  Widget _buildLoginButton(BuildContext context, AuthState state) {
    final isLoading = state is AuthLoading || _isLoading;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _handleLogin(context),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isLoading ? Colors.grey.shade400 : Colors.blue.shade600,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child:
            isLoading
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitThreeBounce(color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Logging in...',
                      style: _systemFont(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
                : Text(
                  AppLocalizations.of(context)!.login,
                  style: _systemFont(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }
}
