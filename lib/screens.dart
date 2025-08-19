import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SplashScreen: Displays the initial welcome screen with a short animation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Increased to 3 seconds
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
    _checkSetup();
  }

  Future<void> _checkSetup() async {
    await Future.delayed(const Duration(seconds: 3)); // Match animation duration
    final prefs = await SharedPreferences.getInstance();
    final String? userName = prefs.getString('user_name');
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => userName == null ? const NameInputScreen() : const CharacterSelectionScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A2C2A), Color(0xFFD4A59A)],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', width: 120, height: 120, fit: BoxFit.contain),
                const SizedBox(height: 20),
                const Text(
                  'Welcome to TimeForge',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF9F5F2),
                    fontSize: 36,
                    letterSpacing: 2,
                    shadows: [Shadow(color: Color(0xFF7E5D5A), blurRadius: 5, offset: Offset(1, 1))],
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset('assets/mascot/waving.png', width: 90, height: 90, fit: BoxFit.contain),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// NameInputScreen: Allows user to enter their name and proceed
class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  _NameInputScreenState createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _controller.text);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CharacterSelectionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A2C2A), Color(0xFFD4A59A)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'What’s your name?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF9F5F2),
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  style: const TextStyle(color: Color(0xFFF9F5F2)),
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: const TextStyle(color: Color(0xFF7E6363)),
                    filled: true,
                    fillColor: const Color(0xFF4A2C2A).withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveName,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A59A),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text('Next', style: TextStyle(fontSize: 18, color: Color(0xFF4A2C2A))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// CharacterSelectionScreen: Displays clickable character options for user to choose
class CharacterSelectionScreen extends StatefulWidget {
  const CharacterSelectionScreen({super.key});

  @override
  _CharacterSelectionScreenState createState() => _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  String? _selectedCharacter;

  void _selectCharacter(String character) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_character', character);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeDashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A2C2A), Color(0xFFD4A59A)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'Choose Your Guide',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF9F5F2),
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 30),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildCharacterCard('Planner', 'Master of schedules', 'assets/mascot/planner.png', () => _selectCharacter('Planner')),
                  _buildCharacterCard('Explorer', 'Adventurer of tasks', 'assets/mascot/explorer.png', () => _selectCharacter('Explorer')),
                  _buildCharacterCard('Warrior', 'Conqueror of goals', 'assets/mascot/warrior.png', () => _selectCharacter('Warrior')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterCard(String name, String description, String imagePath, VoidCallback onTap) {
    final isSelected = _selectedCharacter == name;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: isSelected ? const Color(0xFFD4A59A).withOpacity(0.9) : const Color(0xFF4A2C2A).withOpacity(0.9),
          elevation: isSelected ? 6 : 2,
          child: SizedBox(
            width: 120,
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imagePath, width: 80, height: 80, fit: BoxFit.contain),
                const SizedBox(height: 10),
                Text(name, style: const TextStyle(color: Color(0xFFF9F5F2), fontFamily: 'Poppins', fontSize: 18)),
                Text(description, style: const TextStyle(color: Color(0xFF7E6363), fontSize: 12), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// HomeDashboard: Displays the main app screen after character selection
class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TimeForge', style: TextStyle(color: Color(0xFFF9F5F2)))),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A2C2A), Color(0xFFD4A59A)],
          ),
        ),
        child: const Center(child: Text('Home Dashboard', style: TextStyle(color: Color(0xFFF9F5F2)))),
      ),
    );
  }
}