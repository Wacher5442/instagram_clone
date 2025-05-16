abstract class FeedEvent {}

// Déclenche le chargement des photos
class FetchPhotos extends FeedEvent {}

// Déclenche l'action de like ou unlike d'une photo
class ToggleLike extends FeedEvent {
  final String photoId;
  ToggleLike(this.photoId);
}
