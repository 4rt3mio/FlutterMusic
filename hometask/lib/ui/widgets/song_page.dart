import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/playlist_model.dart';
import '../../data/models/track_model.dart';
import '../../main.dart';
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
  final isFavoriteNotifier = ValueNotifier<bool>(false); // Initialize the ValueNotifier

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      playlist = (args as Map)['playlist'] as Playlist;
      index = (args)['index'] as int;
      track = playlist.tracks[index];
      audioPlayer.setUrl(track.trackUrl);
      _checkIfFavorite(); // Check if the track is favorite
    }
  }

  Future<void> _checkIfFavorite() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final currentData = await supabase.from('profiles').select('track_uuids').eq('id', userId).single();
      final List<String> currentUuids = (currentData['track_uuids'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
      setState(() {
        isFavoriteNotifier.value = currentUuids.contains(track.trackId); // Set the value based on whether trackId is in currentUuids
      });
    } catch (error) {
      print('Error checking if track is favorite: $error');
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
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/main',
                  (route) => false,
              arguments: {
                'reload': true,
              },
            );
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
            isFavoriteNotifier: isFavoriteNotifier, // Pass the isFavoriteNotifier to _MusicPlayer
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
    required this.isFavoriteNotifier, // Add isFavoriteNotifier argument
  })  : _seekBarDataStream = seekBarDataStream,
        super(key: key);

  final Track track;
  final Stream<SeekBarData> _seekBarDataStream;
  final AudioPlayer audioPlayer;
  final Playlist playlist;
  final int index;
  final ValueNotifier<bool> isFavoriteNotifier; // Declare isFavoriteNotifier

  Future<void> _addTrackUuid(String uuid) async {
    try {
      final userId = supabase.auth.currentUser!.id;

      final currentData = await supabase.from('profiles').select('track_uuids').eq('id', userId).single();
      final List<String> currentUuids = (currentData['track_uuids'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

      if (!currentUuids.contains(uuid)) {
        final List<String> updatedUuids = [...currentUuids, uuid];

        await supabase.from('profiles').upsert({
          'id': userId,
          'track_uuids': updatedUuids,
        });

        print('UUID трека успешно добавлен в ваш профиль!');
      } else {
        print('Трек уже существует в вашем профиле');
      }
    } on PostgrestException catch (error) {
      print('Ошибка при добавлении UUID трека: ${error.message}');
    } catch (error) {
      print('Произошла непредвиденная ошибка: $error');
    }
  }

  Future<void> _removeTrackUuid(String uuid) async {
    try {
      final userId = supabase.auth.currentUser!.id;

      final currentData = await supabase.from('profiles').select('track_uuids').eq('id', userId).single();
      final List<String> currentUuids = (currentData['track_uuids'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

      if (currentUuids.contains(uuid)) {
        final List<String> updatedUuids = List<String>.from(currentUuids)..remove(uuid);

        await supabase.from('profiles').upsert({
          'id': userId,
          'track_uuids': updatedUuids,
        });

        print('UUID трека успешно удален из вашего профиля!');
      } else {
        print('Трек не найден в вашем профиле');
      }
    } on PostgrestException catch (error) {
      print('Ошибка при удалении UUID трека: ${error.message}');
    } catch (error) {
      print('Произошла непредвиденная ошибка: $error');
    }
  }

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
                onPressed: () {
                  audioPlayer.seek(Duration.zero);
                  audioPlayer.play();
                },
                icon: const Icon(
                  Icons.autorenew_rounded,
                  color: Colors.white,
                ),
              ),
              IconButton(
                iconSize: 35,
                onPressed: () async {
                  try {
                    if (!isFavoriteNotifier.value) { // Check if the track is not a favorite
                      await _addTrackUuid(track.trackId);
                      isFavoriteNotifier.value = true;
                    } else { // If the track is already a favorite, remove it
                      await _removeTrackUuid(track.trackId);
                      isFavoriteNotifier.value = false;
                    }
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Ошибка при добавлении трека в избранное: $error'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                },
                icon: ValueListenableBuilder<bool>(
                  valueListenable: isFavoriteNotifier,
                  builder: (context, isFavorite, child) {
                    return Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_outline,
                      color: Colors.white,
                    );
                  },
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