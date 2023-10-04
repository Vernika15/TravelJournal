import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../widgets/custom_alert_dialog.dart';
import '../models/profile.dart';
import '../network_manager/firebase_client.dart';

class ProfileDataManager extends ChangeNotifier {
  final _firebaseClient = FirebaseClient();
  bool isLoading = false;
  Profile _profileData = Profile();

  Profile get profileData {
    return _profileData;
  }

  Future<Map<String, dynamic>> getProfileData({
    required BuildContext context,
  }) async {
    isLoading = true;
    final response = await _firebaseClient.getProfileData(context: context);
    _profileData = Profile(
      firstName: response['firstName'] ?? '',
      lastName: response['lastName'] ?? '',
      address: response['address'] ?? '',
      email: response['email'] ?? '',
    );
    isLoading = false;
    notifyListeners();
    return response;
  }

  Future<void> sendUpdateProfileRequest({
    required BuildContext context,
    required Profile profile,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      await _firebaseClient.updateProfileResponse(
        context: context,
        profile: profile,
      );
      isLoading = false;
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
