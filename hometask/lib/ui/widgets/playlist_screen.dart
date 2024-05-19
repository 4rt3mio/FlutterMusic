import 'package:flutter/material.dart';

import '../../data/models/playlist_model.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final GlobalKey<_PlaylistSongsState> _playlistSongsKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Playlist playlist = Playlist.playlists[0];
    final args = ModalRoute.of(context)?.settings.arguments;
    bool isDefPlaylist = true;
    if (args is Playlist) {
      playlist = args;
      isDefPlaylist = false;
    } else if (args == 'defolt') {
      playlist = Playlist.playlists[Playlist.playlists.length - 1];
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green.shade800.withOpacity(0.8),
            Colors.green.shade200.withOpacity(0.8),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(isDefPlaylist ? 'Любимые треки' : "Плейлист"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _PlaylistInformation(playlist: playlist),
                const SizedBox(height: 30),
                _PlayOrShuffleSwitch(
                  playlist: playlist,
                  onShufflePressed: _onShufflePressed,
                ),
                _PlaylistSongs(
                  key: _playlistSongsKey,
                  playlist: playlist,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onShufflePressed(Playlist playlist) {
    setState(() {
      playlist.tracks.shuffle();
      _playlistSongsKey.currentState?.setState(() {});
    });
  }
}

class _PlaylistSongs extends StatefulWidget {
  const _PlaylistSongs({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  final Playlist playlist;

  @override
  State<_PlaylistSongs> createState() => _PlaylistSongsState();
}

class _PlaylistSongsState extends State<_PlaylistSongs> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.playlist.tracks.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Text(
            '${index + 1}',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          title: Text(
            widget.playlist.tracks[index].title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            widget.playlist.tracks[index].artist,
          ),
          trailing: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.of(context).pushNamed('/song', arguments: {
              'playlist': widget.playlist,
              'index': index,
            });
          },
        );
      },
    );
  }
}

class _PlayOrShuffleSwitch extends StatefulWidget {
  final Playlist playlist;
  final Function(Playlist) onShufflePressed;

  const _PlayOrShuffleSwitch({
    Key? key,
    required this.playlist,
    required this.onShufflePressed,
  }) : super(key: key);

  @override
  State<_PlayOrShuffleSwitch> createState() => _PlayOrShuffleSwitchState();
}

class _PlayOrShuffleSwitchState extends State<_PlayOrShuffleSwitch> {
  bool isPlay = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        setState(() {
          isPlay = !isPlay;
        });
      },
      child: Container(
        height: 50,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: isPlay ? 0 : width * 0.45,
              child: Container(
                height: 50,
                width: width * 0.45,
                decoration: BoxDecoration(
                  color: Colors.green.shade400,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/song', arguments: {
                            'playlist': widget.playlist,
                            'index': 0,
                          });
                        },
                        child: Center(
                          child: Text(
                            'Включить трек',
                            style: TextStyle(
                              color: isPlay ? Colors.white : Colors.green,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.play_circle,
                        color: isPlay ? Colors.white : Colors.green,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.onShufflePressed(widget.playlist);
                        },
                        child: Center(
                          child: Text(
                            'Перемешать',
                            style: TextStyle(
                              color: isPlay ? Colors.green : Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.shuffle,
                        color: isPlay ? Colors.green : Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaylistInformation extends StatelessWidget {
  const _PlaylistInformation({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: playlist.imageUrl.startsWith('http')
              ? Image.network(
            playlist.imageUrl,
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.height * 0.3,
            fit: BoxFit.cover,
          )
              : Image.asset(
            playlist.imageUrl,
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.height * 0.3,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          playlist.title,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}