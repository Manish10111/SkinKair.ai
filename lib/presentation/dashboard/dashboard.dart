import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../profile.dart';
import '../../services/auth.dart';
import '../../core/app_export.dart';
import '../../services/ai_skincare_service.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/quick_stats_widget.dart';
import './widgets/routine_products_list_widget.dart';
import './widgets/routine_progress_card_widget.dart';
import './widgets/usage_history_chart_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  bool _isLoadingRoutine = false;
  final AuthService authService = AuthService();
  String displayName = "User"; // default

  // User data - this would come from user profile in real app

  final DateTime currentDate = DateTime.now();

  // AI-powered routine data
  List<Map<String, dynamic>> routineProducts = [];
  Map<String, dynamic>? aiRoutineData;

  // AI Services
  final AiSkincareService _aiService = AiSkincareService();

  // Mock usage history data (this could also be AI-generated)
  final List<Map<String, dynamic>> weeklyUsageData = [
    {"label": "Mon", "value": 4},
    {"label": "Tue", "value": 5},
    {"label": "Wed", "value": 3},
    {"label": "Thu", "value": 5},
    {"label": "Fri", "value": 2},
    {"label": "Sat", "value": 4},
    {"label": "Sun", "value": 3},
  ];

  final List<Map<String, dynamic>> monthlyUsageData = [
    {"label": "Week 1", "value": 28},
    {"label": "Week 2", "value": 32},
    {"label": "Week 3", "value": 25},
    {"label": "Week 4", "value": 30},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeAiRoutine();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeAiRoutine() async {
    try {
      // Check for cached routine first
      final cachedRoutine = await _aiService.getCachedRoutine();
      if (cachedRoutine != null) {
        _processAiRoutine(cachedRoutine);
        return;
      }

      // Generate new AI routine if no cache
      await _generateAiRoutine();
    } catch (e) {
      _loadFallbackRoutine();
    }
  }

  Future<void> _generateAiRoutine() async {
    setState(() {
      _isLoadingRoutine = true;
    });

    try {
      // In a real app, these would come from user onboarding/profile
      final routine = await _aiService.generatePersonalizedRoutine(
        age: 28,
        gender: 'female',
        skinType: 'combination',
        skinGoals: ['hydration', 'anti-aging', 'acne-prevention'],
        additionalInfo: 'Sensitive to fragrances, prefers morning routine',
      );

      _processAiRoutine(routine);
    } catch (e) {
      _loadFallbackRoutine();
      Fluttertoast.showToast(
        msg: "Using cached recommendations. Check your internet connection.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      setState(() {
        _isLoadingRoutine = false;
      });
    }
  }

  void _processAiRoutine(Map<String, dynamic> routine) {
    setState(() {
      aiRoutineData = routine;
      // Convert AI routine to display format
      routineProducts = _convertAiRoutineToProducts(routine);
    });
  }

  List<Map<String, dynamic>> _convertAiRoutineToProducts(
      Map<String, dynamic> routine) {
    final List<Map<String, dynamic>> products = [];

    if (routine['routine']?['morning'] is List) {
      for (var product in routine['routine']['morning']) {
        products.add({
          "id": products.length + 1,
          "name": product['name'] ?? 'Unknown Product',
          "category": _capitalizeCategory(product['category'] ?? ''),
          "image": product['image'] ??
              "https://images.unsplash.com/photo-1556228720-195a672e8a03?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
          "usedToday": false,
          "lastUsed":
              DateTime.now().subtract(Duration(hours: product['step'] ?? 1)),
          "description": product['description'] ?? '',
          "ingredients": product['ingredients'] ?? [],
          "application": product['application'] ?? '',
          "timeOfDay": "morning",
        });
      }
    }

    return products;
  }

  String _capitalizeCategory(String category) {
    if (category.isEmpty) return 'Skincare';
    return category[0].toUpperCase() + category.substring(1);
  }

  void _loadFallbackRoutine() {
    // Fallback to mock data if AI fails
    setState(() {
      routineProducts = [
        {
          "id": 1,
          "name": "Gentle Face Wash",
          "category": "Cleanser",
          "image":
              "https://images.unsplash.com/photo-1556228720-195a672e8a03?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
          "usedToday": true,
          "lastUsed": DateTime.now().subtract(const Duration(hours: 2)),
          "description": "A gentle cleanser for daily use",
          "ingredients": ["ceramides", "hyaluronic acid"],
          "application": "Apply to wet skin, massage gently",
          "timeOfDay": "morning",
        },
        {
          "id": 2,
          "name": "Hydrating Toner",
          "category": "Toner",
          "image":
              "https://images.unsplash.com/photo-1620916566398-39f1143ab7be?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
          "usedToday": false,
          "lastUsed": DateTime.now().subtract(const Duration(days: 1)),
          "description": "Balances pH and adds moisture",
          "ingredients": ["niacinamide", "glycerin"],
          "application": "Pat gently with cotton pad",
          "timeOfDay": "morning",
        },
        {
          "id": 3,
          "name": "Vitamin C Serum",
          "category": "Serum",
          "image":
              "https://images.unsplash.com/photo-1571781926291-c477ebfd024b?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
          "usedToday": false,
          "lastUsed": DateTime.now().subtract(const Duration(hours: 8)),
          "description": "Antioxidant protection and brightening",
          "ingredients": ["vitamin c", "vitamin e"],
          "application": "Apply 2-3 drops to clean skin",
          "timeOfDay": "morning",
        },
        {
          "id": 4,
          "name": "Daily Moisturizer",
          "category": "Moisturizer",
          "image":
              "https://images.unsplash.com/photo-1556228578-8c89e6adf883?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
          "usedToday": true,
          "lastUsed": DateTime.now().subtract(const Duration(minutes: 30)),
          "description": "Hydrates and strengthens skin barrier",
          "ingredients": ["ceramides", "peptides"],
          "application": "Apply evenly to face and neck",
          "timeOfDay": "morning",
        },
        {
          "id": 5,
          "name": "SPF 50 Sunscreen",
          "category": "Sunscreen",
          "image":
              "https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
          "usedToday": false,
          "lastUsed": DateTime.now().subtract(const Duration(days: 2)),
          "description": "Broad spectrum UV protection",
          "ingredients": ["zinc oxide", "titanium dioxide"],
          "application": "Apply 15-20 minutes before sun exposure",
          "timeOfDay": "morning",
        },
      ];
    });
  }

  int get completedSteps {
    return routineProducts
        .where((product) => product['usedToday'] as bool? ?? false)
        .length;
  }

  int get totalSteps => routineProducts.length;

  int get streakDays => 7; // Mock streak data

  int get productsRemaining => 12; // Mock products remaining

  double get completionPercentage => 85.0; // Mock completion percentage

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Regenerate AI routine
      await _generateAiRoutine();

      Fluttertoast.showToast(
        msg: "AI recommendations updated successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to update recommendations",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startRoutine() {
    Navigator.pushNamed(context, '/product-routine');
  }

  void _markProductAsUsed(Map<String, dynamic> product) {
    setState(() {
      final index = routineProducts.indexWhere((p) => p['id'] == product['id']);
      if (index != -1) {
        routineProducts[index]['usedToday'] = true;
        routineProducts[index]['lastUsed'] = DateTime.now();
      }
    });

    Fluttertoast.showToast(
      msg: "${product['name']} marked as used!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _viewProductDetails(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
                margin: EdgeInsets.only(bottom: 2.h),
              ),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: product['image'] as String? ?? '',
                      width: 20.w,
                      height: 20.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'] as String? ?? 'Unknown Product',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          product['category'] as String? ?? 'Skincare',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              // AI-Generated Description
              if (product['description'] != null &&
                  product['description'].toString().isNotEmpty) ...[
                Text(
                  'AI Recommendation',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  product['description'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                SizedBox(height: 2.h),
              ],

              // Key Ingredients
              if (product['ingredients'] != null &&
                  (product['ingredients'] as List).isNotEmpty) ...[
                Text(
                  'Key Ingredients',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: (product['ingredients'] as List)
                      .map<Widget>((ingredient) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        ingredient.toString(),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme
                              .lightTheme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 2.h),
              ],

              // Application Instructions
              if (product['application'] != null &&
                  product['application'].toString().isNotEmpty) ...[
                Text(
                  'How to Apply',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  product['application'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                SizedBox(height: 2.h),
              ],

              // Usage Status
              Text(
                'Usage Status',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: product['usedToday'] as bool? ?? false
                        ? 'check_circle'
                        : 'radio_button_unchecked',
                    color: product['usedToday'] as bool? ?? false
                        ? AppTheme.getSemanticColor(
                            type: 'success', isLight: true)
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    product['usedToday'] as bool? ?? false
                        ? 'Used today'
                        : 'Not used today',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  void _setProductReminder(Map<String, dynamic> product) {
    Fluttertoast.showToast(
      msg: "Reminder set for ${product['name']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showAiSkincareChatbot() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.75,
        child: _buildAiChatbotInterface(),
      ),
    );
  }

  Widget _buildAiChatbotInterface() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'psychology',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 32,
              ),
              SizedBox(width: 2.w),
              Text(
                'AI Skincare Expert',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: ListView(
              children: [
                _buildChatMessage(
                  'AI',
                  'Hello! I\'m your personal AI skincare expert. I can help with:\n\n• Product recommendations\n• Routine questions\n• Ingredient explanations\n• Skin concerns\n\nWhat would you like to know?',
                  true,
                ),
                SizedBox(height: 2.h),
                _buildQuickQuestions(),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // This would integrate with Murf.ai for TTS
                    Fluttertoast.showToast(
                      msg: "Voice chat coming soon with Murf.ai integration",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                    );
                  },
                  icon: CustomIconWidget(
                    iconName: 'mic',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  label: const Text('Voice Chat'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildChatMessage(String sender, String message, bool isAi) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: isAi
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: isAi ? 'psychology' : 'person',
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: isAi
                    ? AppTheme.lightTheme.colorScheme.primaryContainer
                        .withAlpha(77)
                    : AppTheme.lightTheme.colorScheme.secondaryContainer
                        .withAlpha(77),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickQuestions() {
    final questions = [
      'Why is my skin breaking out?',
      'Best ingredients for anti-aging?',
      'How to layer skincare products?',
      'Morning vs evening routine?',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Questions',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: questions.map((question) {
            return GestureDetector(
              onTap: () => _askAiQuestion(question),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  question,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _askAiQuestion(String question) async {
    // Close current bottom sheet
    Navigator.pop(context);

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final response = await _aiService.getSkincareAdvice(
        question: question,
        skinType: 'combination', // Would come from user profile
        currentRoutine:
            'Morning: cleanser, toner, serum, moisturizer, sunscreen',
      );

      Navigator.pop(context); // Close loading

      // Show AI response
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'psychology',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'AI Expert Advice',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              response,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                // This would integrate with Murf.ai for TTS
                Fluttertoast.showToast(
                  msg: "Audio playback coming soon with Murf.ai",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
              child: const Text('Listen'),
            ),
          ],
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close loading
      Fluttertoast.showToast(
        msg: "Failed to get AI advice. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String userName = "${authService.displayName}";

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Dashboard'),
                  Tab(text: 'Routine'),
                  Tab(text: 'History'),
                  Tab(text: 'Profile'),
                ],
              ),
            ),
            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Dashboard Tab
                  RefreshIndicator(
                    onRefresh: _refreshData,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Greeting Header
                          GreetingHeaderWidget(
                            userName: userName,
                            currentDate: currentDate,
                          ),

                          // Routine Progress Card
                          RoutineProgressCardWidget(
                            completedSteps: completedSteps,
                            totalSteps: totalSteps,
                            onStartRoutine: _startRoutine,
                          ),

                          SizedBox(height: 3.h),

                          // AI Loading Indicator
                          if (_isLoadingRoutine) ...[
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color: AppTheme
                                    .lightTheme.colorScheme.primaryContainer
                                    .withAlpha(77),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const CircularProgressIndicator(),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'AI is personalizing your routine...',
                                          style: AppTheme
                                              .lightTheme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 0.5.h),
                                        Text(
                                          'Analyzing your skin type and goals',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 3.h),
                          ],

                          // Current Routine Products (AI-Generated)
                          RoutineProductsListWidget(
                            products: routineProducts,
                            onMarkAsUsed: _markProductAsUsed,
                            onViewDetails: _viewProductDetails,
                            onSetReminder: _setProductReminder,
                          ),

                          SizedBox(height: 3.h),

                          // Quick Stats
                          QuickStatsWidget(
                            streakDays: streakDays,
                            productsRemaining: productsRemaining,
                            completionPercentage: completionPercentage,
                          ),

                          SizedBox(height: 3.h),

                          // Usage History Chart
                          UsageHistoryChartWidget(
                            weeklyData: weeklyUsageData,
                            monthlyData: monthlyUsageData,
                          ),

                          SizedBox(height: 10.h), // Bottom padding for FAB
                        ],
                      ),
                    ),
                  ),

                  // Routine Tab (Placeholder)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'spa',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 64,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Routine Management',
                          style: AppTheme.lightTheme.textTheme.headlineSmall,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Coming Soon',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // History Tab (Placeholder)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'history',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 64,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Usage History',
                          style: AppTheme.lightTheme.textTheme.headlineSmall,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Coming Soon',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Profile Tab (Placeholder)
                  ProfilePage()
                  //Center(
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         CustomIconWidget(
                //           iconName: 'person',
                //           color: AppTheme.lightTheme.colorScheme.primary,
                //           size: 64,
                //         ),
                //         SizedBox(height: 2.h),
                //         Text(
                //           'Profile Settings',
                //           style: AppTheme.lightTheme.textTheme.headlineSmall,
                //         ),
                //         SizedBox(height: 1.h),
                //         Text(
                //           'Coming Soon',
                //           style:
                //               AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                //             color: AppTheme
                //                 .lightTheme.colorScheme.onSurfaceVariant,
                //           ),
                //         ),
                //       ],
                //     ),
                // ),
                // 
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: _showAiSkincareChatbot,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              child: CustomIconWidget(
                iconName: 'psychology',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
