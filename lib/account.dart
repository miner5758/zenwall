import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zenwall/authentication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:zenwall/changee.dart';
import 'package:zenwall/changep.dart';
import 'dart:io';

final FirebaseAuth auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;

String? inputData() {
  final User? user = auth.currentUser;
  final uid = user?.uid;
  return uid;
}

bool? inputDatatwo() {
  final User? user = auth.currentUser;
  final uid = user?.emailVerified;
  return uid;
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.32,
                child: const MyStatefulWidget(),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.68,
                child: const MyStatefulWidgetTwo(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class MyStatefulWidgetTwo extends StatefulWidget {
  const MyStatefulWidgetTwo({Key? key}) : super(key: key);
  @override
  State<MyStatefulWidgetTwo> createState() => _MyStatefulWidgetStateTwo();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String imageUrl = "";

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

  @override
  void initState() {
    super.initState();
    printurl();
  }

  @override
  void dispose() {
    super.dispose();
  }

  File? _photo;
  final ImagePicker _picker = ImagePicker();

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
    return Scaffold(
      body: Column(
        children: [
          Column(children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.32,
                child: Stack(
                  children: [
                    Container(
                      height: (MediaQuery.of(context).size.height * 0.32),
                      width: (MediaQuery.of(context).size.width),
                      foregroundDecoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('lib/images/blu.jpg'),
                        fit: BoxFit.fill,
                      )),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.08),
                          child: Center(
                            child: Center(
                                child: Text(
                              "Account Information",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.09),
                            )),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02),
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  width:
                                      MediaQuery.of(context).size.width * 0.26,
                                  foregroundDecoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: imageUrl != ""
                                          ? NetworkImage(imageUrl)
                                          : const AssetImage(
                                                  'lib/images/pig.jpg')
                                              as ImageProvider,
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () => imgFromGallery(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ]),
        ],
      ),
    );
  }
}

class _MyStatefulWidgetStateTwo extends State<MyStatefulWidgetTwo> {
  TextEditingController passwordcontroller = TextEditingController();

