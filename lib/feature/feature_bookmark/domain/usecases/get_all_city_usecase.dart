import 'package:weather/core/resources/data_state.dart';
import 'package:weather/core/usecase/use_case.dart';
import 'package:weather/feature/feature_bookmark/domain/entity/save_city_entity.dart';
import 'package:weather/feature/feature_bookmark/domain/repository/save_city_repository.dart';

class GetAllCityUseCase implements UseCase<DataState<List<City>>, NoParams>{
  final CityRepository _cityRepository;
  GetAllCityUseCase(this._cityRepository);

  @override
  Future<DataState<List<City>>> call({required NoParams params}) {
    return _cityRepository.getAllCityFromDB();
  }
}