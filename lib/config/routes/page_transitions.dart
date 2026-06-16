// lib/config/routes/page_transitions.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Smooth fade-through transition used for top-level route changes
/// (e.g. login ⇄ dashboard). Keeps navigation feeling polished instead
/// of the default instant/janky page swap.
CustomTransitionPage<T> fadePage<T>({
  required GoRouterState state,
  required Widget child,
  Duration duration = const Duration(milliseconds: 350),
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        child: child,
      );
    },
  );
}
