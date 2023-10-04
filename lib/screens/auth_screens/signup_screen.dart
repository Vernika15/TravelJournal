import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../data_manager/authentication_data_manager.dart';
import '../../data_manager/home_data_manager.dart';
import '../../screens/home_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/text_widget.dart';
import '../../widgets/textfield_widget.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _utils = Utils();

  void submitRegister(
    BuildContext context,
    HomeDataManager homeProvider,
    AuthenticationDataManager authDataProvider,
  ) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty) {
      Fluttertoast.showToast(
        msg: validations['emailEmpty'].toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (!_utils.isEmailValid(email)) {
      Fluttertoast.showToast(
        msg: validations['emailInvalid'].toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (password.isEmpty) {
      Fluttertoast.showToast(
        msg: validations['passwordEmpty'].toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (password.length < 6) {
      Fluttertoast.showToast(
        msg: validations['passwordLength'].toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      bool registerSuccess = await authDataProvider.sendRegisterRequest(
        context: context,
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (registerSuccess) {
        bool createCollectionForUserSuccess =
            await authDataProvider.createCollectionForUser(
          context: context,
          uid: _utils.getCurrentUserId(),
          email: _emailController.text,
        );
        if (createCollectionForUserSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
          homeProvider.setIndex(
              0); //will move to dashboard screen after submitting the form
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeDataManager>(context);
    final authDataProvider = Provider.of<AuthenticationDataManager>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: TextWidget(
          text: signup,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.end,
          fontSize: 24,
          color: whiteColor,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20.0),
        color: whiteColor,
        child: Column(
          children: [
            TextFieldWidget(
              hintText: enterEmail,
              prefixImage: Icons.email,
              isPasswordType: false,
              controller: _emailController,
              passwordVisible: false,
              subText: email,
            ),
            const SizedBox(height: 20),
            TextFieldWidget(
              hintText: enterPassword,
              prefixImage: Icons.lock,
              isPasswordType: true,
              controller: _passwordController,
              passwordVisible: true,
              subText: password,
            ),
            const SizedBox(height: 30),
            authDataProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: kAppThemeColor))
                : ButtonWidget(
                    buttonText: signupCaps,
                    onTap: () {
                      submitRegister(context, homeProvider, authDataProvider);
                    },
                  ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
