import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CircularGaugeWidget extends StatefulWidget {
  final double mvValue;
  final double hclValue;
  final double spValue;
  final double lclValue;
  final double minValue;
  final double maxValue;
  final String unit;
  final bool showLabels;
  final double lowSpecValue;
  final double highSpecValue;

  const CircularGaugeWidget({
    super.key,
    required this.mvValue,
    required this.hclValue,
    required this.spValue,
    required this.lclValue,
    this.minValue = 0,
    this.maxValue = 100,
    this.unit = '',
    this.showLabels = true,
    required this.lowSpecValue,
    required this.highSpecValue,
  });

  @override
  State<CircularGaugeWidget> createState() => _CircularGaugeWidgetState();
}

class _CircularGaugeWidgetState extends State<CircularGaugeWidget> {

  static const Color mvOrange = Color(0xFFFF5A00);  

  static const Color hclLclPink = Color(0xFFE91E63); 

  static const Color markerGreen = Color(0xFF16A34A);
  static const Color specRed = Color(0xFF2563EB); 

  @override
  Widget build(BuildContext context) {
    // Calculate the normalized value for the gauge (3-97 range to keep away from spec markers)
    final normalizedValue = ((widget.mvValue - widget.minValue) /
            (widget.maxValue - widget.minValue) *
            100)
        .clamp(3.0, 97.0);

    // Calculate normalized LCL value (0-100 range)
    final normalizedLcl = ((widget.lclValue - widget.minValue) /
            (widget.maxValue - widget.minValue) *
            100)
        .clamp(0.0, 100.0);

    // Calculate normalized SP value (0-100 range)
    final normalizedSp = ((widget.spValue - widget.minValue) /
            (widget.maxValue - widget.minValue) *
            100)
        .clamp(0.0, 100.0);

    // Calculate normalized HCL value (0-95 range to keep away from High Spec marker)
    final normalizedHcl = ((widget.hclValue - widget.minValue) /
            (widget.maxValue - widget.minValue) *
            100)
        .clamp(0.0, 95.0);

    // Calculate normalized Low Spec value (0-100 range)
    ((widget.lowSpecValue - widget.minValue) /
            (widget.maxValue - widget.minValue) *
            100)
        .clamp(0.0, 100.0);

    // Calculate normalized High Spec value (0-100 range)
    final normalizedHighSpec = ((widget.highSpecValue - widget.minValue) /
            (widget.maxValue - widget.minValue) *
            100)
        .clamp(0.0, 100.0);

    // Calculate angles for label positions
    // Gauge: startAngle 135° to endAngle 45° (270° sweep clockwise)
    final lclAngle = 135 + (normalizedLcl / 100) * 270;
    final spAngle = 135 + (normalizedSp / 100) * 270;
    final hclAngle = 135 + (normalizedHcl / 100) * 270;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: SizedBox(
        // width: 296,
        // height: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            //! Main Syncfusion Radial Gauge
            SizedBox(
          
              child: SfRadialGauge(
                enableLoadingAnimation: true,
                animationDuration: 800,
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    startAngle: 135,
                    endAngle: 45,
                    radiusFactor: 0.80,
                    showLabels: false,
                    showTicks: true,
                    ticksPosition: ElementsPosition.outside,
                    majorTickStyle: MajorTickStyle(
                      length: 20,
                      thickness: 2,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    minorTickStyle: MinorTickStyle(
                      length: 12,
                      thickness: 1,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    minorTicksPerInterval: 1,
                    interval: 10,
                    axisLineStyle: AxisLineStyle(
                      thickness: 16,
                      color: Colors.transparent,
                      cornerStyle: CornerStyle.bothCurve,
                    ),
                    ranges: <GaugeRange>[
                      //! Full gauge arc with gradient background
                      GaugeRange(
                        startValue: 0,
                        endValue: 100,
                        startWidth: 16,
                        endWidth: 16,
                        gradient: const SweepGradient(
                          colors: [Color(0xFF0EA5E9), Color(0xFF1D4ED8)],
                          stops: [0.0, 1.0],
                        ),
                      ),
                    ],
                    pointers: <GaugePointer>[
                      //! Orange Marker pointer (the circular knob) - moves with MV value
                      MarkerPointer(
                        value: normalizedValue,
                        markerType: MarkerType.circle,
                        markerWidth: 16,
                        markerHeight: 16,
                        color: mvOrange,
                        borderWidth: 4,
                        borderColor: Colors.white,
                        elevation: 4,
                        enableAnimation: true,
                        animationDuration: 800,
                        animationType: AnimationType.ease,
                      ),
                      //! LCL Pink Marker - moves with LCL value
                      MarkerPointer(
                        value: normalizedLcl,
                        markerType: MarkerType.triangle,
                        markerWidth: 14,
                        markerHeight: 14,
                        color: hclLclPink,
                        enableAnimation: true,
                        animationDuration: 800,
                        animationType: AnimationType.ease,
                        offsetUnit: GaugeSizeUnit.factor,
                        markerOffset: -0.12,
                      ),
                      //! SP Green Marker - moves with SP value
                      MarkerPointer(
                        value: normalizedSp,
                        markerType: MarkerType.triangle,
                        markerWidth: 14,
                        markerHeight: 14,
                        color: markerGreen,
                        enableAnimation: true,
                        animationDuration: 800,
                        animationType: AnimationType.ease,
                        offsetUnit: GaugeSizeUnit.factor,
                        markerOffset: -0.12,
                      ),
                      //! HCL Pink Marker - moves with HCL value
                      MarkerPointer(
                        value: normalizedHcl,
                        markerType: MarkerType.triangle,
                        markerWidth: 14,
                        markerHeight: 14,
                        color: hclLclPink,
                        enableAnimation: true,
                        animationDuration: 800,
                        animationType: AnimationType.ease,
                        offsetUnit: GaugeSizeUnit.factor,
                        markerOffset: -0.12,
                      ),
                    ],
                    annotations: <GaugeAnnotation>[
                      //! Center value display
                      GaugeAnnotation(
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // MV value - show 3 decimal places, blue color
                            Text(
                              widget.mvValue.toStringAsFixed(3),
                              style: const TextStyle(
                                fontSize: 30, 
                                fontWeight: FontWeight.bold,
                                color: mvOrange,
                                // fontFamily: 'Inter',
                              ),
                            ),
                            // Unit text (underlined, blue)
                            Text(
                              widget.unit.isNotEmpty ? widget.unit : '',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: mvOrange,
                                // fontFamily: 'Inter',
                                decoration: TextDecoration.underline,
                                decorationColor: mvOrange,
                              ),
                            ),

                            const SizedBox(height: 2),
                            // MV label with blue dot
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: mvOrange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'MV',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: mvOrange,
                                    // fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        angle: 90,
                        positionFactor: 0.0,
                      ),
                      //! LCL label - moves dynamically with lclValue
                      GaugeAnnotation(
                        widget: Text(
                          'LCL ${widget.lclValue.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: hclLclPink,
                            // fontFamily: 'Inter',
                          ),
                        ),
                        angle: lclAngle,
                        positionFactor: 1.20,
                      ),
                      //! SP label - moves dynamically with spValue
                      GaugeAnnotation(
                        widget: Text(
                          'SP ${widget.spValue.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: markerGreen,
                            // fontFamily: 'Inter',
                          ),
                        ),
                        angle: spAngle,
                        positionFactor: 1.10,
                      ),
                      //! HCL label - moves dynamically with hclValue
                      GaugeAnnotation(
                        widget: Text(
                          'HCL ${widget.hclValue.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: hclLclPink,
                            // fontFamily: 'Inter',
                          ),
                        ),
                        angle: hclAngle,
                        positionFactor: 1.20,
                      ),

                      //! Low Spec Red Marker - at gauge start, pointing outward towards label
                      GaugeAnnotation(
                        widget: Transform.rotate(
                          angle: -1.40,
                          child: Icon(
                            Icons.play_arrow,
                            color: specRed,
                            size: 28,
                          ),
                        ),
                        angle: 133,
                        positionFactor: 0.74,
                      ),
                      //! High Spec Red Marker - at gauge end, pointing outward towards label
                      GaugeAnnotation(
                        widget: Transform.rotate(
                          angle: -1.80,
                          child: Icon(
                            Icons.play_arrow,
                            color: specRed,
                            size: 28,
                          ),
                        ),
                        angle: 47.70,
                        positionFactor: 0.73,
                      ),
                      //! Low Spec label (bottom left) - RED color
                      GaugeAnnotation(
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.lowSpecValue.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: specRed,
                                // fontFamily: 'poppins',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 17),
                              child: Text(
                                "Low Spec",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: specRed,
                                  // fontFamily: 'poppins',
                                ),
                              ),
                            ),
                          ],
                        ),
                        angle: 112,
                        positionFactor: 0.73,
                      ),



                         
                      //! High Spec label (bottom right) - RED color
                      GaugeAnnotation(                      
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.highSpecValue.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: specRed,
                                // fontFamily: 'poppins',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 19),
                              child: Text(
                                'High Spec',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: specRed,
                                  // fontFamily: 'poppins',
                                ),
                              ),
                            ),
                          ],
                        ),
                        angle: 69,
                        positionFactor: 0.71,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Minus button (bottom left)
            // Positioned(
            //   left: 0,
            //   bottom: 0,
            //   child: _buildControlButton(Icons.remove, () {}),
            // ),
            // // Plus button (bottom right)
            // Positioned(
            //   right: 0,
            //   bottom: 0,
            //   child: _buildControlButton(Icons.add, () {}),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black87, size: 28),
      ),
    );
  }
}

/// Compact version of the gauge for constrained spaces
class CompactCircularGauge extends StatelessWidget {
  final double value;
  final double maxValue;
  final String label;
  final Color color;

  const CompactCircularGauge({
    super.key,
    required this.value,
    this.maxValue = 100,
    required this.label,
    this.color = const Color(0xFF1D8DFD),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: maxValue,
            startAngle: 135,
            endAngle: 45,
            showLabels: false,
            showTicks: false,
            radiusFactor: 0.9,
            axisLineStyle: AxisLineStyle(
              thickness: 6,
              color: color.withOpacity(0.2),
              cornerStyle: CornerStyle.bothCurve,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: value,
                width: 6,
                color: color,
                cornerStyle: CornerStyle.bothCurve,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value.toStringAsFixed(3),
                      style: const TextStyle(
                        color: Color(0xff2177C7),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                angle: 90,
                positionFactor: 0.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
