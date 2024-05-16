class Track {
  final String trackId;
  final String trackUrl;
  final String coverUrl;
  final String artist;
  final String title;
  final String album;
  final String genre;
  final int duration;

  Track({
    required this.trackId,
    required this.trackUrl,
    required this.coverUrl,
    required this.artist,
    required this.title,
    required this.album,
    required this.genre,
    required this.duration,
  });
}