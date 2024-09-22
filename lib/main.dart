import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart'; // Import Remote Config
import 'package:firebase_sample_app/firebase_options.dart';
import 'package:firebase_sample_app/pages/home/home.dart';
import 'package:firebase_sample_app/pages/login/login.dart';
import 'package:firebase_sample_app/pages/signup/signup.dart';
import 'package:firebase_sample_app/viewmodela/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupRemoteConfig(); // Call to set up Remote Config

  runApp(const MyApp());
}

Future<void> setupRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 1),
    minimumFetchInterval: const Duration(seconds: 2),
  ));
  await remoteConfig.fetchAndActivate();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()..fetchComments()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Comments App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => const Login(), // Define the initial route
          '/signup': (context) => const Signup(), // Define the signup route
          '/home': (context) => const HomeScreen(), // Define your home route
        },
      ),
    );
  }
}
