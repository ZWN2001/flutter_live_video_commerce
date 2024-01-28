class LiveRoom {
  String rid;
  String uid;
  int sectionId;
  String roomName;
  String liveUrl;
  String coverUrl;
  String description;
  int status;


  LiveRoom({
    required this.rid,
    required this.uid,
    required this.sectionId,
    required this.roomName,
    required this.liveUrl,
    required this.coverUrl,
    required this.description,
    required this.status,
  });

  factory LiveRoom.fromJson(Map<String, dynamic> jsonMap) {
    return LiveRoom(
      rid: jsonMap['roomId'] as String,
      uid: jsonMap['roomOwnerId'] as String,
      sectionId: jsonMap['roomSectionId'] as int,
      roomName: jsonMap['roomName'] as String,
      liveUrl: jsonMap['roomLiveUrl'] as String,
      coverUrl: jsonMap['roomCoverUrl'] as String,
      description: jsonMap['roomDescription'] as String,
      status: jsonMap['roomStatus'] as int,
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