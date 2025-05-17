import 'package:flutter/material.dart';


// Modèle utilisateur pour gérer les données
class User {
  final String name;
  final String imageUrl;
  final bool isAdmin;
  final double walletBalance;
  final int totalServices;

  User({
    required this.name,
    required this.imageUrl,
    required this.isAdmin,
    required this.walletBalance,
    required this.totalServices,
  });
}

// Écran des paramètres (Settings Screen)
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Exemple d'utilisateur (à remplacer par les données de votre backend)
    final User currentUser = User(
      name: 'Bzg a_hafidh',
      imageUrl: 'assets/profile_image.jpg',
      isAdmin: true,
      walletBalance: 5000.68,
      totalServices: 35,
    );

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
          // Section profil
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(currentUser.imageUrl),
                  onBackgroundImageError: (_, __) {
                    // Fallback pour les erreurs d'image
                  },
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentUser.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currentUser.isAdmin ? 'Admin' : 'User',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),

          // Options de menu
          _buildMenuItem(
            icon: Icons.person,
            title: 'Account',
            subtitle: 'Privacy, security, change email or number',
            onTap: () {
              // Navigation vers l'écran du profil/compte
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: currentUser),
                ),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.chat_bubble_outline,
            title: 'Chats',
            subtitle: 'Theme, wallpapers, chat history',
            onTap: () {
              // Navigation vers l'écran des chats
            },
          ),
          _buildMenuItem(
            icon: Icons.notifications_none,
            title: 'Notifications',
            subtitle: 'Message, group & call tones',
            onTap: () {
              // Navigation vers les paramètres de notification
            },
          ),
          _buildMenuItem(
            icon: Icons.storage,
            title: 'Storage and data',
            subtitle: 'Network usage, auto-download',
            onTap: () {
              // Navigation vers les paramètres de stockage
            },
          ),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Help',
            subtitle: 'Help center, contact us, privacy policy',
            onTap: () {
              // Navigation vers l'aide
            },
          ),

          // Invite un ami
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: InkWell(
              onTap: () {
                // Logique pour inviter un ami
              },
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
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 3, // Index profil sélectionné
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
      onTap: onTap,
    );
  }
}

// Écran de profil (Profile Screen)
class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(user.imageUrl),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.isAdmin ? 'Admin' : 'User',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section Wallet Balance
              _buildWalletCard(),
              
              const SizedBox(height: 24),
              
              // Section Privacy
              Text(
                'Privacy :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Options de confidentialité
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRoundedButton(
                    icon: Icons.person,
                    label: 'Privacy',
                    onTap: () {
                      // Logique pour les paramètres de confidentialité
                    },
                    color: Colors.green.shade100,
                    iconColor: Colors.green.shade700,
                  ),
                  _buildRoundedButton(
                    icon: Icons.lock,
                    label: 'security',
                    onTap: () {
                      // Logique pour les paramètres de sécurité
                    },
                    color: Colors.green.shade100,
                    iconColor: Colors.green.shade700,
                  ),
                  _buildRoundedButton(
                    icon: Icons.sync,
                    label: 'Change email or\nnumber',
                    onTap: () {
                      // Logique pour changer l'email ou le numéro
                    },
                    color: Colors.green.shade100,
                    iconColor: Colors.green.shade700,
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Section Contacts
              Text(
                'contacts:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Options de contact
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 32),
                  _buildRoundedButton(
                    icon: Icons.smartphone,
                    label: 'Phone Number',
                    onTap: () {
                      // Logique pour gérer le numéro de téléphone
                    },
                    color: Colors.green.shade100,
                    iconColor: Colors.green.shade700,
                    width: 120,
                  ),
                  const SizedBox(width: 32),
                  _buildRoundedButton(
                    icon: Icons.email,
                    label: 'Email',
                    onTap: () {
                      // Logique pour gérer l'email
                    },
                    color: Colors.green.shade100,
                    iconColor: Colors.green.shade700,
                    width: 120,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Wallet Balance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${user.walletBalance.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Total Service',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Text(
            '${user.totalServices}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    required Color iconColor,
    double width = 90,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: width,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 32,
              color: iconColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: width,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// Classe utilitaire pour gérer l'authentification
class AuthService {
  Future<User?> loginUser(String email, String password) async {
    // À implémenter avec votre backend
    // Exemple de simulation:
    await Future.delayed(const Duration(seconds: 2));
    return User(
      name: 'Bzg a_hafidh',
      imageUrl: 'assets/profile_image.jpg',
      isAdmin: true,
      walletBalance: 5000.68,
      totalServices: 35,
    );
  }

  Future<void> registerUser(String name, String email, String password) async {
    // À implémenter avec votre backend
    await Future.delayed(const Duration(seconds: 2));
    return;
  }

  Future<void> logoutUser() async {
    // À implémenter avec votre backend
    await Future.delayed(const Duration(seconds: 1));
    return;
  }
}

// Classe pour gérer les réservations d'espace co-working
class BookingService {
  Future<List<Map<String, dynamic>>> getUserBookings(String userId) async {
    // À implémenter avec votre backend
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'id': '1',
        'spaceName': 'Desk Space A',
        'date': '2025-05-20',
        'startTime': '09:00',
        'endTime': '17:00',
        'price': 25.0,
      },
      {
        'id': '2',
        'spaceName': 'Meeting Room B',
        'date': '2025-05-22',
        'startTime': '14:00',
        'endTime': '16:00',
        'price': 45.0,
      },
    ];
  }

  Future<bool> createBooking(Map<String, dynamic> bookingData) async {
    // À implémenter avec votre backend
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> cancelBooking(String bookingId) async {
    // À implémenter avec votre backend
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}

// Classe pour gérer les transactions du portefeuille
class WalletService {
  Future<List<Map<String, dynamic>>> getTransactionHistory(String userId) async {
    // À implémenter avec votre backend
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'id': 'tx1',
        'type': 'debit',
        'amount': 25.0,
        'description': 'Booking: Desk Space A',
        'date': '2025-05-15',
      },
      {
        'id': 'tx2',
        'type': 'credit',
        'amount': 100.0,
        'description': 'Wallet Recharge',
        'date': '2025-05-10',
      },
    ];
  }

  Future<bool> addFunds(String userId, double amount) async {
    // À implémenter avec votre backend
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}

// Écran de connexion (à implémenter)
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome to Co-working Space',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (_emailController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all fields'),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        final user = await _authService.loginUser(
                          _emailController.text,
                          _passwordController.text,
                        );

                        if (user != null) {
                          // Navigation vers l'écran principal après connexion
                          if (mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsScreen(),
                              ),
                            );
                          }
                        } else {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid credentials'),
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${e.toString()}'),
                            ),
                          );
                        }
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Navigation vers l'écran d'inscription
              },
              child: const Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}