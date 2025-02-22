import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodapp/service/database.dart';
import 'package:foodapp/service/shared_pref.dart';
import 'package:foodapp/widgets/fonts.dart';

class Details extends StatefulWidget {
  String name, detail, price, image;
  Details(
      {required this.name,
      required this.detail,
      required this.price,
      required this.image});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int a = 1, total = 0;

  String? id;

  getSharedPref() async {
    id = await SharedePrefHelper().getUserId();
    setState(() {});
  }

  onTheLoad() async {
    await getSharedPref();
    setState(() {});
  }

  @override
  void initState() {
    total = int.parse(widget.price);
    onTheLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.only(top: 55, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  )),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Image.network(
            widget.image,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.5,
            fit: BoxFit.fill,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                widget.name,
                style: AppFont.boldTextStyle(),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  if (a > 1) {
                    --a;
                    total = total - int.parse(widget.price);
                  }
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
              Text(
                a.toString(),
                style: AppFont.semiBoldTextStyle(),
              ),
              const SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                onTap: () {
                  ++a;
                  total = total + int.parse(widget.price);
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.detail,
            style: AppFont.lightTextStyle(),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                'Delivery Time',
                style: AppFont.semiBoldTextStyle(),
              ),
              const SizedBox(
                width: 50,
              ),
              const Icon(
                Icons.alarm,
                color: Colors.black,
              ),
              Text(
                '30min',
                style: AppFont.semiBoldTextStyle(),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Price',
                      style: AppFont.semiBoldTextStyle(),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '\$' + total.toString(),
                      style: AppFont.boldTextStyle(),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                          Map<String, dynamic> AddedToCart = {
                            'Name': widget.name,
                            'Price': total.toString(),
                            'Image': widget.image,
                            'Quantity': a.toString()
                          };
                          await DatabaseService()
                              .AddFoodToCart(AddedToCart, id!);

                          Fluttertoast.showToast(
                            msg: "Food Added Successful",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor:
                                Colors.black, // Green background for success
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const Text(
                          'Add To Cart',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                       
                         Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.white),
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.black,
                            ),
                          ),
                        
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
