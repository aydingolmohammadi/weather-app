import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:weather/feature/feature_bookmark/presentation/screen/book_mark_screen.dart';
import 'package:weather/feature/feature_weather/presentation/screen/home_screen.dart';

class MainWrapper extends StatefulWidget {
  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: 0);
    List<Widget> pageViewWidget = [
      const HomeScreen(),
      BookMarkScreen(pageController: pageController),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xffdef3ff),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              child: const SizedBox(
                width: 40,
                height: 40,
                child: HeroIcon(
                  HeroIcons.home,
                  style: HeroIconStyle.outline,
                  size: 35,
                  color: Color(0xff003555),
                ),
              ),
              onTap: () {
                pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
            InkWell(
              child: const SizedBox(
                width: 40,
                height: 40,
                child: HeroIcon(
                  HeroIcons.bookmark,
                  style: HeroIconStyle.outline,
                  size: 35,
                  color: Color(0xff003555),
                ),
              ),
              onTap: () {
                pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ],
        )
      ),
      body: PageView(
        physics: const BouncingScrollPhysics(),
        controller: pageController,
        children: pageViewWidget,
      )
    );
  }
}
