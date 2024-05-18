import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import '../../data/models/playlist_model.dart';
import '../../data/models/track_model.dart'; // Changed to track_model.dart
import '../components/player_buttons.dart';
import '../components/seekbar.dart';

class SongPage extends StatefulWidget {
  const SongPage({Key? key}) : super(key: key);

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  AudioPlayer audioPlayer = AudioPlayer();
  late Track track;
  late Playlist playlist;
  late int index;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      playlist = (args as Map)['playlist'] as Playlist;
      index = (args)['index'] as int;
      track = playlist.tracks[index];
      audioPlayer.setUrl(track.trackUrl);
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Stream<SeekBarData> get _seekBarDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
        audioPlayer.positionStream,
        audioPlayer.durationStream,
            (Duration position, Duration? duration) {
          return SeekBarData(
            position,
            duration ?? Duration.zero,
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            track.coverUrl,
            fit: BoxFit.cover,
          ),
          const _BackgroundFilter(),
          _MusicPlayer(
            track: track,
            seekBarDataStream: _seekBarDataStream,
            audioPlayer: audioPlayer,
            playlist: playlist,
            index: index,
          ),
        ],
      ),
    );
  }
}

class _MusicPlayer extends StatelessWidget {
  const _MusicPlayer({
    Key? key,
    required this.track,
    required Stream<SeekBarData> seekBarDataStream,
    required this.audioPlayer,
    required this.playlist,
    required this.index,
  })  : _seekBarDataStream = seekBarDataStream,
        super(key: key);

  final Track track;
  final Stream<SeekBarData> _seekBarDataStream;
  final AudioPlayer audioPlayer;
  final Playlist playlist;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 50.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            track.title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            track.artist,
            maxLines: 2,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          StreamBuilder<SeekBarData>(
            stream: _seekBarDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                position: positionData?.position ?? Duration.zero,
                duration: positionData?.duration ?? Duration.zero,
                onChangeEnd: audioPlayer.seek,
              );
            },
          ),
          PlayerButtons(
            audioPlayer: audioPlayer,
            playlist: playlist,
            index: index,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 35,
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_outline,
                  color: Colors.white,
                ),
              ),
              IconButton(
                iconSize: 35,
                onPressed: () {},
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackgroundFilter extends StatelessWidget {
  const _BackgroundFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.0),
          ],
          stops: const [
            0.0,
            0.4,
            0.6
          ],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade200,
              Colors.green.shade800,
            ],
          ),
        ),
      ),
    );
  }
}