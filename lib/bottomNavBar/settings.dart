import 'package:flutter/material.dart';

// Settings Screen UI
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/default_profile.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'User Name',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'User',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.grey),
            title: const Text(
              'Account',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'Privacy, security, change email or number',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.chat_bubble_outline, color: Colors.grey),
            title: const Text(
              'Chats',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'Theme, wallpapers, chat history',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications_none, color: Colors.grey),
            title: const Text(
              'Notifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'Message, group & call tones',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.storage, color: Colors.grey),
            title: const Text(
              'Storage and data',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'Network usage, auto-download',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.grey),
            title: const Text(
              'Help',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'Help center, contact us, privacy policy',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            onTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: InkWell(
              onTap: () {},
              child: const Text(
                'Invite a friend',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
