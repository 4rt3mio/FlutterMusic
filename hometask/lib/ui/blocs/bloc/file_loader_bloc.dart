import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hometask/data/repositories/track_repository_imp.dart';

part 'file_loader_event.dart';
part 'file_loader_state.dart';

class FileLoaderBloc extends Bloc<FileLoaderEvent, FileLoaderState> {
  final TrackRepositoryImpl trackLoader = TrackRepositoryImpl();

  FileLoaderBloc() : super(FileDeletedState('', '')) {
    on<LoadFileEvent>(_onFileLoadEvent);
    on<DeleteFileEvent>(_onFileDeleteEvent);
  }

  void _onFileLoadEvent(LoadFileEvent event, Emitter<FileLoaderState> emit) async {
      emit(FileLoadingState(event.id));

      final file = await trackLoader.loadTrack(event.id);

      emit(FileLoadedState('file id: ${file.id}\nmp3data: ${file.mp3data}\nLocal path: ${file.localPath}\nDuration: ${file.durationInS}', event.id));
  }

  void _onFileDeleteEvent(DeleteFileEvent event, Emitter<FileLoaderState> emit) async {
      emit(FileDeletingState(event.id));
      await trackLoader.deleteTrack(event.id);
      emit(FileDeletedState('file deleted', event.id));
  }
}


