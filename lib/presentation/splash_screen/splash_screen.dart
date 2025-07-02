import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _backgroundFadeAnimation;

  bool _showRetryButton = false;
  bool _isInitializing = true;

  // Mock authentication states for demonstration
  final List<Map<String, dynamic>> _mockUserStates = [
    {
      "isAuthenticated": true,
      "hasValidSession": true,
      "isFirstTime": false,
      "route": "/home-screen"
    },
    {
      "isAuthenticated": false,
      "hasValidSession": false,
      "isFirstTime": true,
      "route": "/onboarding-flow"
    },
    {
      "isAuthenticated": true,
      "hasValidSession": false,
      "isFirstTime": false,
      "route": "/login-screen"
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOut,
    ));

    _backgroundFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeIn,
    ));
  }

  void _startSplashSequence() async {
    // Start background fade
    _fadeAnimationController.forward();

    // Delay for background animation
    await Future.delayed(const Duration(milliseconds: 300));

    // Start logo animation
    _logoAnimationController.forward();

    // Initialize app services
    await _initializeAppServices();
  }

  Future<void> _initializeAppServices() async {
    try {
      setState(() {
        _isInitializing = true;
        _showRetryButton = false;
      });

      // Simulate Supabase initialization
      await Future.delayed(const Duration(milliseconds: 1500));

      // Simulate checking authentication token
      await Future.delayed(const Duration(milliseconds: 500));

      // Simulate loading user session data
      await Future.delayed(const Duration(milliseconds: 500));

      // Simulate app configuration fetch
      await Future.delayed(const Duration(milliseconds: 300));

      // Navigate based on authentication state
      await _handleNavigation();
    } catch (e) {
      // Handle initialization error
      setState(() {
        _isInitializing = false;
        _showRetryButton = true;
      });

      // Auto retry after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && _showRetryButton) {
          _retryInitialization();
        }
      });
    }
  }

  Future<void> _handleNavigation() async {
    // Simulate random user state for demonstration
    final mockState = _mockUserStates[
        DateTime.now().millisecondsSinceEpoch % _mockUserStates.length];

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Navigate based on authentication state
    if (mockState["isAuthenticated"] == true &&
        mockState["hasValidSession"] == true) {
      // Authenticated user with valid session - go to home
      Navigator.pushReplacementNamed(context, '/home-screen');
    } else if (mockState["isFirstTime"] == true) {
      // First-time user - show onboarding
      Navigator.pushReplacementNamed(context, '/onboarding-flow');
    } else {
      // Expired session or not authenticated - go to login
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  void _retryInitialization() {
    setState(() {
      _showRetryButton = false;
      _isInitializing = true;
    });
    _initializeAppServices();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.lightTheme.primaryColor,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: AnimatedBuilder(
          animation: _backgroundFadeAnimation,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.lightTheme.primaryColor
                        .withValues(alpha: _backgroundFadeAnimation.value),
                    AppTheme.lightTheme.colorScheme.primaryContainer
                        .withValues(alpha: _backgroundFadeAnimation.value),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildLogoSection(),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildLoadingSection(),
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoScaleAnimation, _logoFadeAnimation]),
      builder: (context, child) {
        return Center(
          child: Transform.scale(
            scale: _logoScaleAnimation.value,
            child: Opacity(
              opacity: _logoFadeAnimation.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 25.w,
                    height: 25.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(4.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'shopping_bag',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 12.w,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'EcomAuth',
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Secure Shopping Experience',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.8),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _showRetryButton ? _buildRetrySection() : _buildLoadingIndicator(),
        SizedBox(height: 2.h),
        _buildStatusText(),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return _isInitializing
        ? SizedBox(
            width: 8.w,
            height: 8.w,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.colorScheme.surface,
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildRetrySection() {
    return Column(
      children: [
        CustomIconWidget(
          iconName: 'error_outline',
          color: AppTheme.lightTheme.colorScheme.surface,
          size: 8.w,
        ),
        SizedBox(height: 2.h),
        ElevatedButton(
          onPressed: _retryInitialization,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            foregroundColor: AppTheme.lightTheme.primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.w),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.lightTheme.primaryColor,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Retry',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusText() {
    String statusText;
    if (_showRetryButton) {
      statusText = 'Connection failed. Tap retry or wait 5 seconds.';
    } else if (_isInitializing) {
      statusText = 'Initializing secure services...';
    } else {
      statusText = 'Ready to launch';
    }

    return Text(
      statusText,
      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.7),
        fontSize: 11.sp,
      ),
      textAlign: TextAlign.center,
    );
  }
}
