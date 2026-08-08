import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/providers/home_provider.dart';
import 'package:frontend/widgets/portfolio_gauge.dart';
import 'package:provider/provider.dart';

class UserPortfolioScreen extends StatefulWidget {
  const UserPortfolioScreen({super.key});

  @override
  State<UserPortfolioScreen> createState() => _UserPortfolioScreenState();
}

class _UserPortfolioScreenState extends State<UserPortfolioScreen> {
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final stockData = homeProvider.stockData;

    if (stockData == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF101126),
        body: Center(
          child: Text(
            'No data yet.\nGo to Home and analyze a stock.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ),
      );
    }

    final profitLossPct = stockData.profitLossPercentage;
    final isProfit = profitLossPct >= 0;
    final gaugeProgress = (profitLossPct.abs() / 100).clamp(0.0, 1.0);
    final currentPrice = stockData.currentPrice;
    final buyPrice = stockData.userBoughtPrice;
    final totalInvestment = stockData.totalInvestmentAmount;
    final currentValue = stockData.currentPortfolioValue;
    final profitLoss = stockData.profitLoss;
    final bestDay = stockData.bestDay;
    final worstDay = stockData.worstDay;
    final volatility = stockData.volatility;

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          backgroundColor: const Color(0xFF7B2CBF).withOpacity(0.2),
          toolbarHeight: 70,
          title: Text(
            'Portfolio Analysis',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFE1E0FE),
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 8),
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF27283E),
                  foregroundColor: const Color(0xFFE1E0FE),
                  side: const BorderSide(color: Color(0xFF4C4353)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.download, size: 16),
                label: const Text(
                  'EXPORT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF7B2CBF).withOpacity(0.2),
                  boxShadow: [
                    
                  ]
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   

                    // Top Grid: Gauge & Key Metrics
                    Column(
                      children: [
                        _buildGaugeCard(gaugeProgress, profitLossPct, isProfit, volatility, bestDay.returnValue, worstDay.returnValue),
                        const SizedBox(height: 16),
                        _buildMetricsColumn(
                          currentPrice,
                          buyPrice,
                          profitLossPct,
                          totalInvestment,
                          currentValue,
                          profitLoss,
                          isProfit,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Risk & Extremes
                    Column(
                      children: [
                        _buildRiskProfileCard(volatility),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildExtremeDayCard(
                                'BEST DAY',
                                '+${bestDay.returnValue.toStringAsFixed(2)}%',
                                bestDay.date.split('T')[0],
                                true,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildExtremeDayCard(
                                'WORST DAY',
                                '${worstDay.returnValue.toStringAsFixed(2)}%',
                                worstDay.date.split('T')[0],
                                false,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Line Chart Card
                    _buildChartCard(),
                    const SizedBox(height: 100), 
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassContainer({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: padding ?? const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1D1E33).withOpacity(0.6),
            // borderRadius: BorderRadius.circular(16),
            border: Border(
              top: BorderSide(color: const Color(0xFFDEB7FF).withOpacity(0.2)),
              left: BorderSide(color: const Color(0xFFDEB7FF).withOpacity(0.1)),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildGaugeCard(
    double gaugeProgress,
    double profitLossPct,
    bool isProfit,
    double volatility,
    double bestDayReturn,
    double worstDayReturn,
  ) {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'OVERALL PERFORMANCE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: Color(0xFFCFC2D5),
            ),
          ),
          const SizedBox(height: 8),
          PortfolioGauge(
            profitLossPercentage: profitLossPct,
            volatility: volatility,
            bestDayReturn: bestDayReturn,
            worstDayReturn: worstDayReturn,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsColumn(
    double currentPrice,
    double buyPrice,
    double profitLossPct,
    double totalInvestment,
    double currentValue,
    double profitLoss,
    bool isProfit,
  ) {
    return Column(
      children: [
        _buildGlassContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ASSET VALUATION',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: Color(0xFFCFC2D5),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF191A2F).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CURRENT PRICE',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFFCFC2D5),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${currentPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE1E0FE),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (isProfit
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFFEF4444))
                                      .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isProfit
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  size: 14,
                                  color: isProfit
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFEF4444),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${profitLossPct.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    color: isProfit
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFFEF4444),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.arrow_forward, color: Color(0xFF988D9E)),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF191A2F).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'BUY PRICE',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFFCFC2D5),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${buyPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE1E0FE),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(
                                Icons.schedule,
                                size: 14,
                                color: Color(0xFFCFC2D5),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Avg Entry',
                                style: TextStyle(
                                  color: Color(0xFFCFC2D5),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildStatCard(
              'TOTAL INVESTMENT',
              '₹${totalInvestment.toStringAsFixed(0)}',
              Icons.currency_rupee,
              const Color(0xFFDEB7FF),
              const Color(0xFF7B2CBF),
            ),
            _buildStatCard(
              'CURRENT VALUE',
              '₹${currentValue.toStringAsFixed(0)}',
              Icons.account_balance_wallet,
              const Color(0xFFADC6FF),
              const Color(0xFF006BE3),
            ),
            _buildStatCard(
              'NET PROFIT',
              '${isProfit ? "+" : ""}₹${profitLoss.toStringAsFixed(0)}',
              Icons.trending_up,
              isProfit ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              isProfit ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
    Color containerColor,
  ) {
    return _buildGlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFCFC2D5),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: title.contains('PROFIT')
                      ? const Color(0xFF10B981)
                      : const Color(0xFFE1E0FE),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskProfileCard(double volatility) {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'RISK PROFILE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: Color(0xFFCFC2D5),
                ),
              ),
              Text(
                volatility < 1.0
                    ? 'Low'
                    : volatility < 1.5
                    ? 'Medium'
                    : volatility < 2.0
                    ? 'Medium-High'
                    : 'High',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDEB7FF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF32334A),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                widthFactor: (volatility / 3.0).clamp(0.0, 1.0),
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF10B981),
                        Colors.amber,
                        Color(0xFFEF4444),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Text(
                'Low',
                style: TextStyle(fontSize: 12, color: Color(0xFFCFC2D5)),
              ),
              Text(
                'Medium',
                style: TextStyle(fontSize: 12, color: Color(0xFFCFC2D5)),
              ),
              Text(
                'High',
                style: TextStyle(fontSize: 12, color: Color(0xFFCFC2D5)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExtremeDayCard(
    String title,
    String percentage,
    String date,
    bool isPositive,
  ) {
    final color = isPositive
        ? const Color(0xFF10B981)
        : const Color(0xFFEF4444);
    return _buildGlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                  letterSpacing: 1,
                ),
              ),
              Icon(
                Icons.calendar_month,
                size: 20,
                color: color.withOpacity(0.8),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            percentage,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE1E0FE),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: const TextStyle(fontSize: 13, color: Color(0xFFCFC2D5)),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard() {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'DAILY RETURNS TREND (30 DAYS)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: Color(0xFFCFC2D5),
                ),
              ),
              Row(
                children: [
                  _buildChartTab('1W', false),
                  const SizedBox(width: 8),
                  _buildChartTab('1M', true),
                  const SizedBox(width: 8),
                  _buildChartTab('3M', false),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: CustomPaint(painter: LineChartPainter()),
          ),
        ],
      ),
    );
  }

  Widget _buildChartTab(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF7B2CBF).withOpacity(0.3)
            : const Color(0xFF191A2F),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSelected
              ? const Color(0xFFDEB7FF).withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isSelected ? const Color(0xFFDEB7FF) : const Color(0xFFCFC2D5),
        ),
      ),
    );
  }
}

// Custom Painter for progress
class GaugePainter extends CustomPainter {
  final double progress;
  GaugePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 10.0;

    final bgPaint = Paint()
      ..color = const Color(0xFF27283E)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    const startAngle = -3.14159 / 2;
    final sweepAngle = 2 * 3.14159 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom Painter for Trend Line Chart & Area Fill
class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = const Color(0xFFDEB7FF)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.6);
    path.cubicTo(
      size.width * 0.2,
      size.height * 0.8,
      size.width * 0.4,
      size.height * 0.2,
      size.width * 0.6,
      size.height * 0.4,
    );
    path.cubicTo(
      size.width * 0.8,
      size.height * 0.6,
      size.width * 0.9,
      size.height * 0.1,
      size.width,
      size.height * 0.1,
    );

    // Gradient Area Fill Path
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFDEB7FF).withOpacity(0.4),
          const Color(0xFFDEB7FF).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
