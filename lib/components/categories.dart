import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  final String selectedCategory;
  final void Function(String category)? handleClickOnCategory;

  const Categories(
      {super.key,
      required this.selectedCategory,
      required this.handleClickOnCategory});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final categories = [
    "backgrounds",
    "fashion",
    "nature",
    "science",
    "education",
    "feelings",
    "health",
    "people",
    "religion",
    "places",
    "animals",
    "industry",
    "computer",
    "food",
    "sports",
    "transportation",
    "travel",
    "buildings",
    "business",
    "music"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      margin: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: MediaQuery.of(context).size.width > 800 ? 50 : 8,
      ),
      alignment: Alignment.bottomCenter,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              widget.handleClickOnCategory!(categories[index]);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                color: widget.selectedCategory == categories[index] ? Colors.black : Colors.white,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: widget.selectedCategory == categories[index]
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
