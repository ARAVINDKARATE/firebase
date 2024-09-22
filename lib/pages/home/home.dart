import 'package:firebase_sample_app/services/auth_service.dart';
import 'package:firebase_sample_app/viewmodela/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                                    const Text(
                                      'Name: ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                        color: Color(0xFF303F60),
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
                                        overflow: TextOverflow.ellipsis, // Prevent overflow
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Text(
                                      'Email: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        color: Color(0xFF303F60),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        comment.email,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          color: Color(0xFF303F60),
                                        ),
                                        overflow: TextOverflow.ellipsis, // Prevent overflow
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
                        padding: const EdgeInsets.only(left: 76), // Align with name and email
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
