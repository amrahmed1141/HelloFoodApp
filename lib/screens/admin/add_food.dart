
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodapp/service/database.dart';
import 'package:foodapp/widgets/fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddFoodAdmin extends StatefulWidget {
  const AddFoodAdmin({super.key});

  @override
  State<AddFoodAdmin> createState() => _AddFoodAdminState();
}

class _AddFoodAdminState extends State<AddFoodAdmin> {
  // List of dropdown items
  final List<String> items = ['Ice-Cream', 'Burger', 'Salad', 'Pizza'];
  String? selectedItem;
  final itemNameController = TextEditingController();
  final itemPriceController = TextEditingController();
  final itemDetailController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the tree
    itemNameController.dispose();
    itemPriceController.dispose();
    itemDetailController.dispose();

    super.dispose();
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  uploadItems() async {
    if (selectedImage != null &&
        itemNameController.text != "" &&
        itemPriceController.text != "" &&
        itemDetailController.text != "") {
      // upload Image to firebase storage
      String addId = randomAlphaNumeric(10);
      Reference firestorageRef =
          FirebaseStorage.instance.ref().child('Images').child(addId);
      final UploadTask uploadTask = firestorageRef.putFile(selectedImage!);

      var downloadUrl = await (await uploadTask).ref.getDownloadURL();

      Map<String, dynamic> foodData = {
        'Image': downloadUrl,
        'Name': itemNameController.text,
        'Price': itemPriceController.text,
        'Detail': itemDetailController.text,
      };
      await DatabaseService()
          .AddFoodItem(foodData, selectedItem!)
          .then((value) {
        Fluttertoast.showToast(
          msg: "Food Added Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black, // Green background for success
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // Reset form after upload
        setState(() {
          selectedImage = null;
          itemNameController.clear();
          itemPriceController.clear();
          itemDetailController.clear();
          selectedItem = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Add Food',
          style: AppFont.headlineTextStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 20.0, bottom: 55.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text(
                  'Upload Your Food Items Here',
                  style: AppFont.lightTextStyle(),
                )),
                const SizedBox(
                  height: 20,
                ),
                selectedImage == null
                    ? GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Center(
                          child: Material(
                            elevation: 5,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Stack(
                          children: [
                            Material(
                              elevation: 5,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            // Positioned remove icon
                            Positioned(
                              right: -10, // Adjust as needed
                              top: -10, // Adjust as needed
                              child: IconButton(
                                icon:
                                    const Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    selectedImage = null;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Item Name',
                  style: AppFont.semiBoldTextStyle(),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: itemNameController,
                    decoration: InputDecoration(
                      fillColor: Colors.black,
                      focusColor: Colors.black,
                      hintText: 'Enter Item Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Item price',
                  style: AppFont.semiBoldTextStyle(),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: itemPriceController,
                    decoration: InputDecoration(
                      fillColor: Colors.black,
                      focusColor: Colors.black,
                      hintText: 'Enter Item price',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Item Details',
                  style: AppFont.semiBoldTextStyle(),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: itemDetailController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      fillColor: Colors.black,
                      focusColor: Colors.black,
                      hintText: 'Enter Item details',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Select Category',
                  style: AppFont.semiBoldTextStyle(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  width: MediaQuery.of(context).size.width, // Full width
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    // Hides default underline
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // Spaces out items
                      children: [
                        Expanded(
                          // Ensures text takes available space
                          child: DropdownButton<String>(
                            value: selectedItem,
                            hint: const Text('Select Category'),
                            icon: const Icon(
                                Icons.arrow_drop_down), // Arrow at the end
                            iconSize: 20,
                            elevation: 5,
                            dropdownColor: Colors.white,
                            focusColor: Colors.black,
                            isExpanded:
                                true, // Ensures the dropdown expands properly
                            items: items
                                .map<DropdownMenuItem<String>>((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedItem = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      uploadItems();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Add Food',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
