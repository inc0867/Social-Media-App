import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';
import 'package:malazgirt/Managment/service/work/service.dart';
import 'package:malazgirt/widget/BottomBar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    doit();
    super.initState();
  }

  doit() async {
    setState(() {
      load = true;
    });

    await UserPrefs.getuserid().then((value) async {
      if (value != null) {
        DocumentSnapshot documentSnapshot = await _service.getuserdata(value);
        setState(() {
          username = documentSnapshot["username"];
          userpp = documentSnapshot["pp"];
          descip = documentSnapshot["desc"];
          email = documentSnapshot["email"];
          follows = documentSnapshot["follows"];
          followers = documentSnapshot["followers"];
          stars = documentSnapshot["stars"];
          thinks = documentSnapshot["thinks"];
          if (documentSnapshot["pp"] == "") {
            setState(() {
              img = true;
            });
          } else {
            setState(() {
              img = false;
            });
          }

          if (documentSnapshot["desc"] == "") {
            setState(() {
              desc = true;
            });
          } else {
            setState(() {
              desc = false;
            });
          }
        });
      }
    });

    setState(() {
      load = false;
    });
  }

  File? file;
  List stars = [];
  List follows = [];
  List followers = [];
  String email = "";
  String username = "";
  String userpp = "";
  bool img = false;
  bool desc = false;
  String descip = "";
  bool load = true;
  List thinks = [];
  final _service = FireService();
  @override
  Widget build(BuildContext context) {
    return load
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          )
        : Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    title: Text(
                      username,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    subtitle: desc
                        ? GestureDetector(
                            onTap: () {},
                            child: const Text(
                              "Click for a add a personal decsription",
                              style: TextStyle(color: Colors.blue),
                            ))
                        : Container(),
                    leading: img
                        ? GestureDetector(
                            onTap: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();

                              if (result != null) {
                               try {
                                 setState(() {
                                  file = File(result.files.single.path!);
                                });
                                if (file != null) {
                                  setState(() {
                                    load = true;
                                  });
                                  await UserPrefs.getuserid()
                                      .then((value) async {
                                    if (value != null) {
                                      await _service.changeuserphoto(
                                          value, file!);
                                    }
                                  }).whenComplete(() {
                                    doit();
                                  }).whenComplete(() {
                                    ElegantNotification.success(description: const Text("PP has changed succesfully"));
                                  });
                                }
                               }catch (e) {
                                ElegantNotification.error(description: const Text("We had a some error "));
                               }
                              }
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 50,
                              child: Icon(
                                Icons.person_3,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(userpp),
                        ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 30,
                            ),
                            const Text(
                              "Followers",
                              style: TextStyle(fontSize: 17),
                            ),
                            Text("${followers.length}")
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              const Icon(
                                Icons.person,
                                size: 30,
                              ),
                              const Text(
                                "Follows",
                                style: TextStyle(fontSize: 17),
                              ),
                              Text("${follows.length}")
                            ],
                          )),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 30,
                            ),
                            const Text(
                              "Stars",
                              style: TextStyle(fontSize: 17),
                            ),
                            Text("${stars.length}")
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            const Icon(
                              Icons.message_outlined,
                              size: 30,
                            ),
                            const Text(
                              "Thinks",
                              style: TextStyle(fontSize: 17),
                            ),
                            Text("${thinks.length}"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "User by $email",
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
            bottomNavigationBar: const BottomBar(),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Center(
                child: Text(
                  "Profile",
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ),
          );
  }
}
