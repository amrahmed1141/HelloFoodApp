import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/screens/user/details.dart';
import 'package:foodapp/service/database.dart';
import 'package:foodapp/widgets/fonts.dart';
import 'package:foodapp/widgets/icon_selected_row.dart';
import 'package:foodapp/widgets/skeleton_loading.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? foodItemStream;

  // Method to update the foodItemStream based on the selected category
  void updateFoodItemStream(String category) async {
    foodItemStream = await DatabaseService().getFoodItem(category);
    setState(() {});
  }

  onTheLoad() async {
     updateFoodItemStream('Pizza');
    setState(() {});
  }

  @override
  void initState() {
    onTheLoad();
    super.initState();
  }

  Widget allItemsVertical() {
    return StreamBuilder(
      stream: foodItemStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return GestureDetector(onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Details(
                                  name: ds['Name'],
                                  image: ds['Image'],
                                  price: ds['Price'],
                                  detail: ds['Detail'],
                                )));
                  },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: Material(
                        borderRadius: BorderRadius.circular(15),
                        elevation: 5,
                        color: Colors.white,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                ds['Image'],
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      ds['Name'],
                                      style: AppFont.boldTextStyle(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      'Fresh and Tasty',
                                      style: AppFont.lightTextStyle(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      '\$'+ds['Price'],
                                      style: AppFont.semiBoldTextStyle(),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })
            : const SkeletonLoading(isVertical: true);
      },
    );
  }

  Widget allItems() {
    return StreamBuilder(
      stream: foodItemStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Details(
                                name: ds['Name'],
                                image: ds['Image'],                   
                                price: ds['Price'],
                                detail: ds['Detail'],
                              )));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  ds['Image'],
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                ds['Name'],
                                style: AppFont.semiBoldTextStyle(),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Fresh and Tasty',
                                style: AppFont.lightTextStyle(),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                '\$' + ds['Price'],
                                style: AppFont.semiBoldTextStyle(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })
            : const SkeletonLoading(isVertical: false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.only(top: 55.0, left: 15.0, right: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Hello',
                          style: AppFont.boldTextStyle(),
                        ),
                        const SizedBox(width: 10,),
                        Image.asset('assets/images/wave.png',height: 30,width: 30,),
                      ],
                    ),
                    
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Image.asset(
                  'assets/images/ic_food_express.png',
                  fit: BoxFit.cover,
                  width: 200,
                  height: 50,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                IconSelectedRow(onCategorySelected: updateFoodItemStream),
                const SizedBox(
                  height: 20,
                ),
                Container(height: 265, child: allItems()),
                const SizedBox(
                  height: 10,
                ),
          
               Flexible(
                flex: 1,
                child: allItemsVertical()),
              ],
            )),
    );
  }
}
