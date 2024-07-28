import 'package:flutter/material.dart';

import './options_modal.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    required this.querySearchController,
    required this.handleChangeQuerySearch,
    required this.config,
    required this.setConfig,
  });

  final TextEditingController querySearchController;
  final void Function() handleChangeQuerySearch;
  final dynamic config;
  final void Function(dynamic) setConfig;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 800 ? 50 : 0.0,
        vertical: 10.0,
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        title: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Text(
            "Pixel",
            style: TextStyle(
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        surfaceTintColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: const Icon(
                Icons.art_track_sharp,
                size: 42.0,
              ),
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: OptionsModal(
                        config: config,
                        setConfig: setConfig,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Material(
                color: Colors.grey[300],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(Icons.search, color: Colors.grey),
                    Expanded(
                      child: TextField(
                        controller: querySearchController,
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Search by name or address',
                        ),
                        onSubmitted: (value) {
                          handleChangeQuerySearch();
                        },
                      ),
                    ),
                    querySearchController.text.isNotEmpty
                        ? InkWell(
                            child: const Icon(
                              Icons.clear,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              querySearchController.clear();
                              handleChangeQuerySearch();
                            },
                          )
                        : InkWell(
                            child: const Icon(
                              Icons.send,
                              color: Colors.grey,
                            ),
                            onTap: () {
                              handleChangeQuerySearch();
                            },
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}
