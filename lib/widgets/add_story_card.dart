import 'package:flutter/material.dart';
import 'package:instagram_clone/core/utils/colors.dart';

class AddStoryCard extends StatelessWidget {
  const AddStoryCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 80,
              width: 80,
              child: Image.asset("assets/images/user.png"),
            ),
            const SizedBox(height: 10),
            Text("Votre story"),
          ],
        ),
        Positioned(
          top: 60,
          right: 5,
          child: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              color: blackColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Icon(
              Icons.add,
              size: 15,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
