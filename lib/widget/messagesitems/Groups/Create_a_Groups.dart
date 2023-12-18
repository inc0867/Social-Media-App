import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';
import 'package:malazgirt/Managment/service/work/service.dart';
import 'package:malazgirt/widget/Authitems/authfield.dart';

class CreateaGroup extends StatefulWidget {
  const CreateaGroup({super.key});

  @override
  State<CreateaGroup> createState() => _CreateaGroupState();
}

class _CreateaGroupState extends State<CreateaGroup> {
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
      if (value != null) {
        setState(() {
          userid = value;
        });
      }
    });

    await UserPrefs.getusername().then((value) {
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

  TextEditingController textEditingController = TextEditingController();
  bool davetle = true;
  bool load = true;
  String userid = "";
  String username = "";
  final _service = FireService();
  @override
  Widget build(BuildContext context) {
    return load
        ? const AlertDialog(
            content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            ],
          ))
        : AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textEditingController,
                  decoration: InputField(
                      const Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                      "GroupName"),
                ),
                const SizedBox(
                  height: 10,
                ),
                davetle
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            davetle = false;
                          });
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.check_box),
                            Text(
                              " By Invitation Only",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            davetle = true;
                          });
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.check_box_outline_blank),
                            Text(
                              " Open to Anyone",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () async {
                      await createagroup();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "Create",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
            title: const Text(
              "Create a Group",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          );
  }

  createagroup() async {
    if (textEditingController.text != "") {
      setState(() {
        load = true;
      });
      await _service
          .create_a_group(userid, davetle, textEditingController.text, username)
          .whenComplete(() {
        Navigator.pop(context);
      }).whenComplete(() {
        ElegantNotification.success(
                description: const Text("Group created successfully"))
            .show(context);
      });
      setState(() {
        load = false;
      });
    }
  }
}
