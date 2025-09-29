import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:universal_io/io.dart' show Platform;
import 'package:hive/hive.dart';
import '../../routes/app_pages.dart';

class BrowserView extends StatefulWidget {
  @override
  _BrowserViewState createState() => _BrowserViewState();
}

class _BrowserViewState extends State<BrowserView> {
  String status = 'Ready';

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.media);
      if (result == null) return;
      final paths = result.paths.where((p) => p != null).cast<String>().toList();
      if (paths.isEmpty) return;
      if (paths.length == 1) {
        Get.toNamed(Routes.VIDEO, arguments: {'source': paths.first, 'isNetwork': false});
      } else {
        final box = Hive.box('vivid_play_box');
        final list = box.get('playlist', defaultValue: <String>[]).cast<String>();
        for (var p in paths) {
          if (!list.contains(p)) list.add(p);
        }
        box.put('playlist', list);
        Get.snackbar('Playlist', 'Added ${paths.length} items to playlist');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick files: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Browse / Pick files')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.file_open),
              label: Text('Pick media files (SAF-aware)'),
              onPressed: _pickFiles,
            ),
            SizedBox(height: 12),
            Text('On Android this uses the Storage Access Framework under the hood. On web it opens the browser file picker.'),
          ],
        ),
      ),
    );
  }
}
