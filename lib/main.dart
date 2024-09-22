import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_sample_app/firebase_options.dart';
import 'package:firebase_sample_app/pages/home/home.dart';
import 'package:firebase_sample_app/pages/login/login.dart';
import 'package:firebase_sample_app/pages/signup/signup.dart';
import 'package:firebase_sample_app/viewmodela/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set up Remote Config settings
  await setupRemoteConfig();

  // Run the app
  runApp(const MyApp());
}

Future<void> setupRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  // Configure Remote Config settings
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 1),
    minimumFetchInterval: const Duration(seconds: 2),
  ));

  // Fetch and activate the latest Remote Config values
  await remoteConfig.fetchAndActivate();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide HomeViewModel to the widget tree
        ChangeNotifierProvider(create: (_) => HomeViewModel()..fetchComments()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Comments App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          // Define app routes
          '/': (context) => const Login(),
          '/signup': (context) => const Signup(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
