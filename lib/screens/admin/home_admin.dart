import 'package:flutter/material.dart';
import 'package:foodapp/screens/admin/add_food.dart';
import 'package:foodapp/widgets/fonts.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: const EdgeInsets.only(top: 55.0, left: 20.0, right: 20.0),
          child: Column(
            children: [
              Center(
                  child: Text(
                'Home Admin',
                style: AppFont.headlineTextStyle(),
              )),
              const SizedBox(height: 30,),
              GestureDetector(
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddFoodAdmin()));
                },
                child: Material(
                  elevation: 5,
                  child: Container(
                    padding:const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset(
                          'assets/images/food.jpg',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                     const SizedBox(width: 15,),
                      const Text(
                        'Add your food Here',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ]),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
