import 'track_model.dart';

class Playlist {
  final String title;
  List<Track> tracks;
  final String imageUrl;

  Playlist({
    required this.title,
    required this.tracks,
    required this.imageUrl,
  });

  static List<Playlist> playlists = [
    Playlist(
      title: 'R&B Mix',
      tracks: [],
      imageUrl:
      'assets/default_pictures/RB.jpg',
      //'https://images.unsplash.com/photo-1576525865260-9f0e7cfb02b3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1364&q=80',
    ),
    Playlist(
      title: 'Hip-hop',
      tracks: [],
      imageUrl:
      'assets/default_pictures/Hip.jpg',
      //'https://images.unsplash.com/photo-1601643157091-ce5c665179ab?q=80&w=3272&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    Playlist(
      title: 'Pop',
      tracks: [],
      imageUrl:
      'assets/default_pictures/Pop.jpg',
      //'https://images.unsplash.com/photo-1514533212735-5df27d970db0?q=80&w=2545&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    Playlist(
      title: 'Alternative Rock',
      tracks: [],
      imageUrl:
      'assets/default_pictures/AR.jpg',
      //'https://images.unsplash.com/photo-1629276301820-0f3eedc29fd0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2848&q=80',
    ),
    Playlist(
      title: 'Soft Rock',
      tracks: [],
      imageUrl:
      'assets/default_pictures/SR.jpg',
      //'https://images.unsplash.com/photo-1496698161505-d1703dbcab63?q=80&w=3171&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    Playlist(
      title: 'Techno',
      tracks: [],
      imageUrl:
      'assets/default_pictures/Tech.jpg',
      //'https://images.unsplash.com/photo-1594623930572-300a3011d9ae?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2670&q=80',
    ),
    Playlist(
      title: 'Rap',
      tracks: [],
      imageUrl:
      'assets/default_pictures/Rap.jpg',
      //'https://images.unsplash.com/photo-1440660405495-b26acc5309a2?q=80&w=3270&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    Playlist(
      title: 'Cringe',
      tracks: [],
      imageUrl:
      'assets/default_pictures/CR.jpg',
      //'https://images.unsplash.com/photo-1503533464228-bd3c36ddd3fb?q=80&w=3270&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    Playlist(
      title: 'Folk Punk',
      tracks: [],
      imageUrl:
      'assets/default_pictures/FP.jpg',
      //'https://images.unsplash.com/photo-1460723237483-7a6dc9d0b212?q=80&w=3270&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    Playlist(
      title: 'Post Punk',
      tracks: [],
      imageUrl:
      'assets/default_pictures/PP.jpg',
      //'https://images.unsplash.com/photo-1575672913784-11a7cd4f25f4?q=80&w=3269&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    //он всегда последний в логике программы
    Playlist(
      title: 'Любимые треки',
      tracks: [],
      imageUrl: 'assets/default_pictures/plastinka.jpg',
    )
  ];
}