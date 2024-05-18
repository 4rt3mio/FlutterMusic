import 'package:flutter/material.dart';
import '../../data/models/playlist_model.dart';
import '../../data/models/track_model.dart';
import '../../main.dart';
import '../components/playlist_card.dart';
import '../components/section_header.dart';
import '../components/song_card.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Track> tracks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getTracks(context);
  }

  Future<void> _getTracks(BuildContext context) async {
    try {
      final data = await supabase.from('tracks').select();
      tracks.clear();
      tracks.addAll(data.map((trackData) => Track(
        trackId: trackData['track_id'] as String? ?? '',
        trackUrl: trackData['track_url'] as String? ?? '',
        coverUrl: trackData['cover_url'] as String? ?? '',
        artist: trackData['artist'] as String? ?? '',
        title: trackData['title'] as String? ?? '',
        album: trackData['album'] as String? ?? '',
        genre: trackData['genre'] as String? ?? '',
        duration: trackData['duration'] as int? ?? 0,
      )));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при загрузке треков: $error'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Track> ARtracks = [];
    List<Track> PPtracks = [];
    List<Track> RBtracks = [];
    List<Track> TEtracks = [];
    List<Track> RAtracks = [];
    List<Track> CRtracks = [];
    List<Track> FPtracks = [];
    List<Track> POtracks = [];
    List<Track> SRtracks = [];
    List<Track> HHtracks = [];
    for (int i = 0; i < tracks.length; ++i) {
      if (tracks[i].genre == 'Alternative Rock') {
        ARtracks.add(tracks[i]);
      }
      else if (tracks[i].genre == 'Post Punk') {
        PPtracks.add(tracks[i]);
      }
      else if (tracks[i].genre == 'R&B') {
        RBtracks.add(tracks[i]);
      }
      else if (tracks[i].genre == 'Techno') {
        TEtracks.add(tracks[i]);
      }
      else if (tracks[i].genre == 'Rap') {
        RAtracks.add(tracks[i]);
      }
      else if (tracks[i].genre == 'Cringe') {
        CRtracks.add(tracks[i]);
      }
      else if (tracks[i].genre == 'Folk Punk') {
        FPtracks.add(tracks[i]);
      }
      else if (tracks[i].genre == 'Pop') {
        POtracks.add(tracks[i]);
      }
      else if (tracks[i].genre == 'Soft Rock') {
        SRtracks.add(tracks[i]);
      }
      else if (tracks[i].genre == 'Hip-Hop') {
        HHtracks.add(tracks[i]);
      }
    }
    Playlist.playlists[0].tracks = RBtracks;
    Playlist.playlists[1].tracks = HHtracks;
    Playlist.playlists[2].tracks = POtracks;
    Playlist.playlists[3].tracks = ARtracks;
    Playlist.playlists[4].tracks = SRtracks;
    Playlist.playlists[5].tracks = TEtracks;
    Playlist.playlists[6].tracks = RAtracks;
    Playlist.playlists[7].tracks = CRtracks;
    Playlist.playlists[8].tracks = FPtracks;
    Playlist.playlists[9].tracks = PPtracks;
    Playlist.playlists[10].tracks = tracks;
    List<Playlist> playlists = Playlist.playlists;
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
        appBar: const _CustomAppBar(),
        bottomNavigationBar: const _CustomNavBar(),
        body: isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          child: Column(
            children: [
              const _DiscoverMusic(),
              _TrendingMusic(tracks: tracks),
              _PlaylistMusic(playlists: playlists),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaylistMusic extends StatelessWidget {
  const _PlaylistMusic({
    Key? key,
    required this.playlists,
  }) : super(key: key);

  final List<Playlist> playlists;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Плейлисты',
            style: Theme.of(context).textTheme.headline6!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 20),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: playlists.length - 1,
            itemBuilder: ((context, index) {
              return PlaylistCard(playlist: playlists[index]);
            }),
          ),
        ],
      ),
    );
  }
}

class _TrendingMusic extends StatelessWidget {
  const _TrendingMusic({
    Key? key,
    required this.tracks,
  }) : super(key: key);

  final List<Track> tracks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        top: 20.0,
        bottom: 20.0,
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: SectionHeader(title: 'Любимые треки'),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.27,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                return SongCard(track: tracks[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscoverMusic extends StatelessWidget {
  const _DiscoverMusic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Наслаждайтесь вашей любимой музыкой!',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              hintText: 'Искать трек',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.grey.shade400),
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }
}

class _CustomNavBar extends StatelessWidget {
  const _CustomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.green.shade800,
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.white,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_circle_outline),
          label: 'Play',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        if (index == 1) {
          Navigator.of(context).pushNamed('/playlist', arguments: 'defolt');
        }
        if (index == 3) {
          Navigator.of(context).pushNamed('/account');
        }
      },
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        FutureBuilder<String>(
          future: _getImageUrl(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/account');
                },
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data!),
                  radius: 25,
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    );
  }

  Future<String> _getImageUrl() async {
    try {
      final userId = supabase.auth.currentSession!.user.id;
      final data =
      await supabase.from('profiles').select().eq('id', userId).single();
      final imageUrl = (data['avatar_url'] ?? '') as String;
      return imageUrl;
    } catch (error) {
      return '';
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}