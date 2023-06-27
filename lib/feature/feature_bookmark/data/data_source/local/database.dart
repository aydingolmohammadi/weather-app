import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:weather/feature/feature_bookmark/data/data_source/local/save_city_dao.dart';
import 'package:weather/feature/feature_bookmark/domain/entity/save_city_entity.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [City])
abstract class AppDatabase extends FloorDatabase {
  CityDao get cityDao;
}