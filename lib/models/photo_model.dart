class PhotoModel {
  final String id;
  final String imageUrl;
  final String description;

  PhotoModel({
    required this.id,
    required this.imageUrl,
    required this.description,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'],
      imageUrl: json['urls']['regular'],
      description: json['description'] ?? 'Sans description',
    );
  }
}
