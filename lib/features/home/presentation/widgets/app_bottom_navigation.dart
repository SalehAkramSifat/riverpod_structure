import 'package:flutter/material.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTapped;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) => onTapped(index),
      currentIndex: currentIndex,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.movie), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: '')
      ],
    );
  }
}
