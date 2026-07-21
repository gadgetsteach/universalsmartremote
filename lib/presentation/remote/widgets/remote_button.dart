import 'package:flutter/material.dart';

class RemoteButton extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final VoidCallback onPressed;
  final Color? color;
  final double size;
  final bool isCircular;

  const RemoteButton({
    super.key,
    this.icon,
    this.text,
    required this.onPressed,
    this.color,
    this.size = 64.0,
    this.isCircular = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(isCircular ? size / 2 : 12),
      child: Container(
        width: isCircular ? size : null,
        height: size,
        padding: isCircular ? null : const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(isCircular ? size / 2 : 12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: icon != null
            ? Icon(
                icon,
                size: size * 0.5,
                color: color != null ? Colors.white : Theme.of(context).iconTheme.color,
              )
            : Text(
                text ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size * 0.25,
                  color: color != null ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
      ),
    );
  }
}
