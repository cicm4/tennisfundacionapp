import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tennisfundacionapp/services/database_service.dart';
import 'package:tennisfundacionapp/services/image_service.dart';
import 'package:tennisfundacionapp/services/storage_service.dart';

class ImageGaleryHome extends StatefulWidget {
  final DBService dbs;
  final StorageService st;

  const ImageGaleryHome({super.key, required this.dbs, required this.st});

  @override
  State<ImageGaleryHome> createState() => _ImageGaleryHomeState();
}

class ImageAlgolia {
  //images from algolia
  final String name;

  ImageAlgolia(this.name);

  static ImageAlgolia fromJson(Map<String, dynamic> json) {
    return ImageAlgolia(json['objectID']);
  }
}

class HitsPage {
  const HitsPage(this.items, this.pageKey, this.nextPageKey);

  final List<ImageAlgolia> items;
  final int pageKey;
  final int? nextPageKey;

  factory HitsPage.fromResponse(SearchResponse response) {
    final items = response.hits.map(ImageAlgolia.fromJson).toList();

    //debug, print items:
    //print("DEBUG STATEMENT: IMAGE ALGOLIA INFROMATION:
    //for(var i = 0; i < items.length; i++) {
    //  print(items[i].name);
    //}
    //print("END DEBUG STATEMENT");
    //end debug

    final isLastPage = response.page >= response.nbPages;
    final nextPageKey = isLastPage ? null : response.page + 1;

    return HitsPage(items, response.page, nextPageKey);
  }
}

class SearchMetadata {
  final int nbHits;

  const SearchMetadata(this.nbHits);

  factory SearchMetadata.fromResponse(SearchResponse response) =>
      SearchMetadata(response.nbHits);
}

class _ImageGaleryHomeState extends State<ImageGaleryHome> {
  //variables
  final _productsSearcher = HitsSearcher(
      applicationID: 'FMZTHT04WY',
      apiKey: '797c04401244a85c67630a61ea24776b',
      indexName: 'images');
  final _searchTextController = TextEditingController();
  final PagingController<int, ImageAlgolia> _pagingController =
      PagingController(firstPageKey: 0);
  Stream<HitsPage> get _searchPage =>
      _productsSearcher.responses.map(HitsPage.fromResponse);
  //pages
  Widget _hits(BuildContext context) => PagedListView<int, ImageAlgolia>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<ImageAlgolia>(
          noItemsFoundIndicatorBuilder: (_) => const Center(
                child: Text('No results found'),
              ),
          itemBuilder: (_, item, __) => Container(
                color: Colors.white,
                height: 80,
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    SizedBox(
                        width: 50,
                        child: FutureBuilder<String>(
                          future: ImageService.getImageUrl(imageName: item.name, isLowRes: true, dbService: widget.dbs),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(50.0),
                                child: CircularProgressIndicator(),
                              ); // or some placeholder
                            } else if (snapshot.hasError) {
                              if (kDebugMode) {
                                print('Error: ${snapshot.error}');
                              }
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("name: ${item.name}"),
                                  Text("Error: ${snapshot.error}")
                                ],
                              );
                            } else {
                              return Row(
                                children: [
                                  Image.network(snapshot.data!),
                                  Text(item.name),
                                  Text("name: ${item.name}")
                                ],
                              );
                            }
                          },
                        ))
                  ],
                ),
              )));

  //replaced methods
  @override
  void dispose() {
    _searchTextController.dispose();
    _productsSearcher.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchTextController.addListener(
      () => _productsSearcher.applyState(
        (state) => state.copyWith(
          query: _searchTextController.text,
          page: 0,
        ),
      ),
    );
    _searchPage.listen((page) {
      if (page.pageKey == 0) {
        _pagingController.refresh();
      }
      _pagingController.appendPage(page.items, page.nextPageKey);
    }).onError((error) => _pagingController.error = error);
    _pagingController.addPageRequestListener(
        (pageKey) => _productsSearcher.applyState((state) => state.copyWith(
              page: pageKey,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HitsPage>(
      stream: _searchPage,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SafeArea(
            child: SizedBox(
              width: 100.0,
              height: 100.0,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: SpinKitRing(color: Colors.white, size: 50, lineWidth: 5,),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (snapshot.hasData) {
          var images = snapshot.data!.items;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green[700],
              title: TextField(
                controller: _searchTextController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
            backgroundColor: Colors.grey[900],
            body: GridView.builder(
              itemCount: images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Changed from 2 to 3
                childAspectRatio: 1.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return FutureBuilder<String>(
                  future: ImageService.getImageUrl(
                      imageName: images[index].name,
                      isLowRes: true,
                      dbService: widget.dbs),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SpinKitPulse(color: Colors.white, size: 30);
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      );
                    } else {
                      return GestureDetector(
                        // Wrapped in a GestureDetector for onTap navigation
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/indivFoto',
                            arguments: {
                              'name': images[index].name,
                              'lowResUrl': snapshot.data
                            },
                          ); // Navigate on tap
                        },

                        child: Container(
                          // Removed green border
                          child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(snapshot.data.toString()),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green[700],
              onPressed: () {
                Navigator.pushNamed(context, '/addImage');
              },
              child: const Icon(Icons.add),
            ),
          );
        } else {
          return const Text('No topics found in Firestore. Check database');
        }
      },
    );
  }
}
