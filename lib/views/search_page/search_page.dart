import 'package:flutter/material.dart';
import 'package:mood_tracker/utils/pop_up.dart';
import 'package:mood_tracker/view_models/mood_list_view_model.dart';
import 'package:mood_tracker/views/result_page/result_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _textController = TextEditingController();
  bool showLoading = false;
  String keyword = ""; // what the user wants to search

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: showLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _textController,
                textInputAction: TextInputAction.search,
                onChanged: (str) => setState(() => keyword = str),
                onSubmitted: (str) => handleSearch(),
                decoration: InputDecoration(
                  hintText: 'Search',
                  suffixIcon: keyword.isEmpty ? null : clearTextButton(),
                ),
              ),
            ),
    );
  }

  // deletes the text from textfield
  Widget clearTextButton() {
    return IconButton(
      onPressed: () {
        _textController.clear();
        setState(() {});
      },
      icon: const Icon(Icons.close),
    );
  }

  void handleSearch() async {
    setState(() {
      showLoading = true;
    });
    var keyword = _textController.text.trim();
    if (keyword.isEmpty) {
      showSnackBar(context, "Nothing to display");
    } else {
      await MoodListViewModel()
          .searchMoodsByKeyword(searchKeyword: keyword)
          .then((value) {
        if (value.isNotEmpty) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ResultPage(
                    resultMoods: value,
                    keyword: keyword,
                  )));
        } else {
          showSnackBar(context, "No result found.");
        }
      });
    }
    setState(() {
      showLoading = false;
    });
  }
}
