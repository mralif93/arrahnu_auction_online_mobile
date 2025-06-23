import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'account_collaterals_view.dart';

class BranchAccountsView extends StatelessWidget {
  final String branchName;
  final HomeController controller = Get.find<HomeController>();

  BranchAccountsView({Key? key, required this.branchName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accounts = controller.branchAccounts[branchName] ?? {};
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Accounts at $branchName',
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: accounts.isEmpty
          ? const Center(
              child: Text(
                'No accounts found at this branch',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final accountNumber = accounts.keys.elementAt(index);
                final accountDetails = accounts[accountNumber];
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      'Account: $accountNumber',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Balance: RM ${accountDetails['balance']?.toStringAsFixed(2) ?? '0.00'}',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Status: ${accountDetails['status'] ?? 'Unknown'}',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            color: _getStatusColor(accountDetails['status']),
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to account details
                      Get.toNamed('/account/$accountNumber');
                    },
                  ),
                );
              },
            ),
    );
  }
  
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
