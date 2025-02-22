import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foodapp/service/database.dart';
import 'package:foodapp/service/shared_pref.dart';
import 'package:foodapp/widgets/fonts.dart';
import 'package:foodapp/widgets/stripe.dart';
import 'package:http/http.dart' as http;

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final amountcontroller = TextEditingController();
  String? wallet, id;
  int? add;

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the tree
    amountcontroller.dispose();
    super.dispose();
  }

  getSharedPref() async {
    wallet = await SharedePrefHelper().getUserWallet();
    id = await SharedePrefHelper().getUserId();
    setState(() {});
  }

  onTheLoad() async {
    await getSharedPref();
    setState(() {});
  }

  @override
  void initState() {
    onTheLoad();
    super.initState();
  }

  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: wallet == null
          ?  const CircularProgressIndicator()
          : Container(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  elevation: 5,
                  child: Container(
                      padding:const EdgeInsets.all(10),
                      margin:const EdgeInsets.only(top: 55),
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Wallet',
                        style: AppFont.headlineTextStyle(),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration:  const BoxDecoration(color: Color(0xFFF2F2F2)),
                  child: Row(children: [
                    Image.asset(
                      'assets/images/wallet.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Column(
                      children: [
                        Text(
                          'Your Wallet',
                          style: AppFont.lightTextStyle(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                         '\$' + wallet!,
                          style: AppFont.semiBoldTextStyle(),
                        )
                      ],
                    )
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Add money",
                    style: AppFont.semiBoldTextStyle(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        makePayment('100');
                      },
                      child: Container(
                        padding:const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(color:const Color(0xFFE9E2E2)),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          '\$' + '100',
                          style: AppFont.semiBoldTextStyle(),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        makePayment('500');
                      },
                      child: Container(
                        padding:  const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(color:const Color(0xFFE9E2E2)),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          '\$' + '500',
                          style: AppFont.semiBoldTextStyle(),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        makePayment('1000');
                      },
                      child: Container(
                        padding:const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE9E2E2)),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          '\$' + '1000',
                          style: AppFont.semiBoldTextStyle(),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        makePayment('5000');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(color:const Color(0xFFE9E2E2)),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          '\$' + '5000',
                          style: AppFont.semiBoldTextStyle(),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        makePayment('10000');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE9E2E2)),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          '\$' + '20000',
                          style: AppFont.semiBoldTextStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    openEdit();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                      child: Text(
                        'Add Money',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            )),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                  // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Amr'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet(amount);
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        add = int.parse(wallet!) + int.parse(amount);
        await SharedePrefHelper().saveUserWallet(add.toString());
        await DatabaseService().updateUserWallet(id!, add.toString());
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (_) =>const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children:  [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text("Payment Successfull"),
                        ],
                      ),
                    ],
                  ),
                ));
        await getSharedPref();

        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretkey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;

    return calculatedAmout.toString();
  }

  Future openEdit() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child:const Icon(Icons.cancel)),
                       const SizedBox(
                          width: 60.0,
                        ),
                      const  Center(
                          child: Text(
                            "Add Money",
                            style: TextStyle(
                              color: Color(0xFF008080),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                   const SizedBox(
                      height: 20.0,
                    ),
                  const  Text("Amount"),
                   const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38, width: 2.0),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: amountcontroller,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Enter Amount'),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          makePayment(amountcontroller.text);
                        },
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF008080),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:const  Center(
                              child: Text(
                            "Pay",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
}
