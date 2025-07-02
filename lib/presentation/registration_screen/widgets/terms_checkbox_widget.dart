import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TermsCheckboxWidget extends StatelessWidget {
  final bool isTermsAccepted;
  final bool isPrivacyAccepted;
  final ValueChanged<bool?> onTermsChanged;
  final ValueChanged<bool?> onPrivacyChanged;

  const TermsCheckboxWidget({
    super.key,
    required this.isTermsAccepted,
    required this.isPrivacyAccepted,
    required this.onTermsChanged,
    required this.onPrivacyChanged,
  });

  void _openTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Terms of Service',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: SingleChildScrollView(
            child: Text(
              '''Welcome to EcomAuth! These terms and conditions outline the rules and regulations for the use of our mobile application.

By accessing this app, we assume you accept these terms and conditions. Do not continue to use EcomAuth if you do not agree to take all of the terms and conditions stated on this page.

1. Account Registration
- You must provide accurate and complete information
- You are responsible for maintaining account security
- One account per person is allowed

2. User Conduct
- Use the app lawfully and respectfully
- Do not attempt to breach security measures
- Report any suspicious activity

3. Privacy and Data
- We collect and process data as outlined in our Privacy Policy
- Your data is protected with industry-standard security
- You can request data deletion at any time

4. Limitation of Liability
- The app is provided "as is" without warranties
- We are not liable for any indirect damages
- Our liability is limited to the maximum extent permitted by law

5. Changes to Terms
- We may update these terms at any time
- Continued use constitutes acceptance of new terms
- Users will be notified of significant changes

For questions about these terms, contact us at support@ecomauth.com''',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Privacy Policy',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: SingleChildScrollView(
            child: Text(
              '''EcomAuth Privacy Policy

Last updated: ${DateTime.now().year}

This Privacy Policy describes how we collect, use, and protect your information when you use our mobile application.

Information We Collect:
- Account information (email, name, profile picture)
- Device information (device type, operating system)
- Usage data (app interactions, preferences)
- Location data (if permission granted)

How We Use Your Information:
- To provide and maintain our service
- To notify you about changes to our service
- To provide customer support
- To gather analysis to improve our service
- To monitor usage of our service

Data Security:
- We use encryption to protect your data
- Regular security audits are conducted
- Access to personal data is restricted
- We comply with applicable data protection laws

Your Rights:
- Access your personal data
- Correct inaccurate data
- Delete your account and data
- Opt-out of marketing communications
- Data portability

Third-Party Services:
- We may use third-party services for analytics
- These services have their own privacy policies
- We do not sell your personal information

Contact Us:
If you have questions about this Privacy Policy, contact us at privacy@ecomauth.com''',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Terms of Service Checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 6.w,
              height: 6.w,
              child: Checkbox(
                value: isTermsAccepted,
                onChanged: onTermsChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(text: 'I agree to the '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _openTermsOfService(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Privacy Policy Checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 6.w,
              height: 6.w,
              child: Checkbox(
                value: isPrivacyAccepted,
                onChanged: onPrivacyChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(
                        text:
                            'I acknowledge that I have read and understood the '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _openPrivacyPolicy(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
