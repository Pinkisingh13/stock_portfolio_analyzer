import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/providers/home_provider.dart';
import 'package:frontend/view/history.dart';
import 'package:frontend/view/multi_stock_report_screen.dart';
import 'package:frontend/view/user_portfolio_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // Toggle: 0 = Single, 1 = Multiple
  int _mode = 0;

  // Single stock controllers
  final TextEditingController _singleNameCtrl = TextEditingController();
  final TextEditingController _singlePriceCtrl = TextEditingController();
  int _singleQty = 1;

  // Multiple stock entries
  final List<_StockEntry> _multiEntries = [_StockEntry()];

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animController.forward();
    });
  }

  @override
  void dispose() {
    _singleNameCtrl.dispose();
    _singlePriceCtrl.dispose();
    for (final e in _multiEntries) {
      e.dispose();
    }
    _animController.dispose();
    super.dispose();
  }

  void _addStockEntry() {
    setState(() {
      _multiEntries.add(_StockEntry());
    });
  }

  void _removeStockEntry(int index) {
    if (_multiEntries.length > 1) {
      setState(() {
        _multiEntries[index].dispose();
        _multiEntries.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              color: const Color(0xFF101126).withOpacity(0.8),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Row(
                  children: [
                    Icon(Icons.show_chart, color: Color(0xFFDEB7FF)),
                    SizedBox(width: 12),
                    Text(
                      'Stock Portfolio Analyzer',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: -0.5,
                        color: Color(0xFFDEB7FF),
                      ),
                    ),
                  ],
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 2),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HistoryScreen(),
                          ),
                        );
                      },
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
                      icon: const Icon(Icons.history, size: 16),
                      label: const Text(
                        'History',
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
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background glow
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7B2CBF).withOpacity(0.15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // Main content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),

                  // Mode Toggle
                  _buildModeToggle(),
                  const SizedBox(height: 24),

                  // Form based on mode
                  if (_mode == 0) _buildSingleStockForm(homeProvider),
                  if (_mode == 1) _buildMultiStockForm(homeProvider),

                  const SizedBox(height: 42),

                  // Analyze Button
                  _buildAnalyzeButton(homeProvider),
                  const SizedBox(height: 20),

                  // View Report Button
                  if (_mode == 0 && homeProvider.stockData != null)
                    _buildViewReportButton(homeProvider),
                  if (_mode == 1 && homeProvider.multiStockData != null)
                    _buildViewMultiReportButton(homeProvider),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4C4353)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _mode = 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _mode == 0
                      ? const Color(0xFF7B2CBF).withOpacity(0.4)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _mode == 0
                        ? const Color(0xFFDEB7FF).withOpacity(0.4)
                        : Colors.transparent,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Single Stock',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _mode == 0
                          ? const Color(0xFFDEB7FF)
                          : const Color(0xFFCFC2D5),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _mode = 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _mode == 1
                      ? const Color(0xFF7B2CBF).withOpacity(0.4)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _mode == 1
                        ? const Color(0xFFDEB7FF).withOpacity(0.4)
                        : Colors.transparent,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Multiple Stocks',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _mode == 1
                          ? const Color(0xFFDEB7FF)
                          : const Color(0xFFCFC2D5),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleStockForm(HomeProvider homeProvider) {
    return _buildFormContainer(
      child: Column(
        children: [
          _buildInputCard(
            label: 'STOCK SYMBOL',
            child: TextField(
              controller: _singleNameCtrl,
              style: const TextStyle(color: Color(0xFFE1E0FE)),
              decoration: _buildInputDecoration(
                hint: 'e.g., RELIANCE.NS',
                prefixIcon: Icons.search,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildInputCard(
            label: 'BUY PRICE',
            child: TextField(
              controller: _singlePriceCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(
                color: Color(0xFFE1E0FE),
                fontWeight: FontWeight.w500,
              ),
              decoration: _buildInputDecoration(
                hint: '0.00',
                prefixText: '₹ ',
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildInputCard(
            label: 'QUANTITY',
            child: _buildQuantityStepper(
              value: _singleQty,
              onIncrement: () => setState(() => _singleQty++),
              onDecrement: () {
                if (_singleQty > 1) setState(() => _singleQty--);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiStockForm(HomeProvider homeProvider) {
    return Column(
      children: [
        ..._multiEntries.asMap().entries.map((entry) {
          final index = entry.key;
          final stockEntry = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildFormContainer(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'STOCK ${index + 1}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: Color(0xFFDEB7FF),
                        ),
                      ),
                      if (_multiEntries.length > 1)
                        GestureDetector(
                          onTap: () => _removeStockEntry(index),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Color(0xFFEF4444),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInputCard(
                    label: 'SYMBOL',
                    child: TextField(
                      controller: stockEntry.nameCtrl,
                      style: const TextStyle(color: Color(0xFFE1E0FE)),
                      decoration: _buildInputDecoration(
                        hint: 'e.g., SBIN.NS',
                        prefixIcon: Icons.search,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputCard(
                          label: 'BUY PRICE',
                          child: TextField(
                            controller: stockEntry.priceCtrl,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            style: const TextStyle(
                              color: Color(0xFFE1E0FE),
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: _buildInputDecoration(
                              hint: '0.00',
                              prefixText: '₹ ',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInputCard(
                          label: 'QTY',
                          child: _buildQuantityStepper(
                            value: stockEntry.quantity,
                            onIncrement: () =>
                                setState(() => stockEntry.quantity++),
                            onDecrement: () {
                              if (stockEntry.quantity > 1) {
                                setState(() => stockEntry.quantity--);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),

        // Add Stock Button
        GestureDetector(
          onTap: _addStockEntry,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1D1E33).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFDEB7FF).withOpacity(0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline,
                    color: Color(0xFFDEB7FF), size: 20),
                SizedBox(width: 8),
                Text(
                  'Add Another Stock',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFDEB7FF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyzeButton(HomeProvider homeProvider) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF7B2CBF).withOpacity(0.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B2CBF).withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: homeProvider.isLoading
            ? null
            : () async {
                if (_mode == 0) {
                  await _analyzeSingle(homeProvider);
                } else {
                  await _analyzeMultiple(homeProvider);
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: homeProvider.isLoading
            ? const CircularProgressIndicator(color: Color(0xFFDEB7FF))
            : Text(
                _mode == 0 ? 'Analyze Stock' : 'Analyze Portfolio',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildViewReportButton(HomeProvider homeProvider) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF7B2CBF).withOpacity(0.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B2CBF).withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserPortfolioScreen(),
            ),
          );
          await homeProvider.saveToHistory();
          homeProvider.clearStockData();
          setState(() {});
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Report saved to History')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'View Report',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildViewMultiReportButton(HomeProvider homeProvider) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF7B2CBF).withOpacity(0.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B2CBF).withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MultiStockReportScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'View Portfolio Report',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _analyzeSingle(HomeProvider homeProvider) async {
    String stockSymbol = _singleNameCtrl.text.trim().toUpperCase();
    if (!stockSymbol.endsWith('.NS')) {
      stockSymbol = '$stockSymbol.NS';
    }
    if (_singleNameCtrl.text.isEmpty ||
        _singlePriceCtrl.text.isEmpty ||
        _singleQty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    await homeProvider.callanalyzeSingleStock(
      stockSymbol,
      double.parse(_singlePriceCtrl.text),
      _singleQty,
    );

    if (homeProvider.stockData != null) {
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> _analyzeMultiple(HomeProvider homeProvider) async {
    final List<String> names = [];
    final List<double> prices = [];
    final List<int> quantities = [];

    for (final entry in _multiEntries) {
      if (entry.nameCtrl.text.isEmpty || entry.priceCtrl.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all stock fields')),
        );
        return;
      }
      String symbol = entry.nameCtrl.text.trim().toUpperCase();
      if (!symbol.endsWith('.NS')) {
        symbol = '$symbol.NS';
      }
      names.add(symbol);
      prices.add(double.parse(entry.priceCtrl.text));
      quantities.add(entry.quantity);
    }

    await homeProvider.callanalyzeMultipleStocks(names, prices, quantities);

    if (homeProvider.multiStockData != null) {
      FocusScope.of(context).unfocus();
    }
  }

  // --- Reusable Widgets ---

  Widget _buildFormContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(40, 41, 62, 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFDEB7FF).withOpacity(0.2),
          ),
          left: BorderSide(
            color: const Color(0xFFDEB7FF).withOpacity(0.2),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInputCard({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: Color(0xFFE1E0FE),
          ),
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }

  Widget _buildQuantityStepper({
    required int value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(25, 26, 47, 0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF4C4353)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, color: Color(0xFFCFC2D5)),
            onPressed: onDecrement,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFFE1E0FE),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFFCFC2D5)),
            onPressed: onIncrement,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    IconData? prefixIcon,
    String? prefixText,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF988D9E)),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: const Color(0xFFCFC2D5))
          : null,
      prefixText: prefixText,
      prefixStyle: const TextStyle(
        color: Color(0xFFCFC2D5),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: const Color.fromRGBO(25, 26, 47, 0.6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF4C4353)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFDEB7FF)),
      ),
    );
  }
}

class _StockEntry {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController priceCtrl = TextEditingController();
  int quantity = 1;

  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
  }
}
