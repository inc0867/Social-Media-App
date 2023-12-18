import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';
import 'package:malazgirt/Managment/service/work/service.dart';
import 'package:malazgirt/widget/messagesitems/Groups/Chatitems/readers.dart';

class Msg extends StatefulWidget {
  final String msgid;
  final String avatar;
  final String gid;
  final bool img;
  final String msg;
  final bool read;
  final Timestamp time;
  final String userid;
  final bool res;
  final String username;
  final String url;
  final List readers;
  const Msg({
    Key? key,
    required this.readers,
    required this.url,
    required this.res,
    required this.msgid,
    required this.avatar,
    required this.gid,
    required this.img,
    required this.msg,
    required this.read,
    required this.time,
    required this.userid,
    required this.username,
  }) : super(key: key);

  @override
  State<Msg> createState() => _MsgState();
}

class _MsgState extends State<Msg> {
  @override
  void initState() {
    setState(() {
      load = true;
    });
    UserPrefs.getuserid().then((value) async {
      setState(() {
        userid = value!;
      });
      print(widget.readers);
      if (widget.readers.contains(value)) {
        print("object 2");
      } else {
        print("object");
        await _service.addreaders(value!, widget.gid, widget.msgid);
      }
      if (value != null) {
        if (value == widget.userid) {
          setState(() {
            ben = true;
          });
          if (widget.read == true) {
            setState(() {
              read = true;
            });
          } else {
            setState(() {
              read = false;
            });
          }
        } else {
          setState(() {
            ben = false;
          });

          if (widget.read == true) {
            setState(() {
              read = true;
            });
          } else {
            _service.read(widget.gid, widget.msgid);
            setState(() {
              read = true;
            });
          }
        }
      }
    });
    time = widget.time.toDate();

    setState(() {
      load = false;
    });
    super.initState();
  }

  final _service = FireService();
  bool read = false;
  DateTime? time;
  bool sil = false;
  String userid = "";
  bool load = true;
  bool ben = false;
  @override
  Widget build(BuildContext context) {
    return sil
        ? Container()
        : load
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : ben
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.img
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(widget.avatar),
                              )
                            : const CircleAvatar(
                                backgroundColor: Colors.black,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      " ${widget.username}",
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    Expanded(child: Container()),
                                    Text(
                                      " ${time!.day}.${time!.month}.${time!.year} ",
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                                widget.res
                                    ? Column(
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Image.network(widget.url),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                Container(
                                  child: Text(
                                    " ${widget.msg}",
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Container()),
                                    Text("${time!.hour}:${time!.minute}  "),
                                    read
                                        ? const Icon(
                                            Icons.check,
                                            size: 20,
                                            color: Colors.blue,
                                          )
                                        : const Icon(
                                            Icons.check,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                    PopupMenuButton(
                                      onSelected: (value) async {
                                        if (value == "D") {
                                          await _service.addtodeleteds(
                                              widget.msgid, userid);
                                          setState(() {
                                            sil = true;
                                          });
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Readers(
                                                  msgid: widget.msgid,
                                                  gid: widget.gid);
                                            },
                                          );
                                        }
                                      },
                                      child: const Icon(
                                        Icons.menu,
                                        color: Colors.grey,
                                      ),
                                      itemBuilder: (context) {
                                        return [
                                          const PopupMenuItem(
                                              value: "I",
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.info,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    " Information",
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  )
                                                ],
                                              )),
                                          const PopupMenuItem(
                                              value: "D",
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    " Delete",
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  )
                                                ],
                                              )),
                                        ];
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      " ${widget.username}",
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    Expanded(child: Container()),
                                    Text(
                                      " ${time!.day}.${time!.month}.${time!.year} ",
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                                Container(
                                  child: Text(
                                    " ${widget.msg}",
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Container()),
                                    Text("${time!.hour}:${time!.minute}  "),
                                    read
                                        ? const Icon(
                                            Icons.check,
                                            size: 20,
                                            color: Colors.blue,
                                          )
                                        : const Icon(
                                            Icons.check,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                          PopupMenuButton(
                                      onSelected: (value) async {
                                        if (value == "D") {
                                          await _service.addtodeleteds(
                                              widget.msgid, userid);
                                          setState(() {
                                            sil = true;
                                          });
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Readers(
                                                  msgid: widget.msgid,
                                                  gid: widget.gid);
                                            },
                                          );
                                        }
                                      },
                                      child: const Icon(
                                        Icons.menu,
                                        color: Colors.grey,
                                      ),
                                      itemBuilder: (context) {
                                        return [
                                          const PopupMenuItem(
                                              value: "I",
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.info,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    " Information",
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  )
                                                ],
                                              )),
                                          const PopupMenuItem(
                                              value: "D",
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    " Delete",
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  )
                                                ],
                                              )),
                                        ];
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        widget.img
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(widget.avatar),
                              )
                            : const CircleAvatar(
                                backgroundColor: Colors.black,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                      ],
                    ),
                  );
  }
}
