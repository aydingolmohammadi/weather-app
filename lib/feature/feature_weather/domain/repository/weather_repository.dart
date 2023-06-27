import 'package:weather/core/resources/data_state.dart';
import 'package:weather/feature/feature_weather/data/models/suggest_city_model.dart';
import 'package:weather/feature/feature_weather/domain/entities/current_city_entity.dart';
import 'package:weather/feature/feature_weather/domain/entities/forecase_days_entity.dart';
import 'package:weather/feature/feature_weather/domain/params/forcast_param.dart';

abstract class WeatherRepository {
  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(
      {required String cityName});

  Future<DataState<ForecastDaysEntity>> sendRequest7DaysForcast(
      {required ForecastParams params});

  Future<List<Data>> fetchSuggestData(cityName);
}
