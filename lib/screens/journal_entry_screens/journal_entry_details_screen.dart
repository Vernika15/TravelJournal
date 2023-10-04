import 'package:flutter/material.dart';

class JournalEntryDetailsScreen extends StatefulWidget {
  const JournalEntryDetailsScreen({Key? key}) : super(key: key);

  @override
  State<JournalEntryDetailsScreen> createState() => _JournalEntryDetailsScreenState();
}

class _JournalEntryDetailsScreenState extends State<JournalEntryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('yo'),
      ),
    );
  }
}
