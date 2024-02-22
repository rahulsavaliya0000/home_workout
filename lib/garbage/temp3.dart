import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final double _threshold = 100.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scroll Example'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: 50,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item $index'),
          );
        },
      ),
      floatingActionButton: AnimatedFloatingActionButton(
        scrollController: _scrollController,
        threshold: _threshold,
        iconData: Icons.add,
        text: 'Add',
      ),
    );
  }
}

class AnimatedFloatingActionButton extends StatefulWidget {
  final ScrollController scrollController;
  final double threshold;
  final IconData iconData;
  final String text;

  AnimatedFloatingActionButton({
    required this.scrollController,
    required this.threshold,
    required this.iconData,
    required this.text,
  });

  @override
  _AnimatedFloatingActionButtonState createState() =>
      _AnimatedFloatingActionButtonState();
}

class _AnimatedFloatingActionButtonState
    extends State<AnimatedFloatingActionButton> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    widget.scrollController.addListener(() {
      if (widget.scrollController.offset > widget.threshold &&
          !_animationController.isAnimating) {
        _animationController.forward();
      } else if (widget.scrollController.offset <= widget.threshold &&
          !_animationController.isAnimating) {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return FloatingActionButton(
          onPressed: () {
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.iconData),
              Opacity(
                opacity: _opacityAnimation.value,
                child: Text(widget.text),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
