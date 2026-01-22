import 'package:flutter/material.dart';

class MobilePredictionsScreen extends StatefulWidget {
  const MobilePredictionsScreen({super.key});

  @override
  State<MobilePredictionsScreen> createState() => _MobilePredictionsScreenState();
}

class _MobilePredictionsScreenState extends State<MobilePredictionsScreen> {
  bool showForecast = true;

  final List<_DistrictRisk> districts = const [
    _DistrictRisk(
      name: 'Tondo',
      level: RiskLevel.high,
      score: 82,
      estCases: 67,
      trend: '📈 increasing',
    ),
    _DistrictRisk(
      name: 'Binondo',
      level: RiskLevel.moderate,
      score: 58,
      estCases: 42,
      trend: '➡️ stable',
    ),
    _DistrictRisk(
      name: 'Sta. Cruz',
      level: RiskLevel.high,
      score: 75,
      estCases: 54,
      trend: '📈 increasing',
    ),
    _DistrictRisk(
      name: 'Sampaloc',
      level: RiskLevel.moderate,
      score: 45,
      estCases: 34,
      trend: '📉 decreasing',
    ),
    _DistrictRisk(
      name: 'San Miguel',
      level: RiskLevel.low,
      score: 28,
      estCases: 18,
      trend: '📉 decreasing',
    ),
    _DistrictRisk(
      name: 'Malate',
      level: RiskLevel.low,
      score: 22,
      estCases: 12,
      trend: '➡️ stable',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final highCount = districts.where((d) => d.level == RiskLevel.high).length;
    final avgRisk = districts.isEmpty
        ? 0
        : districts.map((d) => d.score).reduce((a, b) => a + b) / districts.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 140,
            flexibleSpace: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Predictions & History',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Risk forecasting',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 12),
                    _SegmentedToggle(
                      leftLabel: 'Forecast',
                      rightLabel: 'History',
                      isLeftSelected: showForecast,
                      onChanged: (v) => setState(() => showForecast = v),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // Stats grid
                  Row(
                    children: [
                      Expanded(
                        child: _GradientStatCard(
                          title: 'High Risk Districts',
                          value: '$highCount',
                          icon: Icons.warning_amber_rounded,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _GradientStatCard(
                          title: 'Average Risk Score',
                          value: avgRisk.toStringAsFixed(1),
                          icon: Icons.shield_outlined,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Forecast chart card (placeholder)
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Case Forecast (Next Quarter)',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Icon(Icons.calendar_month, size: 18, color: Colors.grey.shade400),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Chart placeholder\n(add fl_chart / syncfusion later)',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Predicted cases with confidence intervals',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'District Risk Predictions',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),

                  ...districts.map((d) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _DistrictRiskCard(
                          district: d,
                          onTap: () {
                            // TODO: Navigate to district details
                          },
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* -------------------- UI Pieces -------------------- */

class _SegmentedToggle extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final bool isLeftSelected;
  final ValueChanged<bool> onChanged;

  const _SegmentedToggle({
    required this.leftLabel,
    required this.rightLabel,
    required this.isLeftSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegButton(
              label: leftLabel,
              selected: isLeftSelected,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _SegButton(
              label: rightLabel,
              selected: !isLeftSelected,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SegButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.black87 : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}

class _GradientStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Gradient gradient;

  const _GradientStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const Spacer(),
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.85))),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F1F1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _DistrictRiskCard extends StatelessWidget {
  final _DistrictRisk district;
  final VoidCallback onTap;

  const _DistrictRiskCard({required this.district, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = district.level.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // icon bubble
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors.softBg,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.trending_up, color: colors.icon, size: 24),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          district.name,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.pillBg,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: colors.border),
                        ),
                        child: Text(
                          district.level.label,
                          style: TextStyle(fontSize: 11, color: colors.pillText, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 14,
                    runSpacing: 6,
                    children: [
                      Text('Score: ${district.score}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      Text('Est. ${district.estCases} cases', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      Text(district.trend, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),

                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: (district.score / 100).clamp(0, 1),
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(colors.progress),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }
}

/* -------------------- Models -------------------- */

enum RiskLevel { high, moderate, low }

extension on RiskLevel {
  String get label {
    switch (this) {
      case RiskLevel.high:
        return 'High';
      case RiskLevel.moderate:
        return 'Moderate';
      case RiskLevel.low:
        return 'Low';
    }
  }

  _RiskColors get colors {
    switch (this) {
      case RiskLevel.high:
        return const _RiskColors(
          border: Color(0xFFFECACA),
          softBg: Color(0xFFFEE2E2),
          icon: Color(0xFFDC2626),
          pillBg: Color(0xFFFEE2E2),
          pillText: Color(0xFFB91C1C),
          progress: Color(0xFFEF4444),
        );
      case RiskLevel.moderate:
        return const _RiskColors(
          border: Color(0xFFFDE68A),
          softBg: Color(0xFFFEF3C7),
          icon: Color(0xFFD97706),
          pillBg: Color(0xFFFEF3C7),
          pillText: Color(0xFFB45309),
          progress: Color(0xFFF59E0B),
        );
      case RiskLevel.low:
        return const _RiskColors(
          border: Color(0xFFBBF7D0),
          softBg: Color(0xFFDCFCE7),
          icon: Color(0xFF16A34A),
          pillBg: Color(0xFFDCFCE7),
          pillText: Color(0xFF15803D),
          progress: Color(0xFF22C55E),
        );
    }
  }
}

class _RiskColors {
  final Color border;
  final Color softBg;
  final Color icon;
  final Color pillBg;
  final Color pillText;
  final Color progress;

  const _RiskColors({
    required this.border,
    required this.softBg,
    required this.icon,
    required this.pillBg,
    required this.pillText,
    required this.progress,
  });
}

class _DistrictRisk {
  final String name;
  final RiskLevel level;
  final int score;
  final int estCases;
  final String trend;

  const _DistrictRisk({
    required this.name,
    required this.level,
    required this.score,
    required this.estCases,
    required this.trend,
  });
}
