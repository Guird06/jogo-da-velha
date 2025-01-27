import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jogo da Velha',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TicTacToePage(),
    );
  }
}

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  List<String> _board = List.filled(9, "");
  bool _isXTurn = true;
  String _winner = "";
  bool _isHumanPlayer = true; 

  void _resetGame() {
    setState(() {
      _board = List.filled(9, "");
      _isXTurn = true;
      _winner = "";
    });
  }

  void _makeMove(int index) {
    if (_board[index].isEmpty && _winner.isEmpty) {
      setState(() {
        _board[index] = _isXTurn ? "X" : "O";
        _isXTurn = !_isXTurn;
        _checkWinner();
        if (!_isHumanPlayer && !_isXTurn && _winner.isEmpty) {
          _makeAIMove(); 
        }
      });
    }
  }

  void _checkWinner() {
    const winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (var combo in winningCombinations) {
      final a = combo[0], b = combo[1], c = combo[2];
      if (_board[a].isNotEmpty && _board[a] == _board[b] && _board[a] == _board[c]) {
        _winner = _board[a];
        break;
      }
    }

    if (_winner.isEmpty && !_board.contains("")) {
      _winner = "Empate";
    }
  }

 
  void _makeAIMove() {
    List<int> availableMoves = [];
    for (int i = 0; i < 9; i++) {
      if (_board[i].isEmpty) {
        availableMoves.add(i);
      }
    }

    if (availableMoves.isNotEmpty) {
      int move = availableMoves[(availableMoves.length * (0.5)).toInt()]; // Pegando um índice aleatório
      setState(() {
        _board[move] = "O"; 
        _isXTurn = !_isXTurn;
        _checkWinner();
      });
    }
  }

  Widget _buildTile(int index) {
    return GestureDetector(
      onTap: () => _makeMove(index),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            _board[index],
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: _board[index] == "X" ? Colors.deepPurple : Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Jogo da Velha'),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(5, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                value: _isHumanPlayer,
                onChanged: (value) {
                  setState(() {
                    _isHumanPlayer = value;
                    if (!_isHumanPlayer && !_isXTurn && _winner.isEmpty) {
                      _makeAIMove(); 
                    }
                  });
                },
                title: Text(_isHumanPlayer ? "Humano" : "Computador"), 
              ),
              AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) => _buildTile(index),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _winner.isEmpty
                    ? "Vez de: ${_isXTurn ? "X" : "O"}"
                    : _winner == "Empate"
                        ? "Empate!"
                        : "Vencedor: $_winner",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Reiniciar Jogo",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
