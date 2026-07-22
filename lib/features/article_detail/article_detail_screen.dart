import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:factshot/app/app_state.dart';
import 'package:factshot/data/models/article/article_model.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/article_meta_row/article_meta_row.dart';
import 'package:factshot/core/widgets/glass_message/glass_message.dart';
import 'package:factshot/core/widgets/glass_icon_button/glass_icon_button.dart';
import 'package:factshot/core/widgets/glass_surface/glass_surface.dart';
import 'package:factshot/core/utils/translations.dart';
import 'package:factshot/core/utils/article_translations.dart';
import 'package:factshot/core/utils/narration_service.dart';
import 'package:factshot/core/widgets/fact_listen_waveform/fact_listen_waveform.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailScreen extends StatefulWidget {
  const ArticleDetailScreen({super.key, required this.article, this.initialLanguage});

  final NewsArticle article;
  final String? initialLanguage;

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isVideoPlaying = false;
  bool _isMuted = true;
  String? _localLanguage;
  final NarrationService _narrationService = NarrationService();
  bool _isPlayerOpen = false;
  double? _draggingProgress;

  @override
  void initState() {
    super.initState();
    _localLanguage = widget.initialLanguage;
    _narrationService.addListener(_onNarrationChanged);
    if (_narrationService.currentArticleId == widget.article.id && !_narrationService.isStopped) {
      _isPlayerOpen = true;
    }
    if (widget.article.hasVideo) {
      _initVideo();
    }
  }

  void _onNarrationChanged() {
    if (mounted) {
      setState(() {});
      // Auto-mute video player if narration starts playing
      if (_narrationService.isPlaying && _videoController != null && _isVideoInitialized && !_isMuted) {
        _videoController!.setVolume(0.0);
        setState(() {
          _isMuted = true;
        });
      }
    }
  }

  Future<void> _initVideo() async {
    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.article.videoUrl!),
      );
      await _videoController!.initialize();
      _videoController!.addListener(() {
        if (mounted) {
          setState(() {
            _isVideoPlaying = _videoController!.value.isPlaying;
          });
        }
      });

      if (mounted) {
        final appState = AppState.instance;
        final autoPlay = appState?.autoplayEnabled ?? true;

        await _videoController!.setLooping(true);

        if (autoPlay) {
          await _videoController!.setVolume(0.0);
          await _videoController!.play();
          setState(() {
            _isVideoInitialized = true;
            _isVideoPlaying = true;
            _isMuted = true;
          });
        } else {
          await _videoController!.setVolume(1.0);
          setState(() {
            _isVideoInitialized = true;
            _isVideoPlaying = false;
            _isMuted = false;
          });
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isVideoInitialized = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _narrationService.removeListener(_onNarrationChanged);
    _narrationService.stop(); // Stop narration when screen is closed
    _videoController?.dispose();
    super.dispose();
  }

  Widget _buildLanguagePillSelector(String currentLang, AppState state) {
    final languages = ['English', 'Hindi', 'Both'];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: languages.map((lang) {
          final isSelected = currentLang == lang;
          final label = lang == 'English'
              ? 'EN'
              : lang == 'Hindi'
                  ? 'हिंदी'
                  : 'Both';
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                _localLanguage = lang;
              });
              GlassMessage.show(
                context,
                state.appLanguage == 'Hindi'
                    ? 'लेख की भाषा: ${lang == 'Both' ? 'दोनों' : lang == 'Hindi' ? 'हिन्दी' : 'अंग्रेजी'}'
                    : 'Article language: ${lang == 'Both' ? 'Both' : lang}',
              );
            },
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.8)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white60 : Colors.black54),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final effLang = _localLanguage ?? state.contentLanguage;
    final isBookmarked = state.isBookmarked(widget.article.id);
    final isHindiApp = state.appLanguage == 'Hindi';
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final isMobile = screenWidth < 600;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final double dockHeight = isMobile ? (50.0 + bottomSafeArea) : 60.0;
    final horizontalPadding = isTablet ? 32.0 : 20.0;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_localLanguage);
        return false;
      },
      child: Scaffold(
        backgroundColor: LiquidGlassTheme.background,
        body: Stack(
          children: [
            // Scrollable Content with Collapsible Parallax SliverAppBar
            CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverAppBar(
                  expandedHeight: 380,
                  pinned: true,
                  stretch: true,
                  backgroundColor: LiquidGlassTheme.background,
                  elevation: 0,
                  leading: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: isMobile ? 8.0 : 12.0),
                      child: GlassIconButton(
                        icon: Icons.chevron_left_rounded,
                        size: isMobile ? 36 : 44,
                        borderColor: isMobile ? Colors.transparent : null,
                        onTap: () => Navigator.of(context).pop(_localLanguage),
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const [
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground,
                    ],
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (widget.article.hasVideo && _isVideoInitialized && _videoController != null)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_videoController!.value.isPlaying) {
                                  _videoController!.pause();
                                  _isVideoPlaying = false;
                                } else {
                                  _videoController!.play();
                                  _isVideoPlaying = true;
                                }
                              });
                            },
                            child: FittedBox(
                              fit: BoxFit.cover,
                              clipBehavior: Clip.hardEdge,
                              child: SizedBox(
                                width: _videoController!.value.size.width,
                                height: _videoController!.value.size.height,
                                child: VideoPlayer(_videoController!),
                              ),
                            ),
                          )
                        else
                          Image.network(
                            widget.article.imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(color: LiquidGlassTheme.backgroundSecondary);
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(color: LiquidGlassTheme.backgroundSecondary);
                            },
                          ),

                        // Premium gradient scrim blending into background
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.55),
                                Colors.transparent,
                                LiquidGlassTheme.background.withValues(alpha: 0.7),
                                LiquidGlassTheme.background,
                              ],
                              stops: const [0.0, 0.4, 0.8, 1.0],
                            ),
                          ),
                        ),

                        // Center play icon if video is paused
                        if (widget.article.hasVideo && _isVideoInitialized && !_isVideoPlaying)
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.65),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                CupertinoIcons.play_fill,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),

                        // TOP-RIGHT CORNER: Source Badge & Video Indicator
                        Positioned(
                          top: 48,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  widget.article.hasVideo
                                      ? CupertinoIcons.videocam_fill
                                      : CupertinoIcons.news_solid,
                                  color: widget.article.hasVideo
                                      ? const Color(0xFFFF453A)
                                      : Colors.white,
                                  size: 13,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  widget.article.source.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                if (widget.article.hasVideo) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF453A),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'VIDEO',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                        // Bottom Right Mute/Unmute Control for Video
                        if (widget.article.hasVideo && _isVideoInitialized)
                          Positioned(
                            bottom: 20,
                            right: 16,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isMuted = !_isMuted;
                                  _videoController!.setVolume(_isMuted ? 0.0 : 1.0);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    width: 0.8,
                                  ),
                                ),
                                child: Icon(
                                  _isMuted ? CupertinoIcons.volume_off : CupertinoIcons.volume_up,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Main Text Details
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    20,
                    horizontalPadding,
                    140, // Generous padding to clear the floating bottom dock
                  ),
                  sliver: SliverList.list(
                    children: [
                      // Meta details row
                      ArticleMetaRow(
                        category: AppTranslations.translate(
                          context,
                          'cat_${widget.article.category.toLowerCase()}',
                        ).toUpperCase(),
                        trailingText: isHindiApp
                            ? '${widget.article.readTimeMinutes} मिनट पठन • ${widget.article.source}'
                            : '${widget.article.readTimeMinutes} min read • ${widget.article.source}',
                      ),
                      const SizedBox(height: 16),

                      // Premium Editorial Headline
                      Text(
                        widget.article.getLocalizedTitle(effLang),
                        style: LiquidGlassTheme.display.copyWith(
                          fontSize: isTablet ? 30 : 24,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Redesigned Glassmorphic Key Takeaway Card
                      GlassSurface(
                        radius: 20,
                        level: GlassLevel.strong,
                        padding: const EdgeInsets.all(20),
                        borderColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  CupertinoIcons.lightbulb_fill,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isHindiApp ? 'मुख्य बिंदु' : 'KEY TAKEAWAY',
                                  style: LiquidGlassTheme.overline.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.article.getLocalizedSummary(effLang),
                              style: LiquidGlassTheme.bodyStrong.copyWith(
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Beautifully typeset main body text
                      Text(
                        widget.article.getLocalizedBody(effLang),
                        style: LiquidGlassTheme.body.copyWith(
                          fontSize: 15,
                          height: 1.7,
                          letterSpacing: -0.1,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // "Read More" button to redirect inside app
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            HapticFeedback.mediumImpact();
                            final Uri url = Uri.parse(widget.article.sourceUrl);
                            try {
                              final success = await launchUrl(
                                url,
                                mode: LaunchMode.inAppBrowserView,
                              );
                              if (!success) {
                                if (context.mounted) {
                                  GlassMessage.show(context, isHindiApp ? 'लिंक नहीं खोला जा सका' : 'Could not launch URL');
                                }
                              }
                            } catch (e) {
                              debugPrint("Error launching URL: $e");
                              try {
                                await launchUrl(url, mode: LaunchMode.platformDefault);
                              } catch (_) {
                                if (context.mounted) {
                                  GlassMessage.show(context, isHindiApp ? 'लिंक नहीं खोला जा सका' : 'Could not launch URL');
                                }
                              }
                            }
                          },
                          child: GlassSurface(
                            radius: 12,
                            level: GlassLevel.regular,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            borderColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  CupertinoIcons.arrow_up_right_circle_fill,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isHindiApp ? 'पूरा लेख पढ़ें' : 'READ MORE AT ${widget.article.source.toUpperCase()}',
                                  style: LiquidGlassTheme.bodyStrong.copyWith(
                                    fontSize: 12,
                                    color: Theme.of(context).colorScheme.primary,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Audio Player Panel
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              left: 16,
              right: 16,
              bottom: _isPlayerOpen ? (isMobile ? (dockHeight + 12.0) : 104.0) : -200.0,
              child: _buildAudioPlayerPanel(effLang, state),
            ),

            // Premium Floating Bottom Action Dock (touches bottom on mobile)
            Positioned(
              left: isMobile ? 0 : 16,
              right: isMobile ? 0 : 16,
              bottom: isMobile ? 0 : 24,
              child: GlassSurface(
                width: isMobile ? double.infinity : null,
                height: dockHeight,
                radius: isMobile ? 0 : LiquidGlassTheme.radius28,
                borderRadius: isMobile
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      )
                    : null,
                level: GlassLevel.strong,
                padding: isMobile
                    ? EdgeInsets.fromLTRB(16, 4, 16, 4 + bottomSafeArea)
                    : const EdgeInsets.symmetric(
                        horizontal: LiquidGlassTheme.space16,
                        vertical: LiquidGlassTheme.space12,
                      ),
                child: Row(
                  children: [
                    // Inline segmented Language selector
                    _buildLanguagePillSelector(effLang, state),
                    const Spacer(),
                    // Listen Button
                    GlassIconButton(
                      icon: CupertinoIcons.headphones,
                      active: _isPlayerOpen,
                      size: isMobile ? 38 : 52,
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        setState(() {
                          _isPlayerOpen = !_isPlayerOpen;
                        });
                        if (_isPlayerOpen && _narrationService.isStopped) {
                          _startNarration(effLang);
                        }
                      },
                    ),
                    SizedBox(width: isMobile ? 6 : LiquidGlassTheme.space8),
                    // Bookmark Button
                    GlassIconButton(
                      icon: isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      active: isBookmarked,
                      size: isMobile ? 38 : 52,
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        state.toggleBookmark(widget.article.id);
                      },
                    ),
                    SizedBox(width: isMobile ? 6 : LiquidGlassTheme.space8),
                    // Share Button
                    GlassIconButton(
                      icon: Icons.ios_share_rounded,
                      size: isMobile ? 38 : 52,
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        final articleTitle = widget.article.getLocalizedTitle(effLang);
                        final articleSummary = widget.article.getLocalizedSummary(effLang);
                        final shareText = "$articleTitle\n\n$articleSummary\n\nRead more on FactShot!";
                        Share.share(shareText);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startNarration(String language) {
    final title = widget.article.getLocalizedTitle(language);
    final summary = widget.article.getLocalizedSummary(language);
    final body = widget.article.getLocalizedBody(language).replaceAll('\n', ' ');
    final fullText = "$title. $summary. $body";

    // Auto-mute video player so it doesn't clash with TTS
    if (_videoController != null && _isVideoInitialized) {
      _videoController!.setVolume(0.0);
      setState(() {
        _isMuted = true;
      });
    }

    _narrationService.speak(
      articleId: widget.article.id,
      text: fullText,
      language: language,
    );
  }

  Widget _buildAudioPlayerPanel(String effLang, AppState state) {
    final accent = Theme.of(context).colorScheme.primary;
    final isPlaying = _narrationService.isPlaying;
    final isCurrentArticle = _narrationService.currentArticleId == widget.article.id;
    final isHindiApp = state.appLanguage == 'Hindi';

    return GlassSurface(
      radius: LiquidGlassTheme.radius20,
      level: GlassLevel.strong,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      borderColor: accent.withValues(alpha: 0.15),
      child: Row(
        children: [
          if (isCurrentArticle) ...[
            // Rewind 10s button
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                _narrationService.skip(-10);
              },
              child: Icon(
                Icons.replay_10_rounded,
                color: accent,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Play/Pause button
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              if (!isCurrentArticle) {
                _startNarration(effLang);
              } else {
                if (isPlaying) {
                  _narrationService.pause();
                } else {
                  _narrationService.resume();
                }
              }
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: accent.withValues(alpha: 0.25),
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Icon(
                  isPlaying && isCurrentArticle
                      ? CupertinoIcons.pause_fill
                      : CupertinoIcons.play_fill,
                  color: accent,
                  size: 16,
                ),
              ),
            ),
          ),
          
          if (isCurrentArticle) ...[
            const SizedBox(width: 8),
            // Fast-Forward 10s button
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                _narrationService.skip(10);
              },
              child: Icon(
                Icons.forward_10_rounded,
                color: accent,
                size: 20,
              ),
            ),
          ],
          const SizedBox(width: 12),

          // Title & Progress Bar / Slider
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        isCurrentArticle
                            ? widget.article.getLocalizedTitle(effLang)
                            : (isHindiApp ? 'नया लेख चलाएं' : 'Play article narration'),
                        style: LiquidGlassTheme.bodyStrong.copyWith(
                          fontSize: 13,
                          height: 1.2,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCurrentArticle)
                      Text(
                        '${_formatDuration(_narrationService.estimatedElapsedSeconds)} / ${_formatDuration(_narrationService.estimatedDurationSeconds)}',
                        style: LiquidGlassTheme.caption.copyWith(
                          fontSize: 10,
                          color: accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                // Slider
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    activeTrackColor: accent,
                    inactiveTrackColor: (Theme.of(context).brightness == Brightness.dark)
                        ? Colors.white.withValues(alpha: 0.12)
                        : Colors.black.withValues(alpha: 0.12),
                    thumbColor: accent,
                    overlayColor: accent.withValues(alpha: 0.12),
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                    trackShape: const RectangularSliderTrackShape(),
                  ),
                  child: SizedBox(
                    height: 20,
                    child: Slider(
                      value: _draggingProgress ?? (isCurrentArticle ? _narrationService.progress : 0.0),
                      onChanged: isCurrentArticle
                          ? (val) {
                              setState(() {
                                _draggingProgress = val;
                              });
                            }
                          : null,
                      onChangeEnd: isCurrentArticle
                          ? (val) {
                              _narrationService.seek(val);
                              setState(() {
                                _draggingProgress = null;
                              });
                            }
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Compact Waveform
          FactListenWaveform(
            isPlaying: isPlaying && isCurrentArticle,
            color: accent,
            barCount: 9,
            barWidth: 2.5,
            spacing: 2.0,
          ),
          const SizedBox(width: 12),

          // Speed control chip
          _buildSpeedChip(accent),
          const SizedBox(width: 8),

          // Close button
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                _isPlayerOpen = false;
              });
              _narrationService.stop(); // Stop narration when closing panel
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Icon(
                CupertinoIcons.xmark,
                color: LiquidGlassTheme.foregroundSoft.withValues(alpha: 0.5),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedChip(Color accent) {
    final multipliers = [0.75, 1.0, 1.25, 1.5, 2.0];
    final currentMultiplier = _narrationService.speedMultiplier;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        final currentIndex = multipliers.indexOf(currentMultiplier);
        final nextIndex = (currentIndex + 1) % multipliers.length;
        _narrationService.setSpeed(multipliers[nextIndex]);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: accent.withValues(alpha: 0.2),
            width: 0.8,
          ),
        ),
        child: Text(
          '${currentMultiplier.toStringAsFixed(2).replaceAll('.00', '')}x',
          style: TextStyle(
            color: accent,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatDuration(double seconds) {
    if (seconds.isNaN || seconds.isInfinite || seconds <= 0) return '0:00';
    final duration = Duration(seconds: seconds.round());
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
