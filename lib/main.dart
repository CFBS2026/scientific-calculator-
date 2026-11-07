
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
  String answer = '0';

  bool degreeMode = true;
  bool shiftMode = false;

  final List<List<String>> keys = [
    ['SHIFT', 'MODE', 'DEL', 'AC', 'Ans'],
    ['sin', 'cos', 'tan', 'log', 'ln'],
    ['√', 'x²', 'xʸ', '(', ')'],
    ['7', '8', '9', '÷', 'π'],
    ['4', '5', '6', '×', 'e'],
    ['1', '2', '3', '-', 'EXP'],
    ['0', '.', '00', '+', '='],
  ];

  void press(String key) {
    setState(() {
      switch (key) {
        case 'SHIFT':
          shiftMode = !shiftMode;
          break;

        case 'MODE':
          degreeMode = !degreeMode;
          break;

        case 'AC':
          expression = '';
          result = '0';
          shiftMode = false;
          break;

        case 'DEL':
          if (expression.isNotEmpty) {
            expression =
                expression.substring(0, expression.length - 1);
          }
          break;

        case '=':
          calculate();
          break;

        case 'sin':
        case 'cos':
        case 'tan':
          if (shiftMode) {
            expression += 'a$key(';
          } else {
            expression += '$key(';
          }
          shiftMode = false;
          break;

        case 'log':
        case 'ln':
          expression += '$key(';
          shiftMode = false;
          break;

        case '√':
          expression += 'sqrt(';
          break;

        case 'x²':
          expression += '^2';
          break;

        case 'xʸ':
          expression += '^';
          break;

        case 'π':
          expression += 'pi';
          break;

        case 'e':
          expression += 'e';
          break;

        case 'Ans':
          expression += answer;
          break;

        case 'EXP':
          expression += '*10^';
          break;

        default:
          expression += key;
      }
    });
  }

  void calculate() {
    try {
      if (expression.trim().isEmpty) return;

      final parser = ScientificParser(
        expression,
        degreeMode,
      );

      final value = parser.parse();

      if (!value.isFinite || value.isNaN) {
        throw Exception('Math Error');
      }

      result = formatResult(value);
      answer = result;
    } catch (e) {
      result = 'Math Error';
    }
  }

  String formatResult(double value) {
    if (value.abs() < 0.0000000001) {
      value = 0;
    }

    String output = value.toStringAsPrecision(10);

    if (output.contains('e')) {
      return output;
    }

    if (output.contains('.')) {
      output = output.replaceAll(RegExp(r'0+$'), '');
      output = output.replaceAll(RegExp(r'\.$'), '');
    }

    return output;
  }

  Color keyColor(String key) {
    if (key == '=') {
      return const Color(0xFF1976D2);
    }

    if (key == 'AC' || key == 'DEL') {
      return const Color(0xFFB64B42);
    }

    if (key == 'SHIFT' || key == 'MODE') {
      return const Color(0xFF52677D);
    }

    if (['+', '-', '×', '÷'].contains(key)) {
      return const Color(0xFF344D68);
    }

    if (key == 'SHIFT' && shiftMode) {
      return Colors.orange;
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
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        shiftMode ? 'SHIFT ON' : '',
                        style: const TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        degreeMode ? 'DEG' : 'RAD',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      result,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
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

                  final color = key == 'SHIFT' && shiftMode
                      ? Colors.orange
                      : keyColor(key);

                  return ElevatedButton(
                    onPressed: () => press(key),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor:
                          color == const Color(0xFFE1E7ED)
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
      ),
    );
  }
}

// SCIENTIFIC CALCULATION ENGINE

class ScientificParser {
  final String input;
  final bool degreeMode;

  late List<String> tokens;
  int position = 0;

  ScientificParser(this.input, this.degreeMode) {
    tokens = tokenize(input);
  }