  void deleteuser(String passwo) async {
    bool ew = false;
    var message = "";

    try {
      final User? users = auth.currentUser;
      UserCredential? authResult = await users?.reauthenticateWithCredential(
        EmailAuthProvider.credential(
            email: users.email.toString(), password: passwo),
      );
    } on FirebaseAuthException catch (e) {
      ew = true;
    }

    if (ew == false) {
      try {
        var collection =
            db.collection('Users').doc(inputData()).collection("Cards");
        var snapshots = await collection.get();
        for (var doc in snapshots.docs) {
          await doc.reference.delete();
        }
      } catch (e) {
        print(e.toString());
      }

      try {
        var collection =
            db.collection('Users').doc(inputData()).collection("Purchases");
        var snapshots = await collection.get();
        for (var doc in snapshots.docs) {
          await doc.reference.delete();
        }
      } catch (e) {
        print(e.toString());
      }

      try {
        var collection =
            db.collection('Users').doc(inputData()).collection("Friends");
        var snapshots = await collection.get();
        for (var doc in snapshots.docs) {
          await doc.reference.delete();
        }
      } catch (e) {
        print(e.toString());
      }

      db.collection('Users').doc(inputData()).delete();
      try {
        final id = inputData();
        await FirebaseStorage.instance
            .ref('$id/profilePicture')
            .listAll()
            .then((value) {
          FirebaseStorage.instance.ref(value.items.first.fullPath).delete();
        });
      } catch (e) {
        print(e.toString());
      }

      try {
        final User? users = auth.currentUser;
        UserCredential? authResult = await users?.reauthenticateWithCredential(
          EmailAuthProvider.credential(
              email: users.email.toString(), password: passwo),
        );
        final newuse = authResult?.user;
        await newuse!
            .delete()
            .then(
              (value) => message = 'Success',
            )
            .catchError((onError) => message = 'error');
      } on FirebaseAuthException catch (e) {
        print("Autism");
      }
    } else if (ew == true) {
      message = "Not Changed";
    }

    if (message == "Not Changed") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Wrong Password"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Try Again"))
              ],
            );
          });
    } else if (message == "Success") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Complete!"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.popUntil(context,
                          (Route<dynamic> predicate) => predicate.isFirst);
                    },
                    child: const Text("Go Back"))
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Something went wrong, please try again"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Try Again"))
              ],
            );
          });
    }
  }

  Timer? timer;
  bool isEmailverified = false;

  @override
  void initState() {
    super.initState();
    isEmailverified = auth.currentUser!.emailVerified;
    if (!isEmailverified) {
      timer = Timer.periodic(const Duration(seconds: 6), (_) => checkvefied());
    }
  }

  Future checkvefied() async {
    await auth.currentUser!.reload();
    setState(() {
      isEmailverified = auth.currentUser!.emailVerified;
    });
    if (isEmailverified) timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVeficationEmail() async {
    final User? user = auth.currentUser;
    final uid = user?.email;
    String tit = "A verification email has been sent to $uid's inbox!";
    try {
      final User? user = auth.currentUser;
      await user?.sendEmailVerification();
    } catch (e) {
      tit = "Something went wrong, please try again!";
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(tit),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("ok"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController usercontroller = TextEditingController();
    TextEditingController phonecontroller = TextEditingController();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xffFFE5B4),
        ),
        child: FutureBuilder(
            future: db.collection("Users").doc(inputData()).get().then((value) {
              return value.data()!["Username"];
            }),
            builder: (BuildContext context, AsyncSnapshot snapshot) =>
                isEmailverified == false
                    ? ListView(
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 20),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * .53,
                                width: MediaQuery.of(context).size.width * .93,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color:
                                      const Color.fromARGB(255, 150, 135, 108),
                                ),
                                child: ListView(children: [
                                  Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .85,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.blue,
                                          onTap: () {
                                            sendVeficationEmail();
                                          },
                                          child: const ListTile(
                                            trailing: FlutterLogo(),
                                            title: Text(
                                              "Verify Email",
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .85,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.blue,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ChangeEmail()));
                                          },
                                          child: const ListTile(
                                            trailing: FlutterLogo(),
                                            title: Text(
                                              "Change Email",
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .85,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.blue,
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Insert New Username"),
                                                    content: TextFormField(
                                                      controller:
                                                          usercontroller,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      validator: ((value) {
                                                        if (value!.isEmpty ==
                                                            true) {
                                                          return 'Please enter some text';
                                                        } else if (value
                                                                .length >
                                                            11) {
                                                          return "not a valid Username!!";
                                                        } else {
                                                          return null;
                                                        }
                                                      }),
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            'New Username',
                                                        hintText:
                                                            'Ex.Zenex@gmail.com',
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  width: 0.0),
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            String tit =
                                                                "Complete!";
                                                            if (usercontroller
                                                                    .text
                                                                    .isEmpty ||
                                                                usercontroller
                                                                        .text
                                                                        .length >
                                                                    11) {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: const Text(
                                                                          "Not a valid Username!"),
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                const Text("Ok"))
                                                                      ],
                                                                    );
                                                                  });
                                                            } else {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Users')
                                                                  .doc(
                                                                      inputData())
                                                                  .update({
                                                                'Username':
                                                                    usercontroller
                                                                        .text
                                                                        .toString()
                                                              }).catchError(
                                                                (error) => tit =
                                                                    "Something went wrong, please try again",
                                                              );
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          tit),
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                const Text("Ok"))
                                                                      ],
                                                                    );
                                                                  });
                                                            }
                                                          },
                                                          child: const Text(
                                                              "Submit"))
                                                    ],
                                                  );
                                                });
                                          },
                                          child: const ListTile(
                                            trailing: FlutterLogo(),
                                            title: Text(
                                              "Change Username",
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .85,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.blue,
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Insert New Phone Number"),
                                                    content: TextFormField(
                                                      controller:
                                                          phonecontroller,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      validator: ((value) {
                                                        if (value!.isEmpty ==
                                                            true) {
                                                          return 'Please enter some text';
                                                        } else if (value
                                                                .length !=
                                                            10) {
                                                          return "not a valid Phone number!";
                                                        } else {
                                                          return null;
                                                        }
                                                      }),
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            'New Phone Number',
                                                        hintText:
                                                            'Ex.7208892121',
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  width: 0.0),
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            String tit =
                                                                "Complete!";
                                                            if (phonecontroller
                                                                    .text
                                                                    .length !=
                                                                10) {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: const Text(
                                                                          "Not a valid phone number"),
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                const Text("Ok"))
                                                                      ],
                                                                    );
                                                                  });
                                                            } else {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Users')
                                                                  .doc(
                                                                      inputData())
                                                                  .update({
                                                                'Phone':
                                                                    phonecontroller
                                                                        .text
                                                                        .toString()
                                                              }).catchError(
                                                                (error) => tit =
                                                                    "Something went wrong, please try again",
                                                              );
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          tit),
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                const Text("Ok"))
                                                                      ],
                                                                    );
                                                                  });
                                                            }
                                                          },
                                                          child: const Text(
                                                              "Submit"))
                                                    ],
                                                  );
                                                });
                                          },
                                          child: const ListTile(
                                            trailing: FlutterLogo(),
                                            title: Text(
                                              "Change Phone Number",
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .85,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.blue,
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "You cant do this until you verify your email!"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text("ok"))
                                                    ],
                                                  );
                                                });
                                          },
                                          child: const ListTile(
                                            trailing: FlutterLogo(),
                                            title: Text(
                                              "Change Password",
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .85,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.blue,
                                          onTap: () {
                                            context
                                                .read<AuthenticationService>()
                                                .signOut();
                                            Navigator.popUntil(
                                                context,
                                                (Route<dynamic> predicate) =>
                                                    predicate.isFirst);
                                          },
                                          child: const ListTile(
                                            trailing: FlutterLogo(),
                                            title: Text(
                                              "Logout",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .85,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.blue,
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Are you sure you want to delete your account? You wont be able to undo this. type in your password and click yes if your sure"),
                                                    content: TextFormField(
                                                      controller:
                                                          passwordcontroller,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      validator: ((value) {
                                                        if (value!.isEmpty ==
                                                            true) {
                                                          return 'Please enter some text';
                                                        } else {
                                                          return null;
                                                        }
                                                      }),
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            'Current Password',
                                                        hintText:
                                                            'Ex.Animals123',
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  width: 0.0),
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            deleteuser(
                                                                passwordcontroller
                                                                    .text);
                                                          },
                                                          child: const Text(
                                                              "Yes")),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .50,
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text("No"))
                                                    ],
                                                  );
                                                });
                                          },
                                          child: const ListTile(
                                            trailing: FlutterLogo(),
                                            title: Text(
                                              "Delete Account",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ],
                      )
                    : ListView(
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 20),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * .53,
                                width: MediaQuery.of(context).size.width * .93,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color:
                                      const Color.fromARGB(255, 150, 135, 108),
                                ),
                                child: ListView(children: [
                                  Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .85,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.blue,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ChangeEmail()),
                                            );
                                          },
                                          child: const ListTile(
                                            trailing: FlutterLogo(),
                                            title: Text(
                                              "Change Email",
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .85,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.blue,
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Insert New Username"),
                                                    content: TextFormField(
                                                      controller:
                                                          usercontroller,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      validator: ((value) {
                                                        if (value!.isEmpty ==
                                                            true) {
                                                          return 'Please enter some text';
                                                        } else if (value
                                                                .length >
                                                            11) {
                                                          return "not a valid Username!!";
                                                        } else {
                                                          return null;
                                                        }
                                                      }),
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            'New Username',
                                                        hintText:
                                                            'Ex.Zenex@gmail.com',
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  width: 0.0),
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            String tit =
                                                                "Complete!";
                                                            if (usercontroller
                                                                    .text
                                                                    .isEmpty ||
                                                                usercontroller
                                                                        .text
                                                                        .length >
                                                                    11) {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: const Text(
                                                                          "Not a valid Username!"),
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                const Text("Ok"))
                                                                      ],
                                                                    );
                                                                  });
                                                            } else {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Users')
                                                                  .doc(
                                                                      inputData())
                                                                  .update({
                                                                'Username':
                                                                    usercontroller
                                                                        .text
                                                                        .toString()
                                                              }).catchError(
                                                                (error) => tit =
                                                                    "Something went wrong, please try again",
                                                              );
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          tit),
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                const Text("Ok"))
                                                                      ],
                                                                    );
                                                                  });
                                                            }
                                                          },
                                                          child: const Text(
                                                              "Submit"))
                                                    ],
                                                  );
                                                });
                                          },
                                          child: const ListTile(
                                            trailing: FlutterLogo(),
                                            title: Text(
                                              "Change Username",
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .85,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.blue,
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Insert New Phone Number"),
                                                    content: TextFormField(
                                                      controller:
                                                          phonecontroller,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      validator: ((value) {
                                                        if (value!.isEmpty ==
                                                            true) {
                                                          return 'Please enter some text';
                                                        } else if (value
                                                                .length !=
                                                            10) {
                                                          return "not a valid Phone number!";
                                                        } else {
                                                          return null;
                                                        }
                                                      }),
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            'New Phone Number',
                                                        hintText:
                                                            'Ex.7208892121',
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  width: 0.0),
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            String tit =
                                                                "Complete!";
                                                            if (phonecontroller
                                                                    .text
                                                                    .length !=
                                                                10) {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: const Text(
                                                                          "Not a valid phone number"),
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                const Text("Ok"))
                                                                      ],
                                                                    );
                                                                  });
                                                            } else {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Users')
                                                                  .doc(
                                                                      inputData())
                                                                  .update({
                                                                'Phone':
                                                                    phonecontroller
                                                                        .text
                                                                        .toString()
                                                              }).catchError(
                                                                (error) => tit =
                                                                    "Something went wrong, please try again",
                                                              );
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          tit),
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                const Text("Ok"))
                                                                      ],
                                                                    );
                                                                  });
                                                            }
                                                          },
                                                          child: const Text(
                                                              "Submit"))
                                                    ],
                                                  );
                                                });
                                          },
                                          child: const ListTile(
                                            trailing: FlutterLogo(),
                                            title: Text(
                                              "Change Phone Number",
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .85,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.blue,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ChangePassword()));
                                          },
                                          child: const ListTile(
                                            trailing: FlutterLogo(),
                                            title: Text(
                                              "Change Password",
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .85,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.blue,
                                          onTap: () {
                                            context
                                                .read<AuthenticationService>()
                                                .signOut();
                                            Navigator.popUntil(
                                                context,
                                                (Route<dynamic> predicate) =>
                                                    predicate.isFirst);
                                          },
                                          child: const ListTile(
                                            trailing: FlutterLogo(),
                                            title: Text(
                                              "Logout",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .85,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.blue,
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Are you sure you want to delete your account? You wont be able to undo this. type in your password and click yes if your sure"),
                                                    content: TextFormField(
                                                      controller:
                                                          passwordcontroller,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      validator: ((value) {
                                                        if (value!.isEmpty ==
                                                            true) {
                                                          return 'Please enter some text';
                                                        } else {
                                                          return null;
                                                        }
                                                      }),
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            'Current Password',
                                                        hintText:
                                                            'Ex.Animals123',
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  width: 0.0),
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            deleteuser(
                                                                passwordcontroller
                                                                    .text);
                                                          },
                                                          child: const Text(
                                                              "Yes")),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .50,
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text("No"))
                                                    ],
                                                  );
                                                });
                                          },
                                          child: const ListTile(
                                            trailing: FlutterLogo(),
                                            title: Text(
                                              "Delete Account",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ],
                      )),
      ),
    );
  }
}
