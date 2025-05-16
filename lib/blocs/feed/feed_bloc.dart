import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/storage/like_storage.dart';
import 'feed_event.dart';
import 'feed_state.dart';
import '../../repositories/unsplash_repository.dart';
import '../../models/photo_model.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final UnsplashRepository repository;
  int page = 1;
  final int perPage = 10;
  bool isFetching = false;
  // Ajout une instance de LikeStorage
  final LikeStorage _likeStorage = LikeStorage();

  FeedBloc(this.repository) : super(FeedInitial()) {
    on<FetchPhotos>(_onFetchPhotos);
    on<ToggleLike>(_onToggleLike);
  }

  // Gère le chargement des photos
  Future<void> _onFetchPhotos(
      FetchPhotos event, Emitter<FeedState> emit) async {
    try {
      if (state is FeedLoading) return;

      final currentState = state;
      List<PhotoModel> currentPhotos = [];

      if (currentState is FeedLoaded) {
        currentPhotos = currentState.photos;
      }

      emit(FeedLoading());

      final List<PhotoModel> photos =
          await repository.fetchPhotos(page, perPage);
      final List<PhotoModel> newPhotos = [...currentPhotos, ...photos];

      final hasReachedMax = photos.length < perPage;

      final likedPhotoIds = await _likeStorage.getLikedPhotos();
      emit(FeedLoaded(newPhotos,
          likedPhotoIds: likedPhotoIds, hasReachedMax: hasReachedMax));

      if (!hasReachedMax) {
        page++;
      }
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }

  // Gère le like/unlike et la mise à jour du stockage
  Future<void> _onToggleLike(ToggleLike event, Emitter<FeedState> emit) async {
    await _likeStorage.toggleLike(event.photoId);
    final updatedLikes = await _likeStorage.getLikedPhotos();

    if (state is FeedLoaded) {
      final current = state as FeedLoaded;
      emit(FeedLoaded(current.photos,
          likedPhotoIds: updatedLikes, hasReachedMax: current.hasReachedMax));
    }
  }
}
