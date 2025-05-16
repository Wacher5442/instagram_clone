import 'package:flutter/material.dart';

import '../../models/story_model.dart';

class StoryCard extends StatelessWidget {
  final StoryModel story;

  const StoryCard({
    Key? key,
    required this.story,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(story.storyPhotoUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(90),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(story.userName),
          ],
        ),
        Positioned(
          top: 55,
          child: Container(
            height: 25,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Image.asset(story.userPhotoUrl),
          ),
        ),
      ],
    );
  }
}
