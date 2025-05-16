import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../models/photo_model.dart';

class PhotoTile extends StatefulWidget {
  final PhotoModel photo;
  final bool isLiked;
  final VoidCallback onLikeToggle;

  const PhotoTile({
    Key? key,
    required this.photo,
    required this.isLiked,
    required this.onLikeToggle,
  }) : super(key: key);

  @override
  State<PhotoTile> createState() => _PhotoTileState();
}

class _PhotoTileState extends State<PhotoTile> {
  bool _isImageLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shadowColor: Colors.white,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              if (!_isImageLoaded)
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 300,
                    color: Colors.white,
                  ),
                ),
              Image.network(
                widget.photo.imageUrl,
                fit: BoxFit.cover,
                height: 620,
                width: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    // Une fois chargé, on met à jour l'état
                    Future.microtask(() {
                      if (!_isImageLoaded) {
                        setState(() {
                          _isImageLoaded = true;
                        });
                      }
                    });
                    return child;
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              Positioned(
                top: 8,
                left: 5,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/profile.jpg"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Jeremyyeo54",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Icon(
                              Icons.verified,
                              color: Colors.white,
                              size: 12,
                            )
                          ],
                        ),
                        Text(
                          "Suggestions",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                top: 12,
                right: 10,
                child: Row(
                  children: [
                    Container(
                      width: 65,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        "Suivre",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Icon(
                      Icons.more_vert,
                      size: 16,
                      color: Colors.white,
                    )
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: widget.onLikeToggle,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 5, right: 5),
                          child: Icon(
                            widget.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.isLiked ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),
                      Text('33 K')
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5, left: 15),
                        child: Image.asset(
                          'assets/images/chat.png',
                          height: 20,
                        ),
                      ),
                      Text('112')
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 5),
                        child: Image.asset(
                          'assets/images/send.png',
                          height: 20,
                        ),
                      ),
                      Text('87')
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.bookmark_border_sharp,
                  color: Colors.black,
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: const Text(
              "80 000 J'aime",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 20),
            child: Text(
              widget.photo.description,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
