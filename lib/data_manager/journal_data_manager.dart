import 'package:flutter/material.dart';

import '../models/journal.dart';
import '../models/journal_entry.dart';
import '../network_manager/firebase_client.dart';
import '../utils/constants.dart';
import '../widgets/custom_alert_dialog.dart';

class JournalDataManager extends ChangeNotifier {
  final _firebaseClient = FirebaseClient();
  List<Journal> _journal = [];
  List<JournalEntry> _journalEntry = [];
  bool isLoading = false;

  List<Journal> get journal {
    return _journal;
  }

  List<JournalEntry> get journalEntry {
    return _journalEntry;
  }

  Future<List<Journal>> getJournalsList({
    required BuildContext context,
  }) async {
    isLoading = true;
    final response = await _firebaseClient.getJournalsList(context: context);
    _journal = response;
    isLoading = false;
    notifyListeners();
    return response;
  }

  Future<bool> sendAddJournalRequest({
    required BuildContext context,
    required Journal journal,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await _firebaseClient.addJournalResponse(
        context: context,
        journal: journal,
      );

      if (response) {
        final journalData = Journal(
          title: journal.title ?? '',
          date: journal.date,
          location: journal.location ?? '',
          coverPhotoUrl: journal.coverPhotoUrl ?? '',
        );
        _journal.insert(0, journalData);
        notifyListeners();
        isLoading = false;
        return true;
      } else {
        _journal = [];
        isLoading = false;
        return false;
      }
    } catch (e) {
      // Handle any errors that occur during the process
      isLoading = false;
      showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return CustomAlertDialog(
              title: error,
              content: e.toString(),
              buttonText1: okCaps,
              onButtonText1Pressed: () {},
            );
          });
      return false;
    }
  }

  Future<List<JournalEntry>> getJournalEntriesList({
    required BuildContext context,
    required String? journalId,
  }) async {
    isLoading = true;
    final response = await _firebaseClient.getJournalEntriesList(
      context: context,
      journalId: journalId,
    );
    _journalEntry = response;
    isLoading = false;
    notifyListeners();
    return response;
  }

  Future<bool> sendAddJournalEntryRequest({
    required BuildContext context,
    required JournalEntry journalEntry,
    required String? journalId,
    required String userId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await _firebaseClient.addJournalEntryResponse(
        context: context,
        journalEntry: journalEntry,
        journalId: journalId,
        userId: userId,
      );

      if (response) {
        final journalEntryData = JournalEntry(
          journalEntryID: journalId,
          title: journalEntry.title ?? '',
          date: journalEntry.date,
          content: journalEntry.content ?? '',
          photoUrls: journalEntry.photoUrls ?? [],
        );
        _journalEntry.insert(0, journalEntryData);
        notifyListeners();
        isLoading = false;
        return true;
      } else {
        _journalEntry = [];
        isLoading = false;
        return false;
      }
    } catch (e) {
      // Handle any errors that occur during the process
      isLoading = false;
      showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return CustomAlertDialog(
              title: error,
              content: e.toString(),
              buttonText1: okCaps,
              onButtonText1Pressed: () {},
            );
          });
      return false;
    }
  }

  Future<void> sendDeleteJournalEntryRequest({
    required BuildContext context,
    required String? journalId,
    required String? entryId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      await _firebaseClient.deleteJournalEntryResponse(
        context: context,
        journalId: journalId,
        entryId: entryId,
      );
      isLoading = false;
      _journalEntry.removeWhere((entry) => entry.journalEntryID == entryId);
      notifyListeners();
    } catch (e) {
      // Handle any errors that occur during the process
      isLoading = false;
      showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return CustomAlertDialog(
              title: error,
              content: e.toString(),
              buttonText1: okCaps,
              onButtonText1Pressed: () {},
            );
          });
    }
  }
}
