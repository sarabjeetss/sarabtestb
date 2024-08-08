import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(HangmanApp());
}

class HangmanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Good Luck Gamer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => StartScreen(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox.expand(
          child: Image.asset(
            'assets/splash.jpg',
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
      ),
    );
  }
}

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/2.jpg',
              fit: BoxFit.cover, // Cover the entire screen
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0), // Padding from edges
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HangmanGame(),
                  ));
                },
                child: Text('Start Game'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen, // Background color
                  foregroundColor: Colors.black, // Text color
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20), // Increased size
                  textStyle: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HangmanGame extends StatefulWidget {
  @override
  _HangmanGameState createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> {
  static const List<String> words = [
    'FLUTTER',
    'HANGMAN',
    'WIDGET',
    'DART',
    'STATE',
    'CONTEXT'
  ];
  static const List<String> hints = [
    'A UI toolkit',
    'A guessing game',
    'A basic building block',
    'Programming language',
    'Management in Flutter',
    'Interface information'
  ];

  late String word;
  late String hint;
  late List<String> guessedLetters;
  int wrongGuesses = 0;
  bool gameOver = false;
  String message = '';
  bool showRules = false;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    final randomIndex = Random().nextInt(words.length);
    word = words[randomIndex];
    hint = hints[randomIndex];
    guessedLetters = [];
    wrongGuesses = 0;
    gameOver = false;
    message = '';
  }

  void guessLetter(String letter) {
    setState(() {
      if (!guessedLetters.contains(letter)) {
        guessedLetters.add(letter);
        if (!word.contains(letter)) {
          wrongGuesses++;
        }
        checkGameOver();
      }
    });
  }

  void checkGameOver() {
    if (wrongGuesses >= 6) {
      gameOver = true;
      message = 'You LOST!';
    } else if (word.split('').every((letter) => guessedLetters.contains(letter))) {
      gameOver = true;
      message = 'You WON!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Good Luck Gamer'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              setState(() {
                showRules = !showRules;
              });
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Game Rules Column
          if (showRules)
            Container(
              padding: EdgeInsets.all(16.0),
              width: 200,
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Game Rules:',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_drop_up),
                        onPressed: () {
                          setState(() {
                            showRules = !showRules;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    '1. Guess the letters in the word.',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '2. You have 6 wrong guesses.',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '3. The game ends when you guess the word or run out of guesses.',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
          // Game Content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.jpg'), // Ensure this image is in your assets folder
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.lightGreen,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    word
                        .split('')
                        .map((letter) => guessedLetters.contains(letter) ? letter : '_')
                        .join(' '),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: gameOver ? (message == 'You WON!' ? Colors.green : Colors.red) : Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Wrong guesses: $wrongGuesses',
                    style: TextStyle(fontSize: 24, color: Colors.red),
                  ),
                  SizedBox(height: 20),
                  if (wrongGuesses > 0)
                    Text(
                      'Hint: $hint',
                      style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.black87),
                    ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 4.0), // Black border around the keyboard
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        children: [
                          // Row 1
                          Wrap(
                            spacing: 4.0, // Space between buttons
                            runSpacing: 4.0,
                            alignment: WrapAlignment.center,
                            children: 'ABCDEFGHIJKLM'.split('').map((letter) => SizedBox(
                              width: 50, // Increased width
                              height: 50, // Increased height
                              child: ElevatedButton(
                                onPressed: gameOver ? null : () => guessLetter(letter),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: guessedLetters.contains(letter)
                                      ? Colors.grey
                                      : Colors.lightGreen, // Light green color
                                  foregroundColor: Colors.black, // Black text
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(color: Colors.black, width: 1.5), // Black border around button
                                  ),
                                ),
                                child: Text(letter, style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                              ),
                            )).toList(),
                          ),
                          // Row 2
                          Wrap(
                            spacing: 4.0,
                            runSpacing: 4.0,
                            alignment: WrapAlignment.center,
                            children: 'NOPQRSTUVWXYZ'.split('').map((letter) => SizedBox(
                              width: 50, // Increased width
                              height: 50, // Increased height
                              child: ElevatedButton(
                                onPressed: gameOver ? null : () => guessLetter(letter),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: guessedLetters.contains(letter)
                                      ? Colors.grey
                                      : Colors.lightGreen, // Light green color
                                  foregroundColor: Colors.black, // Black text
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(color: Colors.black, width: 1.5), // Black border around button
                                  ),
                                ),
                                child: Text(letter, style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                              ),
                            )).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (gameOver)
                    Column(
                      children: [
                        Text(
                          message,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: message == 'You WON!' ? Colors.green : Colors.red,
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              startNewGame();
                            });
                          },
                          child: Text('Play Again'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
