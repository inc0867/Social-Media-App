import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/Navigator/Navigation.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';
import 'package:malazgirt/Managment/service/work/Notification/FirreBaseMessaging.dart';
import 'package:malazgirt/Managment/service/work/service.dart';
import 'package:malazgirt/Pages/CreatePost.dart';
import 'package:malazgirt/Pages/Register.dart';
import 'package:malazgirt/Pages/shorts/CreateShorts.dart';
import 'package:malazgirt/Pages/shorts/MainShort.dart';
import 'package:malazgirt/widget/BottomBar.dart';
import 'package:malazgirt/widget/shareitems/Argument.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    doit();
    super.initState();
  }

  doit() async {
    setState(() {
      load = true;
    });
    final connectResult = await Connectivity().checkConnectivity();

    if (connectResult == ConnectivityResult.none) {
      setState(() {
        connect = true;
      });
    } else {
      if (connectResult == ConnectivityResult.mobile ||
          connectResult == ConnectivityResult.wifi) {
        setState(() {
          connect = false;
        });
      } else {
        setState(() {
          connect = true;
        });
      }
    }

    await UserPrefs.getuserid().then((value) async {
      await _nservice.setToken(value!);
    });
    await UserPrefs.getuserid().then(
      (value) async {
        if (value != null) {
          List<DocumentSnapshot> data = await _service.getsharebyhobbys(value);
          setState(() {
            datas = data;
          });
          DocumentSnapshot documentSnapshot = await _service.getuserdata(value);
          setState(() {
            url = documentSnapshot["pp"];
            if (documentSnapshot["pp"] == "") {
              setState(() {
                img = true;
              });
            } else {
              setState(() {
                img = false;
              });
            }
          });
        }
      },
    );
    setState(() {
      load = false;
    });
  }

  final _nservice = FirebaseNotificatinService();
  bool img = true;
  String url = "";
  final _service = FireService();
  List<DocumentSnapshot> datas = [];
  bool load = true;
  bool loaw = false;
  bool connect = false;
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
        : connect
            ? const Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Text(
                    "Plase Connect to Internet",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
              )
            : Scaffold(
                body: loaw
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )
                    : RefreshIndicator(
                        color: Colors.black,
                        onRefresh: () async {
                          print("a");
                          setState(() {
                            loaw = true;
                          });
                          await UserPrefs.getuserid().then((value) async {
                            if (value != null) {
                              List<DocumentSnapshot> data =
                                  await _service.getsharebyhobbys(value);
                              setState(() {
                                datas = data;
                              });
                            }
                          });
                          setState(() {
                            loaw = false;
                          });
                        },
                        child: ListView.builder(
                          itemCount: datas.length,
                          itemBuilder: (context, index) {
                            List stars = datas[index]["stars"];
                            return ArgueShareSmall(
                              time: datas[index]["time"],
                              starc: stars.length,
                              thinkc: 0,
                              img: datas[index]["img"],
                              purl: datas[index]["url"],
                              stars: datas[index]["stars"],
                              text: datas[index]["text"],
                              thinks: const [],
                              txt: true,
                              username: datas[index]["username"],
                              userid: datas[index]["userid"],
                              thinkid: datas[index].id,
                            );
                          },
                        ),
                      ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigate.NavigatePage(true, const SharePost(), context);
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                bottomNavigationBar: const BottomBar(),
                appBar: AppBar(
                  title: const Text(
                    "Discussions",
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        Navigate.NavigatePage(
                            false, const MainShort(), context);
                      },
                      child: const Icon(
                        Icons.video_call,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigate.NavigatePage(
                            false, const CreateaShort(), context);
                      },
                      child: const Icon(
                        Icons.video_call_rounded,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        UserPrefs.saveuserid("");
                        UserPrefs.saveusername("");
                        UserPrefs.saveuserlogged(false);
                        Navigate.NavigatePage(false, const Register(), context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: img
                            ? const CircleAvatar(
                                backgroundColor: Colors.black,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(url),
                              ),
                      ),
                    ),
                  ],
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              );
  }
}
