

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
    final slideShowMovies = ref.watch(moviesSlideshowProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar( 
            floating: true,
            flexibleSpace: const FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric( horizontal: 0 ),
              title: CustomAppbar()
            ),
            toolbarHeight: 70,
          ),

          SliverList(delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
                children: [              
                  MoviesSlideshow(movies: slideShowMovies),
              
                  MovieHorizontalListview(
                    movies: nowPlayingMovies,
                    title: 'En cines',
                    subTitle: 'Lunes 20/oct',
                    loadNextPage: (){ 
                      ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                    },
                  ),
              
                  MovieHorizontalListview(
                    movies: nowPlayingMovies,
                    title: 'Proximamente',
                    subTitle: 'Diciembre',
                    loadNextPage: (){ 
                      ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                    },
                  ),
              
                  MovieHorizontalListview(
                    movies: nowPlayingMovies,
                    title: 'Continuar viendo',
                    subTitle: 'Listado',
                    loadNextPage: (){ 
                      ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                    },
                  ),
                ]
              );
            },
            childCount: 1
          ))
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}