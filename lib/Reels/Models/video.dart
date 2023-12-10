import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String username;
  String uid;
  String id;
  String caption;
  String videoUrl;
  String thumbnail;
  String profilePhoto;
  int height;
  int width;
  int duration;

  Video({
    required this.username,
    required this.uid,
    required this.id,
    required this.caption,
    required this.videoUrl,
    required this.profilePhoto,
    required this.thumbnail,
    required this.height,
    required this.width,
    required this.duration,
  });

  Future<Map<String, dynamic>> toJson() async => {
        "username": username,
        "uid": uid,
        "profilePhoto": profilePhoto,
        "id": id,
        "caption": caption,
        "videoUrl": videoUrl,
        "thumbnail": thumbnail,
        "height": height,
        "width": width,
        "duration": duration,
      };

  static Video fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Video(
      username: snapshot['username'],
      uid: snapshot['uid'],
      id: snapshot['id'],
      caption: snapshot['caption'],
      videoUrl: snapshot['videoUrl'],
      profilePhoto: snapshot['profilePhoto'],
      thumbnail: snapshot['thumbnail'],
      height: snapshot['height'],
      width: snapshot['width'],
      duration: snapshot['duration'],
    );
  }
}
