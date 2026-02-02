

import 'package:dio/dio.dart';
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';


class ActorMoviedbDatasource extends ActorsDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.theMovieDbKey,
      'language': 'es-MX'
    },
  ));

  List<Actor> _jsonToActors( Map<String, dynamic> jsonData) {
    final actorResponse = CreditsResponse.fromJson(jsonData);

    final List<Actor> actors = actorResponse.cast
      //.where((actor) => actor.profilePath != 'no-image')  //ONLY actors with image
      .map(
        (actor) => ActorMapper.castToEntity(actor)
      ).toList();
    
    return actors;
  }
  
  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');

    return _jsonToActors(response.data);
  }
}