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
  bool searchButtonDisable = true; // for disabling button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: showLoading
          ? const CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (str) {
                            setState(() {
                              searchButtonDisable = str.isEmpty;
                            });
                          },
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: 'Search',
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: searchButtonDisable
                            ? null
                            : () async {
                                setState(() {
                                  showLoading = true;
                                });
                                var keyword = _textController.text.trim();
                                if (keyword.isEmpty) {
                                  showSnackBar(context, "Nothing to display");
                                } else {
                                  await MoodListViewModel()
                                      .searchMoodsByKeyword(
                                          searchKeyword: keyword)
                                      .then((value) {
                                    if (value.isNotEmpty) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
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
                              },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                searchButtonDisable
                                    ? Colors.grey
                                    : Colors.blue)),
                        child: const Text("Search",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
