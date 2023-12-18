import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/Navigator/Navigation.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';
import 'package:malazgirt/Managment/service/work/service.dart';
import 'package:malazgirt/widget/messagesitems/Groups/GroupPage.dart';

class GroupTile extends StatefulWidget {
  final String gid;
  const GroupTile({Key? key, required this.gid}) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
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
      int foreground = await _service.getnewmessages(value!, widget.gid);
      if (foreground == 0) {
        setState(() {
          bil = false;
          bildir = foreground;
        });
      } else {
        setState(() {
          bil = true;
          bildir = foreground;
        });
      }
    });
    DocumentSnapshot documentSnapshot = await _service.getgroupdata(widget.gid);
    setState(() {
      title = documentSnapshot["gname"];
      if (documentSnapshot["url"] == "") {
        setState(() {
          img = false;
        });
      } else {
        setState(() {
          url = documentSnapshot["url"];
          img = true;
        });
      }
      if (documentSnapshot["gdesc"] == "") {
        setState(() {
          dsc = false;
        });
      } else {
        setState(() {
          desc = documentSnapshot["url"];
          dsc = true;
        });
      }
    });
    setState(() {
      load = false;
    });
  }

  bool bil = false;
  bool dsc = false;
  bool img = false;
  int bildir = 0;
  String title = "";
  String desc = "";
  String url = "";
  final _service = FireService();
  bool load = true;
  @override
  Widget build(BuildContext context) {
    return load
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          )
        : ListTile(
            trailing: bil
                ? CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 12,
                    child: Text(
                      "$bildir",
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  )
                : const SizedBox(
                    width: 1,
                  ),
            onTap: () {
              Navigate.NavigatePage(
                  false,
                  GroupPage(
                    gname: title,
                    desc: desc,
                    dsc: dsc,
                    img: img,
                    url: url,
                    gid: widget.gid,
                  ),
                  context);
            },
            subtitle: dsc
                ? Text(
                    desc,
                    style: const TextStyle(color: Colors.grey),
                  )
                : const Text(
                    "it's a Discussion Group",
                    style: TextStyle(color: Colors.grey),
                  ),
            title: Text(
              title,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            leading: img
                ? CircleAvatar(
                    backgroundImage: NetworkImage(url),
                  )
                : const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.groups,
                      color: Colors.white,
                    ),
                  ),
          );
  }
}
