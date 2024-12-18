import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui' as ui;
import 'profile_image_frame_style.dart';

class ProfileImageFrame extends StatelessWidget {
  final String? imageUrl;
  final String? fallbackText;
  final ProfileImageFrameStyle style;
  final VoidCallback? onTap;
  final Widget? badge;
  final AlignmentGeometry badgeAlignment;
  final bool isLoading;

  const ProfileImageFrame({
    super.key,
    this.imageUrl,
    this.fallbackText,
    required this.style,
    this.onTap,
    this.badge,
    this.badgeAlignment = Alignment.bottomRight,
    this.isLoading = false,
  }) : assert(
          imageUrl != null || fallbackText != null,
          'Either imageUrl or fallbackText must be provided',
        );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: style.size,
      height: style.size,
      child: _buildFrame(context),
    );
  }

  Widget _buildFrame(BuildContext context) {
    Widget frame = _buildContent(context);

    // Add inner shadow if specified
    if (style.innerShadowBlur > 0 || style.innerShadowSpread > 0) {
      frame = Stack(
        children: [
          frame,
          _buildInnerShadow(),
        ],
      );
    }

    // Create blurred edge effect
    frame = Stack(
      children: [
        // Main content
        frame,
        // Blurred edge overlay
        Positioned.fill(
          child: ClipPath(
            clipper: _EdgeClipper(style.borderWidth),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: style.borderBlur,
                sigmaY: style.borderBlur,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: style.borderColor.withOpacity(0.3),
                    width: style.borderWidth,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    // Add outer glow/shadow if specified
    if (style.glowBlur > 0 || style.glowSpread > 0) {
      frame = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: style.glowColor,
              blurRadius: style.glowBlur,
              spreadRadius: style.glowSpread,
              offset: style.glowOffset,
            ),
          ],
        ),
        child: frame,
      );
    }

    // Add badge if provided
    if (badge != null) {
      frame = Stack(
        clipBehavior: Clip.none,
        children: [
          frame,
          Positioned.fill(
            child: Align(
              alignment: badgeAlignment,
              child: badge!,
            ),
          ),
        ],
      );
    }

    // Add tap handler if provided
    if (onTap != null) {
      frame = InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: frame,
      );
    }

    return frame;
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.surface,
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => _buildFallback(context),
      );
    }

    return _buildFallback(context);
  }

  Widget _buildFallback(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.primary,
      ),
      child: Center(
        child: Text(
          fallbackText?.substring(0, 1).toUpperCase() ?? '?',
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: style.size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInnerShadow() {
    return ClipPath(
      clipper: _CircleClipper(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: style.innerShadowColor.withOpacity(style.innerShadowOpacity),
              blurRadius: style.innerShadowBlur,
              spreadRadius: style.innerShadowSpread,
              offset: style.innerShadowOffset,
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ));
  }

  @override
  bool shouldReclip(_CircleClipper oldClipper) => false;
}

class _EdgeClipper extends CustomClipper<Path> {
  final double borderWidth;

  _EdgeClipper(this.borderWidth);

  @override
  Path getClip(Size size) {
    final outerPath = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ));

    final innerPath = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: (size.width / 2) - (borderWidth * 2),
      ));

    return Path.combine(PathOperation.difference, outerPath, innerPath);
  }

  @override
  bool shouldReclip(_EdgeClipper oldClipper) => borderWidth != oldClipper.borderWidth;
}
