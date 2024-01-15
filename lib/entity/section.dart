//直播分区
class Section {
  String sid;
  String sectionName;

  Section({
    required this.sid,
    required this.sectionName,
  });

  factory Section.fromJson(Map<String, dynamic> jsonMap) {
    return Section(
      sid: jsonMap['sectionId'] as String,
      sectionName: jsonMap['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sectionId': sid,
      'title': sectionName,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Section &&
              runtimeType == other.runtimeType &&
              sid == other.sid &&
              sectionName == other.sectionName ;

  @override
  int get hashCode =>
      sid.hashCode ^ sectionName.hashCode ;
}