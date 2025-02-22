import 'package:firebase_auth/firebase_auth.dart';

class FirebaseMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

   getCurrentUser() async {
   return await FirebaseAuth.instance.currentUser;
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future deleteUser() async {
    User? user = await FirebaseAuth.instance.currentUser;
    user?.delete();
  }
}
