import 'package:flutter/material.dart';

enum MarkerAnimationType { none, fadeIn, fadeOut }

class MarkerFadeNotifier extends ValueNotifier<double> {
  MarkerFadeNotifier(super.value);

  bool _isAnimating = false;

  Future<void> fadeOut({required Duration duration}) async {
    if (_isAnimating) return;
    await _animateWithTween(
      tween: Tween<double>(begin: 1.0, end: 0.0),
      duration: duration,
    );
  }

  Future<void> fadeIn({required Duration duration}) async {
    if (_isAnimating) return;
    await _animateWithTween(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: duration,
    );
  }

  Future<void> _animateWithTween({
    required Tween<double> tween,
    required Duration duration,
  }) async {
    _isAnimating = true;
    final startTime = DateTime.now();
    final totalMs = duration.inMilliseconds;

    while (true) {
      final elapsedMs = DateTime.now().difference(startTime).inMilliseconds;
      double progress = (elapsedMs / totalMs).clamp(0.0, 1.0);
      double curvedProgress = Curves.easeInOut.transform(progress);
      value = tween.transform(curvedProgress);
      if (progress >= 1.0) break;
      await Future.delayed(const Duration(milliseconds: 16));
    }
    _isAnimating = false;
  }
}
