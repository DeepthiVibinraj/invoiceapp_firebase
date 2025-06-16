import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:toptalents/core/theme/common_widgets/submit_button.dart';
import 'package:toptalents/core/theme/common_widgets/text_form_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Get.back(),
          ),
          backgroundColor: Color.fromARGB(255, 104, 97, 152),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 150, horizontal: defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Enter your email and we will send you a password reset link",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 40,
                ),
                customTextFormField(context, colorScheme, textTheme,
                    _emailController, 'Email', TextInputType.emailAddress, () {
                  return null;
                }, 'email', 'email', false),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SubmitButton(
                        text: 'Reset Password',
                        function: () async {
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: _emailController.text.trim());
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  'Password reset link sent! Check your email'),
                            ));
                          } on FirebaseAuthException catch (e) {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(e.message.toString()),
                            ));
                          }
                        })
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
