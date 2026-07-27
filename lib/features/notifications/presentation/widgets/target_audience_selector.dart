import 'package:flutter/material.dart';
import '../../../../core/constants/admin_colors.dart';
import '../../domain/entities/notification_entity.dart';

class TargetAudienceSelector extends StatelessWidget {
  final TargetAudience selectedAudience;
  final Function(TargetAudience) onChanged;

  const TargetAudienceSelector({
    super.key,
    required this.selectedAudience,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TARGET AUDIENCE',
          style: TextStyle(
            color: AdminColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _AudienceButton(
              label: 'All Users',
              isSelected: selectedAudience == TargetAudience.allUsers,
              onTap: () => onChanged(TargetAudience.allUsers),
            ),
            _AudienceButton(
              label: 'Premium',
              isSelected: selectedAudience == TargetAudience.premium,
              onTap: () => onChanged(TargetAudience.premium),
            ),
            _AudienceButton(
              label: 'Free',
              isSelected: selectedAudience == TargetAudience.free,
              onTap: () => onChanged(TargetAudience.free),
            ),
            _AudienceButton(
              label: 'Specific',
              isSelected: selectedAudience == TargetAudience.specific,
              onTap: () => onChanged(TargetAudience.specific),
            ),
          ],
        ),
      ],
    );
  }
}

class _AudienceButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AudienceButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AdminColors.gold : AdminColors.border,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(6),
            color: isSelected ? AdminColors.goldBg : Colors.transparent,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AdminColors.gold : AdminColors.textPrimary,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
