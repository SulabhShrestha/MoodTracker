import 'package:flutter/material.dart';
import 'package:mood_tracker/bloc/bottom_navbar_bloc.dart';
import 'package:mood_tracker/view_models/mood_list_view_model.dart';
import 'package:mood_tracker/views/home_page/home_page.dart';
import 'package:mood_tracker/views/result_page/result_page.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Provider.of<BottomNavBarBloc>(context, listen: false)
                .counterSink
                .add(true);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false);
          },
        ),
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
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: 'Search',
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            showLoading = true;
                          });
                          var keyword = _textController.text.trim();
                          if (keyword.isNotEmpty) {
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
                          }
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
                ],
              ),
            ),
    );
  }
}
