import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GuideVerificationForm extends StatefulWidget {
  final Map<String, dynamic> userData;

  const GuideVerificationForm({super.key, required this.userData});

  @override
  State<GuideVerificationForm> createState() => _GuideVerificationFormState();
}

class _GuideVerificationFormState extends State<GuideVerificationForm> {
  int _currentStep = 0;

  File? _certificateFile;
  Uint8List? _certificateBytes;
  String _certificateFileName = "";

  File? _nicFile;
  Uint8List? _nicBytes;
  String _nicFileName = "";

  bool _isSubmitting = false;

  bool get _hasExistingCertificate {
    final certificate = widget.userData['certificate'];
    return certificate != null && certificate.toString().trim().isNotEmpty;
  }

  String get _existingCertificateUrl {
    return widget.userData['certificate']?.toString() ?? "";
  }

  bool get _canContinueCertificateStep {
    return _hasExistingCertificate ||
        _certificateFile != null ||
        _certificateBytes != null;
  }

  bool get _canContinueNicStep {
    return _nicFile != null || _nicBytes != null;
  }

  Future<void> _pickCertificate() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      withData: true,
    );

    if (result != null) {
      final file = result.files.single;

      setState(() {
        _certificateFileName = file.name;
        if (kIsWeb) {
          _certificateBytes = file.bytes;
          _certificateFile = null;
        } else {
          _certificateFile = File(file.path!);
          _certificateBytes = null;
        }
      });
    }
  }

  Future<void> _pickNic() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      withData: true,
    );

    if (result != null) {
      final file = result.files.single;

      setState(() {
        _nicFileName = file.name;
        if (kIsWeb) {
          _nicBytes = file.bytes;
          _nicFile = null;
        } else {
          _nicFile = File(file.path!);
          _nicBytes = null;
        }
      });
    }
  }

  void _goNext() {
    if (_currentStep == 0 && !_canContinueCertificateStep) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload a certificate or use the existing one."),
        ),
      );
      return;
    }

    if (_currentStep == 1 && !_canContinueNicStep) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload your NIC document.")),
      );
      return;
    }

    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _submitVerification() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      // TODO:
      // connect backend API here
      // send existing certificate or new uploaded certificate
      // send NIC file
      // then update verificationStatus to pending

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Verification request submitted successfully."),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to submit verification request: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Widget _buildStepHeader() {
    return Row(
      children: [
        _stepCircle(0, "Certificate"),
        _stepLine(),
        _stepCircle(1, "NIC"),
        _stepLine(),
        _stepCircle(2, "Submit"),
      ],
    );
  }

  Widget _stepCircle(int step, String label) {
    final bool isActive = _currentStep == step;
    final bool isDone = _currentStep > step;

    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: isDone || isActive
                ? Colors.green
                : Colors.grey[300],
            child: isDone
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : Text(
                    "${step + 1}",
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? Colors.green : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepLine() {
    return Container(width: 20, height: 2, color: Colors.grey[300]);
  }

  Widget _buildCertificateStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Step 1: Guide Certificate",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "Upload your guide certificate. If you already uploaded one before, you can keep it or replace it.",
          style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
        ),
        const SizedBox(height: 20),

        if (_hasExistingCertificate)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.insert_drive_file, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Existing certificate found",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _existingCertificateUrl,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _pickCertificate,
                  icon: const Icon(Icons.upload_file),
                  label: const Text("Replace Certificate"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green),
                  ),
                ),
              ],
            ),
          )
        else
          _buildUploadBox(
            title: "Upload Guide Certificate",
            subtitle: _certificateFileName.isEmpty
                ? "Tap to upload certificate"
                : _certificateFileName,
            onTap: _pickCertificate,
          ),

        if (_certificateFileName.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildSelectedFileCard(
            title: "New certificate selected",
            fileName: _certificateFileName,
          ),
        ],
      ],
    );
  }

  Widget _buildNicStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Step 2: NIC Upload",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "Upload your NIC document for identity verification.",
          style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
        ),
        const SizedBox(height: 20),
        _buildUploadBox(
          title: "Upload NIC Document",
          subtitle: _nicFileName.isEmpty ? "Tap to upload NIC" : _nicFileName,
          onTap: _pickNic,
        ),
        if (_nicFileName.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildSelectedFileCard(title: "NIC selected", fileName: _nicFileName),
        ],
      ],
    );
  }

  Widget _buildSubmitStep() {
    final bool usingExistingCertificate =
        _hasExistingCertificate && _certificateFileName.isEmpty;

    final String certificateText = usingExistingCertificate
        ? "Using existing uploaded certificate"
        : (_certificateFileName.isNotEmpty
              ? _certificateFileName
              : "No certificate selected");

    final String nicText = _nicFileName.isNotEmpty
        ? _nicFileName
        : "No NIC selected";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Step 3: Review & Submit",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "Please review your uploaded documents before submitting the verification request.",
          style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
        ),
        const SizedBox(height: 20),
        _buildReviewCard(
          icon: Icons.badge_outlined,
          title: "Certificate",
          value: certificateText,
        ),
        const SizedBox(height: 12),
        _buildReviewCard(
          icon: Icons.credit_card,
          title: "NIC Document",
          value: nicText,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: Colors.orange),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "After submission, your request will be reviewed by the admin panel. Until approval, your status will stay pending.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUploadBox({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.grey.shade50,
        ),
        child: Column(
          children: [
            const Icon(
              Icons.cloud_upload_outlined,
              size: 34,
              color: Colors.green,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedFileCard({
    required String title,
    required String fileName,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fileName,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    final bool isLastStep = _currentStep == 2;

    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: _isSubmitting ? null : _goBack,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.green),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Back",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isSubmitting
                ? null
                : isLastStep
                ? _submitVerification
                : _goNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    isLastStep ? "Submit Request" : "Next",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStepContent() {
    if (_currentStep == 0) return _buildCertificateStep();
    if (_currentStep == 1) return _buildNicStep();
    return _buildSubmitStep();
  }

  @override
  Widget build(BuildContext context) {
    final bool isVerified = widget.userData['isVerified'] == true;
    final String verificationStatus =
        widget.userData['verificationStatus']?.toString() ?? 'not_submitted';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Guide Verification"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isVerified
              ? Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified, color: Colors.green),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Your account is already verified.",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : verificationStatus == "pending"
              ? Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.hourglass_top, color: Colors.orange),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Your verification request is pending admin review.",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStepHeader(),
                    const SizedBox(height: 28),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildCurrentStepContent(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildBottomButtons(),
                  ],
                ),
        ),
      ),
    );
  }
}
