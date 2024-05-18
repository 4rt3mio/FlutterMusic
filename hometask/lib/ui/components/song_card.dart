import 'package:flutter/material.dart';
import '../../data/models/playlist_model.dart';
import '../../data/models/track_model.dart';

class SongCard extends StatelessWidget {
  const SongCard({
    Key? key,
    required this.track,
  }) : super(key: key);

  final Track track;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final playlist = Playlist.playlists.last;
        final index = playlist.tracks.indexWhere((t) => t == track);
        Navigator.of(context).pushNamed('/song', arguments: {
          'playlist': playlist,
          'index': index,
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: MediaQuery.of(context).size.width * 0.45,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                track.coverUrl,
                width: MediaQuery.of(context).size.width * 0.45,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.45,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white.withOpacity(0.8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            track.title,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            track.artist,
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.play_circle,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}