import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';
import 'package:malazgirt/Managment/service/work/service.dart';

class InBoxGtile extends StatefulWidget {
  final String gid;
  const InBoxGtile({Key? key, required this.gid}) : super(key: key);

  @override
  State<InBoxGtile> createState() => _InBoxGtileState();
}

class _InBoxGtileState extends State<InBoxGtile> {
  @override
  void initState() {
    doit();
    super.initState();
  }

  final _service = FireService();
  bool load = true;
  doit() async {
    setState(() {
      load = true;
    });

    DocumentSnapshot documentSnapshot = await _service.getgroupdata(widget.gid);
    setState(() {
      gname = documentSnapshot["gname"];
    });
    if (documentSnapshot["url"] == "") {
      setState(() {
        res = false;
      });
    } else {
      setState(() {
        resim = documentSnapshot["url"];
        res = true;
      });
    }

    await UserPrefs.getuserid().then((value) {
      if (value != null) {
        setState(() {
          userid = value;
        });
      }
    });

    setState(() {
      load = false;
    });
  }

  String userid = "";
  bool res = false;
  String gname = "";
  String resim = "";
  @override
  Widget build(BuildContext context) {
    return load
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          )
        : ListTile(
            trailing: Container(
              width: 150,
              child: Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            _service.jorDtoG(widget.gid, userid, true);
                            doit();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: const Text(
                            "Join",
                            style: TextStyle(color: Colors.white),
                          ))),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            _service.jorDtoG(widget.gid, userid, false);
                            doit();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: const Text(
                            "Decline",
                            style: TextStyle(color: Colors.white),
                          ))),
                ],
              ),
            ),
            subtitle: const Text(
              "Invated to Group",
              style: TextStyle(color: Colors.grey),
            ),
            title: Text(
              gname,
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
            leading: res
                ? CircleAvatar(
                    backgroundImage: NetworkImage(gname),
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
