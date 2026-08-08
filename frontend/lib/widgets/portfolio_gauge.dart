import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PortfolioGauge extends StatelessWidget {
  final double profitLossPercentage;
  final double volatility;
  final double bestDayReturn;
  final double worstDayReturn;

  const PortfolioGauge({
    super.key,
    required this.profitLossPercentage,
    required this.volatility,
    required this.bestDayReturn,
    required this.worstDayReturn,
  });

  @override
  Widget build(BuildContext context) {
    final bool isProfit = profitLossPercentage >= 0;
    final Color profitColor = isProfit ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    // Normalize P&L to 0-100 range for gauge
    // Map -50% to +50% range onto 0-100 gauge
    final double normalizedPL = ((profitLossPercentage + 50) / 100 * 100).clamp(3.0, 97.0);

    // Normalize best/worst day returns to 0-100 range
    final double normalizedBest = ((bestDayReturn + 10) / 20 * 100).clamp(5.0, 95.0);
    final double normalizedWorst = ((worstDayReturn + 10) / 20 * 100).clamp(5.0, 95.0);

    // Volatility risk level (0-3% maps to 0-100)
    final double normalizedVolatility = (volatility / 3 * 100).clamp(5.0, 95.0);

    // Calculate angles for labels
    final double plAngle = 135 + (normalizedPL / 100) * 270;
    final double bestAngle = 135 + (normalizedBest / 100) * 270;
    final double worstAngle = 135 + (normalizedWorst / 100) * 270;

    return SizedBox(
      height: 220,
      child: SfRadialGauge(
        enableLoadingAnimation: true,
        animationDuration: 1000,
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 100,
            startAngle: 135,
            endAngle: 45,
            radiusFactor: 0.85,
            showLabels: false,
            showTicks: true,
            ticksPosition: ElementsPosition.outside,
            majorTickStyle: MajorTickStyle(
              length: 12,
              thickness: 2,
              color: Colors.white.withOpacity(0.2),
            ),
            minorTickStyle: MinorTickStyle(
              length: 6,
              thickness: 1,
              color: Colors.white.withOpacity(0.1),
            ),
            minorTicksPerInterval: 1,
            interval: 10,
            axisLineStyle: const AxisLineStyle(
              thickness: 14,
              color: Colors.transparent,
              cornerStyle: CornerStyle.bothCurve,
            ),
            ranges: <GaugeRange>[
              // Background arc with gradient
              GaugeRange(
                startValue: 0,
                endValue: 100,
                startWidth: 14,
                endWidth: 14,
                gradient: SweepGradient(
                  colors: [
                    const Color(0xFFEF4444).withOpacity(0.6),
                    const Color(0xFFEAB308).withOpacity(0.6),
                    const Color(0xFF10B981).withOpacity(0.6),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ],
            pointers: <GaugePointer>[
              // Main P&L pointer (circular knob)
              MarkerPointer(
                value: normalizedPL,
                markerType: MarkerType.circle,
                markerWidth: 18,
                markerHeight: 18,
                color: profitColor,
                borderWidth: 4,
                borderColor: Colors.white,
                elevation: 4,
                enableAnimation: true,
                animationDuration: 1000,
                animationType: AnimationType.ease,
              ),
              // Best Day marker (green triangle)
              MarkerPointer(
                value: normalizedBest,
                markerType: MarkerType.triangle,
                markerWidth: 12,
                markerHeight: 12,
                color: const Color(0xFF10B981),
                enableAnimation: true,
                animationDuration: 1000,
                animationType: AnimationType.ease,
                offsetUnit: GaugeSizeUnit.factor,
                markerOffset: -0.14,
              ),
              // Worst Day marker (red triangle)
              MarkerPointer(
                value: normalizedWorst,
                markerType: MarkerType.triangle,
                markerWidth: 12,
                markerHeight: 12,
                color: const Color(0xFFEF4444),
                enableAnimation: true,
                animationDuration: 1000,
                animationType: AnimationType.ease,
                offsetUnit: GaugeSizeUnit.factor,
                markerOffset: -0.14,
              ),
            ],
            annotations: <GaugeAnnotation>[
              // Center P&L value
              GaugeAnnotation(
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${isProfit ? "+" : ""}${profitLossPercentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: profitColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: profitColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isProfit ? 'PROFIT' : 'LOSS',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: profitColor,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Vol: ${volatility.toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                angle: 90,
                positionFactor: 0.0,
              ),
              // Best Day label
              GaugeAnnotation(
                widget: Text(
                  'Best +${bestDayReturn.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF10B981),
                  ),
                ),
                angle: bestAngle,
                positionFactor: 1.25,
              ),
              // Worst Day label
              GaugeAnnotation(
                widget: Text(
                  'Worst ${worstDayReturn.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF4444),
                  ),
                ),
                angle: worstAngle,
                positionFactor: 1.25,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
