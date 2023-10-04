import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../widgets/custom_alert_dialog.dart';
import '../network_manager/firebase_client.dart';

class AuthenticationDataManager extends ChangeNotifier {
  final _firebaseClient = FirebaseClient();
  bool isLoading = false;

  Future<bool> sendLoginRequest({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      final response = await _firebaseClient.sendLoginResponse(
        context: context,
        email: email,
        password: password,
      );

      if (response) {
        notifyListeners();
        isLoading = false;
        return true;
      } else {
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

  Future<bool> sendRegisterRequest({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      final response = await _firebaseClient.sendRegisterResponse(
        context: context,
        email: email,
        password: password,
      );

      if (response) {
        notifyListeners();
        isLoading = false;
        return true;
      } else {
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

  Future<bool> createCollectionForUser({
    required BuildContext context,
    required String uid,
    required String email,
  }) async {
    try {
      isLoading = true;
      final response = await _firebaseClient.createCollectionForUser(
        context: context,
        uid: uid,
        email: email,
      );

      if (response) {
        notifyListeners();
        isLoading = false;
        return true;
      } else {
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

  Future<bool> logoutUserRequest({
    required BuildContext context,
  }) async {
    try {
      isLoading = true;
      final response = await _firebaseClient.logoutUserResponse(
        context: context,
      );

      if (response) {
        notifyListeners();
        isLoading = false;
        return true;
      } else {
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
}
