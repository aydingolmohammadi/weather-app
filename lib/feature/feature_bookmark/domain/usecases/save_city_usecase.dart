import 'package:weather/core/resources/data_state.dart';
import 'package:weather/core/usecase/use_case.dart';
import 'package:weather/feature/feature_bookmark/domain/entity/save_city_entity.dart';
import 'package:weather/feature/feature_bookmark/domain/repository/save_city_repository.dart';

class SaveCityUseCase implements UseCase<DataState<City>, String>{
  final CityRepository _cityRepository;
  SaveCityUseCase(this._cityRepository);

  @override
  Future<DataState<City>> call({required String params}) {
    return _cityRepository.saveCityToDB(params);
  }
}