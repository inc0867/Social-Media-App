import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';
import 'package:malazgirt/Managment/service/work/service.dart';
import 'package:malazgirt/widget/BottomBar.dart';
import 'package:malazgirt/widget/searchitems/FriendsTile.dart';
import 'package:malazgirt/widget/searchitems/GroupSearchTile.dart';
import 'package:malazgirt/widget/shareitems/Argument.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  void initState() {
    doit();
    super.initState();
  }

  void doit() async {
    setState(() {
      load = true;
    });
    await UserPrefs.getuserid().then((value) async {
      if (value != null) {
        DocumentSnapshot documentSnapshot = await _service.getuserdata(value);
        if (documentSnapshot["pp"] != "") {
          setState(() {
            img = true;
            avater = documentSnapshot["pp"];
          });
        } else {
          setState(() {
            img = false;
          });
        }
      }
    });
    setState(() {
      load = false;
    });
  }

  Stream<QuerySnapshot>? stream;
  String search = "Please Select a Search Type";
  String s = "Select";
  IconData iconData = Icons.search;
  final _service = FireService();
  bool load = true;
  TextEditingController textEditingController = TextEditingController();
  String avater = "";
  bool ara = false;
  bool img = false;
  bool init = false;
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
            body: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: GestureDetector(
                              onTap: () {
                                onsearch();
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20)),
                                child: const Icon(
                                  Icons.search,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          hintText: search,
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    PopupMenuButton(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.black),
                              left: BorderSide(color: Colors.black),
                              right: BorderSide(color: Colors.black),
                              top: BorderSide(color: Colors.black)),
                        ),
                        child: Row(
                          children: [
                            Icon(iconData),
                            Text(
                              s,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      onSelected: (value) {
                        if (value == "F") {
                          setState(() {
                            iconData = Icons.person;
                            search = "Search for a Friends";
                            s = "Friends";
                            ara = false;
                          });
                        } else if (value == "G") {
                          setState(() {
                            iconData = Icons.groups;
                            search = "Search for a Groups";
                            s = "Groups";
                            ara = false;
                          });
                        } else if (value == "P") {
                          setState(() {
                            iconData = Icons.document_scanner;
                            search = "Search for a Posts";
                            s = "Posts";
                            ara = false;
                          });
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                              value: "F",
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    " Friends",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              )),
                          const PopupMenuItem(
                              value: "G",
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.groups,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    " Groups",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              )),
                          const PopupMenuItem(
                              value: "P",
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.document_scanner,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    " Posts",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              )),
                        ];
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                ara
                    ? Expanded(child: searhcstream())
                    : Expanded(child: Container()),
              ],
            ),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              actions: [
                const SizedBox(
                  width: 5,
                ),
                img
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(avater),
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                const SizedBox(
                  width: 5,
                ),
              ],
              title: const Text(
                "Search",
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
            ),
            bottomNavigationBar: const BottomBar(),
          );
  }

  onsearch() async {
    if (s == "Friends") {
      setState(() {
        ara = false;
      });
      Stream<QuerySnapshot> querySnapshot =
          await _service.search("F", textEditingController.text);

      setState(() {
        stream = querySnapshot;
        ara = true;
      });
      setState(() {
        init = false;
      });
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        init = true;
      });
    }
    if (s == "Posts") {
      setState(() {
        ara = false;
      });
      Stream<QuerySnapshot> querySnapshot =
          await _service.search("P", textEditingController.text);
      print("$querySnapshot");

      setState(() {
        stream = querySnapshot;
        ara = true;
      });
      setState(() {
        init = false;
      });
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        init = true;
      });
    }
    if (s == "Groups") {
      setState(() {
        ara = false;
      });
      Stream<QuerySnapshot> querySnapshot =
          await _service.search("G", textEditingController.text);
      print("$querySnapshot");

      setState(() {
        stream = querySnapshot;
        ara = true;
      });
      setState(() {
        init = false;
      });
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        init = true;
      });
    }
  }

  searhcstream() {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  if (s == "Friends") {
                    return init
                        ? FriendsTile(
                            avatar: snapshot.data!.docs[index]["pp"],
                            desc: snapshot.data!.docs[index]["desc"],
                            followers: snapshot.data!.docs[index]["followers"],
                            userid: snapshot.data!.docs[index].id,
                            username: snapshot.data!.docs[index]["username"])
                        : const Center(
                            child: CircularProgressIndicator(
                            color: Colors.black,
                          ));
                  } else if (s == "Posts") {
                    return init
                        ? ArgueShareSmall(
                            time: snapshot.data!.docs[index]["time"],
                            starc: snapshot.data!.docs.length,
                            thinkc: 0,
                            img: snapshot.data!.docs[index]["img"],
                            purl: snapshot.data!.docs[index]["url"],
                            stars: snapshot.data!.docs[index]["stars"],
                            text: snapshot.data!.docs[index]["text"],
                            thinks: const [],
                            txt: true,
                            username: snapshot.data!.docs[index]["username"],
                            userid: snapshot.data!.docs[index]["userid"],
                            thinkid: snapshot.data!.docs[index].id,
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                            color: Colors.black,
                          ));
                  } else {
                    return GroupSearchTile(
                        reqs: snapshot.data!.docs[index]["reqs"],
                        davetle: snapshot.data!.docs[index]["katsek"],
                        desc: snapshot.data!.docs[index]["gdesc"],
                        gid: snapshot.data!.docs[index].id,
                        gname: snapshot.data!.docs[index]["gname"],
                        members: snapshot.data!.docs[index]["members"],
                        url: snapshot.data!.docs[index]["url"]);
                  }
                },
              );
            } else {
              return const Center(
                child: Text(
                  "No Result found",
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              );
            }
          } else {
            return const Center(
              child: Text(
                "No Result found",
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
            );
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
