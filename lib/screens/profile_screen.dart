import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../data_manager/authentication_data_manager.dart';
import '../data_manager/profile_data_manager.dart';
import '../models/profile.dart';
import '../screens/auth_screens/signin_screen.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/button_widget.dart';
import '../widgets/textfield_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userData = {};
  User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileDataManager>(context, listen: false).isLoading = true;
    Future.delayed(Duration.zero, () {
      Provider.of<ProfileDataManager>(context, listen: false)
          .getProfileData(context: context);
    });
  }

  void onLogoutClick(AuthenticationDataManager authDataProvider) async {
    bool success = await authDataProvider.logoutUserRequest(context: context);
    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileDataProvider = Provider.of<ProfileDataManager>(context);
    final authDataProvider = Provider.of<AuthenticationDataManager>(context);
    TextEditingController firstNameController =
        TextEditingController(text: profileDataProvider.profileData.firstName);
    final lastNameController =
        TextEditingController(text: profileDataProvider.profileData.lastName);
    final addressController =
        TextEditingController(text: profileDataProvider.profileData.address);
    final emailController =
        TextEditingController(text: profileDataProvider.profileData.email);

    void getUserDetails(ProfileDataManager profileDataProvider) {
      // Get the values from the controllers
      String firstName = firstNameController.text;
      String lastName = lastNameController.text;
      String address = addressController.text;

      // Create a Profile object
      Profile profile = Profile(
        firstName: firstName,
        lastName: lastName,
        address: address,
      );

      // Call the update user details function with the profile object
      profileDataProvider.sendUpdateProfileRequest(
          context: context, profile: profile);
    }

    void submitProfile(ProfileDataManager profileDataProvider) {
      String firstName = firstNameController.text.trim();
      String lastName = lastNameController.text.trim();
      String address = addressController.text.trim();

      if (firstName.isEmpty) {
        Fluttertoast.showToast(
          msg: validations['firstNameEmpty'].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else if (lastName.isEmpty) {
        Fluttertoast.showToast(
          msg: validations['lastNameEmpty'].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else if (address.isEmpty) {
        Fluttertoast.showToast(
          msg: validations['addressEmpty'].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        getUserDetails(profileDataProvider);
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        // used to hide app bar
        preferredSize: const Size(0.0, 0.0),
        child: Container(
          color: gradientColors[0],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: kAppThemeColor,
                  size: 30,
                ),
                onPressed: () {
                  onLogoutClick(authDataProvider);
                },
              ),
            ),
            TextFieldWidget(
              hintText: enterFirstName,
              prefixImage: Icons.edit,
              isPasswordType: false,
              controller: firstNameController,
              passwordVisible: false,
              subText: firstName,
            ),
            const SizedBox(height: 30),
            TextFieldWidget(
              hintText: enterLastName,
              prefixImage: Icons.edit,
              isPasswordType: false,
              controller: lastNameController,
              passwordVisible: false,
              subText: lastName,
            ),
            const SizedBox(height: 30),
            TextFieldWidget(
              hintText: enterEmail,
              prefixImage: Icons.email,
              isPasswordType: false,
              controller: emailController,
              passwordVisible: false,
              enabled: false,
              subText: email,
            ),
            const SizedBox(height: 30),
            TextFieldWidget(
              hintText: enterAddress,
              prefixImage: Icons.location_on,
              isPasswordType: false,
              controller: addressController,
              passwordVisible: false,
              subText: address,
            ),
            const SizedBox(height: 50),
            ButtonWidget(
              buttonText: save,
              onTap: () {
                submitProfile(profileDataProvider);
              },
            ),
          ],
        ),
      ),
    );
  }
}
