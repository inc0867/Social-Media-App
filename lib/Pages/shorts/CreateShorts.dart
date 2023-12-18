import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/Navigator/Navigation.dart';
import 'package:malazgirt/Pages/Home.dart';
import 'package:video_player/video_player.dart';

class CreateaShort extends StatefulWidget {
  const CreateaShort({super.key});

  @override
  State<CreateaShort> createState() => _CreateaShortState();
}

class _CreateaShortState extends State<CreateaShort> {
  TextEditingController controller = TextEditingController();

  late VideoPlayerController _videoPlayerController;

  initVideo() {
    setState(() {
      load = true;
    });
    _videoPlayerController = VideoPlayerController.file(file!)
      ..initialize().then((_) {
        setState(() {
          _videoPlayerController.play();
        });

        _videoPlayerController.addListener(() {
          int video_zamani = _videoPlayerController.value.duration.inSeconds;

          double cubuk = (MediaQuery.of(context).size.width / video_zamani) *
              _videoPlayerController.value.position.inSeconds;

          setState(() {
            videosize = cubuk;
          });

          if (_videoPlayerController.value.position ==
              _videoPlayerController.value.duration) {
            setState(() {
              videosize = MediaQuery.of(context).size.width;
            });
          }

          if (_videoPlayerController.value.position >=
              _videoPlayerController.value.duration) {
            _videoPlayerController.seekTo(const Duration(seconds: 0));
            setState(() {
              //videosize = 0;
            });
            _videoPlayerController.play();
          }
        });
      });
    setState(() {
      load = false;
    });
  }

  bool load = true;
  double videosize = 0;
  bool isselected = false;
  File? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            isselected
                ? load
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )
                    : Column(
                        children: [
                          AspectRatio(
                            aspectRatio:
                                _videoPlayerController.value.aspectRatio,
                            child: VideoPlayer(_videoPlayerController),
                          ),
                          Row(
                            children: [
                              Container(
                                height: 10,
                                width: videosize,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ],
                      )
                : Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20)),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          onPressed: () async {
                            FilePickerResult? filePickerResult =
                                await FilePicker.platform.pickFiles();

                            if (filePickerResult != null) {
                              File filea =
                                  File(filePickerResult.files.single.path!);

                              setState(() {
                                file = filea;
                                isselected = true;
                              });
                              initVideo();
                            }
                          },
                          child: const Text(
                            "Select a Video",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Please Write a Video Title",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            Expanded(child: Container()),
            FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.black,
              child: const Icon(
                Icons.add,
                size: 30,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigate.NavigatePage(false, const Home(), context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Center(
          child: Text(
            "Create a Short Video",
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
