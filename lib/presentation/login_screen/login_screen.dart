import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/biometric_login_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _isBiometricAvailable = false;
  String? _emailError;
  String? _passwordError;

  // Mock credentials for demonstration
  final Map<String, dynamic> _mockCredentials = {
    "admin": {
      "email": "admin@ecomauth.com",
      "password": "Admin123!",
      "role": "admin"
    },
    "user": {
      "email": "user@ecomauth.com",
      "password": "User123!",
      "role": "user"
    },
    "demo": {
      "email": "demo@ecomauth.com",
      "password": "Demo123!",
      "role": "demo"
    }
  };

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _checkBiometricAvailability() {
    // Simulate biometric availability check
    setState(() {
      _isBiometricAvailable = true;
    });
  }

  void _loadSavedCredentials() {
    // Simulate loading saved credentials
    if (_rememberMe) {
      _emailController.text = "user@ecomauth.com";
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  bool _validateCredentials(String email, String password) {
    for (var userType in _mockCredentials.keys) {
      final credentials = _mockCredentials[userType] as Map<String, dynamic>;
      if (credentials["email"] == email &&
          credentials["password"] == password) {
        return true;
      }
    }
    return false;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _emailError = null;
      _passwordError = null;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_validateCredentials(email, password)) {
      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      Fluttertoast.showToast(
        msg: "Login successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        textColor: AppTheme.lightTheme.colorScheme.onPrimary,
      );

      // Navigate to home screen (placeholder)
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/profile-management-screen');
      }
    } else {
      // Failed login
      HapticFeedback.heavyImpact();

      setState(() {
        _emailError = "Invalid email or password";
        _passwordError = "Invalid email or password";
      });

      Fluttertoast.showToast(
        msg: "Invalid credentials. Please try again.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: AppTheme.lightTheme.colorScheme.onError,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _handleBiometricLogin() async {
    try {
      HapticFeedback.lightImpact();

      // Simulate biometric authentication
      await Future.delayed(const Duration(seconds: 1));

      Fluttertoast.showToast(
        msg: "Biometric authentication successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        textColor: AppTheme.lightTheme.colorScheme.onPrimary,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/profile-management-screen');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Biometric authentication failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: AppTheme.lightTheme.colorScheme.onError,
      );
    }
  }

  void _handleSocialLogin(String provider) {
    HapticFeedback.lightImpact();

    Fluttertoast.showToast(
      msg: "$provider login initiated",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: AppTheme.lightTheme.colorScheme.onPrimary,
    );

    // Simulate social login success
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/profile-management-screen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 4.h),

              // App Logo
              Container(
                width: 25.w,
                height: 25.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'shopping_bag',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 12.w,
                  ),
                ),
              ),

              SizedBox(height: 3.h),

              // Welcome Text
              Text(
                'Welcome Back',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 1.h),

              Text(
                'Sign in to your account',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 4.h),

              // Login Form
              LoginFormWidget(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                emailFocusNode: _emailFocusNode,
                passwordFocusNode: _passwordFocusNode,
                isPasswordVisible: _isPasswordVisible,
                rememberMe: _rememberMe,
                isLoading: _isLoading,
                emailError: _emailError,
                passwordError: _passwordError,
                onPasswordVisibilityToggle: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                onRememberMeChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
                onLogin: _handleLogin,
                onForgotPassword: () {
                  Navigator.pushNamed(context, '/forgot-password-screen');
                },
                validateEmail: _validateEmail,
                validatePassword: _validatePassword,
              ),

              SizedBox(height: 3.h),

              // Biometric Login
              if (_isBiometricAvailable)
                BiometricLoginWidget(
                  onBiometricLogin: _handleBiometricLogin,
                ),

              if (_isBiometricAvailable) SizedBox(height: 3.h),

              // Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      'Or continue with',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              // Social Login
              SocialLoginWidget(
                onSocialLogin: _handleSocialLogin,
              ),

              SizedBox(height: 4.h),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/registration-screen');
                    },
                    child: Text(
                      'Sign Up',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
