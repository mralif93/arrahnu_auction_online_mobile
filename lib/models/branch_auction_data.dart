import 'auction_item.dart';

class BranchAuctionData {
  final String branchName;
  final String? accountName;
  final String? accountNumber;
  final List<AuctionItem> collaterals;

  BranchAuctionData({
    required this.branchName,
    this.accountName,
    this.accountNumber,
    required this.collaterals,
  });

  factory BranchAuctionData.fromJson(String branchName, Map<String, dynamic> json) {
    final accountData = json[''] ?? {};  // Handle empty key in the JSON
    final collateralsList = (accountData['collaterals'] as List?)?.map(
      (item) => AuctionItem.fromJson(item as Map<String, dynamic>)
    ).toList() ?? [];

    return BranchAuctionData(
      branchName: branchName,
      accountName: accountData['accountName'],
      accountNumber: accountData['accountNumber'],
      collaterals: collateralsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchName': branchName,
      'accountName': accountName,
      'accountNumber': accountNumber,
      'collaterals': collaterals.map((item) => item.toJson()).toList(),
    };
  }
} 