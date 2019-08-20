// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) {
  return Book(
      json['idtBook'] as int,
      json['code'] as String,
      json['title'] as String,
      json['author'] as String,
      json['publisher'] as String,
      json['edition'] as int,
      json['year'] as int,
      json['url'] as String,
      json['hasAudio'] as int,
      json['createdBy'] as int,
      json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
      json['updatedBy'] as int,
      json['updatedDate'] == null
          ? null
          : DateTime.parse(json['updatedDate'] as String));
}

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'idtBook': instance.idtBook,
      'code': instance.code,
      'title': instance.title,
      'author': instance.author,
      'publisher': instance.publisher,
      'edition': instance.edition,
      'year': instance.year,
      'url': instance.url,
      'hasAudio': instance.hasAudio,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate?.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'updatedDate': instance.updatedDate?.toIso8601String()
    };
