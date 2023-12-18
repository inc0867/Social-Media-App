import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/Navigator/Navigation.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';
import 'package:malazgirt/Managment/service/work/service.dart';
import 'package:malazgirt/Pages/Messages.dart';
import 'package:malazgirt/widget/Inbox/InBoxGTile.dart';

class InBox extends StatefulWidget {
  const InBox({super.key});

  @override
  State<InBox> createState() => _InBoxState();
}

class _InBoxState extends State<InBox> {


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
      DocumentSnapshot documentSnapshot = await _service.getuserdata(value!);
      setState(() {
        ids = documentSnapshot["box"];
      });
    });

    setState(() {
      load = false;
    });
  }
  List ids = [];
  final _service = FireService();
  bool load = true;
  @override
  Widget build(BuildContext context) {
    return load
        ? const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          )
        : Scaffold(
          body: ListView.builder(
            itemCount: ids.length,
            itemBuilder: (context, index) {
            return InBoxGtile(gid: ids[index]);
          },),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: GestureDetector(onTap: () {
                Navigate.NavigatePage(false, const Messages(), context);
              }, child: const Icon(Icons.arrow_back_ios , size: 30 , color: Colors.black,)),
            ),
        );
  }
}
