import 'package:m19play/Reels/Models/video.dart';
import 'package:m19play/Reels/grid_videos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../reelsItem.dart';
import 'package:flutter/material.dart';

class ReelsController extends StatefulWidget {
  final int index;

  const ReelsController({Key? key, required this.index}) : super(key: key);
  @override
  State<ReelsController> createState() => _ReelsControllerState();
}

class _ReelsControllerState extends State<ReelsController> {
  int currentIndex = 0;
  int indx = 0;
  final List<Video> _video = [];
  bool isfromgrid = false;

  Future Video_info() async {
    if (widget.index != -1) {
      setState(() {
        currentIndex = widget.index;
        isfromgrid = true;
      });
    }

    final firestoreInstance = FirebaseFirestore.instance;
    firestoreInstance.collection("videos").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        setState(() {
          _video.add(Video.fromSnap(result));
          print(result.data());
        });
      });
    });
  }

  @override
  void initState() {
    Video_info();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     onPressed: () {
      //       //pause video when back button is pressed

      //       Navigator.pushAndRemoveUntil(context,
      //           MaterialPageRoute(builder: (context) {
      //         return const GridVideos();
      //       }), (route) => false);
      //     },
      //     icon: const Icon(
      //       Icons.grid_view_rounded,
      //       color: Colors.white,
      //     ),
      //   ),
      //   backgroundColor: Color.fromARGB(255, 7, 13, 33),
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Container(
      //           height: 30,
      //           width: 30,
      //           decoration: BoxDecoration(
      //             // border: Border.all(color: Colors.white),
      //             borderRadius: BorderRadius.circular(100),
      //             image: const DecorationImage(
      //                 image: AssetImage("assets/images/Logo.png"),
      //                 fit: BoxFit.cover,
      //                 scale: 1),
      //           )),
      //     ),
      //   ],
      // ),
      backgroundColor: const Color.fromARGB(255, 7, 13, 33),
      body: Stack(children: [
        _video.isNotEmpty
            ? PageView.builder(
                controller: PageController(initialPage: currentIndex),
                scrollDirection: Axis.vertical,
                itemCount: _video.length,
                onPageChanged: (index) {},
                itemBuilder: (ctx, index) {
                  return ReelsItem(video_: _video[index]);
                },
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
          child: Align(
            alignment: Alignment.topCenter,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      //pause video when back button is pressed

                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return const GridVideos();
                      }), (route) => false);
                    },
                    icon: const Icon(Icons.grid_view_rounded,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 20.0,
                            color: Colors.black54,
                            offset: Offset(1.0, 1.0),
                          ),
                        ]),
                  ),
                  Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            spreadRadius: 1,
                            blurRadius: 20,
                            offset: Offset(1, 1), // changes position of shadow
                          ),
                        ],
                        // border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(100),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/Logo.png"),
                          fit: BoxFit.cover,
                          scale: 1,
                        ),
                      )),
                ]),
          ),
        ),
      ]),
    );
  }
}
