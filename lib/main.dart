import 'package:flutter/material.dart';

void main() {
  runApp(const AnimatedApp());
}

class AnimatedApp extends StatelessWidget {
  const AnimatedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MovingAnimationScreen(),
    );
  }
}

class MovingAnimationScreen extends StatefulWidget {
  @override
  _MovingAnimationScreenState createState() => _MovingAnimationScreenState();
}

class _MovingAnimationScreenState extends State<MovingAnimationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _horizontalMotion;
  late Animation<double> _verticalMotion;
  bool isAnimating = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(reverse: true);

    _horizontalMotion = Tween<double>(begin: -120, end: 120).animate(_controller);
    _verticalMotion = Tween<double>(begin: -60, end: 60).animate(_controller);
  }

  void _toggleAnimation() {
    setState(() {
      isAnimating ? _controller.stop() : _controller.repeat(reverse: true);
      isAnimating = !isAnimating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Motion Animation"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MovingBox(animation: _horizontalMotion, color: Colors.teal, vertical: false),
                  MovingBox(animation: _verticalMotion, color: Colors.pinkAccent, vertical: true),
                  MovingBox(animation: _horizontalMotion, color: Colors.cyan, vertical: false),
                  MovingBox(animation: _verticalMotion, color: Colors.amber, vertical: true),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _toggleAnimation,
              child: Text(isAnimating ? "Pause Animation" : "Resume Animation"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class MovingBox extends StatelessWidget {
  final Animation<double> animation;
  final Color color;
  final bool vertical;

  const MovingBox({required this.animation, required this.color, required this.vertical, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: vertical ? Offset(0, animation.value) : Offset(animation.value, 0),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 3,
                  blurRadius: 4,
                  offset: Offset(5, 8),
                  color: Colors.black26,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
