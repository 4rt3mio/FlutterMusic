import 'package:hometask/domain/entity/track.dart';

abstract class TrackRepository {
  Future<Track> loadTrack(String id);
}