import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:toptalents/core/theme/common_widgets/submit_button.dart';
import 'package:toptalents/pages/home/home_screen.dart';
import 'package:toptalents/pages/resetpassword_screen.dart';
import 'package:toptalents/user_image_picker.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _signInEmailController = TextEditingController();
  final TextEditingController _signInPasswordController =
      TextEditingController();
  String _statusMessage = '';
  File? _image;
  var _isLogin = false;

  Future<void> _signUp() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (_image != null) {
        String imageName = 'profile_image_${userCredential.user!.uid}.jpg';
        Reference storageReference =
            FirebaseStorage.instance.ref().child('profile_images/$imageName');
        await storageReference.putFile(_image!);

        // Get download URL of the uploaded image
        String imageUrl = await storageReference.getDownloadURL();
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': _emailController.text,
          'name': capitalizeFirstLetter(_nameController.text),
          'createdAt': FieldValue.serverTimestamp(),
          'photoURL': imageUrl
        });
      } else {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': _emailController.text,
          'name': capitalizeFirstLetter(_nameController.text),
          //_nameController.text,
          'createdAt': FieldValue.serverTimestamp(),
          'photoURL': ImageConstant.defaultUser
          //'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Unknown_person.jpg/694px-Unknown_person.jpg',
        });
      }

      // Add user details to Firestore

      setState(() {
        _statusMessage = 'User signed up: ${userCredential.user!.email}';
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    } catch (e) {
      setState(() {
        _statusMessage = 'Sign up failed: $e';
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_statusMessage),
      duration: const Duration(seconds: 3),
    ));
  }

  Future<void> _signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _signInEmailController.text,
        password: _signInPasswordController.text,
      );
      setState(() {
        _statusMessage = 'User signed in: ${userCredential.user!.email}';
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    } catch (e) {
      setState(() {
        _statusMessage = 'Sign in failed: $e';
      });
    }
    _signInEmailController.clear();
    _signInPasswordController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_statusMessage),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _emailController.clear();
    _passwordController.clear();
    _nameController.clear();
    _signInEmailController.clear();
    _signInPasswordController.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.clear();
    _passwordController.clear();
    _nameController.clear();
    _signInEmailController.clear();
    _signInPasswordController.clear();
  }

  bool _obscureText = true;
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: _isLogin ? 200 : 100,
              ),
              if (!_isLogin)
                Center(
                  child: UserImagePicker(
                    onPickedImage: (pickedImage) {
                      _image = pickedImage;
                    },
                  ),
                ),
              const SizedBox(
                height: defaultPadding,
              ),
              //if (_isLogin)
              Text(
                _isLogin ? 'LOGIN' : 'SIGNUP',
                style: textTheme.headlineMedium
                    ?.copyWith(color: const Color.fromARGB(250, 253, 180, 27)),
              ),
              const SizedBox(
                height: defaultPadding,
              ),

              TextField(
                controller:
                    _isLogin ? _signInEmailController : _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: textTheme.labelLarge?.copyWith(color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
              TextField(
                controller:
                    _isLogin ? _signInPasswordController : _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: textTheme.labelLarge?.copyWith(color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black54,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                obscureText: _obscureText,
              ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
              if (!_isLogin)
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'User Name',
                    hintStyle:
                        textTheme.labelLarge?.copyWith(color: Colors.grey),
                  ),
                ),
              const SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(''),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SubmitButton(
                        function: _isLogin ? _signIn : _signUp,
                        text: _isLogin ? 'Login' : 'Sign Up',
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                            _emailController.clear();
                            _passwordController.clear();
                            _nameController.clear();
                          },
                          child: Text(
                            _isLogin
                                ? 'Create an account?'
                                : 'I already have an account',
                            style: const TextStyle(
                                color: Color.fromARGB(250, 253, 180, 27)),
                          )),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: defaultPadding),
              //Forgot Password
              if (_isLogin)
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  GestureDetector(
                      onTap: (() => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ResetPasswordScreen()))),
                      child: const Text(
                        'Forgot Password?',
                        style: const TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w700),
                      ))
                ]),
            ],
          ),
        ),
      ),
    );
  }

  String capitalizeFirstLetter(String name) {
    if (name.isEmpty) return '';
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }
}
