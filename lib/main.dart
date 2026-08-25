import 'package:flutter/material.dart';

void main() {
  runApp(const RguktApp());
}

class RguktApp extends StatelessWidget {
  const RguktApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RGUKT Mid Calc',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  double? _result;

  void _calculate() {
    List<double> scores = [];
    for (var controller in _controllers) {
      double? val = double.tryParse(controller.text);
      if (val != null) {
        scores.add(val);
      }
    }

    if (scores.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least 4 mid marks')),
      );
      return;
    }

    // Sort descending and take best 4
    scores.sort((a, b) => b.compareTo(a));
    List<double> bestFour = scores.take(4).toList();
    double sum = bestFour.reduce((a, b) => a + b);

    setState(() {
      _result = sum / 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RGUKT Mid Marks Calculator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Enter marks for 6 Mids (Best 4 will be selected):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...List.generate(6, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextField(
                  controller: _controllers[index],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Mid ${index + 1} Marks',
                    border: const OutlineInputBorder(),
                  ),
                ),
              );
            }),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Calculate Best 4 Average',
                  style: TextStyle(fontSize: 18)),
            ),
            if (_result != null) ...[
              const SizedBox(height: 20),
              Card(
                color: Colors.teal.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Final Score: ${_result!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
