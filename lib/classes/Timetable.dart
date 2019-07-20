
class Lesson {
  final int id;
  final int groupId;
  final int prefLessonId;
  final String name;
  final int teacherId;
  final String audience;
  final Object time;
  final String type;
  final String week;
  final Object day;
  final String subgroup;
  final Object lessonImageId;
  final String group;
  final String teacher;

  Lesson({
    this.id,
    this.name,
    this.groupId,
    this.prefLessonId,
    this.teacherId,
    this.audience,
    this.time,
    this.type,
    this.week,
    this.day,
    this.subgroup,
    this.lessonImageId,
    this.group,
    this.teacher
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      name: json['name'],
      groupId: json['group_id'],
      prefLessonId: json['prefLesson_id'],
      teacherId: json['teacher_id'],
      audience: json['audience'],
      time: json['time'],
      type: json['type'],
      week: json['week'],
      day: json['day'],
      subgroup: json['subgroup'],
      lessonImageId: json['lesson_image_id'],
      group: json['group'],
      teacher: json['teacher']
    );
  }
}

class Group {
  final int id;
  final String name;

  Group({this.id, this.name});
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name']
    );
  }
}

//class Day {
//  final List<Lesson> lessons;
//  final String name;
//  final int index;
//
//  Day({this.name, this.index});
//
//  factory Day.addLesson(json) {
//    reut
//  }
//}