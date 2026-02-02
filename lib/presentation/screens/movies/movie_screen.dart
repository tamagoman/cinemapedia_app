import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_by_movie_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';
  final String movieId;
  
  const MovieScreen({
    super.key, 
    required this.movieId
  });

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie( widget.movieId );
    ref.read(actorsByMovieProvider.notifier).loadActorsByMovie( widget.movieId );
  }

  @override
  Widget build(BuildContext context) {

    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if( movie == null ) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator( strokeWidth: 2,),
        ),
      );
    }
    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(movie: movie),
              childCount: 1
            )
          )
        ]
      )
    );
  }  
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),

              const SizedBox(width: 10,),

              SizedBox(
                width: (size.width - 40) * 0.7 - 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text( 
                      movie.title,
                      style: textStyles.titleLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Text( 
                      movie.overview,
                      style: textStyles.bodyMedium,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

        //Movie Genres
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            spacing: 10,
            children: [
              ...movie.genreIds.map((genreId) => Chip(
                  label: Text( 
                    genreId.toString(),
                    style: textStyles.bodyMedium?.copyWith( color: Colors.white ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  backgroundColor: Colors.indigo,
                )
              )
            ],
          ),
        ),
     
        _ActorsByMovie(movieId:  movie.id.toString()),

        const SizedBox(height: 50),
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final actorsByMovie = ref.watch( actorsByMovieProvider );

    if( actorsByMovie[movieId.toString()] == null ) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator( strokeWidth: 2,),
        ),
      );
    }

    if( actorsByMovie[movieId.toString()] != null ) {
      final actors = actorsByMovie[movieId.toString()]!;

      return SizedBox(
        height: 300,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: actors.length,
          itemBuilder: (context, index) {
            final actor = actors[index];
            return Container(
              width: 135,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInRight(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        actor.profilePath,
                        width: 135,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    actor.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    actor.character??'',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle( 
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return Container();
    
  }
}


class _CustomSliverAppBar extends StatelessWidget {
    final Movie movie;

    const _CustomSliverAppBar({
      required this.movie,
    });

    @override
    Widget build(BuildContext context) {
      final size = MediaQuery.of(context).size;
      return SliverAppBar(
        backgroundColor: Colors.black,
        expandedHeight: size.height * 0.7,
        foregroundColor: Colors.white,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.symmetric( horizontal: 10, vertical: 5),
          // title: Text( 
          //   movie.title,
          //   style: const TextStyle( 
          //     fontSize: 20,
          //     color: Colors.white
          //     // overflow: TextOverflow.ellipsis
          //   ),
          //   textAlign: TextAlign.start,
            
          // ),
          background: Stack(
            children: [
              SizedBox.expand(
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if( loadingProgress != null ) {
                      return SizedBox(
                        width: size.width,
                        height: size.height * 0.7,
                        child: const Center(
                          child: CircularProgressIndicator( strokeWidth: 2,),
                        ),
                      );
                    }
                    return FadeIn(child: child);
                  },
                ),
              ),
              const SizedBox.expand(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.7, 1.0],
                      colors: <Color>[
                        Colors.transparent,
                        Colors.black,
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox.expand(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      stops: [0.0, 0.2],
                      colors: <Color>[
                        Colors.black,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              
            ],
          ),
          // background: FadeInImage(
          //   placeholder: const AssetImage('assets/loading.gif'),
          //   image: NetworkImage( movie.posterPath ),
          //   fit: BoxFit.cover,
          // ),
          
        ),
      );
    }
  } 