import 'package:flutter/material.dart';
import 'package:foodapp/screens/admin/login_admin.dart';
import 'package:foodapp/widgets/sign_in_page.dart';
import 'package:foodapp/widgets/sign_up_page.dart';
import 'package:foodapp/widgets/fonts.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    super.initState();
  }
  @override
  void dispose() {
    tabController.dispose(); // Dispose controller to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Allow the body to resize when the keyboard appears
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          /// **🟢 Welcome Section at the Top**
          const SizedBox(height: 80), // Space from the top
          Image.asset(
            'assets/images/ic_food_express.png',
            fit: BoxFit.cover,
            width: 350,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome To Our Food App',
                style: AppFont.boldTextStyle(),
              ),
              const SizedBox(width: 10),
              Image.asset(
                'assets/icons/burger.png',
                width: 20,
                height: 20,
                fit: BoxFit.cover,
              ),
            ],
          ),

          const SizedBox(
            height: 60,
          ),

          /// **🔵 Tab Layout Positioned at the Bottom**
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.9,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TabBar(
                      controller: tabController,
                      unselectedLabelColor: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.5),
                      labelColor: Theme.of(context).colorScheme.onBackground,
                      tabs: const [
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            'Sign in',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            'Sign up',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            'Admin',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: const [
                         SignIn(), // Sign In Content
                          SignUp(), // Sign Up Content
                        LoginAdmin(), // Admin Content
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
