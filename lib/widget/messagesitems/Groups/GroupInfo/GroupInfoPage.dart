import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/Navigator/Navigation.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';
import 'package:malazgirt/Managment/service/work/service.dart';
import 'package:malazgirt/Pages/Messages.dart';
import 'package:malazgirt/widget/messagesitems/Groups/GroupInfo/GroupUser.dart';
import 'package:malazgirt/widget/messagesitems/Groups/GroupInfo/GroupsReq.dart';
import 'package:malazgirt/widget/messagesitems/Groups/GroupPage.dart';
import 'package:malazgirt/widget/messagesitems/Groups/Gtile/UserGroupTile.dart';

class GroupInfoPage extends StatefulWidget {
  final String gid;
  const GroupInfoPage({Key? key, required this.gid}) : super(key: key);

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  @override
  void initState() {
    doit();
    super.initState();
  }

  doit() async {
    setState(() {
      load = true;
    });
    DocumentSnapshot documentSnapshot = await _service.getgroupdata(widget.gid);

    setState(() {
      gname = documentSnapshot["gname"];
    });

    setState(() {
      members = documentSnapshot["members"];
    });

    await UserPrefs.getuserid().then((value) {
      if (value != null) {
        List a = documentSnapshot["admins"];
        if (a.contains(value)) {
          setState(() {
            admin = true;
          });
        } else {
          setState(() {
            admin = false;
          });
        }
      }
    });

    if (documentSnapshot["url"] == "") {
      print("a");
      setState(() {
        avatar = "";
        img = false;
      });
    } else {
      print("b");
      setState(() {
        img = true;
        avatar = documentSnapshot["url"];
      });
    }
    print(img);

    print(avatar);
    if (documentSnapshot["gdesc"] == "") {
      setState(() {
        desc = false;
        gdesc = "";
      });
    } else {
      setState(() {
        desc = true;
        gdesc = documentSnapshot["gdesc"];
      });
    }
    setState(() {
      stream = _service.getgstream(widget.gid);
    });
    setState(() {
      load = false;
    });
  }

  Stream<DocumentSnapshot>? stream;
  bool admin = false;
  String gname = "";
  String gdesc = "";
  bool desc = false;
  bool img = false;
  File? file;
  bool files = false;
  List members = [];
  String avatar = "";
  final _service = FireService();
  bool load = true;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    img
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(avatar),
                          )
                        : const Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 60,
                              child: Icon(
                                size: 70,
                                Icons.groups,
                                color: Colors.white,
                              ),
                            ),
                          ),
                    admin
                        ? GestureDetector(
                            onTap: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();

                              if (result != null) {
                                setState(() {
                                  load = true;
                                });
                              }
                              File file = File(result!.files.single.path!);
                              await _service.changegphoto(widget.gid, file);
                              await doit();
                              setState(() {
                                load = false;
                              });
                            },
                            child: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                              size: 40,
                            ),
                          )
                        : Container(),
                  ],
                ),
                Text(
                  gname,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
                desc
                    ? Text(
                        "$gdesc * ${members.length} Members",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w500),
                      )
                    : Text("Group of Disscussions * ${members.length} Members",
                        style: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w500)),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () async {
                      setState(() {
                        load = true;
                      });
                      await UserPrefs.getuserid().then((value) async {
                        await _service.leavefromGroup(
                            admin, value!, widget.gid);
                      }).whenComplete(() {
                        Navigate.NavigatePage(false, const Messages(), context);
                      });
                      setState(() {
                        load = false;
                      });
                    },
                    child: const Text(
                      "Leave",
                      style: TextStyle(color: Colors.white),
                    )),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 0.4,
                  color: Colors.grey,
                ),
                Expanded(child: sbuild()),
              ],
            ),
            appBar: AppBar(
              actions: admin ? [
                GestureDetector(
                  onTap: () {
                    Navigate.NavigatePage(false, GREQ(gid: widget.gid), context);
                  },
                  child: const Icon(
                    size: 30,
                    Icons.notifications,
                    color: Colors.black,
                  ),
                ),GestureDetector(
                  onTap: () {
                    Navigate.NavigatePage(false, UseraddPage(gid: widget.gid), context);
                  },
                  child: const Icon(
                    size: 30,
                    Icons.person_add,
                    color: Colors.black,
                  ),
                )
              ] : [],
              leading: GestureDetector(
                onTap: () {
                  print(img);
                  Navigate.NavigatePage(
                      false,
                      GroupPage(
                          desc: gdesc,
                          dsc: desc,
                          gid: widget.gid,
                          gname: gname,
                          img: img,
                          url: avatar),
                      context);
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
            ),
          );
  }

  sbuild() {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            List a = snapshot.data!["members"];
            if (a.isNotEmpty) {
              return ListView.builder(
                itemCount: a.length,
                itemBuilder: (context, index) {
                  return UserGroupTile(
                      gid: widget.gid,
                      userid: snapshot.data!["members"][index]);
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
}
