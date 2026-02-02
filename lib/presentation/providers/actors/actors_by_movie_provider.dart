import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/legacy.dart';

final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>((ref) {
  final actorRepository = ref.watch( actorsRepositoryProvider );

  return ActorsByMovieNotifier( getActorsByMovie: actorRepository.getActorsByMovie );
});

/*
Will return something like this:
{
  'movieId1': <Actor>[],
  'movieId2': <Actor>[],
}
*/

typedef GetActorsByMovieCallback = Future<List<Actor>>Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorsByMovieCallback getActorsByMovie;

  ActorsByMovieNotifier({
    required this.getActorsByMovie,
  }): super({});

  Future<void> loadActorsByMovie( String movieId) async {
    if( state[movieId] != null ) return;
    //print('[[[Loading actors by movie from API $movieId]]]');
    final List<Actor>actors = await getActorsByMovie( movieId );

    state = {
      ...state,
      movieId: actors
    };
  }
  
}