import 'package:animate_do/animate_do.dart';
import 'package:client_app/core/utilities/responsive_utils.dart';
import 'package:client_app/features/address_book/data/models/address_book_models.dart';
// import 'package:client_app/features/address_book/presentation/pages/add_address_page.dart'; // Removed - Add Address functionality disabled
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class AddressDetailsPage extends StatelessWidget {
  final AddressBookEntry entry;

  const AddressDetailsPage({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: ResponsiveUtils.getResponsivePaddingEdgeInsets(
          context,
          const EdgeInsets.all(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 24),
            _buildContactInfoCard(context),
            const SizedBox(height: 24),
            _buildLocationCard(),
            if (entry.zipcode != null || entry.locationUrl != null) ...[
              const SizedBox(height: 24),
              _buildAdditionalInfoCard(),
            ],
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
      // floatingActionButton removed - Edit Address functionality disabled
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: FadeInDown(
        duration: const Duration(milliseconds: 400),
        child: const Text(
          'Address Details',
          style: TextStyle(
            color: Color(0xFF1a1a1a),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      centerTitle: true,
      leading: FadeInLeft(
        duration: const Duration(milliseconds: 400),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Color(0xFF1a1a1a),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667eea).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              entry.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              entry.email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoCard(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10b981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.contact_phone_rounded,
                    color: Color(0xFF10b981),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Contact Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoRow(
              Icons.phone_rounded,
              'Primary Phone',
              entry.cellphone,
              onTap: () => _copyPhoneNumber(context, entry.cellphone),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.phone_outlined,
              'Alternate Phone',
              entry.alternatePhone,
              onTap: () => _copyPhoneNumber(context, entry.alternatePhone),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.email_rounded,
              'Email Address',
              entry.email,
              onTap: () => _launchEmail(entry.email),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFf59e0b).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.location_city_rounded,
                    color: Color(0xFFf59e0b),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Location Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoRow(
              Icons.public_rounded,
              'Country',
              entry.country?.name ?? 'Oman',
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.location_city_rounded,
              'Governorate',
              entry.governorate?.enName ?? 'N/A',
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.location_on_rounded,
              'State',
              entry.state?.enName ?? 'N/A',
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.place_rounded,
              'Place',
              entry.place?.enName ?? 'N/A',
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.home_rounded,
              'Street Address',
              entry.streetAddress,
              isMultiLine: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoCard() {
    return FadeInUp(
      duration: const Duration(milliseconds: 700),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8b5cf6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.info_rounded,
                    color: Color(0xFF8b5cf6),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (entry.zipcode != null) ...[
              _buildInfoRow(
                Icons.markunread_mailbox_rounded,
                'Zip Code',
                entry.zipcode!,
              ),
              if (entry.locationUrl != null) const SizedBox(height: 16),
            ],
            if (entry.locationUrl != null)
              _buildInfoRow(
                Icons.link_rounded,
                'Location URL',
                entry.locationUrl!,
                onTap: () => _launchUrl(entry.locationUrl!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    VoidCallback? onTap,
    bool isMultiLine = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border:
              onTap != null
                  ? Border.all(
                    color: const Color(0xFF667eea).withValues(alpha: 0.3),
                  )
                  : null,
        ),
        child: Row(
          crossAxisAlignment:
              isMultiLine
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: onTap != null ? const Color(0xFF667eea) : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color:
                          onTap != null
                              ? const Color(0xFF667eea)
                              : const Color(0xFF1a1a1a),
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey[400],
              ),
          ],
        ),
      ),
    );
  }

  // _buildFloatingActionButton removed - Edit Address functionality disabled

  // _navigateToEditAddress method removed - Edit Address functionality disabled

  Future<void> _copyPhoneNumber(
    BuildContext context,
    String phoneNumber,
  ) async {
    try {
      await Clipboard.setData(ClipboardData(text: phoneNumber));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone number copied to clipboard'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to copy phone number'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
