import 'package:flutter/material.dart';

import '../../../common/utils/colors.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController _searchController;
  final Function search;
  const SearchBar({
    super.key,
    required this.search,
    required TextEditingController searchController,
  }) : _searchController = searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      decoration: BoxDecoration(
        color: Colours.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => search(value),
        onSubmitted: (value) {
          FocusScope.of(context).unfocus();
          search(value);
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            size: 20,
            color: Colours.black,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(
            color: Colours.grey,
          ),
        ),
      ),
    );
  }
}
