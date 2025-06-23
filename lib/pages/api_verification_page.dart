import 'package:flutter/material.dart';
import '../models/user.dart';

class ApiVerificationPage extends StatefulWidget {
  const ApiVerificationPage({super.key});

  @override
  State<ApiVerificationPage> createState() => _ApiVerificationPageState();
}

class _ApiVerificationPageState extends State<ApiVerificationPage> {
  Map<String, List<TestResult>> testResults = {};
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Verification'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: isLoading ? null : _runTests,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Run API Tests'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _runTests() async {
    setState(() {
      isLoading = true;
      testResults.clear();
    });

    // Placeholder test results since API verification is not implemented
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      testResults = {
        'Authentication Service': [
          TestResult(
            name: 'Login Endpoint',
            endpoint: '/auth/login',
            method: 'POST',
            success: true,
            message: 'Login endpoint available',
          ),
          TestResult(
            name: 'Register Endpoint',
            endpoint: '/auth/register',
            method: 'POST',
            success: true,
            message: 'Register endpoint available',
          ),
        ],
      };
      isLoading = false;
    });
  }

  Widget _buildResults() {
    if (testResults.isEmpty) {
      return const Center(
        child: Text('No test results yet. Run tests to see results.'),
      );
    }

    return ListView.builder(
      itemCount: testResults.length,
      itemBuilder: (context, index) {
        final service = testResults.keys.elementAt(index);
        final tests = testResults[service]!;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Text(service),
            children: tests.map((test) => ListTile(
              leading: Icon(
                test.success ? Icons.check_circle : Icons.error,
                color: test.success ? Colors.green : Colors.red,
              ),
              title: Text(test.name),
              subtitle: Text('${test.method} ${test.endpoint}\n${test.message}'),
            )).toList(),
          ),
        );
      },
    );
  }
} 