// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Section _$SectionFromJson(Map<String, dynamic> json) {
  return Section(
      json['idtSection'] as int,
      json['idtBook'] as int,
      json['name'] as String,
      json['order'] as int,
      json['createdBy'] as int,
      json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
      json['updatedBy'] as int,
      json['updatedDate'] == null
          ? null
          : DateTime.parse(json['updatedDate'] as String),
      (json['articles'] as List)
          ?.map((e) =>
              e == null ? null : Article.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$SectionToJson(Section instance) => <String, dynamic>{
      'idtSection': instance.idtSection,
      'idtBook': instance.idtBook,
      'name': instance.name,
      'order': instance.order,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate?.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'updatedDate': instance.updatedDate?.toIso8601String(),
      'articles': instance.articles
    };
