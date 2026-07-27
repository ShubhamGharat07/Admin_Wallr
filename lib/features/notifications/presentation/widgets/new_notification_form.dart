import 'package:flutter/material.dart';
import '../../../../core/constants/admin_colors.dart';
import '../../../../core/widgets/admin_button.dart';
import '../../../../core/widgets/admin_text_field.dart';
import '../../domain/entities/notification_entity.dart';
import 'notification_preview_modal.dart';
import 'target_audience_selector.dart';

class NewNotificationForm extends StatefulWidget {
  final Function(
    String title,
    String body,
    String? imageUrl,
    TargetAudience audience,
    bool schedule,
    DateTime? scheduledTime,
  ) onSend;

  const NewNotificationForm({
    super.key,
    required this.onSend,
  });

  @override
  State<NewNotificationForm> createState() => _NewNotificationFormState();
}

class _NewNotificationFormState extends State<NewNotificationForm> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _imageUrlController = TextEditingController();
  TargetAudience _selectedAudience = TargetAudience.allUsers;
  bool _scheduleNotification = false;
  DateTime? _scheduledTime;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(hours: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AdminColors.gold,
              surface: AdminColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AdminColors.gold,
                surface: AdminColors.surface,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _scheduledTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _handleSend() {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in title and body')),
      );
      return;
    }

    widget.onSend(
      _titleController.text,
      _bodyController.text,
      _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
      _selectedAudience,
      _scheduleNotification,
      _scheduledTime,
    );

    _titleController.clear();
    _bodyController.clear();
    _imageUrlController.clear();
    setState(() {
      _selectedAudience = TargetAudience.allUsers;
      _scheduleNotification = false;
      _scheduledTime = null;
    });
  }

  void _handlePreview() {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in title and body')),
      );
      return;
    }

    NotificationPreviewModal.show(
      context,
      title: _titleController.text,
      body: _bodyController.text,
      imageUrl: _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
      targetAudience: _selectedAudience,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AdminColors.surface,
        border: Border.all(color: AdminColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New Notification',
            style: TextStyle(
              color: AdminColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          TargetAudienceSelector(
            selectedAudience: _selectedAudience,
            onChanged: (audience) => setState(() => _selectedAudience = audience),
          ),
          const SizedBox(height: 24),
          AdminTextField(
            label: 'Notification Title',
            hint: 'e.g., New Exclusive Wallpapers Available!',
            controller: _titleController,
            maxLength: 65,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          AdminTextField(
            label: 'Message Body',
            hint: 'Tap to see the latest additions to the minimal collection...',
            controller: _bodyController,
            maxLength: 240,
            maxLines: 3,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          AdminTextField(
            label: 'Image URL (Optional)',
            hint: 'https://example.com/image.jpg',
            controller: _imageUrlController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),
          CheckboxListTile(
            value: _scheduleNotification,
            onChanged: (value) {
              setState(() => _scheduleNotification = value ?? false);
            },
            title: const Text('Schedule Delivery'),
            subtitle: const Text('Send notification at a specific time'),
            activeColor: AdminColors.gold,
            checkColor: AdminColors.onGold,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          if (_scheduleNotification) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AdminColors.inputSurface,
                border: Border.all(color: AdminColors.border),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _scheduledTime != null
                        ? 'Scheduled for: ${_scheduledTime!.toString().split('.')[0]}'
                        : 'Select date and time',
                    style: TextStyle(
                      color: _scheduledTime != null
                          ? AdminColors.gold
                          : AdminColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  IconButton(
                    onPressed: _selectDateTime,
                    icon: const Icon(Icons.calendar_today, size: 18),
                    color: AdminColors.gold,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: AdminButton.secondary(
                  label: 'Preview',
                  onTap: _handlePreview,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AdminButton.primary(
                  label: _scheduleNotification ? 'Schedule' : 'Send Notification',
                  onTap: _handleSend,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
