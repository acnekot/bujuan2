import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

/// A squiggly Variant of the default [Slider] track.
/// Similar to that in the Android 13 Media Control.
/// Track for the [SquigglySlider] introduced with this package.
///
/// It paints a moving sinus-curve with rounded edges, vertically centered
/// in the `parentBox`.
/// The amplitude and wavelength of the curve can be adjusted
/// by [squiggleAmplitude] and [squiggleWavelength] respectively,
/// while the current phase shift (as a factor of the wavelength) can be adjusted with [squigglePhaseFactor], this will be animated by the [SquigglySlider].
/// The thickness is defined by the [SliderThemeData.trackHeight].
/// The color is determined by the [Slider]'s enabled state
/// and the track segment's active state which are defined by:
///   [SliderThemeData.activeTrackColor],
///   [SliderThemeData.inactiveTrackColor],
///   [SliderThemeData.disabledActiveTrackColor],
///   [SliderThemeData.disabledInactiveTrackColor].
///
///
/// ![A squiggly slider widget, squiggly slider track shape.](https://github.com/hannesgith/squiggly_slider/raw/main/assets/sample.gif)
///
/// See also:
///
///  * [SquigglySlider], for the component that is meant to display this shape.
///  * [SliderThemeData], where an instance of this class is set to inform the
///    slider of the visual details of the its track.
///  * [SliderTrackShape], which can be used to create custom shapes for the
///    [Slider]'s track.
///  * [RoundedRectSliderTrackShape], for a similar track (the default for the normal [Slider]).
class SquigglySliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  /// Create a slider track that draws two rectangles with rounded outer edges.
  const SquigglySliderTrackShape({
    this.squiggleAmplitude = 0.0,
    this.squiggleWavelength = 0.0,
    this.squigglePhaseFactor = 1.0,
  });

  final double squiggleAmplitude;
  final double squiggleWavelength;
  final double squigglePhaseFactor;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 0.1,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting can be a no-op.
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor,
        end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final Radius trackRadius = Radius.circular(trackRect.height / 2);
    final Radius activeTrackRadius =
        Radius.circular((trackRect.height + additionalActiveTrackHeight) / 2);

    final ll = trackRect.left;
    final lt = (textDirection == TextDirection.ltr)
        ? trackRect.top - (additionalActiveTrackHeight / 2)
        : trackRect.top;
    final lr = thumbCenter.dx;
    final lb = (textDirection == TextDirection.ltr)
        ? trackRect.bottom + (additionalActiveTrackHeight / 2)
        : trackRect.bottom;

    if (squiggleAmplitude == 0) {
      context.canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          ll,
          lt,
          lr,
          lb,
          topLeft: (textDirection == TextDirection.ltr)
              ? activeTrackRadius
              : trackRadius,
          bottomLeft: (textDirection == TextDirection.ltr)
              ? activeTrackRadius
              : trackRadius,
        ),
        leftTrackPaint,
      );
    } else {
      final phase = squiggleWavelength * squigglePhaseFactor;
      final double heightCenter = (lt + lb) / 2;

      const ppp = 1.0; // pixels per point -- the resolution of the curve
      context.canvas.drawPoints(
        PointMode.polygon,
        List.generate(
          ((lr - ll) / ppp).ceil(),
          (index) {
            final double xOff = index * ppp;
            final double x = ll + xOff;
            final double easeLength = squiggleWavelength * 3;
            final double easeFactor = (xOff < easeLength
                ? xOff / easeLength
                : xOff > lr - ll - easeLength
                    ? (lr - ll - xOff) / easeLength
                    : 1);
            return Offset(
              x,
              heightCenter +
                  (sin(x / squiggleWavelength + phase * 2 * pi) *
                          squiggleAmplitude) *
                      easeFactor,
            );
          },
        ),
        leftTrackPaint
          ..style = PaintingStyle.stroke
          ..strokeWidth = (lt - lb).abs()
          ..strokeCap = StrokeCap.round,
      );
    }

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        (textDirection == TextDirection.rtl)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        trackRect.right,
        (textDirection == TextDirection.rtl)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
        bottomRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
      ),
      rightTrackPaint,
    );

    final bool showSecondaryTrack = (secondaryOffset != null) &&
        ((textDirection == TextDirection.ltr)
            ? (secondaryOffset.dx > thumbCenter.dx)
            : (secondaryOffset.dx < thumbCenter.dx));

    if (showSecondaryTrack) {
      final ColorTween secondaryTrackColorTween = ColorTween(
          begin: sliderTheme.disabledSecondaryActiveTrackColor,
          end: sliderTheme.secondaryActiveTrackColor);
      final Paint secondaryTrackPaint = Paint()
        ..color = secondaryTrackColorTween.evaluate(enableAnimation)!;
      if (textDirection == TextDirection.ltr) {
        context.canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            thumbCenter.dx,
            trackRect.top,
            secondaryOffset.dx,
            trackRect.bottom,
            topRight: trackRadius,
            bottomRight: trackRadius,
          ),
          secondaryTrackPaint,
        );
      } else {
        context.canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            secondaryOffset.dx,
            trackRect.top,
            thumbCenter.dx,
            trackRect.bottom,
            topLeft: trackRadius,
            bottomLeft: trackRadius,
          ),
          secondaryTrackPaint,
        );
      }
    }
  }
}