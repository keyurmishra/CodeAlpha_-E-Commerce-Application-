import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "id": 1,
      "title": "Secure Shopping Experience",
      "description":
          "Shop with confidence using biometric authentication and secure payment methods. Your data is protected with bank-level encryption.",
      "imageUrl":
          "https://images.unsplash.com/photo-1563013544-824ae1b704d3?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c2VjdXJlJTIwc2hvcHBpbmd8ZW58MHx8MHx8fDA%3D",
      "primaryColor": AppTheme.primaryLight,
      "backgroundColor": AppTheme.backgroundLight,
    },
    {
      "id": 2,
      "title": "Quick & Easy Checkout",
      "description":
          "Save your payment methods and shipping addresses for lightning-fast checkout. Complete purchases in just a few taps.",
      "imageUrl":
          "https://images.pexels.com/photos/4968391/pexels-photo-4968391.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "primaryColor": AppTheme.secondaryLight,
      "backgroundColor": AppTheme.backgroundLight,
    },
    {
      "id": 3,
      "title": "Personalized Experience",
      "description":
          "Get tailored product recommendations and track your orders in real-time. Enjoy a shopping experience designed just for you.",
      "imageUrl":
          "https://images.pixabay.com/photo/2017/03/13/17/26/ecommerce-2140603_1280.jpg",
      "primaryColor": AppTheme.primaryLight,
      "backgroundColor": AppTheme.backgroundLight,
    },
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    HapticFeedback.lightImpact();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToRegistration();
    }
  }

  void _skipOnboarding() {
    _navigateToRegistration();
  }

  void _navigateToRegistration() {
    Navigator.pushNamed(context, '/registration-screen');
  }

  void _navigateToLogin() {
    Navigator.pushNamed(context, '/login-screen');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            _buildSkipButton(),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final pageData = _onboardingData[index];
                  return OnboardingPageWidget(
                    title: pageData["title"] as String,
                    description: pageData["description"] as String,
                    imageUrl: pageData["imageUrl"] as String,
                    primaryColor: pageData["primaryColor"] as Color,
                    backgroundColor: pageData["backgroundColor"] as Color,
                  );
                },
              ),
            ),

            // Page indicator and navigation
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _skipOnboarding,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.textSecondaryLight,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            ),
            child: Text(
              'Skip',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page indicator
          PageIndicatorWidget(
            currentPage: _currentPage,
            totalPages: _onboardingData.length,
            activeColor: AppTheme.primaryLight,
            inactiveColor: AppTheme.borderLight,
          ),

          SizedBox(height: 4.h),

          // Navigation buttons
          _currentPage == _onboardingData.length - 1
              ? _buildFinalPageButtons()
              : _buildNavigationButton(),
        ],
      ),
    );
  }

  Widget _buildNavigationButton() {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: _nextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryLight,
          foregroundColor: AppTheme.onPrimaryLight,
          elevation: 2,
          shadowColor: AppTheme.shadowLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Next',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.onPrimaryLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'arrow_forward',
              color: AppTheme.onPrimaryLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalPageButtons() {
    return Column(
      children: [
        // Get Started button
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton(
            onPressed: _navigateToRegistration,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryLight,
              foregroundColor: AppTheme.onPrimaryLight,
              elevation: 2,
              shadowColor: AppTheme.shadowLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Get Started',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.onPrimaryLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Sign In link
        TextButton(
          onPressed: _navigateToLogin,
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.primaryLight,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          ),
          child: RichText(
            text: TextSpan(
              text: 'Already have an account? ',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryLight,
                    fontSize: 12.sp,
                  ),
              children: [
                TextSpan(
                  text: 'Sign In',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
