import 'package:flutter/material.dart';

class MobileRegisterScreen extends StatefulWidget {
  const MobileRegisterScreen({super.key});

  @override
  State<MobileRegisterScreen> createState() => _MobileRegisterScreenState();
}

class _MobileRegisterScreenState extends State<MobileRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      // TODO: proceed to step 2 (e.g., Navigator.pushNamed(context, '/register-step2');)
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Continue (step 1)")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final topPad = media.padding.top;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // TOP header area
              Padding(
                padding: EdgeInsets.fromLTRB(16, topPad + 12, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white.withOpacity(0.85),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                      ),
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: const Text("Back", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 6),

                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.monitor_heart_outlined, // lucide-activity vibe
                          size: 40,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    const Center(
                      child: Text(
                        "Create Account",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Center(
                      child: Text(
                        "Register to receive health alerts in your area",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Color(0xFFBFDBFE)),
                      ),
                    ),
                    const SizedBox(height: 18),

                    const _ProgressBars(activeIndex: 0, total: 3),
                  ],
                ),
              ),

              // WHITE sheet
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Personal Information",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF111827)),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Tell us a bit about yourself",
                          style: TextStyle(fontSize: 13, color: Color(0xFF4B5563)),
                        ),
                        const SizedBox(height: 18),

                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _LabeledField(
                                label: "Full Name *",
                                child: TextFormField(
                                  controller: _nameCtrl,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    hintText: "Juan Dela Cruz",
                                    prefixIcon: Icon(Icons.person_outline),
                                  ),
                                  validator: (v) {
                                    final value = (v ?? "").trim();
                                    if (value.isEmpty) return "Full name is required.";
                                    if (value.length < 2) return "Please enter a valid name.";
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 14),

                              _LabeledField(
                                label: "Phone Number *",
                                helper: "We'll send SMS alerts to this number",
                                child: TextFormField(
                                  controller: _phoneCtrl,
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _continue(),
                                  decoration: const InputDecoration(
                                    hintText: "+63 912 345 6789",
                                    prefixIcon: Icon(Icons.phone_outlined),
                                  ),
                                  validator: (v) {
                                    final value = (v ?? "").trim();
                                    if (value.isEmpty) return "Phone number is required.";
                                    if (value.length < 8) return "Enter a valid phone number.";
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 18),

                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: _loading ? null : _continue,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2563EB),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    elevation: 0,
                                  ),
                                  child: _loading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                        )
                                      : const Text(
                                          "Continue",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                                        ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

/* -------------------- Helpers -------------------- */

class _ProgressBars extends StatelessWidget {
  final int activeIndex; // 0-based
  final int total;

  const _ProgressBars({required this.activeIndex, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final active = i == activeIndex;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i == total - 1 ? 0 : 8),
            height: 4,
            decoration: BoxDecoration(
              color: active ? Colors.white : Colors.white.withOpacity(0.30),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        );
      }),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final String? helper;
  final Widget child;

  const _LabeledField({required this.label, this.helper, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
        const SizedBox(height: 8),
        Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
              ),
            ),
          ),
          child: child,
        ),
        if (helper != null) ...[
          const SizedBox(height: 6),
          Text(helper!, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
        ],
      ],
    );
  }
}
