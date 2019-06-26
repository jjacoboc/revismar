// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) {
  return Article(
      json['idtArticle'] as int,
      json['idtSection'] as int,
      json['name'] as String,
      json['author'] as String,
      json['order'] as int,
      json['createdBy'] as int,
      json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
      json['updatedBy'] as int,
      json['updatedDate'] == null
          ? null
          : DateTime.parse(json['updatedDate'] as String));
}

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'idtArticle': instance.idtArticle,
      'idtSection': instance.idtSection,
      'name': instance.name,
      'author': instance.author,
      'order': instance.order,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate?.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'updatedDate': instance.updatedDate?.toIso8601String()
    };
