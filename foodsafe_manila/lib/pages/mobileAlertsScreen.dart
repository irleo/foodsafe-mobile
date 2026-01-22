import 'package:flutter/material.dart';

class MobileAlertsScreen extends StatefulWidget {
  const MobileAlertsScreen({super.key});

  @override
  State<MobileAlertsScreen> createState() => _MobileAlertsScreenState();
}

class _MobileAlertsScreenState extends State<MobileAlertsScreen> {
  int unreadCount = 2;

  final List<AlertItem> alerts = const [
    AlertItem(
      title: "Salmonella",
      risk: RiskLevel.high,
      message:
          "Increased cases reported in the area. Avoid raw or undercooked food.",
      location: "Barangay 123, Tondo",
      timeAgo: "2 hours ago",
      cases: "45 cases reported",
      distance: "0.5 km away",
    ),
    AlertItem(
      title: "Food Poisoning",
      risk: RiskLevel.moderate,
      message:
          "Food contamination suspected at local market. Practice food safety.",
      location: "Barangay 456, Binondo",
      timeAgo: "5 hours ago",
      cases: "12 cases reported",
      distance: "1.2 km away",
    ),
    AlertItem(
      title: "E. Coli",
      risk: RiskLevel.low,
      message:
          "Monitor symptoms. Ensure clean drinking water and proper food handling.",
      location: "Barangay 789, Sampaloc",
      timeAgo: "1 day ago",
      cases: "3 cases reported",
      distance: "2.8 km away",
    ),
    AlertItem(
      title: "Campylobacter",
      risk: RiskLevel.high,
      message: "Linked to poultry products. Cook chicken thoroughly.",
      location: "Barangay 234, Sta. Cruz",
      timeAgo: "1 day ago",
      cases: "23 cases reported",
      distance: "3.2 km away",
    ),
    AlertItem(
      title: "Norovirus",
      risk: RiskLevel.moderate,
      message:
          "Highly contagious. Wash hands frequently and avoid sharing utensils.",
      location: "Barangay 567, Quiapo",
      timeAgo: "2 days ago",
      cases: "8 cases reported",
      distance: "1.8 km away",
    ),
    AlertItem(
      title: "Listeria",
      risk: RiskLevel.moderate,
      message: "Linked to dairy products. Check refrigerator temperatures.",
      location: "Barangay 890, Ermita",
      timeAgo: "3 days ago",
      cases: "15 cases reported",
      distance: "2.1 km away",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // gray-50
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                toolbarHeight: 84, // matches pt-12 + content feel
                titleSpacing: 16,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Alerts & Notifications",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$unreadCount unread notifications",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF4B5563),
                      ), // gray-600
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () {
                        // filter action
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Filter tapped")),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6), // gray-100
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Icon(
                          Icons.filter_list_rounded,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    ),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(
                    height: 1,
                    color: const Color(0xFFE5E7EB), // gray-200 border-b
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    final item = alerts[i];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AlertCard(
                        item: item,
                        onDetails: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Details: ${item.title}")),
                          );
                        },
                      ),
                    );
                  }, childCount: alerts.length),
                ),
              ),
            ],
          ),

          // fixed bottom button (like: fixed bottom-24)
          Positioned(
            left: 16,
            right: 16,
            bottom:
                24, // adjust if your bottom nav overlaps; try 88-96 if needed
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430), // max-w-md
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB), // blue-600
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      elevation: 6,
                    ),
                    onPressed: unreadCount == 0
                        ? null
                        : () => setState(() => unreadCount = 0),
                    child: Text(
                      unreadCount == 0
                          ? "All Read"
                          : "Mark All as Read ($unreadCount)",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
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
}

/* ---------- Models ---------- */

enum RiskLevel { high, moderate, low }

class AlertItem {
  final String title;
  final RiskLevel risk;
  final String message;
  final String location;
  final String timeAgo;
  final String cases;
  final String distance;

  const AlertItem({
    required this.title,
    required this.risk,
    required this.message,
    required this.location,
    required this.timeAgo,
    required this.cases,
    required this.distance,
  });
}

/* ---------- UI Widgets ---------- */

class AlertCard extends StatelessWidget {
  final AlertItem item;
  final VoidCallback onDetails;

  const AlertCard({super.key, required this.item, required this.onDetails});

  @override
  Widget build(BuildContext context) {
    final colors = _riskColors(item.risk);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.softBorder), // ✅ uniform border
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 3),
            color: Color(0x14000000),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14), // ✅ clips accent + content
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ left accent bar (replaces Border(left: ...))
            Container(width: 4, color: colors.border),

            // content padding stays the same
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // icon bubble
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: colors.bg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.risk == RiskLevel.low
                            ? Icons.notifications_rounded
                            : Icons.warning_amber_rounded,
                        color: colors.icon,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // title + badge
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: item.risk == RiskLevel.high
                                        ? const Color(0xFF111827)
                                        : const Color(0xFF374151),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _RiskPill(level: item.risk),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Text(
                            item.message,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // location + time (2 cols)
                          Row(
                            children: [
                              Expanded(
                                child: _MetaRow(
                                  icon: Icons.location_on_outlined,
                                  text: item.location,
                                ),
                              ),
                              Expanded(
                                child: _MetaRow(
                                  icon: Icons.access_time_rounded,
                                  text: item.timeAgo,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          const Divider(height: 1, color: Color(0xFFF3F4F6)),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: Wrap(
                                  spacing: 12,
                                  children: [
                                    Text(
                                      item.cases,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                    Text(
                                      item.distance,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: onDetails,
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF2563EB),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Details",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Icon(Icons.chevron_right_rounded, size: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF6B7280)), // gray-500
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
        ),
      ],
    );
  }
}

class _RiskPill extends StatelessWidget {
  final RiskLevel level;
  const _RiskPill({required this.level});

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;
    late final String label;

    switch (level) {
      case RiskLevel.high:
        bg = const Color(0xFFFEE2E2); // red-100
        fg = const Color(0xFFB91C1C); // red-700
        label = "High Risk";
        break;
      case RiskLevel.moderate:
        bg = const Color(0xFFFEF3C7); // yellow-100
        fg = const Color(0xFFB45309); // yellow-700-ish
        label = "Moderate Risk";
        break;
      case RiskLevel.low:
        bg = const Color(0xFFDCFCE7); // green-100
        fg = const Color(0xFF15803D); // green-700
        label = "Low Risk";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _RiskColors {
  final Color border;
  final Color softBorder;
  final Color bg;
  final Color icon;

  const _RiskColors({
    required this.border,
    required this.softBorder,
    required this.bg,
    required this.icon,
  });
}

_RiskColors _riskColors(RiskLevel level) {
  switch (level) {
    case RiskLevel.high:
      return const _RiskColors(
        border: Color(0xFFFCA5A5), // red-300-ish
        softBorder: Color(0xFFFECACA), // red-200
        bg: Color(0xFFFEE2E2), // red-100
        icon: Color(0xFFDC2626), // red-600
      );
    case RiskLevel.moderate:
      return const _RiskColors(
        border: Color(0xFFFCD34D), // yellow-300-ish
        softBorder: Color(0xFFFDE68A), // yellow-200
        bg: Color(0xFFFEF3C7), // yellow-100
        icon: Color(0xFFD97706), // yellow-600
      );
    case RiskLevel.low:
      return const _RiskColors(
        border: Color(0xFFD1D5DB), // gray-300
        softBorder: Color(0xFFF3F4F6), // gray-100
        bg: Color(0xFFDCFCE7), // green-100
        icon: Color(0xFF16A34A), // green-600
      );
  }
}
