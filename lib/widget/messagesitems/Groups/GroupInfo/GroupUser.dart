import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/Navigator/Navigation.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';
import 'package:malazgirt/Managment/service/work/service.dart';
import 'package:malazgirt/widget/messagesitems/Groups/GroupInfo/GroupInfoPage.dart';
import 'package:malazgirt/widget/messagesitems/Groups/GroupInfo/InvateToGroup.dart';

class UseraddPage extends StatefulWidget {
  final String gid;
  const UseraddPage({Key? key, required this.gid}) : super(key: key);

  @override
  State<UseraddPage> createState() => _UseraddPageState();
}

class _UseraddPageState extends State<UseraddPage> {
  doit() async {
    setState(() {
      load = true;
    });

    UserPrefs.getuserid().then((value) async {
      Stream<DocumentSnapshot> stream = await _service.getuserstream(value!);

      setState(() {
        streams = stream;
      });
    });

    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    doit();
    super.initState();
  }

  final _service = FireService();
  Stream<DocumentSnapshot>? streams;
  bool load = true;
  @override
  Widget build(BuildContext context) {
    return load
        ? const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            )),
          )
        : Scaffold(
            body: stream(),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: GestureDetector(
                onTap: () {
                  Navigate.NavigatePage(
                      false, GroupInfoPage(gid: widget.gid), context);
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
            backgroundColor: Colors.white,
          );
  }

  

  stream() {
    return StreamBuilder(
      stream: streams,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            List a = snapshot.data!["follows"];

            if (a.isNotEmpty) {
              return ListView.builder(
                itemCount: a.length,
                itemBuilder: (context, index) {
                  return Userinvate(
                      gid: widget.gid,
                      userid: snapshot.data!["follows"][index]);
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
