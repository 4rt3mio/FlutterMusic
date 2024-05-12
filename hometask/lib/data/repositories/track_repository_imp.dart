import 'package:hometask/domain/entity/track.dart';
import 'package:hometask/domain/repositories/track_repository.dart';

Map<String, Track> tracks = {
  'ehqrssqzbjhc123': Track(
    id: 'firsttrackid123',
    mp3data: 'first_track',
    localPath: '/path/to/file_1.mp3',
    durationInS: 1,
  ),
  'hsrrdbnmcehkd': Track(
    id: 'itssecondfile',
    mp3data: 'second_track',
    localPath: '/path/to/file_2.mp3',
    durationInS: 2,
  ),
  'sghqcsghqc3': Track(
    id: 'thirdthird3',
    mp3data: 'third_track',
    localPath: '/path/to/file_3.mp3',
    durationInS: 3,
  ),
  'entqsgehkdhc': Track(
    id: 'fourthfileid',
    mp3data: 'fourth_track',
    localPath: '/path/to/file_4.mp3',
    durationInS: 4,
  ),
  'kzrsehesgsqzbj': Track(
    id: 'lastfifthtrack',
    mp3data: 'fifth_track',
    localPath: '/path/to/file_5.mp3',
    durationInS: 5,
  )
};

String processId(String id) {
  String decryptedText = '';

  for (int i = 0; i < id.length; i++) {
    if (id[i].toUpperCase() != id[i].toLowerCase()) {
      String originalChar = id[i];
      String originalCharUpperCase = originalChar.toUpperCase();

      int originalPosition =
          originalCharUpperCase.codeUnitAt(0) - 'A'.codeUnitAt(0);

      int newPosition = (originalPosition - 1) % 26;
      if (newPosition < 0) {
        newPosition += 26;
      }

      String newChar = String.fromCharCode('A'.codeUnitAt(0) + newPosition);
      decryptedText += originalChar == originalCharUpperCase
          ? newChar
          : newChar.toLowerCase();
    } else {
      decryptedText += id[i];
    }
  }

  return decryptedText;
}

class LocalRepo implements TrackRepository {
  Set<String> ids = <String>{};

  @override
  Future<Track> loadTrack(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return tracks[id] ?? Track(
          id: 'error',
          mp3data: 'error',
          localPath: 'error',
          durationInS: -1,
        );
  }

  bool hasTrack(String id) {
    return ids.contains(id);
  }

  Future<bool> hasTrackAsync(String id) async{
    return ids.contains(id);
  }

  void addTrack(String id) {
    ids.add(id);
  }

  void delTrack(String id) {
    ids.remove(id);
  }
}

class RemoteRepo implements TrackRepository {
  @override
  Future<Track> loadTrack(String id) async {
    await Future.delayed(const Duration(seconds: 5));
    return tracks[id] ?? Track(
      id: 'error',
      mp3data: 'error',
      localPath: 'error',
      durationInS: -1,
    );
  }
}

class TrackRepositoryImpl implements TrackRepository {
  static LocalRepo localRepo = LocalRepo();
  static RemoteRepo remoteRepo = RemoteRepo();

  @override
  Future<Track> loadTrack(String id) {
    id = processId(id);
    try {
      final bool hasLocalTrack = localRepo.hasTrack(id);
      if (hasLocalTrack) {
        return localRepo.loadTrack(id);
      } else {
        localRepo.addTrack(id);
        return remoteRepo.loadTrack(id);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTrack(String id) async{
    id = processId(id);
    localRepo.delTrack(id);
  }

  Future<bool> checkTrack(String id) {
    id = processId(id);
    return localRepo.hasTrackAsync(id);
  }
}
