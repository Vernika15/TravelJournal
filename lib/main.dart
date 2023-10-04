import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './data_manager/authentication_data_manager.dart';
import './data_manager/theme_data_manager.dart';
import './data_manager/home_data_manager.dart';
import './data_manager/profile_data_manager.dart';
import './data_manager/journal_data_manager.dart';
import './screens/splash_screen.dart';
import './utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthenticationDataManager()),
    ChangeNotifierProvider(create: (context) => HomeDataManager()),
    ChangeNotifierProvider(create: (context) => JournalDataManager()),
    ChangeNotifierProvider(create: (context) => ProfileDataManager()),
    ChangeNotifierProvider(create: (context) => ThemeDataManager()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // Read the theme mode from the provider
      themeMode: context.watch<ThemeDataManager>().themeMode,
      home: const SplashScreen(),
    );
  }
}
