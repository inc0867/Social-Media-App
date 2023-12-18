import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';
import 'package:malazgirt/Managment/service/work/service.dart';

class FriendsTile extends StatefulWidget {
  final String username;
  final String avatar;
  final String desc;
  final String userid;
  final List followers;
  const FriendsTile(
      {Key? key,
      required this.avatar,
      required this.desc,
      required this.followers,
      required this.userid,
      required this.username})
      : super(key: key);

  @override
  State<FriendsTile> createState() => _FriendsTileState();
}

class _FriendsTileState extends State<FriendsTile> {
  @override
  void initState() {
    doit();
    super.initState();
  }
  void doit() async{
    setState(() {
      load = true;
    });
    if (widget.avatar == "") {
      setState(() {
        img = false;
      });
    } else {
      print("object");
      setState(() {
        img = true;
      });
    }
    if (widget.desc == "") {
      setState(() {
        des = false;
      });
    } else {
      setState(() {
        des = true;
      });
    }
    setState(() {
      load = false;
    });
    await UserPrefs.getuserid().then((value) {
      if (value != null) {
        setState(() {
          userid = value;
        });
      }
    });
  }
  bool load = true;
  String userid = "";
  final _service = FireService();
  bool img = false;
  bool des = false;
  @override
  Widget build(BuildContext context) {
    return load
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          )
        : ListTile(
            subtitle: des
                ? Text(
                    widget.desc,
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w500),
                  )
                : const Text(
                    "User of Discussions",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
            title: Text(
              widget.username,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 19),
            ),
            trailing: buttoncheck(),
            leading: img
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
          );
  }

  buttoncheck() {
    if (widget.followers.contains(userid)) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          onPressed: () async{
            await _service.unfollow(userid, widget.userid);
          },
          child: const Text(
            "Unfollow",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ));
    } else if (widget.userid == userid) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          onPressed: () {
            
          },
          child: const Text(
            "It's you",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ));
    } else {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          onPressed: () async{
            await _service.follow(userid, widget.userid);
          },
          child: const Text(
            "Follow",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ));
    }
  }
}
