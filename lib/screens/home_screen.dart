/// Ana ekran — glassmorphism efektli 3 kategori kartı.
///
/// Arka planda `widget_bg_edited.jpg` görseli kullanılır.
/// Kullanıcı bir kategori seçtiğinde günün sözü gösterilir
/// ve Android widget güncellenir.
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/quotes_data.dart';
import '../services/widget_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String? _selectedCategoryId;
  Quote? _dailyQuote;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _loadSavedCategory();
  }

  Future<void> _loadSavedCategory() async {
    final savedId = await WidgetService.getSelectedCategory();
    if (savedId != null && mounted) {
      _applyCategory(savedId, animate: false);
    }
  }

  void _applyCategory(String categoryId, {bool animate = true}) {
    final category = allCategories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => allCategories.first,
    );
    final quote = WidgetService.getDailyQuote(category.quotes);

    setState(() {
      _selectedCategoryId = categoryId;
      _dailyQuote = quote;
    });

    if (animate) {
      _fadeController.reset();
      _fadeController.forward();
    } else {
      _fadeController.value = 1.0;
    }
  }

  Future<void> _onCategoryTap(String categoryId) async {
    _applyCategory(categoryId);
    await WidgetService.selectCategory(categoryId);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  // ---------- Build ----------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ---- Arka plan görseli ----
          Image.asset(
            'assets/images/widget_bg_edited.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
                ),
              ),
            ),
          ),

          // ---- Koyu overlay ----
          Container(color: Colors.black.withValues(alpha: 0.45)),

          // ---- İçerik ----
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildCategoryCards(),
                  const Spacer(),
                  if (_dailyQuote != null) _buildQuoteCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Header ----------

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Günün Sözü',
          style: GoogleFonts.playfairDisplay(
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Bir kategori seç, her gün yeni bir ilham al.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ---------- Kategori Kartları ----------

  Widget _buildCategoryCards() {
    return Row(
      children: allCategories.map((cat) {
        final isSelected = cat.id == _selectedCategoryId;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: _GlassCard(
              isSelected: isSelected,
              onTap: () => _onCategoryTap(cat.id),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(cat.icon, style: const TextStyle(fontSize: 28)),
                  const SizedBox(height: 10),
                  Text(
                    cat.label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.white70,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ---------- Alıntı Kartı ----------

  Widget _buildQuoteCard() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.format_quote_rounded,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  _dailyQuote!.text,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '— ${_dailyQuote!.author}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Colors.white60,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Glassmorphism kart widget'ı
// ---------------------------------------------------------------------------

class _GlassCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;

  const _GlassCard({
    required this.isSelected,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? Colors.white.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.07),
          border: Border.all(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.08),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: child,
          ),
        ),
      ),
    );
  }
}
