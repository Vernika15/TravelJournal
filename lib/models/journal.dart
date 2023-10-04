import 'package:cloud_firestore/cloud_firestore.dart';

class Journal {
  final String? journalID;
  final String title;
  final Timestamp? date;
  final String location;
  final String coverPhotoUrl;

  Journal({
    this.journalID,
    required this.title,
    required this.date,
    required this.location,
    required this.coverPhotoUrl,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (journalID != null) {
      map['journalID'] = journalID;
    }
    map['title'] = title;
    if (date != null) {
      map['date'] = date;
    }
    map['location'] = location;
    map['coverPhotoUrl'] = coverPhotoUrl;
    return map;
  }
}
