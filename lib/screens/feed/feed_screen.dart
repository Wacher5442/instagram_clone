import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../blocs/feed/feed_bloc.dart';
import '../../blocs/feed/feed_event.dart';
import '../../blocs/feed/feed_state.dart';
import '../../core/utils/stories_list.dart';
import '../../repositories/unsplash_repository.dart';
import '../../widgets/add_story_card.dart';
import '../../widgets/photo_tile.dart';
import '../../widgets/story_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late FeedBloc _feedBloc;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // Initialisation du FeedBloc avec le repository
    _feedBloc = FeedBloc(UnsplashRepository())..add(FetchPhotos());

    // Contrôle du scroll pour charger les données de manière paresseuse (lazy loading)
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  // Déclenche le chargement des photos lorsque l'utilisateur approche du bas de la liste
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_feedBloc.isFetching) {
      _feedBloc.add(FetchPhotos());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _feedBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Récupération du bloc pour envoyer les événements (comme ToggleLike)
    final feedBloc = _feedBloc;

    return BlocProvider.value(
      value: _feedBloc,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 55, left: 16, right: 16, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset('assets/svg/ic_instagram.svg', height: 32),
                  Row(
                    children: [
                      Icon(Icons.favorite_border),
                      const SizedBox(width: 20),
                      Image.asset(
                        'assets/images/send.png',
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 0),
              child: SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: storiesList.length + 1,
                  itemBuilder: (context, index) {
                    // afficher les stories du l'utilisateur
                    if (index == 0) {
                      return const AddStoryCard();
                    }

                    final story = storiesList[index - 1];
                    return StoryCard(story: story);
                  },
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<FeedBloc, FeedState>(
                builder: (context, state) {
                  // Affiche un loader au démarrage
                  if (state is FeedLoading && (state is! FeedLoaded)) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // Affiche les photos avec le bouton "like"
                  else if (state is FeedLoaded) {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: 10),
                      controller: _scrollController,
                      itemCount: state.photos.length + 1,
                      itemBuilder: (context, index) {
                        if (index < state.photos.length) {
                          final photo = state.photos[index];
                          final isLiked = state.likedPhotoIds.contains(
                              photo.id); // Vérifie si cette photo est likée

                          return PhotoTile(
                            photo: photo,
                            isLiked: isLiked,
                            // Envoie l’événement pour liker ou unliker la photo
                            onLikeToggle: () =>
                                feedBloc.add(ToggleLike(photo.id)),
                          );
                        } else {
                          // Affiche un loader en bas de la liste si d'autres éléments sont en cours de chargement
                          return state.hasReachedMax
                              ? const SizedBox.shrink()
                              : const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                        }
                      },
                    );
                  }
                  // Affiche l’erreur en cas de problème
                  else if (state is FeedError) {
                    return Center(child: Text(state.message));
                  }
                  // Cas initial
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        // Barre de navigation en bas
        bottomNavigationBar: Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.white)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem("assets/images/house.png", 0),
              _buildNavItem("assets/images/search.png", 1),
              _buildNavItem("assets/images/more.png", 2),
              _buildNavItem("assets/images/movie.png", 3),
              _buildNavItem("assets/images/profil.png", 4),
            ],
          ),
        ),
      ),
    );
  }

  // Index de l'onglet actuellement sélectionné
  int _currentIndex = 0;

  // Liste des écrans correspondant à chaque onglet
  // final List<Widget> _screens = [
  //   FeedScreen(),
  //   FeedScreen(),
  //   FeedScreen(),
  //   FeedScreen(),
  //   FeedScreen(),
  // ];

  Widget _buildNavItem(String icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Image.asset(
          icon,
          height: 25,
          width: 25,
          color: _currentIndex == index ? Colors.black : Colors.black54,
        ),
      ),
    );
  }
}
