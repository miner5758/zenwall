import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zenwall/newaddc.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;

String? inputData() {
  final User? user = auth.currentUser;
  final uid = user?.uid;
  return uid;
}

class AlmostScrren extends StatelessWidget {
  const AlmostScrren({Key? key}) : super(key: key);
  static const String _title = 'Zenex';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "lib/images/logo.png",
            ),
          ),
          centerTitle: true,
          title: const Text(
            _title,
            style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic),
          ),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      body: Container(
        child: const MyStatefulWidget(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("lib/images/teblutwo.jpg"),
                fit: BoxFit.cover)),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String imageUrl = "";
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  void printurl() async {
    try {
      final id = inputData();
      final ref =
          FirebaseStorage.instance.ref().child('$id/profilePicture/file');

      var url = await ref.getDownloadURL();
      setState(() {
        imageUrl = url;
      });
    } catch (e) {
      setState(() {
        imageUrl = "";
      });
    }
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final id = inputData();
    final destination = '$id/profilePicture';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child('file/');
      await ref.putFile(_photo!);
      printurl();
    } catch (e) {
      print('error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: db.collection("Users").doc(inputData()).get().then((value) {
          return value.data()!["Username"];
        }),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Column(
            children: [
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .20,
                  width: (MediaQuery.of(context).size.width - 50),
                  child: Text(
                    "Welcome To ZenPay " +
                        snapshot.data.toString() +
                        " Would you like to add a Debit Card Now(You can always do this later)",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 35),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
              ),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  width: MediaQuery.of(context).size.width * 0.40,
                  foregroundDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: imageUrl != ""
                          ? NetworkImage(imageUrl)
                          : const AssetImage('lib/images/pig.jpg')
                              as ImageProvider,
                    ),
                  ),
                  child: InkWell(
                    onTap: () => imgFromGallery(),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .10,
                  width: (MediaQuery.of(context).size.width - 50),
                  child: const Text(
                    "Click on the image to change your profile picture!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
              ),
              Row(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * .06,
                      width: MediaQuery.of(context).size.width * .45,
                      child: ElevatedButton(
                        child: const Text('No'),
                        onPressed: (() {
                          Navigator.popUntil(context,
                              (Route<dynamic> predicate) => predicate.isFirst);
                        }),
                      )),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .10,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * .06,
                      width: MediaQuery.of(context).size.width * .45,
                      child: ElevatedButton(
                        child: const Text('Yes'),
                        onPressed: (() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NewAddCreditPage()),
                          );
                        }),
                      )),
                ],
              )
            ],
          );
        });
  }
}
