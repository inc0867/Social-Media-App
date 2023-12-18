import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/service/work/service.dart';

class GreqUser extends StatefulWidget {
  final String uid;
  final String gid;
  const GreqUser({Key? key, required this.gid, required this.uid})
      : super(key: key);

  @override
  State<GreqUser> createState() => _GreqUserState();
}

class _GreqUserState extends State<GreqUser> {
  doit() async {
    setState(() {
      load = true;
    });

    DocumentSnapshot documentSnapshot = await _service.getuserdata(widget.uid);

    setState(() {
      username = documentSnapshot["username"];
    });
    if (documentSnapshot["pp"] == "") {
      setState(() {
        pp = "";
        res = false;
      });
    } else {
      setState(() {
        pp = documentSnapshot["pp"];
        res = true;
      });
    }

    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    doit();
    super.initState();
  }

  String username = "";
  String pp = "";
  bool res = false;
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
            trailing: Container(
                width: 200,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () async {
                            await _service.acceptORdecline(widget.gid, widget.uid, true);
                          },
                          child: const Text("Accept")),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () async {
                            await _service.acceptORdecline(widget.gid, widget.uid, false);
                          },
                          child: const Text("Reddet")),
                    ),
                  ],
                )),
            subtitle: const Text(
              "Can i join your group ?",
              style: TextStyle(color: Colors.grey),
            ),
            title: Text(
              username,
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
            leading: res
                ? CircleAvatar(
                    backgroundImage: NetworkImage(pp),
                  )
                : const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
          );
  }
}
