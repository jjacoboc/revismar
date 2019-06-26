import 'section.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

class SectionList {
  List<Section> sections;

  SectionList({this.sections});

  List<Section> get getSections => sections;

  set setSections(List<Section> list) {
    this.sections = list;
  }

  //json factory
  factory SectionList.fromJson(List<dynamic> parsedJson) {
    List<Section> sections = new List<Section>();
    sections = parsedJson.map((i) => Section.fromJson(i)).toList();

    return new SectionList(sections: sections);
  }
}