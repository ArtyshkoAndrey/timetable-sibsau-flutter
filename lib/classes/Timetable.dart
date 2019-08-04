
class Lesson {
  final int id;
  final String name;

  Lesson({
    this.id,
    this.name,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as int,
      name: json['name'] as String,
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