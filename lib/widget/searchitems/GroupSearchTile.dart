import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/service/auth/UserPreferences.dart';
import 'package:malazgirt/Managment/service/work/service.dart';

class GroupSearchTile extends StatefulWidget {
  final String gid;
  final List reqs;
  final String gname;
  final List members;
  final bool davetle;
  final String desc;
  final String url;
  const GroupSearchTile({
    Key? key,
    required this.reqs,
    required this.davetle,
    required this.desc,
    required this.gid,
    required this.gname,
    required this.members,
    required this.url,
  }) : super(key: key);

  @override
  State<GroupSearchTile> createState() => _GroupSearchTileState();
}

class _GroupSearchTileState extends State<GroupSearchTile> {
  @override
  void initState() {
    doit();
    super.initState();
  }

  doit() async {
    setState(() {
      load = true;
    });

    await UserPrefs.getuserid().then((value) {
      if (value != null) {
        setState(() {
          userid = value;
        });
      }
    });

    if (widget.url == "") {
      setState(() {
        img = false;
      });
    } else {
      setState(() {
        img = true;
      });
    }

    if (widget.desc == "") {
      setState(() {
        desc = false;
      });
    } else {
      setState(() {
        desc = true;
      });
    }

    setState(() {
      load = false;
    });
  }

  String userid = "";
  bool load = true;
  bool img = false;
  bool desc = false;
  final _service = FireService();
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
            subtitle: desc
                ? Text(
                    widget.desc,
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w500),
                  )
                : const Text("Group of Discussions",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w500)),
            title: Text(
              widget.gname,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            leading: img
                ? CircleAvatar(
                    backgroundImage: NetworkImage(widget.url),
                  )
                : const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.groups,
                      color: Colors.white,
                    ),
                  ),
          );
  }

  buttons() {
    if (widget.davetle == true) {
      if (widget.members.contains(userid)) {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () {},
            child: const Text(
              "Already Member",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ));
      } else {
        if (widget.reqs.contains(userid)) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () async {
            },
            child: const Text(
              "Already Sended",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ));
        }else {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () async {
              await _service.sendajoinequest(widget.gid, userid);
            },
            child: const Text(
              "Send a Requests",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ));
        }
      }
    } else {
      if (widget.members.contains(userid)) {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () {},
            child: const Text(
              "Already Member",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ));
      } else {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () async {
              await _service.joinGroup(userid, widget.gid);
            },
            child: const Text(
              "Join",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ));
      }
    }
  }
}
