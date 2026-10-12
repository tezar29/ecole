import 'package:flutter/material.dart';

enum SchoolLevel { sil, cp, ce1, ce2, cm1, cm2 }

extension SchoolLevelX on SchoolLevel {
  String get label => switch (this) {
        SchoolLevel.sil => 'SIL',
        SchoolLevel.cp => 'CP',
        SchoolLevel.ce1 => 'CE1',
        SchoolLevel.ce2 => 'CE2',
        SchoolLevel.cm1 => 'CM1',
        SchoolLevel.cm2 => 'CM2',
      };
}

const Map<String, String> kAvatars = {
  'lion': '🦁',
  'elephant': '🐘',
  'singe': '🐵',
  'tortue': '🐢',
  'perroquet': '🦜',
  'girafe': '🦒',
};

class Child {
  final String id;
  final String name;
  final String avatar;
  final SchoolLevel level;

  const Child({
    required this.id,
    required this.name,
    required this.avatar,
    required this.level,
  });

  String get emoji => kAvatars[avatar] ?? '🦁';

  factory Child.fromMap(Map<String, dynamic> m) => Child(
        id: m['id'] as String,
        name: m['name'] as String,
        avatar: m['avatar'] as String,
        level: SchoolLevel.values.byName(m['level'] as String),
      );
}

class Subject {
  final int id;
  final String slug;
  final String name;
  final String? icon;
  final String? color;

  const Subject({
    required this.id,
    required this.slug,
    required this.name,
    this.icon,
    this.color,
  });

  factory Subject.fromMap(Map<String, dynamic> m) => Subject(
        id: m['id'] as int,
        slug: m['slug'] as String,
        name: m['name'] as String,
        icon: m['icon'] as String?,
        color: m['color'] as String?,
      );

  Color get colorValue {
    final c = color;
    if (c == null) return Colors.orange;
    return Color(int.parse(c.replaceFirst('#', '0xFF')));
  }

  IconData get iconData => switch (icon) {
        'calculate' => Icons.calculate,
        'menu_book' => Icons.menu_book,
        'translate' => Icons.translate,
        'science' => Icons.science,
        'computer' => Icons.computer,
        _ => Icons.school,
      };
}

class Chapter {
  final String id;
  final int subjectId;
  final SchoolLevel level;
  final String title;
  final int position;
  final Map<String, dynamic> content;

  const Chapter({
    required this.id,
    required this.subjectId,
    required this.level,
    required this.title,
    required this.position,
    required this.content,
  });

  factory Chapter.fromMap(Map<String, dynamic> m) => Chapter(
        id: m['id'] as String,
        subjectId: m['subject_id'] as int,
        level: SchoolLevel.values.byName(m['level'] as String),
        title: m['title'] as String,
        position: m['position'] as int,
        content: (m['content'] as Map?)?.cast<String, dynamic>() ?? {},
      );
}

class Exercise {
  final String id;
  final String type;
  final Map<String, dynamic> question;
  final Map<String, dynamic> answer;

  const Exercise({
    required this.id,
    required this.type,
    required this.question,
    required this.answer,
  });

  factory Exercise.fromMap(Map<String, dynamic> m) => Exercise(
        id: m['id'] as String,
        type: m['type'] as String,
        question: (m['question'] as Map).cast<String, dynamic>(),
        answer: (m['answer'] as Map).cast<String, dynamic>(),
      );
}
