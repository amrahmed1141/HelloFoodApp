import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future AddUserDetails(Map<String, dynamic> userData, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userData);
  }

  Future updateUserWallet(String id, String wallet) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'wallet': wallet});
  }

  Future AddFoodItem(Map<String, dynamic> userData, String name) async {
    return await FirebaseFirestore.instance.collection(name).add(userData);
  }

  Future<Stream<QuerySnapshot>> getFoodItem(String name) async {
    return await FirebaseFirestore.instance.collection(name).snapshots();
  }

  Future AddFoodToCart(Map<String, dynamic> userData, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('Cart')
        .add(userData);
  }

  Stream<QuerySnapshot> getFoodCart(String id)  {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('Cart')
        .snapshots();
  }
  Future<QuerySnapshot> getFoodCartItems(String userId) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Cart')
        .get();
  }

  Future<void> deleteFoodCartItem(String userId, String itemId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Cart')
        .doc(itemId)
        .delete();
  }
}
