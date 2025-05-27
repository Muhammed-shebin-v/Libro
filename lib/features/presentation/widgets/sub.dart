import 'package:flutter/material.dart';

class LibroSubscriptionScreen extends StatefulWidget {
  const LibroSubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<LibroSubscriptionScreen> createState() => _LibroSubscriptionScreenState();
}

class _LibroSubscriptionScreenState extends State<LibroSubscriptionScreen>
    with TickerProviderStateMixin {
  int selectedPlan = 1; // Default to Gold plan
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 255, 228, 228),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFF5D76E),
                        Color(0xFFF2C744),
                        Color(0xFFF5E6A8),
                      ],
                    ),
                  ),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              _buildHeader(),
                              const SizedBox(height: 40),
                              _buildTitle(),
                              const SizedBox(height: 8),
                              _buildSubtitle(),
                              const SizedBox(height: 40),
                              _buildSubscriptionPlans(),
                              const SizedBox(height: 40),
                              _buildConfirmButton(),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.menu_book_rounded,
            color: Color(0xFF2A2A2A),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Libro',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2A2A2A),
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Subscription plan!',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2A2A2A),
        height: 1.2,
        letterSpacing: -1,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'For Borrowing books you need to buy our Membership...',
      style: TextStyle(
        fontSize: 16,
        color: const Color(0xFF2A2A2A).withOpacity(0.7),
        height: 1.4,
      ),
    );
  }

  Widget _buildSubscriptionPlans() {
    return Column(
      children: [
        _buildPlanCard(
          index: 0,
          title: 'Silver',
          price: '\$200',
          duration: 'duration: 6 month',
          borrowLimit: 'borrow limit: 3books',
          isPopular: false,
        ),
        const SizedBox(height: 16),
        _buildPlanCard(
          index: 1,
          title: 'Gold',
          price: '\$300',
          duration: 'duration: 6 month',
          borrowLimit: 'borrow limit: 5books',
          isPopular: true,
        ),
        const SizedBox(height: 16),
        _buildPlanCard(
          index: 2,
          title: 'Diamond',
          price: '\$500',
          duration: 'duration: 6 month',
          borrowLimit: 'borrow limit: 10books',
          isPopular: false,
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required int index,
    required String title,
    required String price,
    required String duration,
    required String borrowLimit,
    required bool isPopular,
  }) {
    final isSelected = selectedPlan == index;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedPlan = index;
          });
          // Add haptic feedback
          // HapticFeedback.lightImpact();
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFF2C744).withOpacity(0.9),
                      const Color(0xFFF5D76E).withOpacity(0.9),
                    ],
                  )
                : null,
            color: isSelected ? null : const Color(0xFFF5E6A8).withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected 
                  ? const Color(0xFF2A2A2A).withOpacity(0.3)
                  : const Color(0xFF2A2A2A).withOpacity(0.1),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFFF2C744).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              if (isPopular)
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'POPULAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2A2A2A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          duration,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF2A2A2A).withOpacity(0.7),
                          ),
                        ),
                        Text(
                          borrowLimit,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF2A2A2A).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$price/-',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2A2A2A),
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              if (isSelected)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2A2A2A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFF2C744),
            Color(0xFFF5D76E),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF2C744).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Handle confirm action
            _showConfirmationDialog();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Slide to Confirm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A2A2A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Color(0xFF2A2A2A),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    final planNames = ['Silver', 'Gold', 'Diamond'];
    final planPrices = ['\$200', '\$300', '\$500'];
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF5E6A8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Confirm Subscription',
            style: TextStyle(
              color: Color(0xFF2A2A2A),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'You have selected the ${planNames[selectedPlan]} plan for ${planPrices[selectedPlan]}/-',
            style: TextStyle(
              color: const Color(0xFF2A2A2A).withOpacity(0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF2A2A2A)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle subscription confirmation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF2C744),
                foregroundColor: const Color(0xFF2A2A2A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}