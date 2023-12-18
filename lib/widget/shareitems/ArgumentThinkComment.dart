import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';
import 'package:malazgirt/Managment/service/work/TimeEqualer.dart';
import 'package:malazgirt/Managment/service/work/service.dart';

class ArgumentThinkComment extends StatefulWidget {
  final String docid;
  final String username;
  final String userid;
  final String text;
  final Timestamp dateTime;
  final List stars;
  final String maindocid;
  const ArgumentThinkComment(
      {Key? key,
      required this.docid,
      required this.maindocid,
      required this.stars,
      required this.dateTime,
      required this.text,
      required this.userid,
      required this.username})
      : super(key: key);

  @override
  State<ArgumentThinkComment> createState() => _ArgumentThinkCommentState();
}

class _ArgumentThinkCommentState extends State<ArgumentThinkComment> {
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
      if (value != null) {
        setState(() {
          myid = value;
        });
        bool data = await _service.checkcommentthink(
            widget.maindocid, widget.docid, value);
        setState(() {
          star = data;
        });
      }
    });

    DocumentSnapshot documentSnapshot =
        await _service.getuserdata(widget.userid);
    setState(() {
      time = _tservice.TimeToString(widget.dateTime);
    });
    if (documentSnapshot["pp"] == "") {
      setState(() {
        img = false;
      });
    } else {
      setState(() {
        img = true;
        avatar = documentSnapshot["pp"];
      });
    }

    setState(() {
      load = false;
    });
  }
  bekle() async{
    if (myid != "") {
      print("w00");
      bool data = await _service.checkcommentthink(
            widget.maindocid, widget.docid, myid);
        setState(() {
          star = data;
        });
    }
  }
  String myid = ""; 
  bool star = false;
  String time = "";
  final _tservice = TimerFunc();
  final _service = FireService();
  bool load = true;
  String avatar = "";
  bool img = false;
  @override
  Widget build(BuildContext context) {
    return load
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                trailing: Text(
                  time,
                  style: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                title: Text(
                  widget.username,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 18),
                ),
                leading: img
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
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    widget.text,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 17,
                  ),
                  GestureDetector(
                    onTap: () async{
                      await _service.addcommentstarla(widget.maindocid, widget.docid, myid);
                      await bekle();
                    },
                    child: star
                        ? const Icon(
                            Icons.star,
                            color: Colors.yellow,
                          )
                        : const Icon(
                            Icons.star_outline,
                            color: Colors.black,
                          ),
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 17,
                  ),
                  Text(
                    "${widget.stars.length} user starred this think",
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                height: 0.2,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          );
  }
}
