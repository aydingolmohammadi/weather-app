import 'package:weather/core/resources/data_state.dart';
import 'package:weather/core/usecase/use_case.dart';
import 'package:weather/feature/feature_bookmark/domain/repository/save_city_repository.dart';

class DeleteCityUseCase implements UseCase<DataState<String>, String>{
  final CityRepository _cityRepository;
  DeleteCityUseCase(this._cityRepository);

  @override
  Future<DataState<String>> call({required String params}) {
    return _cityRepository.deleteCityByName(params);
  }
}