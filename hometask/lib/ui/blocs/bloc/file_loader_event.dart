part of 'file_loader_bloc.dart';

sealed class FileLoaderEvent {
}

class LoadFileEvent extends FileLoaderEvent{
  final String id;

  LoadFileEvent(this.id);
}

class DeleteFileEvent extends FileLoaderEvent {
  final String id;

  DeleteFileEvent(this.id);
}