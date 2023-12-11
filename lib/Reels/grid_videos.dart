import 'package:m19play/Reels/controller/reels_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GridVideos extends StatefulWidget {
  const GridVideos({super.key});
  @override
  State<GridVideos> createState() => _GridVideosState();
}

class _GridVideosState extends State<GridVideos> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M19 PLAY"),
        actions: [],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 5, right: 5.0, left: 5.0, bottom: 10.0),
          child: Center(
            child: SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("videos").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Eroor");
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text("No Video"),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ReelsController(index: index)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey[300],
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    snapshot.data!.docs[index].get("thumbnail"),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
