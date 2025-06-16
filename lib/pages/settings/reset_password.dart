import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:toptalents/core/theme/common_widgets/mandatory_text.dart';
import 'package:toptalents/routes/app_routes.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to send reset password email
  Future<void> _resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent! Check your inbox.'),
        ),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error sending password reset email.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Get.offAllNamed(AppRoutes.settingsScreen),
        ),

        backgroundColor: colorScheme.primary,
        // Color.fromARGB(255, 104, 97, 152),
        actions: [
          IconButton(
              onPressed: () => Get.offAllNamed(AppRoutes.homeScreen),
              icon: const Icon(Icons.home)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const mandatoryText(text: 'Enter your email'),
            const SizedBox(
              height: defaultPadding / 2,
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: defaultPadding * 2),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _resetPassword,
                child: const Text('Send Reset Link'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
