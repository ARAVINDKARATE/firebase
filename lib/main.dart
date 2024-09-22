import 'package:firebase_core/firebase_core.dart';
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

  runApp(const MyApp());
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
          '/': (context) => Login(), // Define the initial route
          '/signup': (context) => Signup(), // Define the signup route
          '/home': (context) => HomeScreen(), // Define your home route
        },
      ),
    );
  }
}
