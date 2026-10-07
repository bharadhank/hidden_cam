import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final bool isSuspicious;

  const ResultScreen({super.key, required this.isSuspicious});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: isSuspicious ? const Color(0xFFD6A84F) : const Color(0xFF4F8F89),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    isSuspicious ? Icons.priority_high : Icons.check,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                isSuspicious ? 'Possible indicator' : 'No indicators found',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: isSuspicious ? const Color(0xFFD6A84F) : const Color(0xFF23483F),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isSuspicious
                    ? 'Something may need a closer look.'
                    : 'Nothing suspicious was identified\nduring this check.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF5A716A),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              if (!isSuspicious)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE8E5DA)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            const Icon(Icons.schedule, color: Color(0xFF5A716A), size: 20),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text('Scan completed', style: TextStyle(color: Color(0xFF5A716A))),
                            ),
                            Text('Just now', style: const TextStyle(color: Color(0xFF23483F), fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFE8E5DA)),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            const Icon(Icons.radar, color: Color(0xFF5A716A), size: 20),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text('Scan method', style: TextStyle(color: Color(0xFF5A716A))),
                            ),
                            Text('Device Check', style: const TextStyle(color: Color(0xFF23483F), fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (isSuspicious)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6A84F).withValues(alpha:0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFD6A84F).withValues(alpha:0.3)),
                  ),
                  child: const Text(
                    'This result is an indicator, not proof\nof a hidden camera or device.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF23483F),
                      height: 1.4,
                    ),
                  ),
                ),
              if (!isSuspicious) const SizedBox(height: 24),
              if (!isSuspicious)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF5A716A), size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'No scan can guarantee that a space is completely free of hidden devices.',
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xFF5A716A),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: isSuspicious ? const Color(0xFFD6A84F) : const Color(0xFF4F8F89),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    isSuspicious ? 'Review Details' : 'View Safety Tips',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isSuspicious ? const Color(0xFFD6A84F) : const Color(0xFF4F8F89),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    isSuspicious ? 'Safety Steps' : 'Scan Again',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSuspicious ? const Color(0xFFD6A84F) : const Color(0xFF4F8F89),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
