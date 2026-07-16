import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:factshot/app/app_state.dart';
import 'package:factshot/data/models/article/article_model.dart';
import 'package:factshot/core/theme/liquid_glass_theme.dart';
import 'package:factshot/core/widgets/article_list_tile_card/article_list_tile_card.dart';
import 'package:factshot/core/widgets/factshot_background/factshot_background.dart';
import 'package:factshot/core/widgets/glass_button/glass_button.dart';
import 'package:factshot/core/widgets/empty_state_card/empty_state_card.dart';
import 'package:factshot/core/widgets/glass_message/glass_message.dart';
import 'package:factshot/core/utils/transition_helper.dart';
import 'package:factshot/features/article_detail/article_detail_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key, required this.onNavigateToFeed});

  final VoidCallback onNavigateToFeed;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final bookmarked = mockArticles
        .where((article) => state.bookmarkedIds.contains(article.id))
        .toList();

    return Scaffold(
      body: FactShotBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(LiquidGlassTheme.space20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bookmarks', style: LiquidGlassTheme.display),
                const SizedBox(height: LiquidGlassTheme.space12),
                Text(
                  'Saved stories remain in sync across feed, detail, and this library.',
                  style: LiquidGlassTheme.body,
                ),
                const SizedBox(height: LiquidGlassTheme.space24),
                Expanded(
                  child: bookmarked.isEmpty
                      ? Center(
                          child: EmptyStateCard(
                            icon: CupertinoIcons.bookmark,
                            title: 'Your saved stack is empty.',
                            description:
                                'Bookmark from the feed or article view, then manage items here with a swipe.',
                            action: GlassButton(
                              label: 'Go to Feed',
                              isPrimary: true,
                              onTap: onNavigateToFeed,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 110),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final article = bookmarked[index];
                            return Dismissible(
                              key: ValueKey(article.id),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) {
                                state.toggleBookmark(article.id);
                                GlassMessage.show(
                                  context,
                                  'Removed "${article.title}" from bookmarks.',
                                );
                              },
                              background: const _RemoveBackground(),
                              child: ArticleListTileCard(
                                article: article,
                                onTap: () {
                                  Navigator.of(context).push(
                                    GlassPageRoute(
                                      page: ArticleDetailScreen(
                                        article: article,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: LiquidGlassTheme.space12),
                          itemCount: bookmarked.length,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RemoveBackground extends StatelessWidget {
  const _RemoveBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(LiquidGlassTheme.radius24),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            LiquidGlassTheme.error.withValues(alpha: 0.24),
          ],
        ),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: LiquidGlassTheme.space20),
      child: Text(
        'Remove',
        style: LiquidGlassTheme.bodyStrong.copyWith(color: Colors.white),
      ),
    );
  }
}
