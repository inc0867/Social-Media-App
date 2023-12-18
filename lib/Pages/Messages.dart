import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/Navigator/Navigation.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';
import 'package:malazgirt/Managment/service/work/service.dart';
import 'package:malazgirt/widget/BottomBar.dart';
import 'package:malazgirt/widget/Inbox/InBox.dart';
import 'package:malazgirt/widget/messagesitems/Groups/Create_a_Groups.dart';
import 'package:malazgirt/widget/messagesitems/Groups/GroupTile.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  @override
  void initState() {
    doit();
    super.initState();
  }

  doit() async {
    setState(() {
      load = true;
    });
    _controller = TabController(initialIndex: 0, length: 2, vsync: this);
    UserPrefs.getuserid().then((value) async {
      if (value != null) {
        Stream<DocumentSnapshot> streams = await _service.getuserstream(value);
        setState(() {
          stream = streams;
        });
      }
    });
    setState(() {
      load = false;
    });
  }

  Stream<DocumentSnapshot>? stream;
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
        : Scaffold(
            body: TabBarView(controller: _controller, children: [
              groupstream(),
              Container(),
            ]),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                if (_controller.index == 0) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const CreateaGroup();
                    },
                  );
                }
              },
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.black,
              ),
            ),
            appBar: AppBar(
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigate.NavigatePage(false, const InBox(), context);
                  },
                  child: const Icon(
                    Icons.mail,
                    color: Colors.black,
                    size: 30,
                  ),
                )
              ],
              bottom: TabBar(
                  indicatorColor: Colors.black,
                  controller: _controller,
                  tabs: const [
                    Tab(
                        child: Text(
                      "Groups",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    )),
                    Tab(
                      child: Text(
                        "Personal",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ]),
              elevation: 0,
              backgroundColor: Colors.white,
              title: const Text(
                "Messages",
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
            ),
            bottomNavigationBar: const BottomBar(),
          );
  }

  groupstream() {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            List g = snapshot.data!["groups"];
            if (g.isNotEmpty) {
              return ListView.builder(
                itemCount: g.length,
                itemBuilder: (context, index) {
                  return GroupTile(gid: snapshot.data!["groups"][index]);
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
