import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodapp/widgets/custom_text_field.dart';
import 'package:foodapp/screens/auth/forget_password.dart';
import 'package:foodapp/widgets/fonts.dart';
import 'package:foodapp/widgets/nav_bottom_bar.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? _errorMsg;

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the tree
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,  // Red background for errors
      ),
    );
  }

  Future<void> userLogin() async {
    if (passwordController.text.isNotEmpty && emailController.text.isNotEmpty) {
      setState(() {
        _errorMsg = null;  // Clear previous error message
      });

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        Fluttertoast.showToast(
          msg: "Login Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black, // Green background for success
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => NavigationBottom()),
            (Route<dynamic> route) => false);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            _errorMsg = 'No user found for that email.';
          });
        } else if (e.code == 'wrong-password') {
          setState(() {
            _errorMsg = 'Wrong password provided for that user.';
          });
        } else {
          setState(() {
            _errorMsg = 'An error occurred. Please try again.';
          });
        }
        if (_errorMsg != null && _errorMsg!.isNotEmpty) {
          showErrorSnackBar(_errorMsg!);
        }
      }
    } else {
      showErrorSnackBar('Please fill in all fields.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Allow the UI to resize when the keyboard appears
      body: SafeArea(
        child: SingleChildScrollView(
          // Make the content scrollable
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// **Email Input Field**
                Container(
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(CupertinoIcons.mail_solid),
                    errorMsg: _errorMsg,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                          .hasMatch(val)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),

                /// **Password Input Field**
                Container(
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: const Icon(CupertinoIcons.lock_fill),
                    errorMsg: _errorMsg,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      } else if (!RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                          .hasMatch(val)) {
                        return 'Please enter a valid password';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                          iconPassword = obscurePassword
                              ? CupertinoIcons.eye_fill
                              : CupertinoIcons.eye_slash_fill;
                        });
                      },
                      icon: Icon(iconPassword),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassword()));
                      },
                      child: Text('Forget Password ?', style: AppFont.lightTextStyle()),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      userLogin();
                    } // Your button action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange, // Button color
                    foregroundColor: Colors.white, // Text color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 15), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Rounded corners
                    ),
                    elevation: 3, // Button shadow
                  ),
                  child: const Text(
                    "Sign in",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}