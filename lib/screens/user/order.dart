import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/service/database.dart';
import 'package:foodapp/service/shared_pref.dart';
import 'package:foodapp/widgets/fonts.dart';
import 'package:foodapp/widgets/skeleton_loading.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  String? id, wallet;
  StreamSubscription<QuerySnapshot>? foodItemsSubscription;  // For managing subscription
  bool _isLoading = false;
  int total = 0;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    setState(() => _isLoading = true);
    id = await SharedePrefHelper().getUserId();
    wallet = await SharedePrefHelper().getUserWallet();
    Stream<QuerySnapshot> stream = DatabaseService().getFoodCart(id!);
    foodItemsSubscription = stream.listen(updateTotal);
    setState(() => _isLoading = false);
  }

  void updateTotal(QuerySnapshot snapshot) {
    int newTotal = 0;
    for (var doc in snapshot.docs) {
      newTotal += int.parse(doc['Price']) * int.parse(doc['Quantity']);
    }
    if (mounted) {
      setState(() {
        total = newTotal;
      });
    }
  }

  @override
  void dispose() {
    foodItemsSubscription?.cancel();  // Cancel the subscription
    super.dispose();
  }

  Widget allFoodCart() {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService().getFoodCart(id!),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SkeletonLoading(isVertical: true);
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No items in cart'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data!.docs[index];
            return ListTile(
              leading: Image.network(doc['Image'], width: 75, height: 90),
              title: Text(doc['Name'], style: AppFont.semiBoldTextStyle()),
              subtitle: Text('\$${doc['Price']}', style: AppFont.lightTextStyle()),
              trailing: Text('Qty: ${doc['Quantity']}'),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                AppBar(
                  title: Text('Orders', style: AppFont.headlineTextStyle()),
                ),
                Expanded(child: allFoodCart()),
                if (!_isLoading) checkoutSection(),
              ],
            ),
    );
  }

  Widget checkoutSection() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Price', style: AppFont.boldTextStyle()),
                Text('\$${total.toString()}', style: AppFont.boldTextStyle()),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: processCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Checkout", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> processCheckout() async {
    if (int.parse(wallet!) < total) {
      ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
          content: Text('Insufficient wallet balance!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _isLoading = true);

    try {
      int newWalletAmount = int.parse(wallet!) - total;
      await DatabaseService().updateUserWallet(id!, newWalletAmount.toString());
      await SharedePrefHelper().saveUserWallet(newWalletAmount.toString());

      QuerySnapshot cartItems = await DatabaseService().getFoodCartItems(id!);
      for (var item in cartItems.docs) {
        await DatabaseService().deleteFoodCartItem(id!, item.id);
      }

       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully!'), backgroundColor: Colors.green),
      );

      loadInitialData();  // Refresh data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
