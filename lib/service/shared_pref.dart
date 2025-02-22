import 'package:shared_preferences/shared_preferences.dart';

class SharedePrefHelper {
  static String userIdKey = 'USERKEY';
  static String userNameKey = 'USERNAMEKEY';
  static String userEmailKey = 'USEREMAILKEY';
  static String userWalletKey = 'USERWALLETKEY';
   static String userProfileKey = 'USERPROFILEKEY';


Future<bool> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, userId);
  }

  Future<bool> saveUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, userName);
  }

  Future<bool> saveUserEmail(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, userEmail);
  }

  Future<bool> saveUserWallet(String userWallet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userWalletKey, userWallet);
  }

  Future<bool>saveUserProfile(String userProfile)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString(userProfileKey, userProfile);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getUserWallet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userWalletKey);
  }

  Future<String?> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userProfileKey);
  }

  Future<bool> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
