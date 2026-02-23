import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/admin/data/model/admin_dashboard_model.dart';
import 'package:gap/gap.dart';

class DashboardPipelineWidget extends StatelessWidget {
  final DashboardPipeline pipeline;

  const DashboardPipelineWidget({super.key, required this.pipeline});

  ////////////////////////////////////////////////////////////
  /// STAGE CONFIG
  ////////////////////////////////////////////////////////////

  static const List<_PipelineStageMeta> _stages = [
    _PipelineStageMeta(
      key: "APPLIED",
      label: "Applied",
      icon: Icons.inbox_outlined,
      color: Color(0xff6366F1),
    ),
    _PipelineStageMeta(
      key: "SCREENING",
      label: "Screening",
      icon: Icons.search_outlined,
      color: Color(0xff8B5CF6),
    ),
    _PipelineStageMeta(
      key: "INTERVIEW_SCHEDULED",
      label: "Interview",
      icon: Icons.event_outlined,
      color: Color(0xffF59E0B),
    ),
    _PipelineStageMeta(
      key: "OFFER_SENT",
      label: "Offer",
      icon: Icons.description_outlined,
      color: Color(0xffEC4899),
    ),
    _PipelineStageMeta(
      key: "HIRED",
      label: "Hired",
      icon: Icons.verified_rounded,
      color: Color(0xff10B981),
    ),
  ];

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xff0F172A), Color(0xff111827)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      ////////////////////////////////////////////////////////////
      /// FIXED HEIGHT FOR PERFECT CURVE
      ////////////////////////////////////////////////////////////
      child: SizedBox(
        height: 320,

        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                ////////////////////////////////////////////////////////////
                /// S CURVE CONNECTOR
                ////////////////////////////////////////////////////////////
                CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: _SCurvePainter(),
                ),

                ////////////////////////////////////////////////////////////
                /// STAGE NODES
                ////////////////////////////////////////////////////////////
                _buildNode(_stages[0], 0.08, 0.05),
                _buildNode(_stages[1], 0.78, 0.05),

                _buildNode(_stages[2], 0.78, 0.55),
                _buildNode(_stages[3], 0.08, 0.55),

                _buildNode(_stages[4], 0.43, 0.95),
              ],
            );
          },
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// NODE POSITIONER
  ////////////////////////////////////////////////////////////

  Widget _buildNode(_PipelineStageMeta stage, double x, double y) {
    final count = pipeline.stages[stage.key] ?? 0;

    return Align(
      alignment: Alignment(x * 2 - 1, y * 2 - 1),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ////////////////////////////////////////////////////////////
          /// ICON CIRCLE
          ////////////////////////////////////////////////////////////
          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              gradient: LinearGradient(
                colors: [stage.color, stage.color.withOpacity(.7)],
              ),

              boxShadow: [
                BoxShadow(color: stage.color.withOpacity(.5), blurRadius: 16),
              ],
            ),

            child: Icon(stage.icon, color: Colors.white, size: 20),
          ),

          const Gap(8),

          ////////////////////////////////////////////////////////////
          /// COUNT
          ////////////////////////////////////////////////////////////
          Text(
            _format(count),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),

          ////////////////////////////////////////////////////////////
          /// LABEL
          ////////////////////////////////////////////////////////////
          Text(
            stage.label,
            style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(.7)),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// NUMBER FORMAT
  ////////////////////////////////////////////////////////////

  String _format(int number) {
    if (number >= 1000000) {
      return "${(number / 1000000).toStringAsFixed(1)}M";
    }

    if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(1)}K";
    }

    return number.toString();
  }
}

////////////////////////////////////////////////////////////
/// S CURVE PAINTER
////////////////////////////////////////////////////////////

class _SCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(.25)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    ////////////////////////////////////////////////////////////
    /// YOUR NODE POSITIONS (MATCH YOUR _buildNode)
    ////////////////////////////////////////////////////////////

    final p1 = Offset(size.width * 0.08, size.height * 0.05);
    final p2 = Offset(size.width * 0.78, size.height * 0.05);
    final p3 = Offset(size.width * 0.78, size.height * 0.55);
    final p4 = Offset(size.width * 0.08, size.height * 0.55);
    final p5 = Offset(size.width * 0.43, size.height * 0.95);

    ////////////////////////////////////////////////////////////
    /// START FROM NODE 1
    ////////////////////////////////////////////////////////////

    path.moveTo(p1.dx, p1.dy);

    ////////////////////////////////////////////////////////////
    /// 1 → 2 STRAIGHT LINE
    ////////////////////////////////////////////////////////////

    path.lineTo(p2.dx, p2.dy);

    ////////////////////////////////////////////////////////////
    /// 2 → 3 SEMICIRCLE CURVE (RIGHT SIDE DOWN)
    ////////////////////////////////////////////////////////////

    path.arcToPoint(
      p3,
      radius: Radius.circular(size.width * 0.35),
      clockwise: true,
    );

    ////////////////////////////////////////////////////////////
    /// 3 → 4 STRAIGHT LINE
    ////////////////////////////////////////////////////////////

    path.lineTo(p4.dx, p4.dy);

    ////////////////////////////////////////////////////////////
    /// 4 → 5 CURVE START → STRAIGHT END
    ////////////////////////////////////////////////////////////

    final controlPoint = Offset(
      size.width * 0.08, // start vertical
      size.height * 0.80, // curve depth
    );

    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, p5.dx, p5.dy);

    ////////////////////////////////////////////////////////////
    /// DRAW
    ////////////////////////////////////////////////////////////

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

////////////////////////////////////////////////////////////
/// META CLASS
////////////////////////////////////////////////////////////

class _PipelineStageMeta {
  final String key;
  final String label;
  final IconData icon;
  final Color color;

  const _PipelineStageMeta({
    required this.key,
    required this.label,
    required this.icon,
    required this.color,
  });
}
