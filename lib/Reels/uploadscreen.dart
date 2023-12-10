import 'dart:io';
import 'dart:typed_data';
import 'package:m19play/Reels/controller/upload_controller.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  PlatformFile? pickedFile;
  File? file;
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  upload_controller uploadController = Get.put(upload_controller());

  bool uploading = false;
  bool done = false;
  Uint8List? uni8int8lis;
  Future selectvideo() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      setState(() {
        uni8int8lis = result.files.first.bytes;
        file = File(result.files.first.path!);
        pickedFile = result.files.first;
        print(result.files.first.bytes);
        videoPlayerController = VideoPlayerController.file(file!);
      });

      videoPlayerController.initialize().then((_) => setState(() {
            chewieController = ChewieController(
              autoInitialize: true,
              videoPlayerController: videoPlayerController,
              aspectRatio: videoPlayerController.value.aspectRatio,
              // autoPlay: true,
              looping: true,
              errorBuilder: (context, errorMessage) {
                return Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            );
          }));
    } else {
      // canceled
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //listen to the upload task and show the progress indicator

    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        'https://firebasestorage.googleapis.com/v0/b/mazad-59a47.appspot.com/o/2022_12_16_19_01_IMG_5201.MP4?alt=media&token=0e99a5cc-19de-4834-b881-eb07a51cde3b'));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    videoPlayerController.pause();
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: videoPlayerController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: videoPlayerController.value.aspectRatio * 3,
                    child: Chewie(controller: chewieController))
                : const SizedBox.shrink(),
          ),
          const SizedBox(
            height: 5,
          ),
          pickedFile != null
              ? Text(pickedFile!.name)
              : const Text('No File Selected'),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.blue,
              elevation: 3,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            onPressed: () {
              selectvideo();
            },
            child: const Text('Select video',
                style: TextStyle(fontSize: 20, color: Colors.blue)),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.blue,
              elevation: 3,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            onPressed: () {
              upload_controller().upload_videoinformation(
                  context,
                  file!.path,
                  videoPlayerController.value.duration.inSeconds.toInt(),
                  videoPlayerController.value.size.height.toInt(),
                  videoPlayerController.value.size.width.toInt());
              setState(() {
                uploading = true;
              });
            },
            child: const Text('Upload video',
                style: TextStyle(fontSize: 20, color: Colors.blue)),
          ),
          const SizedBox(
            height: 100,
          ),
          progressIndicator(),
        ],
      ),
    ));
  }

  Widget progressIndicator() {
    return uploading
        ? Column(
            children: [
              !done
                  // ignore: prefer_const_constructors
                  ? Text(
                      'Uploading...',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  : const Text(
                      'Done',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
            ],
          )
        : Container();
  }
}
