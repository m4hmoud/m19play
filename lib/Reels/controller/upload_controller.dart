import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:m19play/Reels/Models/video.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';
import 'package:get/get.dart';

class upload_controller extends GetxController {
  compressVideo(String videopath) async {
    try {
      final compressvideofile = await VideoCompress.compressVideo(videopath,
          quality: VideoQuality.HighestQuality,
          deleteOrigin: false,
          frameRate: 60);
      return compressvideofile!.file;
    } catch (e) {
      print("error in compressing video");
    }
  }
//how to listen to the upload task and show the progress indicator

  upload_compressvideo(VideoID, String videofilepath) async {
    try {
      UploadTask VideoUploadTask = FirebaseStorage.instance
          .ref()
          .child("videos")
          .child(VideoID)
          .putFile(await compressVideo(videofilepath));

      final snapshot = await VideoUploadTask;
      final urlDownload = await snapshot.ref.getDownloadURL();

      return urlDownload;
    } catch (e) {
      print("error in uploading video");
    }
  }

  getthumbnailimage(String videopath) async {
    try {
      final thumbnailfile = await VideoCompress.getFileThumbnail(
        videopath,
        quality: 50,
      );
      return thumbnailfile;
    } catch (e) {
      print("error in getting thumbnail image");
    }
  }

  upload_thumbnailimage(String videoID, String videofilepath) async {
    try {
      UploadTask VideoUploadTask = FirebaseStorage.instance
          .ref()
          .child("thumbnails")
          .child(videoID)
          .putFile(await getthumbnailimage(videofilepath));

      final snapshot = await VideoUploadTask;
      final urlDownload = await snapshot.ref.getDownloadURL();

      return urlDownload;
    } catch (e) {
      print("error in uploading thumbnail image");
    }
  }

  upload_videoinformation(
    BuildContext context,
    videofilepath,
    int duration,
    int height,
    int width,
  ) async {
    try {
      String VideoID = DateTime.now().millisecondsSinceEpoch.toString();
      String downloadurl = await upload_compressvideo(VideoID, videofilepath);
      String thumbnailurl = await upload_thumbnailimage(VideoID, videofilepath);
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      Video video = Video(
        username: 'username',
        uid: 'uid',
        id: 'id',
        caption: "caption",
        videoUrl: downloadurl,
        profilePhoto: 'profilePhoto',
        thumbnail: thumbnailurl,
        height: height,
        width: width,
        duration: duration,
      );
      firestore.collection('videos').add(await video.toJson());

      Get.showSnackbar(
        const GetSnackBar(
          backgroundColor: Colors.green,
          message: "Video Uploaded",
          title: "Success",
          icon: Icon(Icons.done),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      Get.showSnackbar(
        const GetSnackBar(
          backgroundColor: Colors.red,
          message: "error in uploading video information",
          title: "error",
          icon: Icon(Icons.error),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
