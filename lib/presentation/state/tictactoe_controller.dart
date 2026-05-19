import 'dart:math';
import 'package:flutter/material.dart';

class TicTacToeController extends ChangeNotifier {
  List<String> _board = List.generate(9, (_) => ''); // Represents 3x3 grid
  String _currentPlayer = 'X'; // User is 'X', AI is 'O'
  String _winner = ''; // '', 'X', 'O', 'Draw'
  bool _isAiThinking = false;

  // Getters
  List<String> get board => _board;
  String get currentPlayer => _currentPlayer;
  String get winner => _winner;
  bool get isAiThinking => _isAiThinking;

  void makeMove(int index) {
    if (_board[index] != '' || _winner != '' || _isAiThinking) return;

    _board[index] = _currentPlayer;
    _checkWinner();

    if (_winner == '' && _currentPlayer == 'X') {
      _currentPlayer = 'O';
      _triggerAiMove();
    }
    notifyListeners();
  }

  void _triggerAiMove() {
    _isAiThinking = true;
    notifyListeners();

    // Small delay to simulate AI reflection
    Future.delayed(const Duration(milliseconds: 600), () {
      int bestMove = _findBestMove();
      if (bestMove != -1) {
        _board[bestMove] = 'O';
      }
      _checkWinner();
      _currentPlayer = 'X';
      _isAiThinking = false;
      notifyListeners();
    });
  }

  int _findBestMove() {
    // 1. Check if AI can win in this turn
    for (int i = 0; i < 9; i++) {
      if (_board[i] == '') {
        _board[i] = 'O';
        if (_evaluateWinner('O')) {
          _board[i] = '';
          return i;
        }
        _board[i] = '';
      }
    }

    // 2. Check if player X can win in their next turn, and block them!
    for (int i = 0; i < 9; i++) {
      if (_board[i] == '') {
        _board[i] = 'X';
        if (_evaluateWinner('X')) {
          _board[i] = '';
          return i;
        }
        _board[i] = '';
      }
    }

    // 3. Take center if available
    if (_board[4] == '') return 4;

    // 4. Take corners if available
    List<int> corners = [0, 2, 6, 8];
    List<int> availableCorners = corners.where((c) => _board[c] == '').toList();
    if (availableCorners.isNotEmpty) {
      return availableCorners[Random().nextInt(availableCorners.length)];
    }

    // 5. Take any empty space
    List<int> emptySpaces = [];
    for (int i = 0; i < 9; i++) {
      if (_board[i] == '') emptySpaces.add(i);
    }

    if (emptySpaces.isNotEmpty) {
      return emptySpaces[Random().nextInt(emptySpaces.length)];
    }

    return -1;
  }

  bool _evaluateWinner(String player) {
    const List<List<int>> winConditions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6]             // Diagonals
    ];

    for (var condition in winConditions) {
      if (_board[condition[0]] == player &&
          _board[condition[1]] == player &&
          _board[condition[2]] == player) {
        return true;
      }
    }
    return false;
  }

  void _checkWinner() {
    // Check X
    if (_evaluateWinner('X')) {
      _winner = 'X';
      return;
    }
    // Check O
    if (_evaluateWinner('O')) {
      _winner = 'O';
      return;
    }
    // Check Draw
    if (!_board.contains('')) {
      _winner = 'Draw';
      return;
    }
  }

  void resetGame() {
    _board = List.generate(9, (_) => '');
    _currentPlayer = 'X';
    _winner = '';
    _isAiThinking = false;
    notifyListeners();
  }
}
