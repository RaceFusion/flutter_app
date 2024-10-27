import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const CircleIconButton({super.key, 
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      color: color,
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        color: Colors.white,
      ),
    );
  }
}