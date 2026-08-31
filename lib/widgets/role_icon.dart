import 'package:flutter/material.dart';

class RoleIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const RoleIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color,
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          color: color,
          size: size * 0.5,
        ),
      ),
    );
  }
}
