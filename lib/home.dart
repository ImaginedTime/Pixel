import 'package:flutter/material.dart';

import './components/home_app_bar.dart';
import './components/categories.dart';
import './components/image_grid.dart';

import './services/api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedCategory = "";
  final TextEditingController querySearchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false, isRefreshing = false;

  dynamic images = [];
  dynamic config = {
    "image_type": "all",
    "orientation": "all",
    "colors": [],
  };

  dynamic prevParams = {};

  void fetchImages({Map<String, String> params = const {"page": "1"}, bool append = false}) async {
    // add the config to the params and change the colors array to a string separated by commas
    params = {
      ...params,
      'image_type': config['image_type'],
      'orientation': config['orientation'],
      'colors': config['colors'] != null ? config['colors'].join(',') : "",
    };

    // if the params are the same as the previous ones, don't fetch the images but if it's refreshing, fetch the images
    if (params.toString() == prevParams.toString() && !isRefreshing) {
      return;
    }

    prevParams = params;
    setState(() {
      isLoading = true;
    });

    dynamic res = await API().fetchFromPixabay(params);

    if (res['success'] && res['data']['hits'] != null) {
      setState(() {
        images =
            append ? [...images, ...res['data']['hits']] : res['data']['hits'];
      });

      if(images.isEmpty) {
        showSnackBar('No images found', const Color(0xFFe91e63));
      }
    } else {
      showSnackBar(
          'An error occurred while fetching images: ${res['msg']}',
          const Color(0xFFe91e63)
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  void showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: color,
      ),
    );
  }

  void _onRefresh() async {
    setState(() {
      isRefreshing = true;
    });

    fetchImages(
      params: {
        'category': selectedCategory,
        'q': querySearchController.text,
      },
    );

    setState(() {
      isRefreshing = false;
    });
  }

  void handleClickOnCategory(String category) {
    setState(() {
      if (selectedCategory == category) {
        selectedCategory = "";
      } else {
        selectedCategory = category;
      }
    });

    querySearchController.clear();
    _scrollController.jumpTo(0);

    fetchImages(params: {'category': category});
  }

  void handleChangeQuerySearch() {
    String query = querySearchController.text;
    selectedCategory = "";
    _scrollController.jumpTo(0);

    fetchImages(params: {'q': query});
  }

  void setConfig(dynamic newConfig) {
    config = newConfig;
    fetchImages(
      params: {
        'category': selectedCategory,
        'q': querySearchController.text,
      },
    );
  }

  @override
  void initState() {
    super.initState();

    fetchImages();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchImages(
          params: {
            'page': (images.length / 30 + 1).toInt().toString(),
            'category': selectedCategory,
            'q': querySearchController.text,
          },
          append: true,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: HomeAppBar(
          querySearchController: querySearchController,
          handleChangeQuerySearch: handleChangeQuerySearch,
          config: config,
          setConfig: setConfig,
        ),
        body: Column(
          children: [
            Flexible(
              flex: 0,
              child: Categories(
                selectedCategory: selectedCategory,
                handleClickOnCategory: handleClickOnCategory,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              ImageGrid(
                images: images,
                scrollController: _scrollController,
                onRefresh: _onRefresh,
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onRefresh,
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          child: isRefreshing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : const Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 30,
                ),
        ),
      ),
    );
  }
}
