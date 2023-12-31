import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';
import 'Models/video.dart';

class ReelsItem extends StatefulWidget {
  final Video video_;
  const ReelsItem({Key? key, required this.video_}) : super(key: key);

  @override
  State<ReelsItem> createState() => _ReelsItemState();
}

class _ReelsItemState extends State<ReelsItem> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    //initialize player
    initializePlayer(widget.video_.videoUrl);
  }

//Initialize Video Player
  void initializePlayer(String url) async {
    final fileInfo = await checkCacheFor(url);
    if (fileInfo == null) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      _controller!.initialize().then((value) {
        cachedForUrl(url);
        setState(() {
          _controller!.play();
          _controller!.setLooping(true);
        });
      });
    } else {
      final file = fileInfo.file;
      _controller = VideoPlayerController.file(file);
      _controller!.initialize().then((value) {
        setState(() {
          _controller!.play();
          _controller!.setLooping(true);
        });
      });
    }
  }

//check for cache
  Future<FileInfo?> checkCacheFor(String url) async {
    final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
// if file is older than 7 days then will remove it
    if (value != null &&
        DateTime.now().difference(value.file.lastModifiedSync()).inDays > 7) {
      await DefaultCacheManager().removeFile(url);
      return null;
    }

    return value;
  }

//cached Url Data
  void cachedForUrl(String url) async {
    await DefaultCacheManager().getSingleFile(url).then((value) {
      //  print('downloaded successfully done for $url');
    });
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.dispose();
      _controller!.pause();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (_controller == null)
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          )
        : ((_controller!.value.isInitialized)
            ? Stack(
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: widget.video_.width / widget.video_.height,
                      child: VideoPlayer(_controller!),
                    ),
                  ),
                  Center(
                    child: IconButton(
                      icon: _controller!.value.isPlaying
                          ? const Visibility(
                              visible: false,
                              child: Icon(
                                size: 40,
                                Icons.pause,
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              size: 50,
                              Icons.play_arrow,
                              color: Colors.white.withOpacity(0.7),
                            ),
                      onPressed: () {
                        setState(() {
                          _controller!.value.isPlaying
                              ? _controller!.pause()
                              : _controller!.play();
                        });
                      },
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 15, bottom: 60),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  widget.video_.username,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                    radius: 15,
                                    backgroundImage: NetworkImage(
                                        widget.video_.profilePhoto))
                              ]),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5, left: 5),
                            child: SizedBox(
                              height: 60,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Text(
                                  widget.video_.caption,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 181, 203, 221),
                  strokeWidth: 2,
                ),
              ));
  }
}
