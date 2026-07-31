import 'package:dhanra_new/core/router/app_router.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Track Every Expense Automatically',
      'subtitle':
          'Seamlessly monitor cash flow, bank transactions, and recurring subscriptions in real-time.',
      'icon': 'analytics',
    },
    {
      'title': 'AI-Powered Financial Insights',
      'subtitle':
          'Receive personalized recommendations, smart categorization, and financial health scores.',
      'icon': 'psychology',
    },
    {
      'title': 'Achieve Your Savings Goals',
      'subtitle':
          'Set custom budgets, track milestones, and secure your financial future effortlessly.',
      'icon': 'savings',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go(AppRoutes.login),
                child: const Text(
                  'Skip',
                  style: TextStyle(color: AppColors.darkTextSecondary),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  IconData iconData = Icons.auto_graph_rounded;
                  if (slide['icon'] == 'psychology') {
                    iconData = Icons.psychology_rounded;
                  } else if (slide['icon'] == 'savings') {
                    iconData = Icons.savings_rounded;
                  }

                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                width: 2),
                          ),
                          child: Icon(
                            iconData,
                            size: 64,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          slide['title']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide['subtitle']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.darkTextSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primary
                        : AppColors.darkCard,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage < _slides.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    context.go(AppRoutes.login);
                  }
                },
                child: Text(
                  _currentPage == _slides.length - 1
                      ? 'Get Started'
                      : 'Continue',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
