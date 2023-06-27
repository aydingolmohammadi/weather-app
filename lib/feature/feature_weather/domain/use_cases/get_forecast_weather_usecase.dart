import 'package:weather/core/resources/data_state.dart';
import 'package:weather/core/usecase/use_case.dart';
import 'package:weather/feature/feature_weather/domain/entities/forecase_days_entity.dart';
import 'package:weather/feature/feature_weather/domain/params/forcast_param.dart';
import 'package:weather/feature/feature_weather/domain/repository/weather_repository.dart';

class GetForecastWeatherUseCase implements UseCase<DataState<ForecastDaysEntity>, ForecastParams>{
  final WeatherRepository _weatherRepository;
  GetForecastWeatherUseCase(this._weatherRepository);

  @override
  Future<DataState<ForecastDaysEntity>> call({required ForecastParams params}) {
    return _weatherRepository.sendRequest7DaysForcast(params: params);
  }
}