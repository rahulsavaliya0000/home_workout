import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:home_workout/constants/colors/app_color.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;

class VideoPage extends StatefulWidget {
  final String videoUrl;

  VideoPage({required this.videoUrl});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late YoutubePlayerController _controller;
  late yt.YoutubeExplode _ytExplode;
  yt.Video? _video; // Declare _video as nullable

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '',
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    _ytExplode = yt.YoutubeExplode();
    fetchVideoInfo();
  }

  Future<void> fetchVideoInfo() async {
    var videoId = yt.VideoId(widget.videoUrl);

    try {
      _video = await _ytExplode.videos.get(videoId);
    } catch (e) {
      print('Error fetching video: $e');
    }

    if (mounted) {
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: AnimatedTextKit(
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'Video',
                          textStyle: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                          ),
                          colors: [
                            AppColor.blueColor,
                            Colors.orange,
                            Colors.yellow,
                            Colors.green,
                            Colors.blue,
                            Colors.purple,
                          ],
                        ),
                      ],
                      isRepeatingAnimation: true,
                      repeatForever: true,
                    ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
              ),
              SizedBox(height: 16),
              if (_video != null && _video!.title != null)
                Text(
                  'Video Name: ${_video!.title}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              SizedBox(height: 8),
              if (_video != null && _video!.description != null)
                Text(
                  'Description: ${_video!.description}',
                  style: TextStyle(fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ytExplode.close();
    super.dispose();
  }
}
