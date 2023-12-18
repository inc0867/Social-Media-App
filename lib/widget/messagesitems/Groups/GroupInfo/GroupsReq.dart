import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/Navigator/Navigation.dart';
import 'package:malazgirt/Managment/service/work/service.dart';
import 'package:malazgirt/widget/messagesitems/Groups/GroupInfo/Greqinfo.dart';
import 'package:malazgirt/widget/messagesitems/Groups/GroupInfo/GroupInfoPage.dart';

class GREQ extends StatefulWidget {
  final String gid;
  const GREQ({Key? key, required this.gid}) : super(key: key);

  @override
  State<GREQ> createState() => _GREQState();
}

class _GREQState extends State<GREQ> {
  @override
  void initState() {
    doit();
    super.initState();
  }

  doit() async {
    setState(() {
      load = true;
    });
    Stream<DocumentSnapshot> stream = _service.getgstream(widget.gid);
    setState(() {
      streams = stream;
    });
    setState(() {
      load = false;
    });
  }

  bool load = true;
  Stream<DocumentSnapshot>? streams;
  final _service = FireService();
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
          body: stream(),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: GestureDetector(
                onTap: () {
                  Navigate.NavigatePage(false, GroupInfoPage(gid: widget.gid), context);
                },
                child: const Icon(Icons.arrow_back_ios , color: Colors.black , size: 30,),
              ),
            ),
        );
  }
  stream() {
    return StreamBuilder(
      stream: streams,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            List a = snapshot.data!["reqs"];
            if (a.isNotEmpty) {
              return ListView.builder(
                itemCount: a.length,
                itemBuilder: (context, index) {
                  return GreqUser(gid: widget.gid, uid: snapshot.data!["reqs"][index]);
              },);
            }else {
              return const Center(child: Text("No User send a Requests" , style: TextStyle(color: Colors.grey , fontSize: 20),),);
            }
          }else {
            return Container();
          }
        } else {
          return const Center(child: CircularProgressIndicator(color: Colors.black,),);
        }
    },);

  }
}
