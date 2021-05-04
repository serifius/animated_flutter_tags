# animated_flutter_tags
An animated tag selector module for flutter projects

## Usage

This module depends on provider and local hero packages. 

main.dart file
``` dart 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tags.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(bodyText1: TextStyle(fontSize: 30.0)),
        ),
        home: Interests(),
      ),providers: [
        ChangeNotifierProvider(create: (context) => TagList(),),
      //provider
      )],
    );
  }

//SCREENS
class Interests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Create a list of tags
    List<Tag> providedTags = [
      Tag(
          tagName: "history",
          tagDisplayName: "History",
          tagState: TagState.idle),
      Tag(
          tagName: "science",
          tagDisplayName: "Science",
          tagState: TagState.idle),
      Tag(
          tagName: "tech",
          tagDisplayName: "Technology",
          tagState: TagState.idle),
      Tag(
          tagName: "philo",
          tagDisplayName: "Philosophy",
          tagState: TagState.idle),
      Tag(
          tagName: "ent",
          tagDisplayName: "Entertainment",
          tagState: TagState.idle),
      Tag(tagName: "art", tagDisplayName: "Art", tagState: TagState.idle),
      Tag(tagName: "game", tagDisplayName: "Gaming", tagState: TagState.idle),
      Tag(
          tagName: "politics",
          tagDisplayName: "Politics",
          tagState: TagState.idle),
      Tag(
          tagName: "me",
          tagDisplayName: "How much I love Serif",
          tagState: TagState.idle)
    ];
    return Scaffold(
      appBar: AppBar(),
      body: TagGrid(
        providedTags: providedTags,
      ),
    );
  }
}
```

