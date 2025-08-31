import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
// import '../../routes/app_routes.dart'; // Make sure this import is present
import './widgets/alternatives_bottom_sheet.dart';
import './widgets/product_card_widget.dart';
import './widgets/routine_timer_widget.dart';
import './widgets/voice_coaching_widget.dart';

class ProductRoutine extends StatefulWidget {
  const ProductRoutine({Key? key}) : super(key: key);

  @override
  State<ProductRoutine> createState() => _ProductRoutineState();
}

class _ProductRoutineState extends State<ProductRoutine>
    with TickerProviderStateMixin {
  bool _isGuidedMode = false;
  int _currentCoachingStep = 1;
  bool _morningRoutine = true;
  String _selectedRoutineType = 'Morning Routine';
  late DateTime _lastUpdated;

  // Mock data for 5-step skincare routine
  final List<Map<String, dynamic>> _routineProducts = [
    {
      "id": 1,
      "category": "Face Wash",
      "name": "Gentle Foaming Cleanser",
      "brand": "CeraVe",
      "image":
      "https://images.unsplash.com/photo-1556228720-195a672e8a03?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "benefits": [
        "Removes impurities",
        "Maintains skin barrier",
        "Non-comedogenic",
        "Fragrance-free"
      ],
      "instructions":
      "Apply to damp skin, gently massage in circular motions for 30 seconds, then rinse with lukewarm water.",
      "ingredients": [
        "Ceramides",
        "Hyaluronic Acid",
        "Niacinamide",
        "MVE Technology"
      ],
      "step": 1,
    },
    {
      "id": 2,
      "category": "Toner",
      "name": "Hydrating Essence Toner",
      "brand": "The Ordinary",
      "image":
      "https://images.unsplash.com/photo-1620916566398-39f1143ab7be?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "benefits": [
        "Balances pH",
        "Hydrates skin",
        "Prepares for serums",
        "Alcohol-free"
      ],
      "instructions":
      "Apply to clean skin using cotton pad or gentle patting motions with hands. Allow to absorb before next step.",
      "ingredients": ["Hyaluronic Acid", "Glycerin", "Panthenol", "Allantoin"],
      "step": 2,
    },
    {
      "id": 3,
      "category": "Serum",
      "name": "Vitamin C Brightening Serum",
      "brand": "Skinceuticals",
      "image":
      "https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "benefits": [
        "Brightens complexion",
        "Antioxidant protection",
        "Reduces dark spots",
        "Boosts collagen"
      ],
      "instructions":
      "Apply 2-3 drops to face and neck. Gently pat until absorbed. Use in morning routine only.",
      "ingredients": [
        "L-Ascorbic Acid",
        "Vitamin E",
        "Ferulic Acid",
        "Hyaluronic Acid"
      ],
      "step": 3,
    },
    {
      "id": 4,
      "category": "Moisturizer",
      "name": "Daily Facial Moisturizer",
      "brand": "Neutrogena",
      "image":
      "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "benefits": [
        "24-hour hydration",
        "Non-greasy formula",
        "Suitable for all skin types",
        "Fast-absorbing"
      ],
      "instructions":
      "Apply evenly to face and neck using upward strokes. Use as final step before sunscreen.",
      "ingredients": [
        "Hyaluronic Acid",
        "Glycerin",
        "Dimethicone",
        "Ceramides"
      ],
      "step": 4,
    },
    {
      "id": 5,
      "category": "Sunscreen",
      "name": "Broad Spectrum SPF 50",
      "brand": "La Roche-Posay",
      "image":
      "https://images.unsplash.com/photo-1556228578-8c89e6adf883?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "benefits": [
        "UVA/UVB protection",
        "Water-resistant",
        "Non-comedogenic",
        "Antioxidant enriched"
      ],
      "instructions":
      "Apply generously 15 minutes before sun exposure. Reapply every 2 hours or after swimming/sweating.",
      "ingredients": [
        "Zinc Oxide",
        "Titanium Dioxide",
        "Niacinamide",
        "Thermal Spring Water"
      ],
      "step": 5,
    },
  ];

  // Mock alternatives data is unchanged...
  final Map<String, List<Map<String, dynamic>>> _alternativesData = {
    "Face Wash": [
      {
        "id": 6,
        "name": "Hydrating Cream Cleanser",
        "brand": "Cetaphil",
        "image":
        "https://images.unsplash.com/photo-1556228720-195a672e8a03?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "price": "\$12.99",
        "rating": 4.5,
        "benefits": [
          "Gentle on sensitive skin",
          "Soap-free formula",
          "Maintains moisture barrier"
        ],
        "tags": ["budget-friendly", "sensitive skin", "fragrance-free"],
      },
      {
        "id": 7,
        "name": "Purifying Gel Cleanser",
        "brand": "Fresh",
        "image":
        "https://images.unsplash.com/photo-1556228720-195a672e8a03?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "price": "\$38.00",
        "rating": 4.7,
        "benefits": [
          "Deep cleansing",
          "Natural botanicals",
          "Refreshing gel texture"
        ],
        "tags": ["premium", "natural", "oily skin"],
      },
    ],
    "Toner": [
      {
        "id": 8,
        "name": "Rose Water Toner",
        "brand": "Heritage Store",
        "image":
        "https://images.unsplash.com/photo-1620916566398-39f1143ab7be?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "price": "\$9.95",
        "rating": 4.3,
        "benefits": [
          "Natural rose water",
          "Soothing properties",
          "Alcohol-free"
        ],
        "tags": ["budget-friendly", "natural", "sensitive skin"],
      },
    ],
    "Serum": [
      {
        "id": 9,
        "name": "Niacinamide Serum",
        "brand": "The INKEY List",
        "image":
        "https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "price": "\$7.99",
        "rating": 4.4,
        "benefits": [
          "Controls oil production",
          "Minimizes pores",
          "Reduces blemishes"
        ],
        "tags": ["budget-friendly", "oily skin", "acne-prone"],
      },
    ],
    "Moisturizer": [
      {
        "id": 10,
        "name": "Ultra Repair Cream",
        "brand": "First Aid Beauty",
        "image":
        "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "price": "\$36.00",
        "rating": 4.6,
        "benefits": [
          "Intensive hydration",
          "Repairs skin barrier",
          "Suitable for eczema"
        ],
        "tags": ["premium", "sensitive skin", "dry skin"],
      },
    ],
    "Sunscreen": [
      {
        "id": 11,
        "name": "Mineral Sunscreen",
        "brand": "Blue Lizard",
        "image":
        "https://images.unsplash.com/photo-1556228578-8c89e6adf883?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "price": "\$14.99",
        "rating": 4.2,
        "benefits": ["Zinc oxide formula", "Reef-safe", "No white cast"],
        "tags": ["budget-friendly", "sensitive skin", "natural"],
      },
    ],
  };

  // Voice coaching steps are unchanged...
  final List<String> _coachingSteps = [
    "Welcome to your personalized skincare routine! Let's start with step 1: cleansing. Make sure your hands are clean before we begin.",
    "Apply your gentle foaming cleanser to damp skin. Use circular motions and take your time - about 30 seconds of gentle massage.",
    "Rinse thoroughly with lukewarm water. Pat your skin dry with a clean towel - don't rub, just gentle patting motions.",
    "Now for step 2: toning. Apply your hydrating toner using gentle patting motions or a cotton pad. This prepares your skin for the next steps.",
    "Time for your vitamin C serum! Apply 2-3 drops and gently pat into your skin. This powerful antioxidant will protect and brighten your complexion.",
    "Step 4: moisturizing. Apply your daily moisturizer using upward strokes. This locks in hydration and creates a protective barrier.",
    "Finally, don't forget your sunscreen! Apply generously and evenly. This is the most important step for preventing premature aging.",
    "Congratulations! You've completed your skincare routine. Your skin will thank you for this consistent care and attention.",
  ];

  @override
  void initState() {
    super.initState();
    _lastUpdated = DateTime.now();
  }

  // FIX 1: ADD a dedicated navigation method to go to the dashboard cleanly.
  void _navigateToDashboard() {
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.dashboard, (route) => false);
  }

  void _toggleRoutineType() {
    setState(() {
      _morningRoutine = !_morningRoutine;
      _selectedRoutineType =
      _morningRoutine ? 'Morning Routine' : 'Evening Routine';
    });
  }

  void _startGuidedRoutine() {
    setState(() {
      _isGuidedMode = true;
      _currentCoachingStep = 1;
    });
  }

  void _exitGuidedMode() {
    setState(() {
      _isGuidedMode = false;
      _currentCoachingStep = 1;
    });
  }

  void _nextCoachingStep() {
    if (_currentCoachingStep < _coachingSteps.length) {
      setState(() {
        _currentCoachingStep++;
      });
    } else {
      _completeRoutine();
    }
  }

  void _previousCoachingStep() {
    if (_currentCoachingStep > 1) {
      setState(() {
        _currentCoachingStep--;
      });
    }
  }

  void _completeRoutine() {
    setState(() {
      _isGuidedMode = false;
      _currentCoachingStep = 1;
      _lastUpdated = DateTime.now();
    });

    // Show completion celebration
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'celebration',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            const Text('Routine Complete!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Great job completing your skincare routine! Your skin is now protected and nourished.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'local_fire_department',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '7-day streak! Keep it up!',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            // FIX 2: The "Continue" button now correctly navigates to the dashboard.
            onPressed: _navigateToDashboard,
            child: const Text('Continue to Dashboard'),
          ),
        ],
      ),
    );
  }

  // The rest of your methods (_showAlternatives, _markAsUsed, etc.) are unchanged...
  void _showAlternatives(String category) {
    final alternatives = _alternativesData[category] ?? [];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AlternativesBottomSheet(
        productCategory: category,
        alternatives: alternatives,
        onProductSelected: (product) {
          // Handle product selection
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected: ${product['name']}'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _markAsUsed(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} marked as used!'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {},
        ),
      ),
    );
  }

  void _setReminder(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Reminder'),
        content: Text('Set a reminder for ${product['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Reminder set for ${product['name']}'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  void _scanQRCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR Code scanner opened'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky header
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // FIX 3: Replaced the generic IconButton with a BackButton
                      // that uses our new navigation logic.
                      BackButton(onPressed: _navigateToDashboard),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedRoutineType,
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Last updated: ${_lastUpdated.hour.toString().padLeft(2, '0')}:${_lastUpdated.minute.toString().padLeft(2, '0')}',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // QR Scanner button
                      IconButton(
                        onPressed: _scanQRCode,
                        icon: CustomIconWidget(
                          iconName: 'qr_code_scanner',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 6.w,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  // Routine type toggle (unchanged)
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (!_morningRoutine) _toggleRoutineType();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              decoration: BoxDecoration(
                                color: _morningRoutine
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'wb_sunny',
                                    color: _morningRoutine
                                        ? AppTheme
                                        .lightTheme.colorScheme.onPrimary
                                        : AppTheme.lightTheme.colorScheme
                                        .onPrimaryContainer,
                                    size: 4.w,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'Morning',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleSmall
                                        ?.copyWith(
                                      color: _morningRoutine
                                          ? AppTheme
                                          .lightTheme.colorScheme.onPrimary
                                          : AppTheme.lightTheme.colorScheme
                                          .onPrimaryContainer,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (_morningRoutine) _toggleRoutineType();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              decoration: BoxDecoration(
                                color: !_morningRoutine
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'nights_stay',
                                    color: !_morningRoutine
                                        ? AppTheme
                                        .lightTheme.colorScheme.onPrimary
                                        : AppTheme.lightTheme.colorScheme
                                        .onPrimaryContainer,
                                    size: 4.w,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'Evening',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleSmall
                                        ?.copyWith(
                                      color: !_morningRoutine
                                          ? AppTheme
                                          .lightTheme.colorScheme.onPrimary
                                          : AppTheme.lightTheme.colorScheme
                                          .onPrimaryContainer,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Main content
            Expanded(
              child: _isGuidedMode
                  ? _buildGuidedModeContent()
                  : _buildNormalModeContent(),
            ),
          ],
        ),
      ),
      // Floating action button (unchanged)
      floatingActionButton: !_isGuidedMode
          ? FloatingActionButton.extended(
        onPressed: _startGuidedRoutine,
        icon: CustomIconWidget(
          iconName: 'play_arrow',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 5.w,
        ),
        label: const Text('Start Routine'),
      )
          : FloatingActionButton(
        onPressed: _exitGuidedMode,
        backgroundColor: AppTheme.lightTheme.colorScheme.outline,
        child: CustomIconWidget(
          iconName: 'close',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 5.w,
        ),
      ),
    );
  }

  // The rest of your build methods (_buildNormalModeContent, _buildGuidedModeContent) are unchanged...
  Widget _buildNormalModeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.h),
          // Products list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _routineProducts.length,
            itemBuilder: (context, index) {
              final product = _routineProducts[index];
              return ProductCardWidget(
                product: product,
                onMarkAsUsed: () => _markAsUsed(product),
                onSetReminder: () => _setReminder(product),
                onViewAlternatives: () =>
                    _showAlternatives(product['category']),
              );
            },
          ),
          SizedBox(height: 10.h), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildGuidedModeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.h),
          // Timer widget
          RoutineTimerWidget(
            onComplete: _completeRoutine,
            onPause: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Timer paused'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            onResume: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Timer resumed'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          // Voice coaching widget
          VoiceCoachingWidget(
            currentStep: _coachingSteps[_currentCoachingStep - 1],
            stepNumber: _currentCoachingStep,
            totalSteps: _coachingSteps.length,
            onNext: _nextCoachingStep,
            onPrevious: _previousCoachingStep,
            onPlayAudio: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Playing audio guidance...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          SizedBox(height: 10.h), // Space for FAB
        ],
      ),
    );
  }
}

