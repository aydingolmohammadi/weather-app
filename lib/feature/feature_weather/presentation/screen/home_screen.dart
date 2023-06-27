import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:weather/core/constants/constants.dart';
import 'package:weather/feature/feature_bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:weather/feature/feature_weather/data/models/ForcastDaysModel.dart';
import 'package:weather/feature/feature_weather/data/models/suggest_city_model.dart';
import 'package:weather/feature/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weather/feature/feature_weather/domain/entities/forecase_days_entity.dart';
import 'package:weather/feature/feature_weather/domain/params/forcast_param.dart';
import 'package:weather/feature/feature_weather/domain/use_cases/get_suggestion_city_usecase.dart';
import 'package:weather/feature/feature_weather/presentation/bloc/cw_status.dart';
import 'package:weather/feature/feature_weather/presentation/bloc/fw_status.dart';
import 'package:weather/feature/feature_weather/presentation/bloc/home_bloc.dart';
import 'package:weather/feature/feature_weather/presentation/widgets/bookmark_icon.dart';
import 'package:weather/locator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List daysList = [
    '31 May',
    '1 June',
    '2 June',
    '3 June',
    '4 June',
    '5 June',
    '6 June',
    '7 June',
  ];
  TextEditingController textEditingController = TextEditingController();
  GetSuggestionCityUseCase getSuggestionCityUseCase =
      GetSuggestionCityUseCase(locator());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(cityName));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) {
        if (previous.cwStatus == current.cwStatus) {
          return false;
        } else {
          return true;
        }
      },
      builder: (context, state) {
        if (state.cwStatus is CwLoading) {
          return Center(
            child: SpinKitThreeBounce(
              color: Colors.grey[400],
              size: 20,
            ),
          );
        }
        if (state.cwStatus is CwCompleted) {
          /// cast
          final CwCompleted cwCompleted = state.cwStatus as CwCompleted;
          final CurrentCityEntity currentCityEntity =
              cwCompleted.currentCityEntity;

          /// create params for api call
          final ForecastParams forecastParams = ForecastParams(
              currentCityEntity.coord!.lat!, currentCityEntity.coord!.lon!);

          /// start load Fw event+
          BlocProvider.of<HomeBloc>(context).add(LoadFwEvent(forecastParams));

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xffdef3ff),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          onSubmitted: (String prefix) {
                            textEditingController.text = '';
                            if (textEditingController.text.isNotEmpty) {
                              BlocProvider.of<HomeBloc>(context)
                                  .add(LoadCwEvent(prefix));
                            }
                          },
                          controller: textEditingController,
                          style: DefaultTextStyle.of(context).style.copyWith(
                                fontSize: 20,
                                color: const Color(0xff003555),
                              ),
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              color: Color(0xff003555),
                              fontSize: 18,
                              fontFamily: 'iransans',
                            ),
                            prefixIcon: InkWell(
                              child: Icon(
                                Icons.search,
                                size: 23,
                                color: Color(0xff003555),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                        suggestionsCallback: (String prefix) {
                          return getSuggestionCityUseCase(params: prefix);
                        },
                        itemBuilder: (context, Data model) {
                          return ListTile(
                            leading: const Icon(Icons.location_on),
                            title: Text(model.name!),
                            subtitle:
                                Text("${model.region!}, ${model.country!}"),
                          );
                        },
                        onSuggestionSelected: (Data model) {
                          textEditingController.text = '';
                          BlocProvider.of<HomeBloc>(context).add(
                            LoadCwEvent(model.name!),
                          );
                          cityName = model.name!;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        /// Name and Weather
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currentCityEntity.name.toString(),
                                  style: const TextStyle(
                                    color: Color(0xff003555),
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                BlocBuilder<HomeBloc, HomeState>(
                                    buildWhen: (previous, current){
                                      if(previous.cwStatus == current.cwStatus){
                                        return false;
                                      }
                                      return true;
                                    },
                                    builder: (context, state){
                                      /// show Loading State for Cw
                                      if (state.cwStatus is CwLoading) {
                                        return const CircularProgressIndicator();
                                      }

                                      /// show Error State for Cw
                                      if (state.cwStatus is CwError) {
                                        return IconButton(
                                          onPressed: (){
                                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            //   content: Text("please load a city!"),
                                            //   behavior: SnackBarBehavior.floating, // Add this line
                                            // ));
                                          },
                                          icon: const Icon(Icons.error,color: Colors.white,size: 35),);
                                      }

                                      if(state.cwStatus is CwCompleted){
                                        final CwCompleted cwComplete = state.cwStatus as CwCompleted;
                                        BlocProvider.of<BookmarkBloc>(context).add(GetCityByNameEvent(cwComplete.currentCityEntity.name!));
                                        return BookMarkIcon(name: cwComplete.currentCityEntity.name!);
                                      }

                                      return Container();

                                    }
                                ),
                              ],
                            ),
                            Text(
                              currentCityEntity.weather![0].main.toString(),
                              style: const TextStyle(
                                color: Color(0xff003555),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        /// Images
                        Center(
                          child: Column(
                            children: [
                              // clear sky
                              if (currentCityEntity.weather![0].icon == '01d')
                                SizedBox(
                                  height: 200,
                                  width: 300,
                                  child: SvgPicture.asset(
                                    'assets/images/Component 3.svg',
                                  ),
                                ),

                              // few clouds
                              if (currentCityEntity.weather![0].icon == '02d' ||
                                  currentCityEntity.weather![0].icon == '03d' ||
                                  currentCityEntity.weather![0].icon == '04d')
                                SizedBox(
                                  height: 200,
                                  width: 300,
                                  child: SvgPicture.asset(
                                    'assets/images/Component 4.svg',
                                  ),
                                ),

                              // clouds
                              if (currentCityEntity.weather![0].icon == '50d')
                                SizedBox(
                                  height: 200,
                                  width: 300,
                                  child: SvgPicture.asset(
                                    'assets/images/Component 1.svg',
                                  ),
                                ),

                              // rain
                              if (currentCityEntity.weather![0].icon == '09d' ||
                                  currentCityEntity.weather![0].icon == '10d')
                                SizedBox(
                                  height: 200,
                                  width: 300,
                                  child: SvgPicture.asset(
                                    'assets/images/Component 6.svg',
                                  ),
                                ),

                              // thunderstorm
                              if (currentCityEntity.weather![0].icon == '11d')
                                SizedBox(
                                  height: 200,
                                  width: 300,
                                  child: SvgPicture.asset(
                                    'assets/images/Component 5.svg',
                                  ),
                                ),
                            ],
                          ),
                        ),

                        /// Weather temp
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Temp
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${currentCityEntity.main!.temp?.toInt()}',
                                    style: const TextStyle(
                                      color: Color(0xff003555),
                                      fontSize: 50,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    'assets/images/Ellipse 6.svg',
                                    color: const Color(0xff003555),
                                  ),
                                ],
                              ),

                              /// TempMax
                              Row(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${currentCityEntity.main!.tempMax?.toInt()}',
                                        style: const TextStyle(
                                          color: Color(0xff003555),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SvgPicture.asset(
                                        'assets/images/Ellipse 6.svg',
                                        color: const Color(0xff003555),
                                        height: 5,
                                      ),
                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Container(
                                      width: 1,
                                      height: 20,
                                      color: const Color(0xff003555),
                                    ),
                                  ),

                                  /// TempMin
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${currentCityEntity.main!.tempMin?.toInt()}',
                                        style: const TextStyle(
                                          color: Color(0xff90d5ff),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SvgPicture.asset(
                                        'assets/images/Ellipse 6.svg',
                                        color: const Color(0xff90d5ff),
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SvgPicture.asset(
                              'assets/images/Vector.svg',
                              height: 20,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SvgPicture.asset(
                              'assets/images/Component 2.svg',
                              height: 31,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '${currentCityEntity.wind!.speed?.toInt()} km/h',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${currentCityEntity.main!.humidity?.toInt()} %',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xffdef3ff),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                            child: BlocBuilder<HomeBloc, HomeState>(
                              builder: (BuildContext context, state) {
                                if (state.fwStatus is FwLoading) {
                                  return Center(
                                    child: SpinKitThreeBounce(
                                      color: Colors.grey[400],
                                      size: 20,
                                    ),
                                  );
                                }

                                if (state.fwStatus is FwCompleted) {
                                  /// casting
                                  final FwCompleted fwCompleted =
                                      state.fwStatus as FwCompleted;
                                  final ForecastDaysEntity forecastDaysEntity =
                                      fwCompleted.forecastDaysEntity;
                                  final List<Daily> mainDaily =
                                      forecastDaysEntity.daily!;

                                  return ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: mainDaily.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Container(
                                          height: 100,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff005a90),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              /// Date
                                              Text(
                                                daysList[index],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),

                                              /// Icon
                                              const Icon(
                                                Icons.sunny_snowing,
                                                color: Color(0xff90d5ff),
                                                size: 35,
                                              ),

                                              /// Temp
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${mainDaily[index].temp!.day!.toInt()}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SvgPicture.asset(
                                                    'assets/images/Ellipse 6.svg',
                                                    color: Colors.white,
                                                    height: 5,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }

                                if (state.fwStatus is FwError) {
                                  final FwError fwError =
                                      state.fwStatus as FwError;
                                  return Center(
                                    child: Text(fwError.message!),
                                  );
                                }

                                return Container();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (state.cwStatus is CwError) {
          final CwError cwError = state.cwStatus as CwError;
          return Center(
            child: Text(cwError.message),
          );
        }
        return Container();
      },
    );
  }
}
