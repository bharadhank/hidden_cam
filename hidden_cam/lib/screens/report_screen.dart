import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/scan_result_model.dart';
import '../models/report_issue_model.dart';
import '../services/storage_service.dart';
import '../widgets/primary_button.dart';
import '../widgets/rounded_card.dart';
import 'report_confirmation_screen.dart';

class ReportScreen extends StatefulWidget {
  final ScanResultModel? prefillResult;

  const ReportScreen({super.key, this.prefillResult});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  ReportNoticeType _selectedType = ReportNoticeType.suspiciousDevice;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _hasPhotoAttached = true;
  bool _consentGiven = true;
  final int _maxChars = 280;

  @override
  void initState() {
    super.initState();
    if (widget.prefillResult != null) {
      _locationController.text = widget.prefillResult!.location;
      _notesController.text = widget.prefillResult!.detailsNotes ?? '';
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (!_consentGiven) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please confirm local consent before filing.'),
        ),
      );
      return;
    }

    final newReport = ReportIssueModel(
      id: 'REP-${(DateTime.now().millisecondsSinceEpoch % 10000) + 1000}',
      noticeType: _selectedType,
      location: _locationController.text.trim().isEmpty
          ? 'Hotel Suite Room 402'
          : _locationController.text.trim(),
      notes: _notesController.text.trim(),
      hasPhotoAttached: _hasPhotoAttached,
      timestamp: DateTime.now(),
      consentGiven: _consentGiven,
    );

    StorageService().saveReport(newReport);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ReportConfirmationScreen(report: newReport),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        title: const Text('Document Finding'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Confidentiality Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 20,
                      color: AppColors.naturalTeal,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Confidential & Local',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepForestGreen,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Your report remains encrypted on your device. We use this to help you log and document personal safety findings.',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section 1: Notice Type
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'What did you notice?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepForestGreen,
                    ),
                  ),
                  Text(
                    'Required',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.naturalTeal,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              ...ReportNoticeType.values.map((type) {
                final isSelected = _selectedType == type;

                IconData icon;
                switch (type) {
                  case ReportNoticeType.suspiciousDevice:
                    icon = Icons.sensors_rounded;
                    break;
                  case ReportNoticeType.unexpectedCamera:
                    icon = Icons.visibility_outlined;
                    break;
                  case ReportNoticeType.unusualObject:
                    icon = Icons.category_outlined;
                    break;
                  case ReportNoticeType.other:
                    icon = Icons.more_horiz_rounded;
                    break;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: RoundedCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: isSelected
                        ? Border.all(color: AppColors.naturalTeal, width: 1.5)
                        : null,
                    onTap: () {
                      setState(() => _selectedType = type);
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            color: isSelected
                                ? AppColors.naturalTeal
                                : AppColors.deepForestGreen,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                type.label,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.deepForestGreen,
                                ),
                              ),
                              Text(
                                type.description,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? AppColors.naturalTeal
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.naturalTeal
                                  : AppColors.outline,
                              width: 1.5,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Section 2: Location Input
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepForestGreen,
                    ),
                  ),
                  Text(
                    'Optional',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [AppColors.softShadow],
                ),
                child: TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.place_outlined,
                      size: 20,
                      color: AppColors.naturalTeal,
                    ),
                    hintText: 'e.g., Room 101, Dressing Area, Restroom',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Section 3: Notes & Details with char counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notes & Details',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepForestGreen,
                    ),
                  ),
                  Text(
                    '${_notesController.text.length} / $_maxChars',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [AppColors.softShadow],
                ),
                child: TextField(
                  controller: _notesController,
                  maxLines: 3,
                  maxLength: _maxChars,
                  onChanged: (_) => setState(() {}),
                  buildCounter: (
                    _, {
                    required currentLength,
                    required isFocused,
                    maxLength,
                  }) =>
                      null,
                  decoration: const InputDecoration(
                    hintText:
                        'Describe what you observed (blinking lens reflection, strange Bluetooth name, etc.)...',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(14),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Section 4: Attach Visual Snapshot Card
              RoundedCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.surfaceContainer,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/safelens_report_issue.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => const Icon(
                            Icons.photo_camera_rounded,
                            color: AppColors.naturalTeal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Attach visual snapshot',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.deepForestGreen,
                            ),
                          ),
                          Text(
                            'Help verify with local scan history',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _hasPhotoAttached
                            ? Icons.check_circle_rounded
                            : Icons.add_a_photo_outlined,
                        color: AppColors.naturalTeal,
                      ),
                      onPressed: () {
                        setState(() => _hasPhotoAttached = !_hasPhotoAttached);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Section 5: Consent Checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _consentGiven,
                    activeColor: AppColors.naturalTeal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onChanged: (val) {
                      setState(() => _consentGiven = val ?? false);
                    },
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'I understand this report is stored locally on this phone for personal safety records and is not sent to any cloud server.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Submit Button
              PrimaryButton(
                text: 'Submit Report',
                icon: Icons.arrow_forward_rounded,
                onPressed: _submitReport,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
