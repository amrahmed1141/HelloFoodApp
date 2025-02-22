import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodapp/service/database.dart';
import 'package:foodapp/service/shared_pref.dart';
import 'package:foodapp/widgets/custom_text_field.dart';
import 'package:foodapp/widgets/nav_bottom_bar.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Declare controllers and stateful variables here
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
    String? _errorMsg;

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the tree
    passwordController.dispose();
    emailController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration:const Duration(seconds: 2),
        backgroundColor: Colors.red,  // Red background for errors
      ),
    );
  }


  Future<void> registration() async {
    if (nameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
           setState(() {
        _errorMsg = null;  // Clear previous error message
      });
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Register Successfully"), // Message to show in the SnackBar
            duration: Duration(seconds: 2), // Duration of the SnackBar
          ),
        );
        String id = randomAlphaNumeric(10);
        Map<String, dynamic> userData = {
          "name": nameController.text,
          "email": emailController.text,
          'wallet': "0",
          'Id': id,
        };
        await DatabaseService().AddUserDetails(userData, id);
        await SharedePrefHelper().saveUserName(nameController.text);
        await SharedePrefHelper().saveUserEmail(emailController.text);
        await SharedePrefHelper().saveUserWallet("0");
        await SharedePrefHelper().saveUserId(id);

        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => NavigationBottom()),
            (Route<dynamic> route) => false);
      } on FirebaseException catch (e) {
        if (e.code == 'weak-password') {
        setState(() {
          _errorMsg = 'Wrong password provided for that user.';
        });
        } else if (e.code == 'email-already-in-use') {
          setState(() {
             _errorMsg = 'email already in use .';
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
                /// **Name Input Field**
                Container(
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                      controller: nameController,
                      hintText: 'Name',
                      obscureText: false,
                      keyboardType: TextInputType.name,
                      prefixIcon: const Icon(CupertinoIcons.person_fill),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please fill in this field';
                        } else if (val.length > 30) {
                          return 'Name too long';
                        }
                        return null;
                      }),
                ),

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

                /// **Sign Up Button**
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      registration();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange, // Button color
                    foregroundColor: Colors.white, // Text color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 15), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                    elevation: 3, // Button shadow
                  ),
                  child: const Text(
                    "Sign up",
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