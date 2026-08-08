import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/providers/home_provider.dart';
import 'package:frontend/view/history.dart';
import 'package:frontend/view/user_portfolio_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _PortfolioInputScreenState();
}

class _PortfolioInputScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController stocknameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  int quantity = 1;
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
    stocknameController.dispose();
    priceController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (quantity > 1) quantity--;
    });
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
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Row(
                  children: const [
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
                    margin: EdgeInsets.only(right: 2),
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
          // Background Shader
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

          // Main Content
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Form Cards
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 30,
                    ),
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
                    child: Column(
                      children: [
                        _buildInputCard(
                          label: 'STOCK SYMBOL',
                          child: TextField(
                            controller: stocknameController,
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
                            controller: priceController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(25, 26, 47, 0.6),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF4C4353),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Color(0xFFCFC2D5),
                                  ),
                                  onPressed: _decrementQuantity,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                ),
                                Text(
                                  '$quantity',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFE1E0FE),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Color(0xFFCFC2D5),
                                  ),
                                  onPressed: _incrementQuantity,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 42),

                  // Submit Button
                  Container(
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
                        log("Analyze Portfolio Clicked");
                        String stockSymbol = stocknameController.text
                            .trim()
                            .toUpperCase();
                        if (!stockSymbol.endsWith('.NS')) {
                          stockSymbol = '$stockSymbol.NS';
                        }
                        if (stocknameController.text.isEmpty ||
                            priceController.text.isEmpty ||
                            quantity <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please fill all fields')),
                          );
                          return;
                        }

                        await homeProvider.callanalyzeSingleStock(
                          stockSymbol,
                          double.parse(priceController.text),
                          quantity,
                        );

                        if (homeProvider.stockData != null) {
                         FocusScope.of(context).unfocus();
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
                          ? CircularProgressIndicator()
                          : const Text(
                              'Analyze Portfolio',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // View Portfolio Report
                  if (homeProvider.stockData != null)
                    Container(
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
                          log("View Portfolio Report Clicked");
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
                            SnackBar(content: Text('Report saved to History')),
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
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
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
