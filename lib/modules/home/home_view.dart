import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VividPlay')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.folder_open),
                title: Text('Browse device files'),
                subtitle: Text('Use SAF-backed file picker or file browser'),
                trailing: ElevatedButton(
                  child: Text('Browse'),
                  onPressed: () => Get.toNamed(Routes.BROWSER),
                ),
              ),
            ),
            SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: Icon(Icons.queue_music),
                title: Text('Playlists'),
                subtitle: Text('View and manage saved playlists'),
                trailing: ElevatedButton(
                  child: Text('Open'),
                  onPressed: () => Get.toNamed(Routes.PLAYLIST),
                ),
              ),
            ),
            SizedBox(height: 12),
            Text('VividPlay: browse files, manage playlists, play in background. Web & Android friendly.', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
