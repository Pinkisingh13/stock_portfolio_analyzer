import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/providers/home_provider.dart';
import 'package:frontend/models/home_model.dart';
import 'package:provider/provider.dart';

class MultiStockReportScreen extends StatelessWidget {
  const MultiStockReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final stocks = homeProvider.multiStockData;

    if (stocks == null || stocks.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFF101126),
        body: Center(
          child: Text(
            'No data yet.\nGo back and analyze multiple stocks.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ),
      );
    }

    // Calculate portfolio totals
    double totalInvestment = 0;
    double totalCurrentValue = 0;
    for (final stock in stocks) {
      totalInvestment += stock.totalInvestment;
      totalCurrentValue += stock.currentValue;
    }
    final totalPL = totalCurrentValue - totalInvestment;
    final totalPLPercent =
        totalInvestment > 0 ? (totalPL / totalInvestment) * 100 : 0.0;
    final isProfit = totalPL >= 0;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF101126),
        appBar: AppBar(
          backgroundColor: const Color(0xFF7B2CBF).withValues(alpha: 0.2),
          toolbarHeight: 70,
          title: const Text(
            'Portfolio Report',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE1E0FE),
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF7B2CBF).withValues(alpha: 0.15),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Portfolio Summary Card
                  _buildSummaryCard(
                    totalInvestment: totalInvestment,
                    totalCurrentValue: totalCurrentValue,
                    totalPL: totalPL,
                    totalPLPercent: totalPLPercent,
                    isProfit: isProfit,
                    stockCount: stocks.length,
                  ),
                  const SizedBox(height: 24),

                  // Section title
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 12),
                    child: Text(
                      'INDIVIDUAL STOCKS',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: Color(0xFFCFC2D5),
                      ),
                    ),
                  ),

                  // Stock cards
                  ...stocks.map((stock) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildStockCard(stock),
                      )),

                  const SizedBox(height: 24),

                  // Allocation breakdown
                  _buildAllocationCard(stocks, totalInvestment),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required double totalInvestment,
    required double totalCurrentValue,
    required double totalPL,
    required double totalPLPercent,
    required bool isProfit,
    required int stockCount,
  }) {
    final plColor =
        isProfit ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1D1E33).withValues(alpha: 0.7),
           
            border: Border(
              top: BorderSide(
                  color: const Color(0xFFDEB7FF).withValues(alpha: 0.2)),
              left: BorderSide(
                  color: const Color(0xFFDEB7FF).withValues(alpha: 0.1)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'PORTFOLIO OVERVIEW',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: Color(0xFFCFC2D5),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B2CBF).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$stockCount Stocks',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFDEB7FF),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // P&L big number
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isProfit ? "+" : ""}${totalPLPercent.toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: plColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '${isProfit ? "+" : ""}₹${totalPL.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: plColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                isProfit ? 'Total Profit' : 'Total Loss',
                style: TextStyle(
                  fontSize: 14,
                  color: plColor.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),

              // Investment vs Current
              Row(
                children: [
                  Expanded(
                    child: _buildMiniStat(
                      'Invested',
                      '₹${totalInvestment.toStringAsFixed(0)}',
                      Icons.currency_rupee,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMiniStat(
                      'Current Value',
                      '₹${totalCurrentValue.toStringAsFixed(0)}',
                      Icons.account_balance_wallet,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF191A2F).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: const Color(0xFFCFC2D5)),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFFCFC2D5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE1E0FE),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockCard(MultiStockItemModel stock) {
    final isProfit = stock.profitLoss >= 0;
    final plColor =
        isProfit ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stock.stockName.replaceAll('.NS', ''),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE1E0FE),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: plColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isProfit ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 14,
                      color: plColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${stock.profitLossPercentage.toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: plColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Row 1: Price info
          Row(
            children: [
              Expanded(
                child: _buildStockStat(
                    'Current', '₹${stock.currentPrice.toStringAsFixed(2)}'),
              ),
              Expanded(
                child: _buildStockStat(
                    'Buy Price', '₹${stock.boughtPrice.toStringAsFixed(2)}'),
              ),
              Expanded(
                child: _buildStockStat('Qty', '${stock.quantity}'),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Row 2: Investment summary
          Row(
            children: [
              Expanded(
                child: _buildStockStat(
                    'Invested', '₹${stock.totalInvestment.toStringAsFixed(0)}'),
              ),
              Expanded(
                child: _buildStockStat(
                    'Value', '₹${stock.currentValue.toStringAsFixed(0)}'),
              ),
              Expanded(
                child: _buildStockStat(
                  'P&L',
                  '${isProfit ? "+" : ""}₹${stock.profitLoss.toStringAsFixed(0)}',
                  valueColor: plColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Row 3: Risk metrics
          Row(
            children: [
              Expanded(
                child: _buildStockStat(
                    'Volatility', '${stock.volatility.toStringAsFixed(2)}%'),
              ),
              Expanded(
                child: _buildStockStat(
                    'Avg Daily', '${stock.meanDailyReturn.toStringAsFixed(2)}%'),
              ),
              Expanded(
                child: _buildStockStat(
                    '30D High', '₹${stock.high30d.toStringAsFixed(2)}'),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Row 4: 30D Low + Best/Worst with dates
          Row(
            children: [
              Expanded(
                child: _buildStockStat(
                    '30D Low', '₹${stock.low30d.toStringAsFixed(2)}'),
              ),
              Expanded(
                child: _buildStockStat(
                  'Best Day',
                  '+${stock.bestDayReturn.toStringAsFixed(2)}%',
                  valueColor: const Color(0xFF10B981),
                  subtitle: stock.bestDayDate,
                ),
              ),
              Expanded(
                child: _buildStockStat(
                  'Worst Day',
                  '${stock.worstDayReturn.toStringAsFixed(2)}%',
                  valueColor: const Color(0xFFEF4444),
                  subtitle: stock.worstDayDate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Trend Analysis Section
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF101126).withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFDEB7FF).withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TREND ANALYSIS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: Color(0xFFCFC2D5),
                  ),
                ),
                const SizedBox(height: 10),
                _buildTrendBadge('Short', stock.shortTerm),
                const SizedBox(height: 6),
                _buildTrendBadge('Momentum', stock.momentum),
                const SizedBox(height: 6),
                _buildTrendBadge('Long', stock.longTerm),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildSMAMini('SMA20', stock.sma20),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSMAMini('SMA50', stock.sma50),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSMAMini('SMA200', stock.sma200),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendBadge(String label, String value) {
    Color color;
    if (value.toLowerCase().contains('bullish') ||
        value.toLowerCase().contains('strength')) {
      color = const Color(0xFF10B981);
    } else if (value.toLowerCase().contains('bearish') ||
        value.toLowerCase().contains('weakness')) {
      color = const Color(0xFFEF4444);
    } else {
      color = const Color(0xFFEAB308);
    }

    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF988D9E)),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSMAMini(String label, double value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF988D9E)),
        ),
        const SizedBox(height: 2),
        Text(
          '₹${value.toStringAsFixed(1)}',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE1E0FE),
          ),
        ),
      ],
    );
  }

  Widget _buildStockStat(String label, String value,
      {Color? valueColor, String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF988D9E)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFFE1E0FE),
          ),
        ),
        if (subtitle != null && subtitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Color(0xFF988D9E)),
            ),
          ),
      ],
    );
  }

  Widget _buildAllocationCard(
      List<MultiStockItemModel> stocks, double totalInvestment) {
    final colors = [
      const Color(0xFFDEB7FF),
      const Color(0xFF10B981),
      const Color(0xFFADC6FF),
      const Color(0xFFEAB308),
      const Color(0xFFEF4444),
      const Color(0xFF06B6D4),
      const Color(0xFFF97316),
      const Color(0xFFA855F7),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PORTFOLIO ALLOCATION',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: Color(0xFFCFC2D5),
            ),
          ),
          const SizedBox(height: 16),

          // Allocation bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 14,
              child: Row(
                children: stocks.asMap().entries.map((entry) {
                  final index = entry.key;
                  final stock = entry.value;
                  final weight = stock.portfolioWeight / 100; // Backend sends percentage, we need 0-1 for flex
                  return Expanded(
                    flex: (weight * 1000).toInt().clamp(1, 1000),
                    child: Container(
                      color: colors[index % colors.length],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Legend
          ...stocks.asMap().entries.map((entry) {
            final index = entry.key;
            final stock = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      stock.stockName.replaceAll('.NS', ''),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFE1E0FE),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    '${stock.portfolioWeight.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFCFC2D5),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
