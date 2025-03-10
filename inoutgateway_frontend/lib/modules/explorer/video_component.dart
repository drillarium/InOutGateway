import 'package:flutter/material.dart';

class VideoComponentWidget extends StatelessWidget {
  const VideoComponentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.green[100], child: Column(children: [Text("Video Player & Components"), Expanded(child: Placeholder())]));
  }
}
