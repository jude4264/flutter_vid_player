import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;
  const CustomVideoPlayer({required this.video, super.key});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController;

  @override
  void initState() {
    super.initState();
    initializeController();
  }

  initializeController() async {
    videoController = VideoPlayerController.file(
      File(widget.video.path),
    );
    // TODO: implement initState
    await videoController?.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      CircularProgressIndicator();
    }

    return AspectRatio(
      aspectRatio: videoController!.value.aspectRatio,
      child: Stack(
        children: [
          VideoPlayer(
            videoController!,
          ),
          _Controls(
            onForwardPressed: onForwardPressed,
            onPlayPressed: onPlayPressed,
            onReversePressed: onReversePressed,
            isPlaying: videoController!.value.isPlaying,
          ),
          Positioned(
            right: 0,
            child: IconButton(
                onPressed: () {},
                color: Colors.white,
                iconSize: 30.0,
                icon: Icon(
                  Icons.photo_camera_back,
                )),
          )
        ],
      ),
    );
  }

  void onReversePressed() {
    final currentPosition = videoController!.value.position;
    Duration position = Duration();
    if (currentPosition.inSeconds > 10) {
      position = currentPosition - Duration(seconds: 10);
    }

    videoController!.seekTo(position);
  }

  void onPlayPressed() {
    //이미 실행중이면 중지 아니면 실행
    setState(
      () {
        if (videoController!.value.isPlaying) {
          videoController!.pause();
        } else {
          videoController!.play();
        }
      },
    );
  }

  void onForwardPressed() {
    final maxPosition = videoController!.value.duration;
    final currentPosition = videoController!.value.position;
    Duration position = Duration();
    if ((maxPosition - Duration(seconds: 10)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 10);
    }

    videoController!.seekTo(position);
  }
}

class _Controls extends StatelessWidget {
  final VoidCallback onPlayPressed;
  final VoidCallback onReversePressed;
  final VoidCallback onForwardPressed;
  final bool isPlaying;

  const _Controls({
    required this.onForwardPressed,
    required this.onPlayPressed,
    required this.onReversePressed,
    required this.isPlaying,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          renderIconButton(
            onPressed: onReversePressed,
            iconData: Icons.rotate_left,
          ),
          renderIconButton(
            onPressed: onPlayPressed,
            iconData: isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          renderIconButton(
            onPressed: onForwardPressed,
            iconData: Icons.rotate_right,
          ),
        ],
      ),
    );
  }
}

Widget renderIconButton({
  required VoidCallback onPressed,
  required IconData iconData,
}) {
  return IconButton(
    onPressed: onPressed,
    color: Colors.white,
    iconSize: 30.0,
    icon: Icon(
      iconData,
    ),
  );
}
