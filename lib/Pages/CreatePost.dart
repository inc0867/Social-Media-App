import 'dart:io';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/Navigator/Navigation.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';
import 'package:malazgirt/Managment/service/work/service.dart';
import 'package:malazgirt/Pages/Home.dart';
import 'package:malazgirt/widget/Authitems/authfield.dart';

class SharePost extends StatefulWidget {
  const SharePost({super.key});

  @override
  State<SharePost> createState() => _SharePostState();
}

class _SharePostState extends State<SharePost> {
  @override
  void initState() {
    doit();
    super.initState();
  }

  doit() async {
    setState(() {
      load = true;
    });

    await UserPrefs.getuserid().then((value) {
      print(value);
      if (value != null) {
        setState(() {
          userid = value;
        });
      }
    });

    await UserPrefs.getusername().then((value) {
      print(value);
      if (value != null) {
        setState(() {
          username = value;
        });
      }
    });

    setState(() {
      load = false;
    });
  }

  bool load = true;
  String username = "";
  String userid = "";
  File? file;
  String type = "Select a share type";
  bool gor = false;
  pickfiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File files = File(result.files.single.path!);
      setState(() {
        file = files;
        gor = true;
      });
    }
  }

  final _service = FireService();
  TextEditingController textEditingController = TextEditingController();
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
            backgroundColor: gor ? Colors.black : Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  gor
                      ? Expanded(child: Image(image: FileImage(file!)))
                      : Container(),
                  gor ? Container() : Expanded(child: Container()),
                  gor
                      ? Container()
                      : ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          onPressed: () async {
                            await pickfiles();
                          },
                          icon: const Icon(
                            Icons.image_outlined,
                            size: 30,
                          ),
                          label: const Text(
                            "Pick Image",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ),
                  const Text(
                    "(Optional)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  gor ? Container() : Expanded(child: Container()),
                  PopupMenuButton(
                    onSelected: (value) {
                      if (value == "a") {
                        setState(() {
                          type = "IT";
                        });
                      } else if (value == "b") {
                        setState(() {
                          type = "History";
                        });
                      } else if (value == "c") {
                        setState(() {
                          type = "Economy";
                        });
                      } else if (value == "d") {
                        setState(() {
                          type = "Art";
                        });
                      } else if (value == "e") {
                        setState(() {
                          type = "Movie";
                        });
                      } else if (value == "f") {
                        setState(() {
                          type = "News";
                        });
                      } else if (value == "g") {
                        setState(() {
                          type = "Free";
                        });
                      }
                    },
                    child: Container(
                      width: 200,
                      height: 30,
                      decoration: BoxDecoration(
                          color: gor ? Colors.white : Colors.black,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text(
                        type,
                        style: TextStyle(
                            fontSize: 18,
                            color: gor ? Colors.black : Colors.white),
                      )),
                    ),
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                            value: "a",
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.developer_mode),
                                Text("IT")
                              ],
                            )),
                        const PopupMenuItem(
                            value: "b",
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.history_edu),
                                Text("History")
                              ],
                            )),
                        const PopupMenuItem(
                            value: "c",
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [Icon(Icons.money), Text("Economy")],
                            )),
                        const PopupMenuItem(
                            value: "d",
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [Icon(Icons.art_track), Text("Art")],
                            )),
                        const PopupMenuItem(
                            value: "e",
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.movie_creation),
                                Text("Movie")
                              ],
                            )),
                        const PopupMenuItem(
                            value: "f",
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [Icon(Icons.newspaper), Text("News")],
                            )),
                        const PopupMenuItem(
                            value: "g",
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.featured_video),
                                Text("Free")
                              ],
                            )),
                      ];
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    child: TextField(
                      controller: textEditingController,
                      style: gor
                          ? const TextStyle(color: Colors.white)
                          : const TextStyle(color: Colors.black),
                      decoration: SendField(
                          const Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                          "Write a Message",
                          gor, () {
                        createapost();
                      }),
                    ),
                  )
                ],
              ),
            ),
            appBar: AppBar(
              actions: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://www.simplilearn.com/ice9/free_resources_article_thumb/Advantages_and_Disadvantages_of_artificial_intelligence.jpg"),
                  ),
                ),
              ],
              backgroundColor: Colors.black,
              title: const Center(
                child: Text(
                  "Share a Think",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          );
  }

  createapost() async {
    if (file != null && gor == true && textEditingController.text != "" && type != "Select a share type") {
      try {
        setState(() {
          load = true;
        });
        await _service.create_a_post(
            username, userid, textEditingController.text,type , true, file);
        // ignore: use_build_context_synchronously
        ElegantNotification.success(
                description: const Text("Post has create succesfully"))
            .show(context);
        // ignore: use_build_context_synchronously
        Navigate.NavigatePage(false, const Home(), context);
        setState(() {
          load = false;
        });
      } catch (e) {
        ElegantNotification.error(
          description: const Text("Have some Error"),
        ).show(context);
        setState(() {
          load = false;
        });
      }
    } else {
      if (textEditingController.text != "" && type != "Select a share type") {
        try {
          setState(() {
            load = true;
          });
          await _service.create_a_post(
            username,
            userid,
            textEditingController.text,
            type,
            false,
          );
          // ignore: use_build_context_synchronously
          ElegantNotification.success(
                  description: const Text("Post has create succesfully"))
              .show(context);
          // ignore: use_build_context_synchronously
          Navigate.NavigatePage(false, const Home(), context);
          setState(() {
            load = false;
          });
        } catch (e) {
          ElegantNotification.error(
            description: const Text("Have some Error"),
          ).show(context);
          setState(() {
            load = false;
          });
        }
      } else {
        ElegantNotification.error(
                description: const Text("Plase check all variables"))
            .show(context);
      }
    }
  }
}
