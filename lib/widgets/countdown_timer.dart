import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/colors.dart';

class CountdownTimer extends StatefulWidget {
  final Duration duration;
  final VoidCallback onTimerComplete;

  const CountdownTimer({
    super.key,
    required this.duration,
    required this.onTimerComplete,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      
      setState(() {
        if (_remaining.inSeconds > 0) {
          _remaining -= const Duration(seconds: 1);
          
          // Haptics at specific intervals
          if (_remaining.inSeconds == 60) {
            HapticFeedback.mediumImpact();
          } else if (_remaining.inSeconds == 30) {
            HapticFeedback.heavyImpact();
          } else if (_remaining.inSeconds <= 10 && _remaining.inSeconds > 0) {
            HapticFeedback.lightImpact();
          } else if (_remaining.inSeconds == 0) {
            HapticFeedback.vibrate();
            _timer?.cancel();
            widget.onTimerComplete();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Color _getColor() {
    if (_remaining.inSeconds <= 10) return AppColors.agentAccent; // Red
    if (_remaining.inSeconds <= 30) return Colors.orangeAccent;
    return AppColors.textPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _remaining.inMinutes.toString().padLeft(2, '0');
    final seconds = (_remaining.inSeconds % 60).toString().padLeft(2, '0');

    return Text(
      '$minutes:$seconds',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: 72,
            color: _getColor(),
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
    );
  }
}
