import 'package:flutter/material.dart';

class MobileAnalyticsScreen extends StatefulWidget {
  const MobileAnalyticsScreen({super.key});

  @override
  State<MobileAnalyticsScreen> createState() => _MobileAnalyticsScreenState();
}

enum TimeRange { month, quarter, year }
enum ViewTab { trends, districts, illnesses }

class _MobileAnalyticsScreenState extends State<MobileAnalyticsScreen> {
  TimeRange _range = TimeRange.month;
  ViewTab _tab = ViewTab.trends;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // bg-gray-50
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            toolbarHeight: 92,
            titleSpacing: 16,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 8),
                Text(
                  'Analytics & Trends',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text(
                  'Disease patterns and insights',
                  style: TextStyle(fontSize: 13, color: Color(0xFF4B5563)),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () {
                    // TODO: handle download/export
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE), // blue-100
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Icon(
                      Icons.download,
                      size: 20,
                      color: Color(0xFF2563EB), // blue-600
                    ),
                  ),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(54),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: _TimeRangeChips(
                  value: _range,
                  onChanged: (v) => setState(() => _range = v),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _CurrentCasesCard(
                    cases: 110,
                    changePercent: 34.1,
                    subtitle: 'Increase from previous day',
                    onTap: () {},
                  ),
                  const SizedBox(height: 14),

                  _SegmentedTabs(
                    value: _tab,
                    onChanged: (v) => setState(() => _tab = v),
                  ),
                  const SizedBox(height: 14),

                  _ChartCard(
                    title: 'Case Trends (Last Month)',
                    child: const _ChartPlaceholder(),
                  ),
                  const SizedBox(height: 14),

                  _SectionTitle('Key Insights'),
                  const SizedBox(height: 10),

                  _InsightCard(
                    colorBg: const Color(0xFFEFF6FF), // blue-50
                    colorBorder: const Color(0xFFDBEAFE), // blue-100
                    iconBg: const Color(0xFF2563EB), // blue-600
                    icon: Icons.trending_up,
                    title: 'Highest Cases',
                    description: 'Tondo district has the highest cases (245) this month',
                  ),
                  const SizedBox(height: 10),

                  _InsightCard(
                    colorBg: const Color(0xFFF5F3FF), // purple-50
                    colorBorder: const Color(0xFFE9D5FF), // purple-100-ish
                    iconBg: const Color(0xFF7C3AED), // purple-600
                    icon: Icons.calendar_month,
                    title: 'Most Common',
                    description: 'Food Poisoning accounts for 35% of all cases',
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: const [
                      Expanded(
                        child: _StatCard(
                          label: 'Total Cases',
                          value: '889',
                          footnote: 'Last 30 days',
                          footnoteColor: Color(0xFF16A34A), // green-600
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          label: 'Avg Per Day',
                          value: '29.6',
                          footnote: 'cases/day',
                          footnoteColor: Color(0xFF6B7280), // gray-500/600
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// --- Components ---

class _TimeRangeChips extends StatelessWidget {
  final TimeRange value;
  final ValueChanged<TimeRange> onChanged;

  const _TimeRangeChips({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip('Month', TimeRange.month),
        const SizedBox(width: 8),
        _chip('Quarter', TimeRange.quarter),
        const SizedBox(width: 8),
        _chip('Year', TimeRange.year),
      ],
    );
  }

  Widget _chip(String label, TimeRange v) {
    final selected = value == v;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onChanged(v),
      labelStyle: TextStyle(
        fontSize: 13,
        color: selected ? Colors.white : const Color(0xFF374151),
        fontWeight: FontWeight.w600,
      ),
      selectedColor: const Color(0xFF2563EB),
      backgroundColor: const Color(0xFFF3F4F6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }
}

class _CurrentCasesCard extends StatelessWidget {
  final int cases;
  final double changePercent;
  final String subtitle;
  final VoidCallback onTap;

  const _CurrentCasesCard({
    required this.cases,
    required this.changePercent,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)], // blue 600->700
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              blurRadius: 14,
              offset: Offset(0, 6),
              color: Color(0x1A000000),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Cases',
                        style: TextStyle(fontSize: 13, color: Color(0xFFBFDBFE)),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$cases',
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0x33EF4444), // red-500/20
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.trending_up, size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        '${changePercent.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 13, color: Color(0xFFBFDBFE)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  final ViewTab value;
  final ValueChanged<ViewTab> onChanged;

  const _SegmentedTabs({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)), // gray-200
      ),
      child: Row(
        children: [
          _tab('Trends', ViewTab.trends),
          _tab('Districts', ViewTab.districts),
          _tab('Illnesses', ViewTab.illnesses),
        ],
      ),
    );
  }

  Widget _tab(String label, ViewTab tab) {
    final selected = value == tab;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onChanged(tab),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF2563EB) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : const Color(0xFF4B5563),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ChartCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF3F4F6)), // gray-100
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 4),
            color: Color(0x0F000000),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          SizedBox(height: 250, child: child),
        ],
      ),
    );
  }
}

class _ChartPlaceholder extends StatelessWidget {
  const _ChartPlaceholder();

  @override
  Widget build(BuildContext context) {
    // Replace this with fl_chart / syncfusion / charts_flutter later.
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Line chart goes here',
        style: TextStyle(color: Color(0xFF6B7280), fontSize: 13),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700));
  }
}

class _InsightCard extends StatelessWidget {
  final Color colorBg;
  final Color colorBorder;
  final Color iconBg;
  final IconData icon;
  final String title;
  final String description;

  const _InsightCard({
    required this.colorBg,
    required this.colorBorder,
    required this.iconBg,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String footnote;
  final Color footnoteColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.footnote,
    required this.footnoteColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563))),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(footnote, style: TextStyle(fontSize: 12, color: footnoteColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
