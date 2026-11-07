import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const CFBSCalculator());
}

class CFBSCalculator extends StatelessWidget {
  const CFBSCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CFBS Scientific Calculator',
      theme: ThemeData.dark(),
      home: const CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String expression = '';
  String result = '0';
  bool degreeMode = true;

  final List<List<String>> keys = [
    ['SHIFT', 'ALPHA', 'MODE', 'DEL', 'AC'],
    ['sin', 'cos', 'tan', 'log', 'ln'],
    ['√', 'x²', 'xʸ', '(', ')'],
    ['7', '8', '9', '÷', 'π'],
    ['4', '5', '6', '×', 'e'],
    ['1', '2', '3', '-', 'Ans'],
    ['0', '.', 'EXP', '+', '='],
  ];

  void press(String key) {
    setState(() {
      if (key == 'AC') {
        expression = '';
        result = '0';
      } else if (key == 'DEL') {
        if (expression.isNotEmpty) {
          expression =
              expression.substring(0, expression.length - 1);
        }
      } else if (key == 'MODE') {
        degreeMode = !degreeMode;
      } else if (key == '=') {
        calculate();
      } else if (key == 'π') {
        expression += math.pi.toString();
      } else if (key == 'e') {
        expression += math.e.toString();
      } else if (key == 'sin' ||
          key == 'cos' ||
          key == 'tan' ||
          key == 'log' ||
          key == 'ln' ||
          key == '√') {
        expression += '$key(';
      } else if (key == 'x²') {
        expression += '^2';
      } else if (key == 'xʸ') {
        expression += '^';
      } else if (key == 'Ans') {
        expression += result;
      } else {
        expression += key;
      }
    });
  }

  void calculate() {
    try {
      result = 'Function ready';
    } catch (e) {
      result = 'Error';
    }
  }

  Color keyColor(String key) {
    if (key == '=') return const Color(0xFF1976D2);
    if (['AC', 'DEL'].contains(key)) {
      return const Color(0xFFB64B42);
    }
    if (['SHIFT', 'ALPHA', 'MODE'].contains(key)) {
      return const Color(0xFF52677D);
    }
    if (['+', '-', '×', '÷'].contains(key)) {
      return const Color(0xFF344D68);
    }
    return const Color(0xFFE1E7ED);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101B29),
      appBar: AppBar(
        backgroundColor: const Color(0xFF193B63),
        title: const Text(
          'CFBS SCIENTIFIC CALCULATOR',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            height: 155,
            decoration: BoxDecoration(
              color: const Color(0xFFDCE7D9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.blueGrey,
                width: 3,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  degreeMode ? 'DEG' : 'RAD',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    expression,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  result,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: keys.length * 5,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1.15,
                crossAxisSpacing: 7,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final key = keys[index ~/ 5][index % 5];

                return ElevatedButton(
                  onPressed: () => press(key),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: keyColor(key),
                    foregroundColor:
                        keyColor(key) == const Color(0xFFE1E7ED)
                            ? Colors.black87
                            : Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      key,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'CHINDWIN FUTURE BRIGHT SCHOOL',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
