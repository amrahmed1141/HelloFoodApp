import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/service/firebase_auth.dart';
import 'package:foodapp/service/shared_pref.dart';
import 'package:foodapp/widgets/fonts.dart';
import 'package:foodapp/widgets/skeleton_loading_profile.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? profile, name, email;

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {
      uploadItems();
    });
  }

  uploadItems() async {
    if (selectedImage != null) {
      // upload Image to firebase storage
      String addId = randomAlphaNumeric(10);
      Reference firestorageRef =
          FirebaseStorage.instance.ref().child('Images').child(addId);
      final UploadTask uploadTask = firestorageRef.putFile(selectedImage!);

      var downloadUrl = await (await uploadTask).ref.getDownloadURL();

      await SharedePrefHelper().saveUserProfile(downloadUrl);
      setState(() {
      profile = downloadUrl; // Update the profile image URL immediately
      selectedImage = null;  // Clear the selected image after upload
    });
    }
  }

  gettheSharedPref() async {
    profile = await SharedePrefHelper().getUserProfile();
    name = await SharedePrefHelper().getUserName();
    email = await SharedePrefHelper().getUserEmail();
    setState(() {});
  }

  onTheLoad() async {
    gettheSharedPref();
    setState(() {});
  }

  @override
  void initState() {
    onTheLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: name == null
          ? const SkeletonLoadingProfile()
          : Container(
              margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Wrap the Stack in a Container with a defined size
                      Container(
                        width: 150, // Adjust the size as needed
                        height: 150, // Adjust the size as needed
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(top: 30),
                                child: Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(60),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: profile == null
                                        ? Image.asset(
                                            'assets/images/photo.jpeg',
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            profile!,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 3, // Position at the bottom
                              right: 10, // Position at the right
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors
                                      .yellow, // Background color for the icon
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: selectedImage == null
                                    ? GestureDetector(
                                        onTap: () {
                                          getImage();
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                        ),
                                      )
                                    : Image.file(selectedImage!),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Colors.grey.withOpacity(0.5))),
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(Icons.person),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name',
                                style: AppFont.semiBoldTextStyle(),
                              ),
                              Text(
                                name!,
                                style: AppFont.lightTextStyle(),
                              ),
                            ],
                          )
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Colors.grey.withOpacity(0.5))),
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(Icons.email),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email',
                                style: AppFont.semiBoldTextStyle(),
                              ),
                              Text(
                                email!,
                                style: AppFont.lightTextStyle(),
                              ),
                            ],
                          )
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Colors.grey.withOpacity(0.5))),
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(Icons.description),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Terms And Conditions',
                                style: AppFont.semiBoldTextStyle(),
                              ),
                            ],
                          )
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      FirebaseMethods().deleteUser();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.5))),
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(Icons.delete),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Delete Account',
                                  style: AppFont.semiBoldTextStyle(),
                                ),
                              ],
                            )
                          ]),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      FirebaseMethods().signOut();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.5))),
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(Icons.logout),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Log Out',
                                  style: AppFont.semiBoldTextStyle(),
                                ),
                              ],
                            )
                          ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
