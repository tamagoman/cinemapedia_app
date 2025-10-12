

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {

  static const name = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _HomeView();
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {

  @override
  void initState() {
    super.initState();

    ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );

    if( nowPlayingMovies.isEmpty ) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator()
        ),
      );
    };

    return Scaffold(
      body: Column(
        children: [
          CustomAppbar(),

          MoviesSlideshow(movies: nowPlayingMovies)
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: nowPlayingMovies.length,
          //     itemBuilder: (context, index) {
          //       final movie = nowPlayingMovies[index];
            
          //       return ListTile(
          //         title: Text( movie.title ),
          //       );
          //     },
          //   ),
          // ),
        ]
      )
    );
  }
}