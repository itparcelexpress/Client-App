import 'package:animate_do/animate_do.dart';
import 'package:client_app/core/utilities/responsive_utils.dart';
import 'package:client_app/features/auth/cubit/auth_cubit.dart';
import 'package:client_app/features/auth/presentation/pages/home_page.dart';
import 'package:client_app/features/guest/cubit/guest_cubit.dart';
import 'package:client_app/features/guest/presentation/pages/create_guest_order_page.dart';
import 'package:client_app/injections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:client_app/core/utilities/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'hormuz@gmail.com');
  final _passwordController = TextEditingController(text: '12345678');

  bool _isPasswordVisible = false;

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade50,
                Colors.white,
                Colors.purple.shade50,
              ],
            ),
          ),
          child: SafeArea(
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                } else if (state is AuthFailure) {
                  // Show a generic, user-friendly error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Invalid email or password. Please try again.',
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
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
                      _buildGuestButton(context),
                      SizedBox(
                        height: ResponsiveUtils.getResponsivePadding(
                          context,
                          60,
                        ),
                      ), // Added extra space at bottom
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Column(
        children: [
          Container(
            height: ResponsiveUtils.getResponsiveHeight(context, 120),
            width: ResponsiveUtils.getResponsiveWidth(context, 120),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.purple.shade400],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.local_shipping,
              size: ResponsiveUtils.getResponsiveWidth(context, 60),
              color: Colors.white,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 24)),
          Text(
            'Parcel Express',
            style: _systemFont(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 32),
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 8)),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsivePadding(context, 16),
            ),
            child: Text(
              'Welcome back! Please sign in to continue.',
              style: _systemFont(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthState state) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
          context,
          const EdgeInsets.all(24),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              _buildEmailField(),
              SizedBox(
                height: ResponsiveUtils.getResponsivePadding(context, 20),
              ),
              _buildPasswordField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email_outlined, color: Colors.blue.shade400),
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
          borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: Validators.email,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock_outline, color: Colors.blue.shade400),
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
          borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator:
          (value) => Validators.minLength(value, 6, fieldName: 'Password'),
    );
  }

  Widget _buildLoginButton(BuildContext context, AuthState state) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1200),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed:
              state is AuthLoading
                  ? null
                  : () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthCubit>().login(
                        email: _emailController.text.trim(),
                        password: _passwordController.text,
                      );
                    }
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child:
              state is AuthLoading
                  ? SpinKitThreeBounce(color: Colors.white, size: 20)
                  : Text(
                    'Sign In',
                    style: _systemFont(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildGuestButton(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      child: Column(
        children: [
          Text(
            'or',
            style: _systemFont(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsivePadding(context, 16)),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider(
                        create: (context) => getIt<GuestCubit>(),
                        child: const CreateGuestOrderPage(),
                      ),
                ),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: Text(
              'Continue as Guest',
              style: _systemFont(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
