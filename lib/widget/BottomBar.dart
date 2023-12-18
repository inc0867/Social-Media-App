import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/Navigator/Navigation.dart';
import 'package:malazgirt/Pages/Home.dart';
import 'package:malazgirt/Pages/Messages.dart';
import 'package:malazgirt/Pages/Profile.dart';
import 'package:malazgirt/Pages/Search.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 12,
      shape: const CircularNotchedRectangle(),
      elevation: 30,
      color: Colors.white /*const Color.fromRGBO(235, 234, 243, 5)*/,
      child: Row(
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () {
              Navigate.NavigatePage(false, const Home(), context);
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.home_outlined,
                  size: 30,
                ),
                Text(
                  "Home",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          )),
          Expanded(
              child: GestureDetector(
            onTap: () {
              Navigate.NavigatePage(false, const Search(), context);
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search,
                  size: 30,
                ),
                Text(
                  "Search",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          )),
          Expanded(
              child: GestureDetector(
            onTap: () {
              Navigate.NavigatePage(false, const Messages(), context);
            },
            child: const Column(

              mainAxisSize: MainAxisSize.min,
              children: [
                
                Icon(
                  Icons.message_outlined,
                  size: 30,
                ),
                Text(
                  "Messages",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          )),
          Expanded(
              child: GestureDetector(
            onTap: () {
              Navigate.NavigatePage(false, const Profile(), context);
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person_2_outlined,
                  size: 30,
                ),
                Text(
                  "Profile",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          )),
          const SizedBox(height: 75,),
        ],
      ),
    );
  }
}
