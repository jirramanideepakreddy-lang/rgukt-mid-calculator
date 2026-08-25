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
  final TextEditingController _targetController = TextEditingController();

  double? _calculatedAverage;
  String _targetAnalysis = '';

  void _calculateAverage() {
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

    scores.sort((a, b) => b.compareTo(a));
    List<double> bestFour = scores.take(4).toList();
    double sum = bestFour.reduce((a, b) => a + b);

    setState(() {
      _calculatedAverage = sum / 4;
    });
  }

  void _analyzeTarget() {
    double? target = double.tryParse(_targetController.text);
    if (target == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid target average')),
      );
      return;
    }

    List<double> entered = [];
    for (var controller in _controllers) {
      double? val = double.tryParse(controller.text);
      if (val != null) {
        entered.add(val);
      }
    }

    double requiredTotalSum = target * 4;
    
    if (entered.length >= 4) {
      entered.sort((a, b) => b.compareTo(a));
      double currentBest4Sum = entered.take(4).reduce((a, b) => a + b);
      double currentAvg = currentBest4Sum / 4;
      if (currentAvg >= target) {
        setState(() {
          _targetAnalysis = '🎉 Target Achieved! Your current Best 4 average is ${currentAvg.toStringAsFixed(2)}';
        });
      } else {
        setState(() {
          _targetAnalysis = 'Current Best 4 average is ${currentAvg.toStringAsFixed(2)}, which is below your target of ${target.toStringAsFixed(2)}.';
        });
      }
      return;
    }

    double currentSum = entered.isEmpty ? 0 : entered.reduce((a, b) => a + b);
    double neededRemainingSum = requiredTotalSum - currentSum;
    int remainingMidsToPick = 4 - entered.length;
    double requiredPerMid = neededRemainingSum / remainingMidsToPick;

    if (requiredPerMid > 30) { 
      setState(() {
        _targetAnalysis = '⚠️ Target of ${target.toStringAsFixed(2)} is mathematically impossible with your current scores (requires >30 per remaining mid).';
      });
    } else if (requiredPerMid <= 0) {
      setState(() {
        _targetAnalysis = '🎉 You have already secured enough marks to hit your target of ${target.toStringAsFixed(2)}!';
      });
    } else {
      setState(() {
        _targetAnalysis = 'To reach an average of ${target.toStringAsFixed(2)}:\n'
            '• You need a total of ${neededRemainingSum.toStringAsFixed(2)} marks across your next $remainingMidsToPick required best Mids.\n'
            '• Minimum average needed per remaining Mid: ${requiredPerMid.toStringAsFixed(2)}';
      });
    }
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
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const Text('Target Average Predictor',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _targetController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Desired Target Average',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Enter Mid Marks:'),
            const SizedBox(height: 8),
            ...List.generate(6, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
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
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _calculateAverage,
                    child: const Text('Calc Best 4 Avg'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _analyzeTarget,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade100),
                    child: const Text('Predict Required', style: TextStyle(color: Colors.black87)),
                  ),
                ),
              ],
            ),
            if (_calculatedAverage != null) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.teal.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Best 4 Average: ${_calculatedAverage!.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
            if (_targetAnalysis.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(_targetAnalysis, style: const TextStyle(fontSize: 15)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
