import 'package:flutter/material.dart';

class MobileBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MobileBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))), // gray-200
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430), // max-w-md
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  label: "Home",
                  icon: Icons.home_rounded,
                  isActive: currentIndex == 0,
                  onPressed: () => onTap(0),
                ),
                _NavItem(
                  label: "Analytics",
                  icon: Icons.bar_chart_rounded,
                  isActive: currentIndex == 1,
                  onPressed: () => onTap(1),
                ),
                _NavItem(
                  label: "Predict",
                  icon: Icons.trending_up_rounded,
                  isActive: currentIndex == 2,
                  onPressed: () => onTap(2),
                ),
                _NavItem(
                  label: "Alerts",
                  icon: Icons.notifications_rounded,
                  isActive: currentIndex == 3,
                  onPressed: () => onTap(3),
                ),
                _NavItem(
                  label: "Profile",
                  icon: Icons.person_rounded,
                  isActive: currentIndex == 4,
                  onPressed: () => onTap(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onPressed;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color(0xFF2563EB); // blue-600
    final inactiveColor = const Color(0xFF6B7280); // gray-500

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                height: 1,
                color: isActive ? activeColor : inactiveColor,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
