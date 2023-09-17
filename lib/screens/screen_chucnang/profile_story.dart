import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import '../../models/strory.dart';

class FullScreenStoryPage extends StatefulWidget {
  final List<StoryU> stories;
  final int initialStoryIndex;

  FullScreenStoryPage({
    Key? key,
    required this.stories,
    required this.initialStoryIndex,
  }) : super(key: key);

  @override
  _FullScreenStoryPageState createState() => _FullScreenStoryPageState();
}

class _FullScreenStoryPageState extends State<FullScreenStoryPage> {
  int currentStoryIndex = 0;

  @override
  void initState() {
    super.initState();
    currentStoryIndex = widget.initialStoryIndex;
    Timer(Duration(seconds: 5), () {
      // Automatically navigate to the next story
      _navigateToNextStory();
    });
  }

  void _navigateToHome() {
    if (Platform.isAndroid) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (Platform.isIOS) {
      Navigator.of(context).popUntil((route) => route.settings.name == '/');
    }
  }

  void _navigateToNextStory() {
    if (currentStoryIndex < widget.stories.length - 1) {
      setState(() {
        currentStoryIndex++;
      });
      Timer(Duration(seconds: 5), () {
        // Automatically navigate to the next story
        _navigateToNextStory();
      });
    } else {
      _navigateToHome();
      // You've reached the end of the stories, you can handle this case as needed.
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStory = widget.stories[currentStoryIndex];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: FittedBox(
              fit: BoxFit.cover,
              child: CachedNetworkImage(
                  fadeInDuration: Duration(milliseconds: 200),
                  imageUrl: currentStory.story,
                  placeholder: (context, urlImage) =>
                      Container(color: Colors.grey),
                  errorWidget: (context, urlImage, error) => Center(
                      child: Icon(Icons.music_note,
                          size: 50.0, color: Colors.white))),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.black.withOpacity(0.5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: CachedNetworkImageProvider(
                      currentStory.avatar,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(width: 8),
                  Text(
                    currentStory.name,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
