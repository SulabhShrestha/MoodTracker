import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/mood_list_view_model.dart';

import '../result_page/result_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _textController = TextEditingController();
  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: (){
          Navigator.of(context).pop();
        },),
      ),
      body: showLoading
          ? const CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        showLoading = true;
                      });
                      var keyword = _textController.text.trim();
                      await MoodListViewModel()
                          .searchMoodsByKeyword(searchKeyword: keyword)
                          .then((value) {
                        if (value.isNotEmpty) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ResultPage(
                                    resultMoods: value,
                                    keyword: keyword,
                                  )));
                        }
                      });

                      setState(() {
                        showLoading = false;
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue)),
                    child: const Text("Search",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
    );
  }
}
