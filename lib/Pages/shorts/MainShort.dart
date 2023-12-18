import 'package:flutter/material.dart';
import 'package:malazgirt/Managment/Navigator/Navigation.dart';
import 'package:malazgirt/Pages/Home.dart';
import 'package:video_player/video_player.dart';

class MainShort extends StatefulWidget {
  const MainShort({super.key});

  @override
  State<MainShort> createState() => _MainShortState();
}

class _MainShortState extends State<MainShort> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
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

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  double videosize = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _videoPlayerController.value.isInitialized
            ? GestureDetector(
                onVerticalDragEnd: (details) {
                  print(details);
                  if (details.primaryVelocity! < 0) {
                    print("yukari");
                  } else if (details.primaryVelocity! > 0) {
                    print("asagi");
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Container(
                      color: Colors.black,
                    )),
                    GestureDetector(
                      onTap: () {
                        if (_videoPlayerController.value.isPlaying == true) {
                          _videoPlayerController.pause();
                        } else {
                          _videoPlayerController.play();
                        }
                      },
                      child: AspectRatio(
                        aspectRatio: _videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(_videoPlayerController),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 10,
                          width: videosize,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    Expanded(
                        child: Container(
                      color: Colors.black,
                    )),
                    Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () {},
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_outline,
                                color: Colors.white,
                                size: 30,
                              ),
                              Text(
                                "0",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(child: Container()),
                                          const Text(
                                            "Comments",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Expanded(child: Container()),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Icon(
                                                Icons.arrow_downward,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.chat,
                                color: Colors.white,
                                size: 30,
                              ),
                              Text(
                                "0",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {},
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.share,
                                color: Colors.white,
                                size: 30,
                              ),
                              Text(
                                "Share",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {},
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.more_vert,
                                color: Colors.white,
                                size: 30,
                              ),
                              Text(
                                "More",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            'The first shorts video',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              )
            : const CircularProgressIndicator(
                color: Colors.white,
              ),
      ),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigate.NavigatePage(false, const Home(), context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
    );
  }
}
