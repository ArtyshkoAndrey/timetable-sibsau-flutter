class Time {
  final String start;
  final String end;

  Time({this.start, this.end});

  factory Time.fromJson(json) {
    return Time(start: json['start'] as String, end: json['end'] as String);
  }
}

class Data {
  final int index;
  final String name;

  Data({this.index, this.name});

  factory Data.fromJson(json) {
    return Data(index: json['index'] as int, name: json['name']);
  }
}

class Lesson {
  final int id;
  final String name;
  final Time time;
  final String type;
  final int week;
  final String subgroup;
  final String lessonImageId;
  final String group;
  final String teacher;
  final String audience;
  final Lesson nextLesson;
  final Data day;

  Lesson(
      {this.id,
      this.name,
      this.time,
      this.type,
      this.week,
      this.subgroup,
      this.lessonImageId,
      this.group,
      this.teacher,
      this.audience,
      this.day,
      this.nextLesson});

  factory Lesson.fromJson(json) {
    if (json is Map) {
      return Lesson(
          id: json['id'] as int,
          name: json['name'][0].toUpperCase() +
              json['name'].substring(1).toLowerCase(),
          time: Time.fromJson(json['time'] as Map),
          type: json['type'],
          week: json['week'] as int,
          subgroup: json['subgroup'],
          lessonImageId: json['lesson_image_id'].toString(),
          group: json['group'],
          teacher: json['teacher'],
          day: Data.fromJson(json['day'] as Map),
          audience: json['audience'],
          nextLesson: null);
    } else {
      return Lesson(
          id: json[0]['id'] as int,
          name: json[0]['name'][0].toUpperCase() +
              json[0]['name'].substring(1).toLowerCase(),
          time: Time.fromJson(json[0]['time']),
          type: json[0]['type'],
          week: json[0]['week'] as int,
          subgroup: json[0]['subgroup'],
          lessonImageId: json[0]['lesson_image_id'].toString(),
          group: json[0]['group'],
          teacher: json[0]['teacher'],
          day: Data.fromJson(json[0]['day']),
          audience: json[0]['audience'],
          nextLesson: Lesson.fromJson(json[1]));
    }
  }
}

class Day {
  final List<Lesson> lessons;
  final int index;
  final String name;
  Day({this.lessons, this.index, this.name});

  factory Day.fromJson(Map json) {
    return Day(
        lessons: json['lessons']
            .map<Lesson>((lesson) => Lesson.fromJson(lesson))
            .toList(),
        index: json['index'],
        name: json['name']);
  }
}

class Group {
  final int id;
  final String name;

  Group({this.id, this.name});
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(id: json['id'], name: json['name']);
  }
}

class Post {
  final int id;
  final String title;
  final String summary;
  final String body;
  final String avatar;
  final String img;
  final DateTime date;

  Post({this.id, this.title, this.summary, this.body, this.avatar, this.img, this.date});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        title: json['title'],
        summary: json['summary'],
        body: json['body'],
        avatar: json['user']['avatar'],
        img: json['avatar'],
        date: DateTime.parse(json['created_at']));
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "title": this.title,
      'summary': this.summary,
      'body': this.body,
      'avatar': this.avatar,
      'img': this.img
    };
  }
}

class Event {
  final int id;
  final String title;
  final int numDay;
  final String date;

  Event({this.id, this.title, this.numDay, this.date});
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        id: json['id'] as int,
        title: json['title'],
        numDay: json['num_day'],
        date: json['date']);
  }
}
