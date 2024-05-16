class Song {
  final String title;
  final String description;
  final String url;
  final String coverUrl;

  Song({
    required this.title,
    required this.description,
    required this.url,
    required this.coverUrl,
  });

  static List<Song> songs = [
    Song(
      title: 'Glass',
      description: 'Glass',
      url: 'https://mlnybhnuiefugvyzpfwz.supabase.co/storage/v1/object/sign/mp3s/glass.mp3?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJtcDNzL2dsYXNzLm1wMyIsImlhdCI6MTcxNTc5NDE1OSwiZXhwIjoxNzE4Mzg2MTU5fQ.7lBcGH9K8hpbRD_tiPdO5042zuVnosDN9Ktha1wzsZE&t=2024-05-15T17%3A29%3A19.659Z',
      coverUrl: 'assets/images/glass.jpg',
    ),
    Song(
      title: 'Believer',
      description: 'Imagine Dragons',
      url: 'https://mlnybhnuiefugvyzpfwz.supabase.co/storage/v1/object/sign/mp3s/Imagine_Dragons_-_Thunder_47828258.mp3?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJtcDNzL0ltYWdpbmVfRHJhZ29uc18tX1RodW5kZXJfNDc4MjgyNTgubXAzIiwiaWF0IjoxNzE1NzkzNjQ2LCJleHAiOjE3MTgzODU2NDZ9.UVk768efFon3FKiHwrdecWeiq067KW2psA-U3SA9JyU&t=2024-05-15T17%3A20%3A46.646Z',
      coverUrl: 'https://mlnybhnuiefugvyzpfwz.supabase.co/storage/v1/object/sign/covers/believer.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJjb3ZlcnMvYmVsaWV2ZXIuanBnIiwiaWF0IjoxNzE1Nzk3OTI2LCJleHAiOjE3MTgzODk5MjZ9.x56nh4W5ZRyPKgd_OQbF5dI4gdfYCb4DbYma92gU9X0&t=2024-05-15T18%3A32%3A07.407Z',
    ),
    Song(
      title: 'Pray',
      description: 'Pray',
      url: 'assets/music/pray.mp3',
      coverUrl: 'assets/images/pray.jpg',
    )
  ];
}