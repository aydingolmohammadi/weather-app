import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/core/widget/main_wrapper.dart';
import 'package:weather/feature/feature_bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:weather/feature/feature_weather/presentation/bloc/home_bloc.dart';
import 'package:weather/locator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => locator<HomeBloc>()),
                BlocProvider(create: (_) => locator<BookmarkBloc>()),
              ],
              child: MainWrapper(),
            ),
          ),
          (route) => false,
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Image.asset('assets/images/icon.jpg'),
        ),
      ),
    );
  }
}
