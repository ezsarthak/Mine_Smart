// filename: lib/presentation/pages/ai_summary/ai_summary_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../controllers/ai_summary_controller.dart';
import '../../../core/theme/app_theme.dart';

class AISummaryPage extends StatelessWidget {
  AISummaryPage({super.key});

  final AISummaryController _controller = Get.put(AISummaryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _controller.regenerateReport();
                  await Future.delayed(const Duration(seconds: 1));
                },
                color: AppTheme.accentColor,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(context),
                            const SizedBox(height: 24),
                            _buildStatistics(context),
                            const SizedBox(height: 24),
                            _buildActionButtons(context),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                    _buildInsightsList(context),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.accentColor),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 12),
          Icon(Icons.auto_awesome, color: AppTheme.accentColor, size: 28)
              .animate(onPlay: (controller) => controller.repeat())
              .rotate(duration: 3000.ms),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Insights',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Daily Summary Report',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppTheme.accentColor),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.accentColor),
            onPressed: _controller.regenerateReport,
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2, end: 0);
  }

  Widget _buildHeader(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.accentColor.withOpacity(0.2), AppTheme.cardColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.accentColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppTheme.accentColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _controller.reportDate.value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.successColor,
                            AppTheme.successColor.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.successColor.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 14,
                              )
                              .animate(
                                onPlay: (controller) => controller.repeat(),
                              )
                              .rotate(duration: 2000.ms),
                          const SizedBox(width: 6),
                          const Text(
                            'AI GENERATED',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(
                      duration: 2000.ms,
                      color: AppTheme.successColor.withOpacity(0.3),
                    ),
              ],
            ),
            if (_controller.isGenerating.value) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _controller.generationProgress.value,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  color: AppTheme.accentColor,
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Generating insights...',
                style: TextStyle(
                  color: AppTheme.accentColor,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatistics(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: _buildStatBox(
              'Total',
              _controller.totalInsights.value.toString(),
              Icons.list_alt,
              AppTheme.accentColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatBox(
              'Critical',
              _controller.criticalInsights.value.toString(),
              Icons.priority_high,
              AppTheme.errorColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatBox(
              'Positive',
              _controller.positiveInsights.value.toString(),
              Icons.trending_up,
              AppTheme.successColor,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatBox(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2000.ms, color: color.withOpacity(0.3)),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: color.withOpacity(0.8), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => ElevatedButton.icon(
              onPressed: _controller.isPlayingVoice.value
                  ? _controller.stopVoicePlayback
                  : _controller.playVoiceSummary,
              icon: Icon(
                _controller.isPlayingVoice.value ? Icons.stop : Icons.volume_up,
              ),
              label: Text(_controller.isPlayingVoice.value ? 'Stop' : 'Voice'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _controller.isPlayingVoice.value
                    ? AppTheme.errorColor
                    : AppTheme.accentColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _controller.downloadPDF,
            icon: const Icon(Icons.download),
            label: const Text('PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildInsightsList(BuildContext context) {
    return Obx(
      () => SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final category = _controller.insights[index];
          return _buildCategorySection(category, index);
        }, childCount: _controller.insights.length),
      ),
    );
  }

  Widget _buildCategorySection(InsightCategory category, int categoryIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
                children: [
                  Text(category.icon, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Text(
                    category.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
              .animate()
              .fadeIn(delay: (250 + categoryIndex * 50).ms)
              .slideX(begin: -0.1, end: 0),
          const SizedBox(height: 12),
          ...category.items.asMap().entries.map((entry) {
            final itemIndex = entry.key;
            final item = entry.value;
            return _buildInsightCard(item, categoryIndex, itemIndex);
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInsightCard(InsightItem item, int categoryIndex, int itemIndex) {
    final priorityColor = _getPriorityColor(item.priority);
    final trendIcon = _getTrendIcon(item.trend);
    final trendColor = _getTrendColor(item.trend);

    return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [priorityColor.withOpacity(0.1), AppTheme.cardColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: item.priority == PriorityLevel.critical
                  ? priorityColor
                  : priorityColor.withOpacity(0.3),
              width: item.priority == PriorityLevel.critical ? 2 : 1,
            ),
            boxShadow: item.priority == PriorityLevel.critical
                ? [
                    BoxShadow(
                      color: priorityColor.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(item.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.description,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: trendColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: trendColor),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(trendIcon, color: trendColor, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              item.value,
                              style: TextStyle(
                                color: trendColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _controller.getRelativeTime(item.timestamp),
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (item.priority == PriorityLevel.critical) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.errorColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                            Icons.priority_high,
                            color: AppTheme.errorColor,
                            size: 20,
                          )
                          .animate(onPlay: (controller) => controller.repeat())
                          .shake(duration: 1000.ms),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Immediate attention required',
                          style: TextStyle(
                            color: AppTheme.errorColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        )
        .animate(
          onPlay: (controller) => item.priority == PriorityLevel.critical
              ? controller.repeat()
              : null,
        )
        .fadeIn(duration: 1000.ms)
        .then()
        .fadeOut(duration: 1000.ms)
        .animate()
        .fadeIn(delay: (300 + categoryIndex * 50 + itemIndex * 50).ms)
        .slideX(begin: 0.2, end: 0);
  }

  Color _getPriorityColor(PriorityLevel priority) {
    switch (priority) {
      case PriorityLevel.normal:
        return AppTheme.accentColor;
      case PriorityLevel.high:
        return AppTheme.warningColor;
      case PriorityLevel.critical:
        return AppTheme.errorColor;
    }
  }

  IconData _getTrendIcon(TrendType trend) {
    switch (trend) {
      case TrendType.positive:
        return Icons.trending_up;
      case TrendType.negative:
        return Icons.trending_down;
      case TrendType.neutral:
        return Icons.trending_flat;
    }
  }

  Color _getTrendColor(TrendType trend) {
    switch (trend) {
      case TrendType.positive:
        return AppTheme.successColor;
      case TrendType.negative:
        return AppTheme.errorColor;
      case TrendType.neutral:
        return AppTheme.accentColor;
    }
  }
}
