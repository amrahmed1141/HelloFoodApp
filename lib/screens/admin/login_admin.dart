import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/screens/admin/home_admin.dart';
import 'package:foodapp/widgets/custom_text_field.dart';

class LoginAdmin extends StatefulWidget {
  const LoginAdmin({super.key});

  @override
  State<LoginAdmin> createState() => _LoginAdminState();
}

class _LoginAdminState extends State<LoginAdmin> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the tree
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Allow the UI to resize when the keyboard appears
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
                    hintText: 'username',
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(CupertinoIcons.person_fill),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
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

                ElevatedButton(
                  onPressed: () {
                    AdminLogin();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Button color
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

  AdminLogin() {
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot) {
      snapshot.docs.forEach((result) {
        if (result.data()['id'] != emailController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.blueAccent,
              content: Text(
                "Your id is not correct",
                style: TextStyle(fontSize: 18.0),
              )));
        } else if (result.data()['password'] !=
            passwordController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.blueAccent,
              content: Text(
                "Your password is not correct",
                style: TextStyle(fontSize: 18.0),
              )));
        } else {
          Route route = MaterialPageRoute(builder: (context) => const  HomeAdmin());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
