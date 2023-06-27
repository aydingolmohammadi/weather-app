import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:weather/feature/feature_weather/domain/entities/forecase_days_entity.dart';

@immutable
abstract class FwStatus extends Equatable{}

class FwLoading extends FwStatus{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class FwCompleted extends FwStatus{
  final ForecastDaysEntity forecastDaysEntity;
  FwCompleted(this.forecastDaysEntity);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class FwError extends FwStatus{
  final String? message;
  FwError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}