class AuctionItem {
  final String id;
  final String title;
  final String currentBid;
  final String timeLeft;
  final String category;
  final String weight;
  final String purity;
  final String startingPrice;
  final String reservedPrice;
  final String totalPrice;
  final String goldType;
  final String goldPrice;
  final String bidIncrement;
  final String description;

  AuctionItem({
    required this.id,
    required this.title,
    required this.currentBid,
    required this.timeLeft,
    required this.category,
    required this.weight,
    required this.purity,
    required this.startingPrice,
    required this.reservedPrice,
    required this.totalPrice,
    required this.goldType,
    required this.goldPrice,
    required this.bidIncrement,
    required this.description,
  });

  factory AuctionItem.fromJson(Map<String, dynamic> json) {
    return AuctionItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      currentBid: json['currentBid'] ?? 'RM 0.00',
      timeLeft: json['timeLeft'] ?? '',
      category: json['category'] ?? '',
      weight: json['weight'] ?? '',
      purity: json['purity'] ?? '',
      startingPrice: json['startingPrice'] ?? 'RM 0.00',
      reservedPrice: json['reservedPrice'] ?? 'RM 0.00',
      totalPrice: json['totalPrice'] ?? 'RM 0.00',
      goldType: json['goldType'] ?? '',
      goldPrice: json['goldPrice'] ?? 'RM 0.00/g',
      bidIncrement: json['bidIncrement'] ?? 'RM 0.00',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'currentBid': currentBid,
      'timeLeft': timeLeft,
      'category': category,
      'weight': weight,
      'purity': purity,
      'startingPrice': startingPrice,
      'reservedPrice': reservedPrice,
      'totalPrice': totalPrice,
      'goldType': goldType,
      'goldPrice': goldPrice,
      'bidIncrement': bidIncrement,
      'description': description,
    };
  }
} 