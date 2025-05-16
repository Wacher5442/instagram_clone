import '../../models/photo_model.dart';

abstract class FeedState {}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<PhotoModel> photos;
  final bool hasReachedMax;
  final Set<String> likedPhotoIds;

  FeedLoaded(this.photos,
      {required this.likedPhotoIds, this.hasReachedMax = false});
}

class FeedError extends FeedState {
  final String message;
  FeedError(this.message);
}
