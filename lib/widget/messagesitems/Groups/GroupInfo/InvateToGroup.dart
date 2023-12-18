import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/service/work/service.dart';

class Userinvate extends StatefulWidget {
  final String userid;
  final String gid;
  const Userinvate({Key? key, required this.gid, required this.userid})
      : super(key: key);

  @override
  State<Userinvate> createState() => _UserinvateState();
}

class _UserinvateState extends State<Userinvate> {
  doit() async {
    setState(() {
      load = true;
    });
    DocumentSnapshot documentSnapshot =
        await _service.getuserdata(widget.userid);
    DocumentSnapshot documentSnapshots =
        await _service.getgroupdata(widget.gid);
    setState(() {
      members = documentSnapshots["members"];
      reqs = documentSnapshots["reqs"];
    });
    setState(() {
      username = documentSnapshot["username"];
    });
    setState(() {
      box = documentSnapshot["box"];
    });
    if (documentSnapshot["pp"] == "") {
      setState(() {
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

  List members = [];
  List reqs = [];
  List box = [];
  bool res = false;
  String username = "";
  String pp = "";
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
          trailing: buttons(),
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

  buttons() {
    if (members.contains(widget.userid)) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          onPressed: () {},
          child: const Text(
            "Member of group",
            style: TextStyle(color: Colors.white),
          ));
    } else {
      if (reqs.contains(widget.userid)) {
        return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        onPressed: () {
        
      }, child: const Text("Pending", style: TextStyle(color: Colors.white),));
      }else {
        if (box.contains(widget.gid)) {
          return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        onPressed: () {
        
      }, child: const Text("Already sended" , style: TextStyle(color: Colors.white),));
        }else {
          return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        onPressed: () {
          _service.invategroup(widget.gid, widget.userid);
          doit();
      }, child: const Text("Invate to Group" , style: TextStyle(color: Colors.white),));
        }
      }
    }
  }
}
