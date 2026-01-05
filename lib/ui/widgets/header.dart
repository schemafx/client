import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Reusable header scaffold that shows a logo + app name and the provided body.
class AppHeader extends StatelessWidget {
  final Widget child;
  final String title;

  const AppHeader({super.key, required this.child, this.title = 'SchemaFX'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            final segments = GoRouter.of(context).state.uri.pathSegments;
            if (segments.isEmpty || segments.length == 1) {
              context.go('/');
              return;
            }

            context.go(
              '/${segments.sublist(0, segments.length - 1).join('/')}',
            );
          },
          child: Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/icons/Icon-32.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 8),
              Text(title),
            ],
          ),
        ),
        centerTitle: false,
      ),
      body: child,
    );
  }
}
