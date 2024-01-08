//直播分区
class Section {
  int id;
  String title;
  String description;

  Section({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Section.fromJson(Map<String, dynamic> jsonMap) {
    return Section(
      id: jsonMap['sectionId'] as int,
      title: jsonMap['title'] as String,
      description: jsonMap['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sectionId': id,
      'title': title,
      'description': description,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Section &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              title == other.title &&
              description == other.description;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ description.hashCode ;
}