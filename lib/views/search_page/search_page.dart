import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mood_tracker/view_models/mood_list_view_model.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          leading: const Icon(Icons.arrow_back),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Search',
                ),
                onSubmitted: (value) {},
              ),
              const Expanded(
                child: SizedBox(),
              ),
              TextButton(
                onPressed: () async {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (_) => ResultPage(
                  //           textToSearch: _textController.text.trim(),
                  //         )));

                  var data = await MoodListViewModel().searchMoodsByKeyword(
                      searchKeyword: _textController.text.trim());

                  if (data.isNotEmpty) {
                    log("FINAL DATA: $data");
                  } else {
                    log("Not found");
                  }
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
                child:
                    const Text("Search", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
