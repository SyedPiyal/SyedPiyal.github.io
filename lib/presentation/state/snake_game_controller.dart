import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

enum SnakeDirection { up, down, left, right }
enum SnakeGameState { idle, playing, gameOver }

class SnakeGameController extends ChangeNotifier {
  static const int gridSize = 20; // 20x20 grid
  
  // Game State Variables
  List<Point<int>> _snakeBody = [];
  Point<int> _food = const Point(5, 5);
  SnakeDirection _direction = SnakeDirection.right;
  SnakeGameState _gameState = SnakeGameState.idle;
  int _score = 0;
  int _highScore = 0;
  Timer? _gameTimer;

  // Getters
  List<Point<int>> get snakeBody => _snakeBody;
  Point<int> get food => _food;
  SnakeDirection get direction => _direction;
  SnakeGameState get gameState => _gameState;
  int get score => _score;
  int get highScore => _highScore;

  void startGame() {
    _snakeBody = [
      const Point(10, 10),
      const Point(9, 10),
      const Point(8, 10),
    ];
    _direction = SnakeDirection.right;
    _score = 0;
    _gameState = SnakeGameState.playing;
    _generateNewFood();
    
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(milliseconds: 180), (timer) {
      _moveSnake();
    });
    notifyListeners();
  }

  void changeDirection(SnakeDirection newDirection) {
    if (_gameState != SnakeGameState.playing) return;
    
    // Prevent 180-degree turns into the snake's own body
    if (newDirection == SnakeDirection.up && _direction != SnakeDirection.down) {
      _direction = newDirection;
    } else if (newDirection == SnakeDirection.down && _direction != SnakeDirection.up) {
      _direction = newDirection;
    } else if (newDirection == SnakeDirection.left && _direction != SnakeDirection.right) {
      _direction = newDirection;
    } else if (newDirection == SnakeDirection.right && _direction != SnakeDirection.left) {
      _direction = newDirection;
    }
    notifyListeners();
  }

  void pauseOrResume() {
    if (_gameState == SnakeGameState.playing) {
      _gameTimer?.cancel();
      _gameState = SnakeGameState.idle;
    } else if (_gameState == SnakeGameState.idle && _snakeBody.isNotEmpty) {
      _gameState = SnakeGameState.playing;
      _gameTimer = Timer.periodic(const Duration(milliseconds: 180), (timer) {
        _moveSnake();
      });
    }
    notifyListeners();
  }

  void _moveSnake() {
    if (_gameState != SnakeGameState.playing) return;

    Point<int> head = _snakeBody.first;
    Point<int> newHead;

    switch (_direction) {
      case SnakeDirection.up:
        newHead = Point(head.x, head.y - 1);
        break;
      case SnakeDirection.down:
        newHead = Point(head.x, head.y + 1);
        break;
      case SnakeDirection.left:
        newHead = Point(head.x - 1, head.y);
        break;
      case SnakeDirection.right:
        newHead = Point(head.x + 1, head.y);
        break;
    }

    // Check boundary collisions
    if (newHead.x < 0 || newHead.x >= gridSize || newHead.y < 0 || newHead.y >= gridSize) {
      _endGame();
      return;
    }

    // Check self collision
    if (_snakeBody.contains(newHead)) {
      _endGame();
      return;
    }

    // Insert new head
    _snakeBody.insert(0, newHead);

    // Check food collection
    if (newHead == _food) {
      _score += 10;
      if (_score > _highScore) {
        _highScore = _score;
      }
      _generateNewFood();
    } else {
      // Remove tail if food wasn't eaten
      _snakeBody.removeLast();
    }
    notifyListeners();
  }

  void _generateNewFood() {
    final random = Random();
    Point<int> randomPoint;
    
    do {
      randomPoint = Point(random.nextInt(gridSize), random.nextInt(gridSize));
    } while (_snakeBody.contains(randomPoint));

    _food = randomPoint;
  }

  void _endGame() {
    _gameTimer?.cancel();
    _gameState = SnakeGameState.gameOver;
    notifyListeners();
  }

  void resetGame() {
    _gameTimer?.cancel();
    _snakeBody.clear();
    _score = 0;
    _gameState = SnakeGameState.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
}
