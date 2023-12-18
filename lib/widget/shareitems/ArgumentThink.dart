import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/Navigator/Navigation.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';
import 'package:malazgirt/Managment/service/work/service.dart';
import 'package:malazgirt/Pages/Home.dart';
import 'package:malazgirt/widget/shareitems/ArgumentThinkComment.dart';

class ArgumentThink extends StatefulWidget {
  final String userid;
  final bool img;
  final String timer;
  final String photourl;
  final String text;
  final String username;
  final String documentid;
  const ArgumentThink(
      {Key? key,
      required this.userid,
      required this.documentid,
      required this.img,
      required this.photourl,
      required this.text,
      required this.timer,
      required this.username})
      : super(key: key);

  @override
  State<ArgumentThink> createState() => _ArgumentThinkState();
}

class _ArgumentThinkState extends State<ArgumentThink> {
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
    if (documentSnapshot["pp"] == "") {
          setState(() {
            mainnav = false;
          });
        } else {
          setState(() {
            mainnav = true;
            photo = documentSnapshot["pp"];
          });
        }
    Stream<QuerySnapshot> streams =
        _service.getcommetsstream(widget.documentid);
    setState(() {
      stream = streams;
    });
    await UserPrefs.getuserid().then((value) async {
      if (value != null) {
        setState(() {
          usrid = value;
        });
        DocumentSnapshot datas = await _service.getuserdata(value);
        bool data = await _service.starli(value, widget.documentid);
        setState(() {
          star = data;
        });
        if (datas["pp"] == "") {
          setState(() {
            img = false;
          });
        } else {
          setState(() {
            img = true;
            avatarimg = datas["pp"];
          });
        }
      }
    });

    setState(() {
      load = false;
    });
    DocumentSnapshot doc = await _service.getthinkdata(widget.documentid);
    List a = doc["stars"];
    setState(() {
      yildiz = a.length;
    });
  }

  bekle() async {
    bool yeni = await _service.starli(usrid, widget.documentid);
    setState(() {
      star = yeni;
    });
    DocumentSnapshot documentSnapshot =
        await _service.getthinkdata(widget.documentid);
    List a = documentSnapshot["stars"];
    setState(() {
      yildiz = a.length;
    });
  }
  String photo = "";
  bool mainnav = false;
  int yildiz = 0;
  String usrid = "";
  bool star = false;
  TextEditingController controller = TextEditingController();
  Stream<QuerySnapshot>? stream;
  String avatarimg = "";
  bool img = false;
  final _service = FireService();
  bool load = true;
  @override
  Widget build(BuildContext context) {
    return load
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          )
        : Scaffold(
            body: Center(
                child: Column(
              children: [
                ListTile(
                  trailing: Text(
                    widget.timer,
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                  title: Text(
                    widget.username,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 23),
                  ),
                  leading: mainnav
                      ? CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(photo),
                        )
                      : const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                ),
                widget.img
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Image(image: NetworkImage(widget.photourl)),
                      )
                    : Container(),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      widget.text,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                        onTap: () async {
                          await _service.starfunction(usrid, widget.documentid);
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
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "         $yildiz",
                      style: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 0.2,
                  color: Colors.grey,
                ),
                Expanded(child: comments()),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                Container(
                  height: 80,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                if (controller.text != "") {
                                  UserPrefs.getusername().then((value) async {
                                    if (value != null) {
                                      await _service.SendaMessages(
                                          widget.documentid,
                                          usrid,
                                          value,
                                          controller.text);
                                      controller.clear();
                                    }
                                  });
                                }
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20)),
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            prefixIcon: const Icon(
                              Icons.edit,
                              color: Colors.grey,
                            ),
                            hintText: "Write your thoughts about this idea"),
                      ),
                    ),
                  ),
                )
              ],
            )),
            appBar: AppBar(
              actions: [
                img
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(avatarimg),
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                const SizedBox(
                  width: 10,
                ),
              ],
              leading: GestureDetector(
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 30,
                ),
                onTap: () {
                  Navigate.NavigatePage(false, const Home(), context);
                },
              ),
              title: const Text(
                "Discussions",
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
          );
  }

  comments() {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ArgumentThinkComment(
                      docid: snapshot.data!.docs[index].id,
                      maindocid: widget.documentid,
                      stars: snapshot.data!.docs[index]["stars"],
                      dateTime: snapshot.data!.docs[index]["time"],
                      text: snapshot.data!.docs[index]["text"],
                      userid: snapshot.data!.docs[index]["userid"],
                      username: snapshot.data!.docs[index]["username"]);
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
