import 'package:json_annotation/json_annotation.dart';

part 'symbols_model.g.dart';

@JsonSerializable()
class SymbolsModel {
  final Motd motd;
  final bool success;
  final Map<String, Currency> symbols;

  SymbolsModel({
    required this.motd,
    required this.success,
    required this.symbols,
  });

  factory SymbolsModel.fromJson(Map<String, dynamic> json) =>
      _$SymbolsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SymbolsModelToJson(this);
}

@JsonSerializable()
class Motd {
  final String msg;
  final String url;

  Motd({
    required this.msg,
    required this.url,
  });

  factory Motd.fromJson(Map<String, dynamic> json) => _$MotdFromJson(json);

  Map<String, dynamic> toJson() => _$MotdToJson(this);
}

@JsonSerializable()
class Currency {
  final String description;
  final String code;

  Currency({
    required this.description,
    required this.code,
  });

  factory Currency.fromJson(Map<String, dynamic> json) =>
      _$CurrencyFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyToJson(this);
}
