import 'package:flutter/material.dart';

class OptionsModal extends StatefulWidget {
  const OptionsModal({
    super.key,
    required this.config,
    required this.setConfig,
  });

  final dynamic config;
  final void Function(dynamic) setConfig;

  @override
  State<OptionsModal> createState() => _OptionsModalState();
}

class _OptionsModalState extends State<OptionsModal> {
  static const colors = {
    "": Colors.grey,
    "grayscale": Colors.grey,
    "transparent": Colors.transparent,
    "red": Colors.red,
    "orange": Colors.orange,
    "yellow": Colors.yellow,
    "green": Colors.green,
    "turquoise": Colors.teal,
    "blue": Colors.blue,
    "lilac": Colors.purple,
    "pink": Colors.pink,
    "white": Colors.white,
    "gray": Colors.grey,
    "black": Colors.black,
    "brown": Colors.brown,
  };
  static const orientations = {
    "All": "all",
    "Horizontal": "horizontal",
    "Vertical": "vertical",
  };
  static const imageTypes = {
    "All": "all",
    "Photo": "photo",
    "Illustration": "illustration",
    "Vector": "vector",
  };

  dynamic config;

  @override
  void initState() {
    setState(() {
      config = widget.config;
    });
    super.initState();
  }

  void handleConfigSelection(String key, String value) {
    if (config[key] == value) {
      setState(() {
        config[key] = "all";
      });
      return;
    }
    setState(() {
      config[key] = value;
    });
  }

  void handleColorSelection(String key) {
    if (key == "") {
      setState(() {
        config["colors"] = [];
      });
      return;
    }
    if (config["colors"].contains(key)) {
      setState(() {
        config["colors"].remove(key);
      });
      return;
    }
    setState(() {
      config["colors"].add(key);
    });
  }

  void applyConfig(BuildContext context) {
    widget.setConfig(config);
    Navigator.pop(context);
  }

  void resetConfig() {
    setState(() {
      config = {
        "orientation": "all",
        "image_type": "all",
        "colors": [],
      };
    });
    widget.setConfig(config);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Orientation",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Wrap(
            children: orientations.keys
                .map(
                  (String key) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChoiceChip(
                      label: Text(key),
                      selected: config['orientation'] == orientations[key],
                      onSelected: (bool selected) {
                        handleConfigSelection(
                          "orientation",
                          orientations[key]!,
                        );
                      },
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Image Type",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Wrap(
            children: imageTypes.keys
                .map(
                  (String key) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChoiceChip(
                      label: Text(key),
                      selected: config['image_type'] == imageTypes[key],
                      onSelected: (bool selected) {
                        handleConfigSelection(
                          "image_type",
                          imageTypes[key]!,
                        );
                      },
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Color",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Wrap(
            children: colors.keys
                .map(
                  (String key) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 4.0),
                    child: ChoiceChip(
                      label: key == ""
                          ? const Text(
                              "All",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            )
                          : Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: colors[key],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: key == "transparent" ?
                                const Icon(
                                  Icons.apps,
                                  color: Colors.black,
                                  size: 18,
                                ) : null,
                            ),
                      selected: config['colors'].contains(key) ||
                          (key == "" && config['colors'].isEmpty),
                      onSelected: (bool selected) {
                        handleColorSelection(key);
                      },
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(
            height: 20,
          ),
          //   apply and reset button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.black),
                ),
                onPressed: () {
                  applyConfig(context);
                },
                child: const Text(
                  "Apply",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.black),
                ),
                onPressed: () {
                  resetConfig();
                },
                child: const Text(
                  "Reset",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Note: The changes will be applied to the next search",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
