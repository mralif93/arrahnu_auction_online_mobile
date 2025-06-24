import 'auction_item.dart';

class BranchAuctionData {
  final String branchName;
  final String? accountName;
  final String? accountNumber;
  final List<AuctionItem> collaterals;
  final int totalAccounts;
  final int totalCollaterals;

  BranchAuctionData({
    required this.branchName,
    this.accountName,
    this.accountNumber,
    required this.collaterals,
    this.totalAccounts = 0,
    this.totalCollaterals = 0,
  });

  factory BranchAuctionData.fromJson(String branchName, Map<String, dynamic> json) {
    // Initialize lists to store all accounts and collaterals
    final allCollaterals = <AuctionItem>[];
    var accountCount = 0;

    // Process each account entry in the branch data
    json.forEach((accountKey, accountData) {
      if (accountData is Map<String, dynamic>) {
        accountCount++;
        final collateralsList = (accountData['collaterals'] as List?)?.map(
          (item) => AuctionItem.fromJson(item as Map<String, dynamic>)
        ).toList() ?? [];
        allCollaterals.addAll(collateralsList);
      }
    });

    // Get the first account's data for display (since UI only shows one)
    final firstAccountData = json.entries.first.value as Map<String, dynamic>;

    return BranchAuctionData(
      branchName: branchName,
      accountName: firstAccountData['accountName'],
      accountNumber: firstAccountData['accountNumber'],
      collaterals: allCollaterals,
      totalAccounts: accountCount,
      totalCollaterals: allCollaterals.length,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchName': branchName,
      'accountName': accountName,
      'accountNumber': accountNumber,
      'collaterals': collaterals.map((item) => item.toJson()).toList(),
      'totalAccounts': totalAccounts,
      'totalCollaterals': totalCollaterals,
    };
  }
}

class AccountData {
  final String? accountName;
  final String? accountNumber;
  final List<AuctionItem> collaterals;

  AccountData({
    this.accountName,
    this.accountNumber,
    required this.collaterals,
  });

  factory AccountData.fromJson(Map<String, dynamic> json) {
    final collateralsList = (json['collaterals'] as List?)?.map(
      (item) => AuctionItem.fromJson(item as Map<String, dynamic>)
    ).toList() ?? [];

    return AccountData(
      accountName: json['accountName'],
      accountNumber: json['accountNumber'],
      collaterals: collateralsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountName': accountName,
      'accountNumber': accountNumber,
      'collaterals': collaterals.map((item) => item.toJson()).toList(),
    };
  }
} 