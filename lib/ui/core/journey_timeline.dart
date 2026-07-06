import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

enum JourneyStatus { completed, active, locked }

/// A premium, reusable journey timeline node circle that supports status-specific colors,
/// pulsing glowing borders for active nodes, and an optional [nodeLabel] text
/// (e.g. a sequence number) shown instead of an icon.
class JourneyNodeCircle extends StatefulWidget {
  final JourneyStatus status;
  final IconData? icon;
  /// When non-null, renders this string (e.g. '1', '2') inside the circle
  /// instead of [icon].
  final String? nodeLabel;
  final double size;

  const JourneyNodeCircle({
    super.key,
    required this.status,
    this.icon,
    this.nodeLabel,
    this.size = 40,
  });

  @override
  State<JourneyNodeCircle> createState() => _JourneyNodeCircleState();
}

class _JourneyNodeCircleState extends State<JourneyNodeCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _pulseAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.status == JourneyStatus.active) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant JourneyNodeCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status == JourneyStatus.active) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color bg;
    Color border;
    Color contentColor;
    IconData? displayIcon;

    switch (widget.status) {
      case JourneyStatus.completed:
        bg = theme.colorScheme.tertiary.withOpacity(0.15);
        border = theme.colorScheme.tertiary;
        displayIcon = widget.nodeLabel == null ? (widget.icon ?? Icons.check) : null;
        contentColor = theme.colorScheme.tertiary;
        break;
      case JourneyStatus.active:
        bg = theme.colorScheme.primary.withOpacity(0.15);
        border = theme.colorScheme.primary;
        displayIcon = widget.nodeLabel == null ? (widget.icon ?? Icons.play_arrow) : null;
        contentColor = theme.colorScheme.primary;
        break;
      case JourneyStatus.locked:
        bg = theme.colorScheme.onSurface.withOpacity(0.05);
        border = theme.colorScheme.onSurface.withOpacity(0.15);
        // Locked always shows the lock icon regardless of nodeLabel
        displayIcon = Icons.lock_outline;
        contentColor = theme.colorScheme.onSurface.withOpacity(0.3);
        break;
    }

    // Inner content: number label takes priority over icon
    final Widget innerChild = widget.nodeLabel != null && widget.status != JourneyStatus.locked
        ? Text(
            widget.nodeLabel!,
            style: TextStyle(
              fontSize: widget.size * 0.38,
              fontWeight: FontWeight.w800,
              color: contentColor,
              height: 1,
            ),
          )
        : Icon(
            displayIcon!,
            size: widget.size * 0.5,
            color: contentColor,
          );

    Widget circleWidget = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: border, width: 2),
      ),
      child: Center(child: innerChild),
    );

    if (widget.status == JourneyStatus.active) {
      return AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: border.withOpacity(0.4),
                  blurRadius: _pulseAnimation.value,
                  spreadRadius: _pulseAnimation.value * 0.5,
                ),
              ],
            ),
            child: child,
          );
        },
        child: circleWidget,
      );
    }

    return circleWidget;
  }
}

/// A wrapper layout item that connects a JourneyNodeCircle to vertical path lines using timeline_tile.
class JourneyTimelineItem extends StatelessWidget {
  final JourneyStatus status;
  final bool isFirst;
  final bool isLast;
  final JourneyStatus? nextStatus;
  final IconData? icon;
  /// Optional sequence number to show inside the node circle instead of [icon].
  final String? nodeLabel;
  final Widget content;
  final double nodeSize;

  const JourneyTimelineItem({
    super.key,
    required this.status,
    required this.content,
    this.isFirst = false,
    this.isLast = false,
    this.nextStatus,
    this.icon,
    this.nodeLabel,
    this.nodeSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completedColor = theme.colorScheme.tertiary;
    final activeColor = theme.colorScheme.primary;
    final lockedColor = theme.colorScheme.onSurface.withOpacity(0.2);

    Color beforeLineColor;
    Color afterLineColor;

    if (isFirst) {
      beforeLineColor = Colors.transparent;
    } else {
      beforeLineColor = status == JourneyStatus.completed
          ? completedColor
          : (status == JourneyStatus.active ? activeColor : lockedColor);
    }

    if (isLast) {
      afterLineColor = Colors.transparent;
    } else {
      final next = nextStatus ?? JourneyStatus.locked;
      afterLineColor = (status == JourneyStatus.completed && next == JourneyStatus.completed)
          ? completedColor
          : ((status == JourneyStatus.active || next == JourneyStatus.active)
              ? activeColor
              : lockedColor);
    }

    return TimelineTile(
      alignment: TimelineAlign.start,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: nodeSize,
        height: nodeSize,
        indicator: JourneyNodeCircle(
          status: status,
          icon: icon,
          nodeLabel: nodeLabel,
          size: nodeSize,
        ),
      ),
      beforeLineStyle: LineStyle(
        color: beforeLineColor,
        thickness: 3,
      ),
      afterLineStyle: LineStyle(
        color: afterLineColor,
        thickness: 3,
      ),
      endChild: Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 24, top: 4),
        child: content,
      ),
    );
  }
}
