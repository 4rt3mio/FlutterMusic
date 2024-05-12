part of 'file_loader_bloc.dart';

sealed class FileLoaderState {
}

class FileLoadingState extends FileLoaderState {
  final String id;
  FileLoadingState(this.id);
}

class FileLoadedState extends FileLoaderState {
  final String payload, id;

  FileLoadedState(this.payload, this.id);
}

class FileDeletingState extends FileLoaderState {
  final String id;
  FileDeletingState(this.id);
}

class FileDeletedState extends FileLoaderState {
  final String payload, id;

  FileDeletedState(this.payload, this.id);
}