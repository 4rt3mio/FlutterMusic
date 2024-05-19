import 'package:flutter/material.dart';
import '../../data/models/playlist_model.dart';
import '../../data/models/track_model.dart';

class SearchPage extends StatelessWidget {
  final List<Track>? listItems;

  const SearchPage({Key? key, this.listItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Track>? tracks = ModalRoute.of(context)!.settings.arguments as List<Track>?;
    final List<Track>? itemsToShow = tracks ?? listItems;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Поиск треков',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade900.withOpacity(0.8),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.green.shade900.withOpacity(0.8),
                  Colors.green.shade200.withOpacity(0.8),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: itemsToShow != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Autocomplete<Track>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<Track>.empty();
                    }
                    return itemsToShow.where((track) =>
                    track.title.toLowerCase().contains(textEditingValue.text.toLowerCase()) ||
                        track.artist.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                  },
                  displayStringForOption: (Track track) => track.title,
                  fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
                      FocusNode focusNode, VoidCallback onFieldSubmitted) {
                    return TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Искать трек',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Colors.grey.shade400),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: Colors.grey.shade800),
                    );
                  },
                  optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<Track> onSelected,
                      Iterable<Track> options) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: Material(
                        elevation: 4.0,
                        child: Container(
                          color: Colors.white,
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Track option = options.elementAt(index);
                              return ListTile(
                                onTap: () {
                                  onSelected(option);
                                },
                                title: Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Image.network(
                                        option.coverUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 10), // Add some spacing
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            option.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(color: Colors.black),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            option.artist,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.grey.shade600),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  onSelected: (Track track) {
                    int ind = -1;
                    if (track.genre == 'Alternative Rock') {
                      ind = 3;
                    } else if (track.genre == 'Post Punk') {
                      ind = 9;
                    } else if (track.genre == 'R&B') {
                      ind = 0;
                    } else if (track.genre == 'Techno') {
                      ind = 5;
                    } else if (track.genre == 'Rap') {
                      ind = 6;
                    } else if (track.genre == 'Cringe') {
                      ind = 7;
                    } else if (track.genre == 'Folk Punk') {
                      ind = 8;
                    } else if (track.genre == 'Pop') {
                      ind = 2;
                    } else if (track.genre == 'Soft Rock') {
                      ind = 4;
                    } else if (track.genre == 'Hip-Hop') {
                      ind = 1;
                    }
                    final playlist = Playlist.playlists[ind];
                    final index = playlist.tracks.indexWhere((t) => t == track);
                    Navigator.of(context).pushReplacementNamed('/song', arguments: {
                      'playlist': playlist,
                      'index': index,
                    });
                  },
                ),
              ],
            )
                : const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}