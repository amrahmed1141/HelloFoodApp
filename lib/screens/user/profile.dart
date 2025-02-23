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
  double uploadProgress = 0;
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

      // Listen to the upload task to track progress and update the UI
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          double progress =
              (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          // Update a state variable to reflect progress
          uploadProgress = progress;
        });
      });
      // Wait for upload to complete
      TaskSnapshot snapshot = await uploadTask;
      var downloadUrl = await (await uploadTask).ref.getDownloadURL();

      await SharedePrefHelper().saveUserProfile(downloadUrl);
      setState(() {
        profile = downloadUrl; // Update the profile image URL immediately
        selectedImage = null; // Clear the selected image after upload
        uploadProgress = 0; // Reset the progress
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
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
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
                              bottom: 3,
                              right: 10,
                              child: uploadProgress > 0 && uploadProgress < 100
                                  ? CircularProgressIndicator(
                                      value: uploadProgress / 100)
                                  : GestureDetector(
                                      onTap: getImage,
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: Colors.yellow,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  profileDetailsSection(
                      Icons.person, "Name", name ?? "Loading..."),
                  const SizedBox(height: 20),
                  profileDetailsSection(
                      Icons.email, "Email", email ?? "Loading..."),
                  const SizedBox(height: 20),
                  profileDetailsSection(
                      Icons.description, "Terms And Conditions", "View"),
                  const SizedBox(height: 20),
                  profileActionButton(Icons.delete, "Delete Account",
                      FirebaseMethods().deleteUser),
                  const SizedBox(height: 20),
                  profileActionButton(
                      Icons.logout, "Log Out", FirebaseMethods().signOut),
                ],
              ),
            ),
    );
  }

  Widget profileDetailsSection(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Icon(icon),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppFont.semiBoldTextStyle()),
                  Text(value, style: AppFont.lightTextStyle()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget profileActionButton(IconData icon, String label, Function action) {
    return GestureDetector(
      onTap: () => action(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
        ),
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Icon(icon),
                const SizedBox(width: 20),
                Text(label, style: AppFont.semiBoldTextStyle()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
