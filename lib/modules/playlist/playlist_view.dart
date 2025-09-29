import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../routes/app_pages.dart';

class PlaylistView extends StatefulWidget {
  @override
  _PlaylistViewState createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  List<String> items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final box = Hive.box('vivid_play_box');
    items = box.get('playlist', defaultValue: <String>[]).cast<String>();
    setState((){});
  }

  void _save() {
    final box = Hive.box('vivid_play_box');
    box.put('playlist', items);
  }

  void _playAt(int idx) {
    final path = items[idx];
    Get.toNamed(Routes.VIDEO, arguments: {'source': path, 'isNetwork': false});
  }

  void _removeAt(int idx) {
    items.removeAt(idx);
    _save();
    setState((){});
  }

  void _playAll() {
    if (items.isEmpty) {
      Get.snackbar('Playlist', 'No items to play');
      return;
    }
    Get.toNamed(Routes.VIDEO, arguments: {'source': items.first, 'isNetwork': false});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Playlist')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton.icon(onPressed: _playAll, icon: Icon(Icons.play_arrow), label: Text('Play All')),
                SizedBox(width: 12),
                ElevatedButton.icon(onPressed: () { setState((){ items.clear(); _save(); }); }, icon: Icon(Icons.delete_forever), label: Text('Clear')),
              ],
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              itemCount: items.length,
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) newIndex -= 1;
                final item = items.removeAt(oldIndex);
                items.insert(newIndex, item);
                _save();
                setState((){});
              },
              itemBuilder: (ctx, i) {
                final p = items[i];
                return ListTile(
                  key: ValueKey(p),
                  leading: Icon(Icons.music_note),
                  title: Text(p.split('/').last),
                  subtitle: Text(p),
                  onTap: () => _playAt(i),
                  trailing: IconButton(icon: Icon(Icons.delete), onPressed: () => _removeAt(i)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
