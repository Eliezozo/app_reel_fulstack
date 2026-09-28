class Market {
  const Market({
    required this.id,
    required this.crop,
    required this.market,
    required this.unit,
    required this.price,
    required this.currency,
    required this.changePercent,
    required this.updatedAt,
  });

  final String id;
  final String crop;
  final String market;
  final String unit;
  final double price;
  final String currency;
  final double changePercent;
  final String updatedAt;
}
