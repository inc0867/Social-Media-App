import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/service/work/service.dart';
import 'package:malazgirt/widget/messagesitems/Groups/Chatitems/readerstile.dart';

class Readers extends StatefulWidget {
  final String msgid;
  final String gid;
  const Readers({Key? key, required this.msgid, required this.gid})
      : super(key: key);

  @override
  State<Readers> createState() => _ReadersState();
}

class _ReadersState extends State<Readers> {
  @override
  void initState() {
    doit();
    super.initState();
  }

  doit() async {
    setState(() {
      load = true;
    });
    DocumentSnapshot documentSnapshot =
        await _service.getmsgdata(widget.msgid, widget.gid);
    setState(() {
      readers = documentSnapshot["readers"];
    });
    setState(() {
      load = false;
    });
  }

  List readers = [];
  final _service = FireService();
  bool load = true;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: load
          ? const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              ],
            )
          : Container(
            height: 200,
            width: 100,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: readers.length,
              itemBuilder: (context, index) {
                return ReadersTile(uid: readers[index]);
              },
            ),
          ),
      title: const Text(
        "Readers ",
        style: TextStyle(
            color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }
}
