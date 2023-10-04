import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../data_manager/authentication_data_manager.dart';
import '../../data_manager/home_data_manager.dart';
import '../../screens/auth_screens/signup_screen.dart';
import '../../screens/home_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/text_widget.dart';
import '../../widgets/textfield_widget.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _utils = Utils();

  void submitLogin(
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
      bool success = await authDataProvider.sendLoginRequest(
        context: context,
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (success) {
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

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeDataManager>(context);
    final authDataProvider = Provider.of<AuthenticationDataManager>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20.0),
        color: whiteColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            ButtonWidget(
              buttonText: loginCaps,
              onTap: () {
                submitLogin(context, homeProvider, authDataProvider);
              },
            ),
            const SizedBox(height: 15),
            signUpOption(context),
          ],
        ),
      ),
    );
  }

  Row signUpOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget(
          text: noAccount,
          textAlign: TextAlign.center,
          color: kAppThemeColor.withOpacity(0.9),
          fontSize: 16,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // fullscreenDialog: true,
                builder: (context) => SignUpScreen(),
              ),
            );
          },
          child: TextWidget(
            text: signup,
            textAlign: TextAlign.center,
            color: kAppThemeColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        )
      ],
    );
  }
}
