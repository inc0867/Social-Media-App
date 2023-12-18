import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/Navigator/Navigation.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';
import 'package:malazgirt/Managment/service/work/TimeEqualer.dart';
import 'package:malazgirt/Managment/service/work/service.dart';
import 'package:malazgirt/widget/shareitems/ArgumentThink.dart';

class ArgueShareSmall extends StatefulWidget {
  final bool img;
  final bool txt;
  final String thinkid;
  final String username;
  final String userid;
  final List stars;
  final List thinks;
  final String text;
  final String purl;
  final int starc;
  final Timestamp time;
  final int thinkc;
  const ArgueShareSmall({
    Key? key,
    required this.time,
    required this.thinkid,
    required this.starc,
    required this.thinkc,
    required this.img,
    required this.purl,
    required this.stars,
    required this.text,
    required this.thinks,
    required this.txt,
    required this.username,
    required this.userid,
  }) : super(key: key);

  @override
  State<ArgueShareSmall> createState() => _ArgueShareSmallState();
}

class _ArgueShareSmallState extends State<ArgueShareSmall> {
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
        await _service.getuserdata(widget.userid);
    setState(() {
      pp = documentSnapshot["pp"];
    });
    if (documentSnapshot["pp"] == "") {
      setState(() {
        goster = false;
      });
    } else {
      setState(() {
        goster = true;
      });
    }
    await UserPrefs.getuserid().then((value) async {
      if (value != null) {
        setState(() {
          userid = value;
        });
        bool st = await _service.starli(value, widget.thinkid);
        setState(() {
          star = st;
        });
      }
    });
    setState(() {
      timer = _tservice.TimeToString(widget.time);
    });
    setState(() {
      stars = widget.starc;
    });
    setState(() {
      load = false;
    });
  }

  bekle() async {
    await UserPrefs.getuserid().then((value) async {
      if (value != null) {
        setState(() {
          userid = value;
        });

        bool st = await _service.starli(value, widget.thinkid);
        DocumentSnapshot documentSnapshot =
            await _service.getthinkdata(widget.thinkid);
        List a = documentSnapshot["stars"];
        setState(() {
          timer = _tservice.TimeToString(widget.time);
        });
        setState(() {
          star = st;
          stars = a.length;
        });
      }
    });
  }

  final _tservice = TimerFunc();
  String timer = "";
  int stars = 0;
  String userid = "";
  bool star = false;
  bool goster = false;
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
        : Column(
            children: [
              ListTile(
                trailing: Text(
                  timer,
                  style: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                title: Text(
                  widget.username,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 17),
                ),
                leading: goster
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
              ),
              const SizedBox(
                height: 10,
              ),
              widget.img
                  ? Image(image: NetworkImage(widget.purl))
                  : Container(),
              widget.img
                  ? const SizedBox(
                      height: 10,
                    )
                  : Container(),
              widget.txt
                  ? Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          widget.text,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  : Container(),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                      onTap: () async {
                        await _service.starfunction(userid, widget.thinkid);
                        await bekle();
                      },
                      child: star
                          ? const Icon(
                              size: 30,
                              Icons.star,
                              color: Colors.yellow,
                            )
                          : const Icon(
                              size: 30,
                              Icons.star_outline,
                              color: Colors.black,
                            )),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigate.NavigatePage(
                            false,
                            ArgumentThink(
                                userid: widget.userid,
                                documentid: widget.thinkid,
                                img: widget.img,
                                photourl: widget.purl,
                                text: widget.text,
                                timer: timer,
                                username: widget.username),
                            context);
                      },
                      child: const Icon(
                        size: 26,
                        Icons.messenger_outline_rounded,
                        color: Colors.black,
                      )),
                  Expanded(child: Container()),
                  PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(child: Text("Report")),
                        const PopupMenuItem(child: Text("I dont wanna see")),
                      ];
                    },
                  )
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    "$stars stars , ${widget.thinkc} think",
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 0.2,
                color: Colors.grey,
              ),
            ],
          );
  }
}
