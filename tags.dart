import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart'; // provider: ^4.3.2+2
import 'package:local_hero/local_hero.dart'; // local_hero: ^0.1.0

//MODELS
enum TagState { idle, selected } // selected tags will be displayed first

List<String> userTags = List<String>(); //selected tags output

class Tag implements Comparable {
  String tagName;
  String tagDisplayName;
  TagState tagState;

  Tag(
      {@required String tagName,
      @required String tagDisplayName,
      @required TagState tagState}) {
    this.tagName = tagName;
    this.tagDisplayName = tagDisplayName;
    this.tagState = tagState;
  }

  @override // Tag sorting
  int compareTo(other) {
    if (this.tagState == null || other == null) {
      return null;
    }
    if (this.tagState == TagState.selected && other.tagState == TagState.idle) {
      return -1;
    }
    if (this.tagState == TagState.idle && other.tagState == TagState.selected) {
      return 1;
    }
    if (this.tagState == TagState.selected &&
        other.tagState == TagState.selected) {
      return 0;
    }
    if (this.tagState == TagState.idle && other.tagState == TagState.idle) {
      return 0;
    }
    return null;
  }
}

class TagList extends ChangeNotifier {
  List<Tag> _tagList = List<Tag>();

  UnmodifiableListView<Tag> get tagList => UnmodifiableListView(_tagList);

  void init(List<Tag> tagListAdd) {
    _tagList.addAll(tagListAdd);
  }

  void addTag(Tag _tag) {
    _tagList.add(_tag);
    notifyListeners();
  }

  void updateTagState(Tag tag, TagState _newState) {
    //switch between states and move up-down
    tag.tagState = _newState;
    _tagList.sort((a, b) => a.compareTo(b));
    userTags.clear();
    tagList.forEach((element) {
      if (element.tagState == TagState.selected) {
        userTags.add(element.tagName);
      }
    });
    notifyListeners();
  }
}

//WIDGETS
class TagChips extends StatelessWidget {
  //Visual FilterChip
  final Tag tag;
  final TagList tagList;
  TagChips({@required this.tag, @required this.tagList, @required Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TagState newState = tag.tagState == TagState.selected
        ? TagState.idle
        : TagState.selected; //Switch between states
    return LocalHeroScope(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: LocalHero(
          tag: tag.tagName,
          key: Key(tag.tagName),
          child: Material(
            key: Key(tag.tagName),
            color: Colors.transparent,
            child: Consumer<TagList>(
              builder: (context, tagList, child) {
                return FilterChip(
                  key: Key(tag.tagName),
                  label: Text(tag.tagDisplayName),
                  labelStyle: Theme.of(context).textTheme.bodyText1,
                  selected: tag.tagState == TagState.selected ? true : false,
                  selectedColor: Theme.of(context).primaryColor,
                  showCheckmark: true,
                  onSelected: (bool value) {
                    tagList.updateTagState(tag, newState);
                  },
                );
              },
            ),
          ),
        ));
  }
}

// ignore: must_be_immutable
class TagGrid extends StatefulWidget {
  List<Tag> providedTags;
  TagGrid({this.providedTags}); //tag input
  @override
  _TagGridState createState() => _TagGridState();
}

class _TagGridState extends State<TagGrid> {
  @override
  void initState() {
    Provider.of<TagList>(context, listen: false)
        .init(widget.providedTags); //initialize tags
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Consumer<TagList>(
          builder: (context, tagList, child) {
            return Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                alignment: WrapAlignment.center,
                children: tagList.tagList.map((Tag tag) {
                  return TagChips(
                    tag: tag,
                    tagList: tagList,
                    key: Key(tag.tagName),
                  );
                }).toList());
          },
        ),
      ),
    );
  }
}
