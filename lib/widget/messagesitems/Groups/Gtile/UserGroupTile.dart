import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';
import 'package:malazgirt/Managment/service/work/service.dart';

class UserGroupTile extends StatefulWidget {
  final String userid;
  final String gid;
  const UserGroupTile({Key? key, required this.gid, required this.userid})
      : super(key: key);

  @override
  State<UserGroupTile> createState() => _UserGroupTileState();
}

class _UserGroupTileState extends State<UserGroupTile> {
  @override
  void initState() {
    doit();
    super.initState();
  }

  doit() async {
    setState(() {
      load = true;
    });
    DocumentSnapshot documentSnapshots =
        await _service.getgroupdata(widget.gid);

    List members = documentSnapshots["admins"];

    await UserPrefs.getuserid().then((value) {
      if (value != null) {
        if (members.contains(widget.userid)) {
          setState(() {
            admin = true;
          });
        } else {
          setState(() {
            admin = false;
          });
        }
        if (members.contains(value)) {
          setState(() {
            meadmin = true;
          });
        } else {
          setState(() {
            meadmin = false;
          });
        }
      }
    });

    DocumentSnapshot documentSnapshot =
        await _service.getuserdata(widget.userid);
    setState(() {
      username = documentSnapshot["username"];
    });
    if (documentSnapshot["pp"] == "") {
      setState(() {
        img = false;
      });
    } else {
      setState(() {
        url = documentSnapshot["pp"];
        img = true;
      });
    }

    if (documentSnapshot["desc"] == "") {
      setState(() {
        descs = false;
      });
    } else {
      setState(() {
        desc = documentSnapshot["desc"];
        descs = true;
      });
    }

    setState(() {
      load = false;
    });
  }

  final _service = FireService();
  bool meadmin = false;
  bool img = false;
  String url = "";
  String desc = "";
  bool descs = false;
  bool admin = false;
  bool load = true;
  String username = "";
  @override
  Widget build(BuildContext context) {
    return load
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          )
        : ListTile(
            trailing: meadmin
                ? admin
                    ? Container(
                        width: 1,
                      )
                    : PopupMenuButton(
                        onSelected: (value) async {
                          if (value == "a") {
                            setState(() {
                              load = true;
                            });
                            await _service.makeaadmin(
                                widget.gid, widget.userid);
                            doit();
                          } else if (value == "b") {
                            setState(() {
                              load = true;
                            });
                            await _service.removefromgroup(
                                widget.gid, widget.userid);
                            doit();
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                                value: "a",
                                child: Text(
                                  "Make admin",
                                  style: TextStyle(color: Colors.green),
                                )),
                            const PopupMenuItem(
                                value: "b",
                                child: Text(
                                  "Remove",
                                  style: TextStyle(color: Colors.red),
                                )),
                          ];
                        },
                      )
                : Container(
                    width: 1,
                  ),
            subtitle: descs
                ? Text(
                    desc,
                    style: const TextStyle(color: Colors.grey),
                  )
                : const Text(
                    "User of Discussions",
                    style: TextStyle(color: Colors.grey),
                  ),
            title: Row(
              children: [
                Text(
                  username,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
                Expanded(child: Container()),
                admin
                    ? const Text(
                        "admin",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      )
                    : const Text(
                        "member",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.grey),
                      )
              ],
            ),
            leading: img
                ? CircleAvatar(
                    backgroundImage: NetworkImage(url),
                  )
                : const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
          );
  }
}
