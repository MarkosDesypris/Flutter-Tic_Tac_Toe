import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class GameScreen extends StatefulWidget {
  final String player1;
  final String player2;

  const GameScreen({
    super.key,
    required this.player1,
    required this.player2,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<String>> _board;
  late String _winner;
  late String _currentPlayer;
  late bool _gameOver;

  @override
  void initState() {
    super.initState();
    _board = List.generate(3, (index) => List.generate(3, (index) => ''));
    _currentPlayer = 'X';
    _winner = '';
    _gameOver = false;
  }

  void _resetGame() {
    setState(() {
      _board = List.generate(3, (index) => List.generate(3, (index) => ''));
      _currentPlayer = 'X';
      _winner = '';
      _gameOver = false;
    });
  }

  void _makeMove(int row, int col) {
    if (_board[row][col] != '' || _gameOver) {
      return;
    }

    setState(() {
      _board[row][col] = _currentPlayer;

      // Check for a winner
      if (_board[row][0] == _currentPlayer &&
          _board[row][1] == _currentPlayer &&
          _board[row][2] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][col] == _currentPlayer &&
          _board[1][col] == _currentPlayer &&
          _board[2][col] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][0] == _currentPlayer &&
          _board[1][1] == _currentPlayer &&
          _board[2][2] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][2] == _currentPlayer &&
          _board[1][1] == _currentPlayer &&
          _board[2][0] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;

        // Check your a Draw
      } else if (!_board.any((row) => row.any((cell) => cell == ''))) {
        _gameOver = true;
        _winner = 'It\'s a Draw';
      }

      // Switch Players
      _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';

      if (_winner != '') {
        // ignore: avoid_single_cascade_in_expression_statements
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          btnOkText: 'Play Again',
          title: _winner == 'X'
              ? '${widget.player1.toUpperCase()} Won!'
              : _winner == 'O'
                  ? '${widget.player2.toUpperCase()} Won!'
                  : _winner,
          btnOkOnPress: () {
            _resetGame();
          },
        )..show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF323D5B),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 130),
            SizedBox(
              height: 60,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Turn: ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _currentPlayer == 'X'
                            ? '  ${widget.player1.toUpperCase()} (X)'
                            : '  ${widget.player2.toUpperCase()} (O)',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: _currentPlayer == 'X'
                              ? const Color(0xFFE25041)
                              : const Color(0xFF1CBD93),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: const Color(0XFF5F6B84),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(5),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                itemCount: 9,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  int row = index ~/ 3;
                  int col = index % 3;
                  return GestureDetector(
                    onTap: () => _makeMove(row, col),
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E1E3A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          _board[row][col],
                          style: TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                            color: _board[row][col] == 'X'
                                ? const Color(0xFFE25041)
                                : const Color(0xFF1CBD93),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _resetGame(),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 20),
                  ),
                  child: const Text(
                    'Reset Game',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 20),
                  ),
                  child: const Text(
                    'Restart Game',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
