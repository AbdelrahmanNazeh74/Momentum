import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:momentum/features/HomeScreen/data/models/task_model.dart';

class TaskSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [ 
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final taskBox = Hive.box<Task>('tasks');
    final searchResults = taskBox.values
        .where((task) => task.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final task = searchResults[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description ?? ''),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final taskBox = Hive.box<Task>('tasks');
    final suggestionList = query.isEmpty
        ? taskBox.values.toList() // Show all tasks initially
        : taskBox.values
            .where((task) => task.title.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final task = suggestionList[index];
        return ListTile(
          title: Text(task.title),
          onTap: () {
            query = task.title;
            showResults(context);
          },
        );
      },
    );
  }
}
