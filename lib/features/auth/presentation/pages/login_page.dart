// lib/features/auth/presentation/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../core/constants/admin_colors.dart';
import '../../../../core/constants/admin_dimensions.dart';
import '../../../../core/constants/admin_strings.dart';
import '../../../../core/constants/admin_text_styles.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/widgets/admin_button.dart';
import '../../../../core/widgets/admin_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _onSignIn() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
      SignInRequested(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.go(RouteNames.dashboard);
        } else if (state is AuthFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AdminColors.errorBg,
            ),
          );
        } else if (state is AuthUnauthorized) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AdminStrings.unauthorized),
              backgroundColor: AdminColors.errorBg,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AdminColors.background,
        body: Center(
          child: SingleChildScrollView(
            padding: ResponsiveHelper.contentPadding(context),
            child: _LoginCard(
              formKey: _formKey,
              emailCtrl: _emailCtrl,
              passwordCtrl: _passwordCtrl,
              obscure: _obscure,
              onToggleObscure: () => setState(() => _obscure = !_obscure),
              onSignIn: _onSignIn,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Login Card ───────────────────────────────────────────────────────────────

class _LoginCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final VoidCallback onSignIn;

  const _LoginCard({
    required this.formKey,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.obscure,
    required this.onToggleObscure,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthBloc>().state is AuthLoading;
    final cardWidth = ResponsiveHelper.isMobile(context)
        ? MediaQuery.sizeOf(context).width * 0.92
        : 400.0;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(AdminDimensions.xl),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(AdminDimensions.dialogRadius),
        border: Border.all(color: AdminColors.border),
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo
            _GoldDiamond(),
            SizedBox(height: AdminDimensions.md),

            // Title
            Text(
              AdminStrings.loginTitle,
              style: AdminTextStyles.headlineMd(
                context,
              ).copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: AdminDimensions.xs),
            Text(
              'Sign in to your admin account',
              style: AdminTextStyles.bodyMdMuted(context),
            ),
            SizedBox(height: AdminDimensions.xl),

            // Email
            AdminTextField(
              controller: emailCtrl,
              hint: 'admin@wallr.app',
              label: AdminStrings.emailHint,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            SizedBox(height: AdminDimensions.md),

            // Password label row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AdminStrings.passwordHint,
                  style: AdminTextStyles.labelMd(context),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Forgot password?',
                    style: AdminTextStyles.labelMd(
                      context,
                    ).copyWith(color: AdminColors.gold),
                  ),
                ),
              ],
            ),
            SizedBox(height: AdminDimensions.sm),

            // Password
            AdminTextField(
              controller: passwordCtrl,
              hint: '••••••••',
              obscureText: obscure,
              validator: Validators.password,
              suffixIcon: GestureDetector(
                onTap: onToggleObscure,
                child: Icon(
                  obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: AdminDimensions.iconMd,
                  color: AdminColors.textTertiary,
                ),
              ),
            ),
            SizedBox(height: AdminDimensions.lg),

            // Sign In Button
            SizedBox(
              width: double.infinity,
              child: AdminButton.primary(
                label: AdminStrings.signIn,
                onTap: isLoading ? null : onSignIn,
                isLoading: isLoading,
              ),
            ),
            SizedBox(height: AdminDimensions.lg),

            Divider(color: AdminColors.border),
            SizedBox(height: AdminDimensions.md),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: AdminDimensions.iconSm,
                  color: AdminColors.textTertiary,
                ),
                SizedBox(width: AdminDimensions.xs),
                Text(
                  AdminStrings.loginSubtitle,
                  style: AdminTextStyles.bodySmMuted(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Gold Diamond Logo ────────────────────────────────────────────────────────

class _GoldDiamond extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AdminColors.gold,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: CustomPaint(size: const Size(28, 28), painter: _GemPainter()),
      ),
    );
  }
}

class _GemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AdminColors.onGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height * 0.4)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, size.height * 0.4)
      ..close();

    final top = Path()
      ..moveTo(size.width * 0.2, size.height * 0.4)
      ..lineTo(size.width / 2, size.height * 0.15)
      ..lineTo(size.width * 0.8, size.height * 0.4);

    final bottom = Path()
      ..moveTo(size.width * 0.2, size.height * 0.4)
      ..lineTo(size.width / 2, size.height * 0.65)
      ..lineTo(size.width * 0.8, size.height * 0.4);

    canvas.drawPath(path, paint);
    canvas.drawPath(top, paint..strokeWidth = 1.5);
    canvas.drawPath(bottom, paint..strokeWidth = 1.5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
