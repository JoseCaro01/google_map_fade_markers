import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_map_fade_markers/src/utils/utils.dart';

part 'google_map_fade_markers_cubit.freezed.dart';
part 'google_map_fade_markers_state.dart';

class GoogleMapFadeMarkersCubit extends Cubit<GoogleMapFadeMarkersState> {
  GoogleMapFadeMarkersCubit({required this.duration})
      : super(const GoogleMapFadeMarkersState.initial());
  final Duration duration;
  StreamSubscription<double>? _fadeStreamSubscription;

  void startAnimationChangeMarkers() {
    _startPreviousMarkersFadeAnimation(
      onFinish: () => _startCurrentMarkersFadeAnimation(),
    );
  }

  void _startPreviousMarkersFadeAnimation({VoidCallback? onFinish}) {
    _fadeStreamSubscription?.cancel();
    _fadeStreamSubscription = _generateFadeValues(
            initialValue: 1,
            finalValue: 0,
            operation: Operation.subtraction,
            difference: 0.1,
            durationPerInteraction:
                Duration(milliseconds: duration.inMilliseconds ~/ (1 / 0.1)))
        .listen((event) {
      if (isClosed) return;
      if (event > 0) {
        log(event.toString());
        emit(
          GoogleMapFadeMarkersState.animationPreviousMarkers(
            previousOpacity: event,
          ),
        );
      } else {
        onFinish?.call();
      }
    });
  }

  void _startCurrentMarkersFadeAnimation() {
    _fadeStreamSubscription?.cancel();
    _fadeStreamSubscription = _generateFadeValues(
            initialValue: 0,
            finalValue: 1,
            operation: Operation.addition,
            difference: 0.1,
            durationPerInteraction:
                Duration(milliseconds: duration.inMilliseconds ~/ (1 / 0.1)))
        .listen((event) {
      if (isClosed) return;
      if (event <= 1) {
        emit(
          GoogleMapFadeMarkersState.animationCurrentMarkers(
            currentOpacity: event,
          ),
        );
      }
    });
  }

  Stream<double> _generateFadeValues({
    required double initialValue,
    required double finalValue,
    required double difference,
    required Operation operation,
    required Duration durationPerInteraction,
  }) async* {
    assert(initialValue >= 0 && initialValue <= 1,
        'Initial value must be greater than 0 and lower than 1');
    assert(finalValue >= 0 && finalValue <= 1,
        'Initial value must be greater than 0 and lower than 1');
    yield initialValue;
    switch (operation) {
      case Operation.addition:
        for (var i = initialValue; i <= finalValue; i += difference) {
          await Future.delayed(
            durationPerInteraction,
          );
          yield i >= 1 ? 1 : i;
        }

      case Operation.subtraction:
        for (var i = initialValue; i >= finalValue; i -= difference) {
          await Future.delayed(
            durationPerInteraction,
          );
          yield double.parse(i.toStringAsFixed(2)) <= 0 ? 0 : i;
        }

      default:
        throw Exception(
            "Not implemented generator for multiple and division operations");
    }
  }

  @override
  Future<void> close() async {
    await _fadeStreamSubscription?.cancel();
    return super.close();
  }
}
