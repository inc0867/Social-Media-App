import 'dart:io';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/service/work/service.dart';

class SendaPhoto extends StatefulWidget {
  final String userid;
  final String username;
  final String gid;
  final bool img;
  final String avatar;
  const SendaPhoto({
    Key? key,
    required this.avatar,
    required this.gid,
    required this.img,
    required this.userid,
    required this.username,
  }) : super(key: key);

  @override
  State<SendaPhoto> createState() => _SendaPhotoState();
}

class _SendaPhotoState extends State<SendaPhoto> {
  bool select = false;
  File? file;
  bool load = false;
  final _service = FireService();
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      content: load
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                select
                    ? Container(
                        width: 220,
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: FileImage(file!)),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          FilePickerResult? filePickerResult =
                              await FilePicker.platform.pickFiles();

                          if (filePickerResult != null) {
                            setState(() {
                              load = true;
                            });
                            setState(() {
                              file = File(filePickerResult.files.single.path!);
                              select = true;
                            });
                            print(file);
                            setState(() {
                              load = false;
                            });
                          }
                        },
                        child: const Text(
                          "Pick a File",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        )),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.white),
                            hintText: "Write a Message",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: Colors.white))),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        sendamsg();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.send,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
      title: const Text(
        "Send a Photo",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  sendamsg() async{
    if (file != null && select == true && textEditingController.text != "") {
      setState(() {
        load = true;
      });
      await _service.SendaImage(widget.userid, widget.username, textEditingController.text,
          widget.gid, widget.img, widget.avatar, file!).whenComplete(() {
            setState(() {
              load =  false;
            });
          }).whenComplete(() {
            Navigator.pop(context);
          });

    } else {
      ElegantNotification.info(
              description: const Text("Pls Select a IMG and Write a Message"))
          .show(context);
    }
  }
}
