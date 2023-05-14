class ExchangeRates {
  ExchangeRates({
    required this.motd,
    required this.success,
    required this.timeseries,
    required this.base,
    required this.startDate,
    required this.endDate,
    required this.rates,
  });

  final Motd motd;
  final bool success;
  final bool timeseries;
  final String base;
  final String startDate;
  final String endDate;
  final Map<String, Map<String, double>> rates;

  factory ExchangeRates.fromJson(Map<String, dynamic> json) => ExchangeRates(
        motd: Motd.fromJson(json['motd']),
        success: json['success'],
        timeseries: json['timeseries'],
        base: json['base'],
        startDate: json['start_date'],
        endDate: json['end_date'],
        rates: Map.from(json['rates']).map((k, v) =>
            MapEntry<String, Map<String, double>>(
                k,
                Map.from(v)
                    .map((k, v) => MapEntry<String, double>(k, v.toDouble())))),
      );
}

class Motd {
  Motd({
    required this.msg,
    required this.url,
  });

  final String msg;
  final String url;

  factory Motd.fromJson(Map<String, dynamic> json) => Motd(
        msg: json['msg'],
        url: json['url'],
      );
}
