// account_screen.dart
import 'package:flutter/material.dart';
import 'package:support_local_artisans/features/AccountScreen/UserApi.dart';
import 'package:support_local_artisans/features/AccountScreen/UserModel.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: UserApi.getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: \${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No user data'));
        }

        final user = snapshot.data!;

        return Scaffold(
          appBar: AppBar(title: const Text("My Account")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: NetworkImage(user.avatarUrl),
                ),
                const SizedBox(height: 16),
                Text(user.name,
                    style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(user.email, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 24),
                ListTile(
                  leading: const Icon(Icons.shopping_bag),
                  title: const Text("My Orders"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to orders screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text("Wishlist"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to wishlist screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Log Out"),
                  trailing: const Icon(Icons.exit_to_app),
                  onTap: () {
                    // Logout logic
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
