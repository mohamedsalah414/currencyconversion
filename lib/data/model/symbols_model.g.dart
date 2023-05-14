// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symbols_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SymbolsModel _$SymbolsModelFromJson(Map<String, dynamic> json) => SymbolsModel(
      motd: Motd.fromJson(json['motd'] as Map<String, dynamic>),
      success: json['success'] as bool,
      symbols: (json['symbols'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Currency.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$SymbolsModelToJson(SymbolsModel instance) =>
    <String, dynamic>{
      'motd': instance.motd,
      'success': instance.success,
      'symbols': instance.symbols,
    };

Motd _$MotdFromJson(Map<String, dynamic> json) => Motd(
      msg: json['msg'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$MotdToJson(Motd instance) => <String, dynamic>{
      'msg': instance.msg,
      'url': instance.url,
    };

Currency _$CurrencyFromJson(Map<String, dynamic> json) => Currency(
      description: json['description'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$CurrencyToJson(Currency instance) => <String, dynamic>{
      'description': instance.description,
      'code': instance.code,
    };
