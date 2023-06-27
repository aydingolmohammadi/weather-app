import 'package:weather/core/resources/data_state.dart';
import 'package:weather/feature/feature_bookmark/domain/entity/save_city_entity.dart';

abstract class CityRepository{

  Future<DataState<City>> saveCityToDB(String cityName);

  Future<DataState<List<City>>> getAllCityFromDB();

  Future<DataState<City?>> findCityByName(String name);

  Future<DataState<String>> deleteCityByName(String name);


}