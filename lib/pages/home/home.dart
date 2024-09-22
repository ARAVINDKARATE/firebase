import 'dart:async';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_sample_app/services/auth_service.dart';
import 'package:firebase_sample_app/utilities/validation_util.dart';
import 'package:firebase_sample_app/viewmodela/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool _maskEmail = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchRemoteConfig();
    _startPeriodicFetch();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Clean up observer
    _timer?.cancel(); // Cancel timer on dispose
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchRemoteConfig(); // Fetch new values when the app resumes
    }
  }

  // Fetch values from Firebase Remote Config
  Future<void> _fetchRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    // Set a short cache expiration time for development
    await remoteConfig.fetchAndActivate();
    setState(() {
      _maskEmail = remoteConfig.getBool('mask_email');
    });
    print('Mask Email: $_maskEmail');
  }

  // Start periodic fetching of remote config every 2 seconds
  void _startPeriodicFetch() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _fetchRemoteConfig(); // Fetch remote config periodically
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCED3DC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C54BE),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Comments',
          style: TextStyle(
            color: Color(0xFFF5F9FD),
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Color(0xFFF5F9FD),
            ),
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error.isNotEmpty) {
            return Center(child: Text('Error: ${viewModel.error}'));
          }

          return ListView.builder(
            itemCount: viewModel.comments.length,
            itemBuilder: (context, index) {
              final comment = viewModel.comments[index];
              final initialLetter = comment.name.isNotEmpty ? comment.name[0].toUpperCase() : '';
              final displayEmail = _maskEmail ? maskEmail(comment.email) : comment.email;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F9FD),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0xFF303F60).withOpacity(0.3),
                            child: Text(
                              initialLetter,
                              style: const TextStyle(
                                fontSize: 28,
                                color: Color(0xFF303F60),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Name : ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                        color: const Color(0xFF303F60).withOpacity(0.4),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        comment.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                          color: Color(0xFF303F60),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      'Email : ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                        color: const Color(0xFF303F60).withOpacity(0.4),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        displayEmail,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                          color: Color(0xFF303F60),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 76),
                        child: Text(
                          comment.body,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF303F60),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