  List<String> tokenize(String text) {
    final pattern = RegExp(
      r'\d+(?:\.\d*)?(?:[eE][+-]?\d+)?'
      r'|\.\d+(?:[eE][+-]?\d+)?'
      r'|[a-zA-Z]+'
      r'|[+\-*/^()]',
    );

    final matches = pattern.allMatches(text).toList();

    final found = matches.map((m) => m.group(0)!).toList();

    final combined = found.join();

    final cleaned = text.replaceAll('×', '*').replaceAll('÷', '/');

    if (found.join() != cleaned.replaceAll(' ', '')) {
      throw Exception('Invalid expression');
    }

    return found;
  }

  String? get current =>
      position < tokens.length ? tokens[position] : null;

  bool match(String token) {
    if (current == token) {
      position++;
      return true;
    }
    return false;
  }

  void expect(String token) {
    if (!match(token)) {
      throw Exception('Expected $token');
    }
  }

  double parse() {
    if (tokens.isEmpty) {
      throw Exception('Empty');
    }

    final value = parseAdd();

    if (position != tokens.length) {
      throw Exception('Invalid expression');
    }

    return value;
  }

  double parseAdd() {
    double value = parseMultiply();

    while (current == '+' || current == '-') {
      final op = tokens[position++];

      final right = parseMultiply();

      value = op == '+'
          ? value + right
          : value - right;
    }

    return value;
  }

  bool startsPrimary(String? token) {
    if (token == null) return false;

    return token == '(' ||
        RegExp(r'^\d').hasMatch(token) ||
        token.startsWith('.') ||
        RegExp(r'^[a-zA-Z]+$').hasMatch(token);
  }

  double parseMultiply() {
    double value = parseUnary();

    while (true) {
      if (match('*')) {
        value *= parseUnary();
      } else if (match('/')) {
        final divisor = parseUnary();

        if (divisor == 0) {
          throw Exception('Division by zero');
        }

        value /= divisor;
      } else if (startsPrimary(current)) {
        value *= parseUnary();
      } else {
        break;
      }
    }

    return value;
  }

  double parseUnary() {
    if (match('+')) return parseUnary();
    if (match('-')) return -parseUnary();

    return parsePower();
  }

  double parsePower() {
    double value = parsePrimary();

    if (match('^')) {
      value = math.pow(value, parseUnary()).toDouble();
    }

    return value;
  }

  double parsePrimary() {
    if (match('(')) {
      final value = parseAdd();
      expect(')');
      return value;
    }

    final token = current;

    if (token == null) {
      throw Exception('Unexpected end');
    }

    position++;

    final number = double.tryParse(token);

    if (number != null) {
      return number;
    }

    if (token == 'pi') return math.pi;
    if (token == 'e') return math.e;

    final functions = [
      'sin', 'cos', 'tan',
      'asin', 'acos', 'atan',
      'log', 'ln', 'sqrt',
    ];

    if (functions.contains(token)) {
      expect('(');

      final x = parseAdd();

      expect(')');

      switch (token) {
        case 'sin':
          return math.sin(toRadians(x));

        case 'cos':
          return math.cos(toRadians(x));

        case 'tan':
          return math.tan(toRadians(x));

        case 'asin':
          return fromRadians(math.asin(x));

        case 'acos':
          return fromRadians(math.acos(x));

        case 'atan':
          return fromRadians(math.atan(x));

        case 'log':
          if (x <= 0) throw Exception('Invalid log');
          return math.log(x) / math.ln10;

        case 'ln':
          if (x <= 0) throw Exception('Invalid ln');
          return math.log(x);

        case 'sqrt':
          if (x < 0) throw Exception('Invalid sqrt');
          return math.sqrt(x);
      }
    }

    throw Exception('Unknown function');
  }

  double toRadians(double value) {
    return degreeMode
        ? value * math.pi / 180
        : value;
  }

  double fromRadians(double value) {
    return degreeMode
        ? value * 180 / math.pi
        : value;
  }
}
