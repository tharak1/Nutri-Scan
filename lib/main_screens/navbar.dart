import 'package:flutter/material.dart';
import 'package:flutter_application_1/main_screens/homescreen.dart';
import 'package:flutter_application_1/main_screens/temp_screen.dart';
import 'package:flutter_application_1/recents/recent_screen.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  late int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> get _screens => [
        const RecentScreen(),
        const Homescreen(),
        const TempScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (index) async {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Recent',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner_rounded),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add Product',
          ),
        ],
      ),
    );
  }
}
