class LiveRoom {
  String rid;
  String roomName;
  String coverUrl;
  String description;
  int status;
  int onlineCount;
  String uid;
  String anchorName;
  String anchorAvatarUrl;

  LiveRoom({
    required this.rid,
    required this.roomName,
    required this.coverUrl,
    required this.description,
    required this.status,
    required this.onlineCount,
    required this.uid,
    required this.anchorName,
    required this.anchorAvatarUrl,
  });

  factory LiveRoom.fromJson(Map<String, dynamic> jsonMap) {
    return LiveRoom(
      rid: jsonMap['roomId'] as String,
      roomName: jsonMap['roomName'] as String,
      coverUrl: jsonMap['roomCoverUrl'] as String,
      description: jsonMap['roomDescription'] as String,
      status: jsonMap['roomStatus'] as int,
      onlineCount: jsonMap['roomOnlineCount'] as int,
      uid: jsonMap['roomOwnerUid'] as String,
      anchorName: jsonMap['roomOwnerName'] as String,
      anchorAvatarUrl: jsonMap['roomOwnerAvatarUrl'] as String,
    );
  }
}

class LiveRoomMini{
  String rid;
  String roomName;
  String coverUrl;
  int onlineCount;
  String anchorName;

  LiveRoomMini({
    required this.rid,
    required this.roomName,
    required this.coverUrl,
    required this.onlineCount,
    required this.anchorName,
  });

  factory LiveRoomMini.fromJson(Map<String, dynamic> jsonMap) {
    return LiveRoomMini(
      rid: jsonMap['roomId'] as String,
      roomName: jsonMap['roomName'] as String,
      coverUrl: jsonMap['roomCoverUrl'] as String,
      onlineCount: jsonMap['roomOnlineCount'] as int,
      anchorName: jsonMap['roomOwnerName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': rid,
      'title': roomName,
      'coverUrl': coverUrl,
      'onlineCount': onlineCount,
      'anchorName': anchorName,
    };
  }
}