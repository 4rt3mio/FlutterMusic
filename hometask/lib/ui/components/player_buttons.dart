import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../data/models/playlist_model.dart';

class PlayerButtons extends StatelessWidget {
  const PlayerButtons({
    Key? key,
    required this.audioPlayer,
    required this.playlist,
    required this.index,
  }) : super(key: key);

  final AudioPlayer audioPlayer;
  final Playlist playlist;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<SequenceState?>(
          stream: audioPlayer.sequenceStateStream,
          builder: (context, sequenceStateSnapshot) {
            return IconButton(
              onPressed: () {
                final newIndex = (index == 0) ? (playlist.tracks.length - 1) : (index - 1);
                Navigator.of(context).pushReplacementNamed('/song', arguments: {
                  'playlist': playlist,
                  'index': newIndex,
                });
              },
              iconSize: 45,
              icon: const Icon(
                Icons.skip_previous,
                color: Colors.white,
              ),
            );
          },
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final playerState = snapshot.data;
              final processingState = playerState!.processingState;

              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  width: 64.0,
                  height: 64.0,
                  margin: const EdgeInsets.all(10.0),
                  child: const CircularProgressIndicator(),
                );
              } else if (!audioPlayer.playing) {
                return IconButton(
                  onPressed: audioPlayer.play,
                  iconSize: 75,
                  icon: const Icon(
                    Icons.play_circle,
                    color: Colors.white,
                  ),
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: const Icon(
                    Icons.pause_circle,
                    color: Colors.white,
                  ),
                  iconSize: 75.0,
                  onPressed: audioPlayer.pause,
                );
              } else {
                return IconButton(
                  icon: const Icon(
                    Icons.replay_circle_filled_outlined,
                    color: Colors.white,
                  ),
                  iconSize: 75.0,
                  onPressed: () => audioPlayer.seek(
                    Duration.zero,
                    index: audioPlayer.effectiveIndices!.first,
                  ),
                );
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: audioPlayer.sequenceStateStream,
          builder: (context, sequenceStateSnapshot) {
            return IconButton(
              onPressed: () {
                final newIndex = (index + 1) % playlist.tracks.length;
                Navigator.of(context).pushReplacementNamed('/song', arguments: {
                  'playlist': playlist,
                  'index': newIndex,
                });
              },
              iconSize: 45,
              icon: const Icon(
                Icons.skip_next,
                color: Colors.white,
              ),
            );
          },
        ),
      ],
    );
  }
}