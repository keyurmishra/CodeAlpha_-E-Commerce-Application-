import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/forgot_password_screen/forgot_password_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/email_verification_screen/email_verification_screen.dart';
import '../presentation/reset_password_screen/reset_password_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/biometric_setup_screen/biometric_setup_screen.dart';
import '../presentation/account_deletion_screen/account_deletion_screen.dart';
import '../presentation/profile_management_screen/profile_management_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String forgotPasswordScreen = '/forgot-password-screen';
  static const String loginScreen = '/login-screen';
  static const String emailVerificationScreen = '/email-verification-screen';
  static const String resetPasswordScreen = '/reset-password-screen';
  static const String registrationScreen = '/registration-screen';
  static const String biometricSetupScreen = '/biometric-setup-screen';
  static const String accountDeletionScreen = '/account-deletion-screen';
  static const String profileManagementScreen = '/profile-management-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    forgotPasswordScreen: (context) => const ForgotPasswordScreen(),
    loginScreen: (context) => const LoginScreen(),
    emailVerificationScreen: (context) => const EmailVerificationScreen(),
    resetPasswordScreen: (context) => const ResetPasswordScreen(),
    registrationScreen: (context) => const RegistrationScreen(),
    biometricSetupScreen: (context) => const BiometricSetupScreen(),
    accountDeletionScreen: (context) => const AccountDeletionScreen(),
    profileManagementScreen: (context) => const ProfileManagementScreen(),
    // TODO: Add your other routes here
  };
}
