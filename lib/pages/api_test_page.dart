import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ApiTestPage extends StatefulWidget {
  const ApiTestPage({super.key});

  @override
  State<ApiTestPage> createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {
  final ApiService _apiService = ApiService();
  final List<TestResult> _testResults = [];
  bool _isTesting = false;

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }

  Future<void> _runTests() async {
    setState(() {
      _isTesting = true;
      _testResults.clear();
    });

    // Test API Connection
    await _testEndpoint('API Connection Test', () => _apiService.testConnection());

    // Test Public Endpoints
    await _testEndpoint('Get Auctions List', () => _apiService.getAuctions());
    
    // Test Accounts with and without branch_id
    await _testEndpoint('Get All Accounts', () => _apiService.getAccounts());
    await _testEndpoint(
      'Get Accounts (with branch_id)', 
      () => _apiService.getAccounts(branchId: 'branch_1')
    );

    await _testEndpoint('Get Collaterals List', () => _apiService.getCollaterals());
    
    // Test Branches with and without region
    await _testEndpoint('Get All Branches', () => _apiService.getBranches());
    await _testEndpoint(
      'Get Branches (with region)', 
      () => _apiService.getBranches(region: 'central')
    );
    
    await _testEndpoint('Get Active Auctions', () => _apiService.getActiveAuctions());
    await _testEndpoint('Get Auction Items', () => _apiService.getAuctionItems());

    setState(() => _isTesting = false);
  }

  Future<void> _testEndpoint(String name, Future<dynamic> Function() test) async {
    try {
      final startTime = DateTime.now();
      final result = await test();
      final duration = DateTime.now().difference(startTime);
      
      setState(() {
        _testResults.add(TestResult(
          name: name,
          success: true,
          message: 'Success (${duration.inMilliseconds}ms)',
          response: result.toString(),
        ));
      });
    } catch (e) {
      setState(() {
        _testResults.add(TestResult(
          name: name,
          success: false,
          message: 'Error: $e',
          response: e.toString(),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Test'),
        actions: [
          if (_isTesting)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _runTests,
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: _testResults.length,
        itemBuilder: (context, index) {
          final result = _testResults[index];
          return ExpansionTile(
            leading: Icon(
              result.success ? Icons.check_circle : Icons.error,
              color: result.success ? Colors.green : Colors.red,
            ),
            title: Text(result.name),
            subtitle: Text(
              result.message,
              style: TextStyle(
                color: result.success ? Colors.green : Colors.red,
              ),
            ),
            children: [
              if (result.response != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SelectableText(
                    result.response!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isTesting ? null : _runTests,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}

class TestResult {
  final String name;
  final bool success;
  final String message;
  final String? response;

  TestResult({
    required this.name,
    required this.success,
    required this.message,
    this.response,
  });
} 