import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/Navigator/Navigation.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';
import 'package:malazgirt/Managment/service/work/Notification/FirreBaseMessaging.dart';
import 'package:malazgirt/Managment/service/work/service.dart';
import 'package:malazgirt/Pages/Messages.dart';
import 'package:malazgirt/widget/messagesitems/Groups/GroupActions/SendaPhoto.dart';
import 'package:malazgirt/widget/messagesitems/Groups/GroupInfo/GroupInfoPage.dart';
import 'package:malazgirt/widget/messagesitems/Groups/Messages.dart';

class GroupPage extends StatefulWidget {
  final bool img;
  final String gname;
  final String url;
  final String desc;
  final bool dsc;
  final String gid;
  const GroupPage(
      {Key? key,
      required this.desc,
      required this.dsc,
      required this.gid,
      required this.gname,
      required this.img,
      required this.url})
      : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  void initState() {
    doit();
    super.initState();
  }

  doit() async {
    setState(() {
      load = true;
    });
    Stream<QuerySnapshot> querySnapshot =
        await _service.getchatstreamgroups(widget.gid);
    setState(() {
      stream = querySnapshot;
    });

    List<String> token = await _service.GetGroupUserToken(widget.gid);
    setState(() {
      tokens = token;
    });
    await UserPrefs.getuserid().then((value) async {
      if (value != null) {
        setState(() {
          userid = value;
        });
        DocumentSnapshot documentSnapshot = await _service.getuserdata(value);
        setState(() {
          deleteds = documentSnapshot["deleteds"];
        });
        if (documentSnapshot["pp"] == "") {
          setState(() {
            img = false;
          });
        } else {
          setState(() {
            avatarurl = documentSnapshot["pp"];
            img = true;
          });
        }
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

  List deleteds = [];
  final _nservice = FirebaseNotificatinService();
  final _service = FireService();
  Stream<QuerySnapshot>? stream;
  List<String> tokens = [];
  bool img = false;
  String avatarurl = "";
  String userid = "";
  String username = "";
  bool load = true;
  TextEditingController controller = TextEditingController();
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                sendamessage();
              },
              backgroundColor: Colors.black,
              child: const Icon(
                Icons.send,
                size: 30,
              ),
            ),
            appBar: AppBar(
              actions: [
                const SizedBox(
                  width: 5,
                ),
                PopupMenuButton(
                  color: Colors.black,
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                          child: Text(
                        "Build by nearly",
                        style: TextStyle(color: Colors.white),
                      )),
                    ];
                  },
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
              title: ListTile(
                onTap: () {
                  Navigate.NavigatePage(
                      false, GroupInfoPage(gid: widget.gid), context);
                },
                subtitle: widget.dsc
                    ? Text(widget.desc)
                    : const Text(
                        "Group of Discussion",
                        style: TextStyle(color: Colors.grey),
                      ),
                title: Text(
                  widget.gname,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
                leading: widget.img
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(widget.url),
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.groups,
                          color: Colors.white,
                        ),
                      ),
              ),
              elevation: 10,
              backgroundColor: Colors.white,
              leading: GestureDetector(
                  onTap: () {
                    Navigate.NavigatePage(false, const Messages(), context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.black,
                  )),
            ),
            body: Column(
              children: [
                Expanded(child: msgstream()),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 15, top: 10, left: 20, right: 80),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        prefixIcon: GestureDetector(
                          onTap: () {},
                          child: const Icon(
                            Icons.file_upload,
                            color: Colors.grey,
                            size: 28,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SendaPhoto(
                                  gid: widget.gid,
                                  avatar: avatarurl,
                                  img: img,
                                  userid: userid,
                                  username: username,
                                );
                              },
                            );
                          },
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                            size: 28,
                          ),
                        ),
                        hintText: "Send a Messages",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1.7)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1.7))),
                  ),
                ),
              ],
            ),
          );
  }

  msgstream() {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  if (deleteds.contains(snapshot.data!.docs[index].id)) {
                    return Container();
                  } else {
                    return Msg(
                        readers: snapshot.data!.docs[index]["readers"],
                        url: snapshot.data!.docs[index]["resurl"],
                        res: snapshot.data!.docs[index]["res"],
                        msgid: snapshot.data!.docs[index].id,
                        avatar: snapshot.data!.docs[index]["avatar"],
                        gid: snapshot.data!.docs[index]["gid"],
                        img: snapshot.data!.docs[index]["img"],
                        msg: snapshot.data!.docs[index]["msg"],
                        read: snapshot.data!.docs[index]["read"],
                        time: snapshot.data!.docs[index]["time"],
                        userid: snapshot.data!.docs[index]["userid"],
                        username: snapshot.data!.docs[index]["username"]);
                  }
                },
              );
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        }
      },
    );
  }

  sendamessage() async {
    if (controller.text != "") {
      await _service
          .sendamessage(
              userid, username, controller.text, widget.gid, img, avatarurl)
          .whenComplete(() async {
        _nservice.sendNotification(
            true, tokens, username, controller.text, widget.gname);
        controller.clear();
      });
    }
  }
}
