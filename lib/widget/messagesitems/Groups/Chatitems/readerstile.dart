import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/service/work/service.dart';

class ReadersTile extends StatefulWidget {
  final String uid;
  const ReadersTile({Key? key, required this.uid}) : super(key: key);

  @override
  State<ReadersTile> createState() => _ReadersTileState();
}

class _ReadersTileState extends State<ReadersTile> {
  @override
  void initState() {
    doit();
    super.initState();
  }

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
        avatar = "";
        avat = false;
      });
    } else {
      setState(() {
        avatar = documentSnapshot["pp"];
        avat = true;
      });
    }

    if (documentSnapshot["desc"] == "") {
      setState(() {
        desc = false;
        descs = "";
      });
    } else {
      setState(() {
        descs = documentSnapshot["desc"];
        desc = true;
      });
    }

    setState(() {
      load = false;
    });
  }

  String username = "";
  String avatar = "";
  bool avat = false;
  bool desc = false;
  String descs = "";
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
            subtitle: Text(
              desc ? descs : "User of Disscussions",
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            title: Text(
              username,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            leading: avat
                ? CircleAvatar(
                    backgroundImage: NetworkImage(avatar),
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
