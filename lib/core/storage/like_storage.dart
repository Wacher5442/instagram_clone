import 'package:shared_preferences/shared_preferences.dart';

class LikeStorage {
  static const _likedPhotosKey = 'likedPhotos';

  /// Récupère la liste des IDs d’images likées

  Future<Set<String>> getLikedPhotos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_likedPhotosKey)?.toSet() ?? {};
  }

  /// Enregistre une image comme likée ou dislikée
  Future<void> toggleLike(String photoId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentLikes = await getLikedPhotos();
    if (currentLikes.contains(photoId)) {
      currentLikes.remove(photoId);
    } else {
      currentLikes.add(photoId);
    }
    await prefs.setStringList(_likedPhotosKey, currentLikes.toList());
  }
}
