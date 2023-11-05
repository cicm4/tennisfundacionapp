import 'package:flutter/material.dart';
import 'package:tennisfundacionapp/services/database_service.dart';
import 'package:tennisfundacionapp/services/image_service.dart';

class SpecificImageView extends StatelessWidget {
  final ImageService imageService;
  final DBService dbService;
  const SpecificImageView({super.key, required this.imageService, required this.dbService});

  @override
  Widget build(BuildContext context) {
    final Map<String, String?> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
    final String imageName = arguments['name']!;
    final String lowResUrl = arguments['lowResUrl']!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text('Photo Details'),
      ),
      backgroundColor: Colors.grey[900],
      bottomNavigationBar: Container(
        color: Colors.green[700],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.white,
              onPressed: () {
                // Your edit action here
              },
            ),
            IconButton(
              icon: const Icon(Icons.file_download),
              color: Colors.white,
              onPressed: () {
                // Your download action here
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.white,
              onPressed: () {
                // Your delete action here
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: Future.wait<dynamic>([
          ImageService.getImageUrl(imageName: imageName, isLowRes: false, dbService: dbService),
          imageService.getImageMetaData(
            name: imageName,
            path: "photos/",
            dbService: dbService
          ),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                Expanded(
                  flex: 8,
                  child: Align(
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Image.network(
                          lowResUrl,
                          fit: BoxFit.fitWidth,
                        ),
                        Container() // This empty container will ensure the Stack behaves consistently
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(), // Empty container to maintain structure
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            String imageUrl = snapshot.data![0] as String;
            Map<String, dynamic>? metaData = snapshot.data![1] as Map<String, dynamic>?;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 8,
                  child: Stack(
                    children: [
                      // Low-res image as the base layer
                      Image.network(
                        lowResUrl,
                        fit: BoxFit.fitWidth,
                      ),
                      // High-res image loading on top
                      Image.network(
                        imageUrl,
                        fit: BoxFit.fitWidth,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Opacity(
                            opacity:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : 0,
                            child: child,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    child: metaData == null
                        ? const Center(child: Text('No metadata available'))
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    'Image Name: $imageName',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                ...metaData.keys.map((key) {
                                  return ListTile(
                                    title: Text(
                                      '$key: ${metaData[key]}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}
