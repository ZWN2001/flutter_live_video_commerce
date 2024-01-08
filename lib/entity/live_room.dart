class LiveRoom {
  int roomId;
  String title;
  String coverUrl;
  String description;
  int status;
  int onlineCount;
  int anchorUid;
  String anchorName;
  String ownerAvatarUrl;
  int roomSectionId;
  String roomSectionName;

  LiveRoom({
    required this.roomId,
    required this.title,
    required this.coverUrl,
    required this.description,
    required this.status,
    required this.onlineCount,
    required this.anchorUid,
    required this.anchorName,
    required this.ownerAvatarUrl,
    required this.roomSectionId,
    required this.roomSectionName,
  });

  factory LiveRoom.fromJson(Map<String, dynamic> jsonMap) {
    return LiveRoom(
      roomId: jsonMap['roomId'] as int,
      title: jsonMap['roomName'] as String,
      coverUrl: jsonMap['roomCoverUrl'] as String,
      description: jsonMap['roomDescription'] as String,
      status: jsonMap['roomStatus'] as int,
      onlineCount: jsonMap['roomOnlineCount'] as int,
      anchorUid: jsonMap['roomOwnerUid'] as int,
      anchorName: jsonMap['roomOwnerName'] as String,
      ownerAvatarUrl: jsonMap['roomOwnerAvatarUrl'] as String,
      roomSectionId: jsonMap['roomSectionId'] as int,
      roomSectionName: jsonMap['roomSectionName'] as String,
    );
  }
}

class LiveRoomMini{
  int roomId;
  String title;
  String coverUrl;
  int status;
  int onlineCount;
  String anchorName;
  String roomSectionName;

  LiveRoomMini({
    required this.roomId,
    required this.title,
    required this.coverUrl,
    required this.status,
    required this.onlineCount,
    required this.anchorName,
    required this.roomSectionName,
  });

  factory LiveRoomMini.fromJson(Map<String, dynamic> jsonMap) {
    return LiveRoomMini(
      roomId: jsonMap['roomId'] as int,
      title: jsonMap['roomName'] as String,
      coverUrl: jsonMap['roomCoverUrl'] as String,
      status: jsonMap['roomStatus'] as int,
      onlineCount: jsonMap['roomOnlineCount'] as int,
      anchorName: jsonMap['roomOwnerName'] as String,
      roomSectionName: jsonMap['roomSectionName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'title': title,
      'coverUrl': coverUrl,
      'status': status,
      'onlineCount': onlineCount,
      'anchorName': anchorName,
      'roomSectionName': roomSectionName,
    };
  }
}