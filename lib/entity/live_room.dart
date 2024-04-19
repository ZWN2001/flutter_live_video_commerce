import 'package:live_video_commerce/api/server.dart';

class LiveRoom {
  int rid;
  String uid;
  int sectionId;
  String roomName;
  String liveUrl;
  String coverUrl;
  String danmuUrl;
  String description;
  int status;


  LiveRoom({
    required this.rid,
    required this.uid,
    required this.sectionId,
    required this.roomName,
    required this.liveUrl,
    required this.coverUrl,
    required this.danmuUrl,
    required this.description,
    required this.status,
  });

  factory LiveRoom.fromJson(Map<String, dynamic> jsonMap) {
    String liveUrl = jsonMap['liveUrl'];
    liveUrl = liveUrl.replaceAll("localhost", Server.hostIp);
    String coverUrl = jsonMap['coverUrl'];
    coverUrl = coverUrl.replaceAll("localhost", Server.hostIp);
    return LiveRoom(
      rid: jsonMap['rid'] as int,
      uid: jsonMap['uid'] as String,
      sectionId: jsonMap['sectionId'] as int,
      roomName: jsonMap['roomName'] as String,
      liveUrl: liveUrl,
      coverUrl: coverUrl,
      danmuUrl: jsonMap['danmuUrl'] ?? '',
      description: jsonMap['roomDescription'] ?? '',
      status: jsonMap['liveStatus'] as int,
    );
  }

  //空白对象
  factory LiveRoom.empty() {
    return LiveRoom(
      rid: -1,
      uid: '',
      sectionId: 0,
      roomName: '',
      liveUrl: '',
      coverUrl: '',
      danmuUrl: '',
      description: '',
      status: 0,
    );
  }

  //判断是否为空白对象
  bool get isEmpty => rid == -1;
}

class LiveRoomMini{
  int rid;
  String roomName;
  String coverUrl;
  String roomDescription;
  int liveStatus;

  LiveRoomMini({
    required this.rid,
    required this.roomName,
    required this.coverUrl,
    required this.roomDescription,
    required this.liveStatus,
  });

  factory LiveRoomMini.fromJson(Map<String, dynamic> jsonMap) {
    String coverUrl = jsonMap['coverUrl'];
    coverUrl = coverUrl.replaceAll("localhost", Server.hostIp);
    return LiveRoomMini(
      rid: jsonMap['rid'] as int,
      roomName: jsonMap['roomName'] as String,
      coverUrl: coverUrl,
      roomDescription: jsonMap['roomDescription'] as String,
      liveStatus: jsonMap['liveStatus'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rid': rid,
      'roomName': roomName,
      'coverUrl': coverUrl,
      'roomDescription': roomDescription,
      'liveStatus': liveStatus,
    };
  }
}