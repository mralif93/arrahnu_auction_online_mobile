import 'branch_auction_data.dart';
import 'auction_item.dart';

class AuctionItemsResponse {
  final bool success;
  final String message;
  final List<BranchAuctionData> branchData;

  AuctionItemsResponse({
    required this.success,
    required this.message,
    required this.branchData,
  });

  factory AuctionItemsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final branches = data.entries.map((entry) {
      return BranchAuctionData.fromJson(
        entry.key,  // branch name
        entry.value as Map<String, dynamic>,
      );
    }).toList();

    return AuctionItemsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      branchData: branches,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': Map.fromEntries(
        branchData.map((branch) => MapEntry(
          branch.branchName,
          {
            '': {
              'accountName': branch.accountName,
              'accountNumber': branch.accountNumber,
              'collaterals': branch.collaterals.map((item) => item.toJson()).toList(),
            }
          },
        )),
      ),
    };
  }

  // Helper method to get all collaterals across all branches
  List<AuctionItem> get allCollaterals {
    return branchData.expand((branch) => branch.collaterals).toList();
  }

  // Helper method to get collaterals for a specific branch
  List<AuctionItem> getCollateralsByBranch(String branchName) {
    return branchData
        .firstWhere(
          (branch) => branch.branchName == branchName,
          orElse: () => BranchAuctionData(
            branchName: branchName,
            collaterals: [],
          ),
        )
        .collaterals;
  }
} 