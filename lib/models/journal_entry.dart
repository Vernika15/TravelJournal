import 'package:cloud_firestore/cloud_firestore.dart';

class JournalEntry {
  final String? journalEntryID;
  final String title;
  final Timestamp? date;
  final String content;
  final List photoUrls;

  JournalEntry({
    this.journalEntryID,
    required this.title,
    required this.date,
    required this.content,
    required this.photoUrls,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (journalEntryID != null) {
      map['journalEntryID'] = journalEntryID;
    }
    map['title'] = title;
    if (date != null) {
      map['date'] = date;
    }
    map['content'] = content;
    map['photoUrls'] = photoUrls;
    return map;
  }
}
