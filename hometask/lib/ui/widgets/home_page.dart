import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hometask/ui/blocs/file_loader/file_loader_bloc.dart';
import 'package:hometask/ui/listenable classes/theme/themeValue.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hometask"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                ThemeValue.nextTheme();
              },
              child: const Text('Theme'),
            ),
            BlocBuilder<FileLoaderBloc, FileLoaderState>(
              builder: (context, state) {
                if (state is FileDeletedState) {
                  return Text(state.payload);
                }
                if (state is FileLoadedState) {
                  return Text(state.payload);
                }
                return const CircularProgressIndicator();
              },
            ),
            buildFileRow(context, id: 'firsttrackid123', label: 'File 1'),
            buildFileRow(context, id: 'itssecondfile', label: 'File 2'),
            buildFileRow(context, id: 'thirdthird3', label: 'File 3'),
            buildFileRow(context, id: 'fourthfileid', label: 'File 4'),
            buildFileRow(context, id: 'lastfifthtrack', label: 'File 5'),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/account');
              },
              child: const Text('Go to Account'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFileRow(BuildContext context, {required String id, required String label}) {
    final fileLoaderBloc = BlocProvider.of<FileLoaderBloc>(context);

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        TextButton(
          onPressed: () {
            fileLoaderBloc.add(LoadFileEvent(id));
          },
          child: Text('Download $label'),
      ),
      BlocBuilder<FileLoaderBloc, FileLoaderState>(
        buildWhen: (previousState, state) => (state as dynamic).id == id,
        builder: (context, state) {
          if (state is FileLoadingState || state is FileDeletingState) {
            return buildStatusIndicator(Colors.grey);
          } else if (state is FileLoadedState) {
            return buildStatusIndicator(Colors.blue);
          } else {
            return buildStatusIndicator(Colors.red);
          }
        },
      ),
      TextButton(
        onPressed: () {
          fileLoaderBloc.add(DeleteFileEvent(id));
        },
        child: Text('Delete $label'),
      ),
    ],
    );
  }

  Widget buildStatusIndicator(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}