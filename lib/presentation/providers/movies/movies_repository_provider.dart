
import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_impl.dart';

// This repository is inmutable 
final movieRepositoryProvider = Provider((_ref){

  return MovieRepositoryImpl( MoviedbDatasource() );
});