import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/core/constants/constants.dart';
import 'package:weather/feature/feature_bookmark/domain/entity/save_city_entity.dart';
import 'package:weather/feature/feature_bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:weather/feature/feature_bookmark/presentation/bloc/get_all_city_status.dart';
import 'package:weather/feature/feature_weather/presentation/bloc/home_bloc.dart';

class BookMarkScreen extends StatelessWidget {
  final PageController pageController;

  const BookMarkScreen({Key? key, required this.pageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    BlocProvider.of<BookmarkBloc>(context).add(GetAllCityEvent());

    return BlocBuilder<BookmarkBloc, BookmarkState>(
      buildWhen: (previous, current) {
        /// rebuild UI just when allCityStatus Changed
        if (current.getAllCityStatus == previous.getAllCityStatus) {
          return false;
        } else {
          return true;
        }
      },
      builder: (context, state) {
        /// show Loading for AllCityStatus
        if (state.getAllCityStatus is GetAllCityLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        /// show Completed for AllCityStatus
        if (state.getAllCityStatus is GetAllCityCompleted) {
          /// casting for getting cities
          GetAllCityCompleted getAllCityCompleted =
              state.getAllCityStatus as GetAllCityCompleted;
          List<City> cities = getAllCityCompleted.cities;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'WatchList',
                    style: TextStyle(
                        color: Color(0xff003555),
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    /// show text in center if there is no city bookmarked
                    child: (cities.isEmpty)
                        ? const Center(
                            child: Text(
                              'there is no bookmark city',
                              style: TextStyle(color: Color(0xff003555)),
                            ),
                          )
                        : ListView.builder(
                            itemCount: cities.length,
                            itemBuilder: (context, index) {
                              City city = cities[index];
                              return GestureDetector(
                                onTap: () {
                                  /// call for getting bookmarked city Data
                                  BlocProvider.of<HomeBloc>(context)
                                      .add(LoadCwEvent(city.name));
                                  cityName = city.name;

                                  /// animate to HomeScreen for showing Data
                                  pageController.animateToPage(
                                    0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: width,
                                      height: 70.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffdef3ff),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              city.name,
                                              style: const TextStyle(
                                                color: Color(0xff003555),
                                                fontSize: 20,
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  BlocProvider.of<BookmarkBloc>(
                                                          context)
                                                      .add(DeleteCityEvent(
                                                          city.name));
                                                  BlocProvider.of<BookmarkBloc>(
                                                          context)
                                                      .add(GetAllCityEvent());
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Color(0xff003555),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              );
                            }),
                  ),
                ],
              ),
            ),
          );
        }

        /// show Error for AllCityStatus
        if (state.getAllCityStatus is GetAllCityError) {
          /// casting for getting Error
          GetAllCityError getAllCityError =
              state.getAllCityStatus as GetAllCityError;

          return Center(
            child: Text(getAllCityError.message!),
          );
        }

        /// show Default value
        return Container();
      },
    );
  }
}
