import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/widgets/custom_text_field.dart';
import 'package:foodapp/screens/auth/welcome_page.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMsg;

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the tree
    emailController.dispose();
    super.dispose();
  }

  resetPassword() async {
    if (emailController.text.isNotEmpty) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Password reset email sent !"), // Message to show in the SnackBar
            duration: Duration(seconds: 2), // Duration of the SnackBar
          ),
        );
      } on FirebaseException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            _errorMsg = 'No user found for that email.';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: _formKey,
        child: Container(
            child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Container(
              alignment: Alignment.topCenter,
              child: const Text(
                'Password Recovery',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Enter your email address to reset your password',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
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
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  resetPassword();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Button color
                foregroundColor: Colors.white, // Text color
                padding: const EdgeInsets.symmetric(
                    horizontal: 90, vertical: 15), // Button padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                elevation: 3, // Button shadow
              ),
              child: const Text(
                "Send Email",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               const Text(
                  'Dont Have an Account ?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              const  SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const WelcomePage()));
                  },
                  child: const Text(
                    'Create',
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 70,
            ),
          ],
        )),
      ),
    );
  }
}
