import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';
import '../models/profile.dart';
import '../models/journal.dart';
import '../models/journal_entry.dart';
import '../utils/constants.dart';
import '../widgets/custom_alert_dialog.dart';

class FirebaseClient {
  late FirebaseFirestore firestore;
  late CollectionReference usersCollection;
  final _utils = Utils();

  FirebaseClient() {
    firestore = FirebaseFirestore.instance;
    usersCollection = firestore.collection('users');
  }

  // Function for login using email and password
  Future<bool> sendLoginResponse({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final response = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle any errors that occur during the process
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

  // Function for register using email and password
  Future<bool> sendRegisterResponse({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final response =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle any errors that occur during the process
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

  // Create a Firestore collection with the user's UID
  Future<bool> createCollectionForUser({
    required BuildContext context,
    required String uid,
    required String email,
  }) async {
    try {
      await usersCollection.doc(uid).set({
        'email': email,
        'firstName': '',
        'lastName': '',
        'address': '',
      });
      return true;
    } catch (e) {
      // Handle any errors that occur during the process
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

  // Function for logout from firebase
  Future<bool> logoutUserResponse({
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      // Handle errors
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

  // Function to fetch journal entries
  Future<List<Journal>> getJournalsList({
    required BuildContext context,
  }) async {
    try {
      final QuerySnapshot querySnapshot = await usersCollection
          .doc(_utils.getCurrentUserId())
          .collection('journals')
          .get();

      return querySnapshot.docs.map((doc) {
        String journalID = doc.id;

        return Journal(
          journalID: journalID,
          title: doc['title'] ?? '',
          date: doc['date'] as Timestamp?,
          location: doc['location'] ?? '',
          coverPhotoUrl: doc['coverPhotoUrl'] ?? '',
        );
      }).toList();
    } catch (e) {
      // Handle errors
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
      return [];
    }
  }

  // Function to create journal and send data to firestore database
  Future<bool> addJournalResponse({
    required BuildContext context,
    required Journal journal,
  }) async {
    try {
      final response = await usersCollection
          .doc(_utils.getCurrentUserId())
          .collection('journals')
          .add(journal.toJson());

      if (response.id.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle errors
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

  // Function to fetch journal entries
  Future<List<JournalEntry>> getJournalEntriesList({
    required BuildContext context,
    required String? journalId,
  }) async {
    try {
      final QuerySnapshot querySnapshot = await usersCollection
          .doc(_utils.getCurrentUserId())
          .collection('journals')
          .doc(journalId)
          .collection('entries')
          .get();

      return querySnapshot.docs.map((doc) {
        String journalEntryID = doc.id;

        return JournalEntry(
          journalEntryID: journalEntryID,
          title: doc['title'] ?? '',
          date: doc['date'] as Timestamp?,
          content: doc['content'] ?? '',
          photoUrls: doc['photoUrls'] ?? '',
        );
      }).toList();
    } catch (e) {
      // Handle errors
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
      return [];
    }
  }

  // Function to create journal entry and send data to firestore database
  Future<bool> addJournalEntryResponse({
    required BuildContext context,
    required JournalEntry journalEntry,
    required String? journalId,
    required String userId,
  }) async {
    try {
      final response = await usersCollection
          .doc(_utils.getCurrentUserId())
          .collection('journals')
          .doc(journalId)
          .collection('entries')
          .add(journalEntry.toJson());

      if (response.id.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle errors
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

  // Function to delete journal entry from firestore database
  Future<void> deleteJournalEntryResponse({
    required BuildContext context,
    required String? journalId,
    required String? entryId,
  }) async {
    try {
      await usersCollection
          .doc(_utils.getCurrentUserId())
          .collection('journals')
          .doc(journalId)
          .collection('entries')
          .doc(entryId)
          .delete();
    } catch (e) {
      // Handle errors
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

  // Function to fetch profile data
  Future<Map<String, dynamic>> getProfileData({
    required BuildContext context,
  }) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> userDoc = await firestore
          .collection('users')
          .doc(_utils.getCurrentUserId())
          .get();

      if (userDoc.exists) {
        return userDoc.data()!;
      } else {
        return {};
      }
    } catch (e) {
      // Handle errors
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
      return {};
    }
  }

  // Function to update profile details and send data to firestore database
  Future<void> updateProfileResponse({
    required BuildContext context,
    required Profile profile,
  }) async {
    try {
      await usersCollection
          .doc(_utils.getCurrentUserId())
          .update(profile.toJson());
    } catch (e) {
      // Handle errors
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
