import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class BottomNav extends StatefulWidget {
  PageController controller;
  int currentIndex;

  BottomNav({
    Key? key,
    required this.controller,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffdef3ff),
          borderRadius: BorderRadius.circular(20),
        ),
        height: 80,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          currentIndex: widget.currentIndex,
          onTap: (value) {
            setState(() {
              widget.currentIndex = value;
            });
          },
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.red.shade700,
          items: const [
            BottomNavigationBarItem(
              label: '',
              icon: HeroIcon(
                HeroIcons.home,
                style: HeroIconStyle.outline,
                size: 30,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: HeroIcon(
                HeroIcons.bookmark,
                style: HeroIconStyle.outline,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
