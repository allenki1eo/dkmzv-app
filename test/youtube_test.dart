import 'package:dkmzv_app/data/models.dart';
import 'package:dkmzv_app/data/youtube.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses watch, short, live and embed YouTube urls', () {
    expect(
      youtubeVideoId('https://www.youtube.com/watch?v=8XUYZoguhEQ'),
      '8XUYZoguhEQ',
    );
    expect(youtubeVideoId('https://youtu.be/8XUYZoguhEQ'), '8XUYZoguhEQ');
    expect(
      youtubeVideoId('https://www.youtube.com/live/8XUYZoguhEQ'),
      '8XUYZoguhEQ',
    );
    expect(
      youtubeVideoId('https://www.youtube.com/embed/8XUYZoguhEQ'),
      '8XUYZoguhEQ',
    );
    expect(
      youtubeVideoId('https://www.youtube.com/shorts/8XUYZoguhEQ'),
      '8XUYZoguhEQ',
    );
    expect(
      youtubeVideoId('https://www.youtube.com/results?search_query=KKKT+live'),
      isNull,
    );
    expect(youtubeEmbedUrl('8XUYZoguhEQ'), contains('youtube.com/embed/'));
  });

  test('the embed is wrapped in an iframe on a real origin', () {
    // Loading the embed as the top-level document is what makes YouTube
    // answer "Video player configuration error (153)". The player must be an
    // iframe inside a page served from a genuine origin.
    final html = youtubeEmbedHtml('8XUYZoguhEQ');
    expect(html, contains('<iframe'));
    expect(html, contains('https://www.youtube.com/embed/8XUYZoguhEQ'));
    expect(html, contains('origin=https://www.youtube.com'));
    expect(html, contains('playsinline=1'));
    expect(html, contains('allowfullscreen'));
    expect(youtubeEmbedBaseUrl, 'https://www.youtube.com');
  });

  test('the channel live stream is wrapped the same way', () {
    const channel = 'https://www.youtube.com/channel/UC_x5XG1OV2P6uZZ5FSM9Ttw';
    final html = youtubeChannelLiveEmbedHtml(channel);
    expect(html, isNotNull);
    expect(html, contains('<iframe'));
    expect(
      html,
      contains('embed/live_stream?channel=UC_x5XG1OV2P6uZZ5FSM9Ttw'),
    );
    expect(html, contains('origin=https://www.youtube.com'));

    // A bare handle still has no embeddable stream, so callers fall back to
    // opening YouTube rather than showing an empty player.
    expect(youtubeChannelLiveEmbedHtml('@dkmzv'), isNull);
  });

  test('v1 json without congregations still parses', () {
    final v1 = ChurchData.fromJson({
      'version': 1,
      'settings': {'adminPin': 'dkmzv', 'defaultLocale': 'sw'},
      'church': {'nameSw': 'Angaza', 'nameEn': 'Angaza'},
      'hymns': [],
      'sermons': [
        {
          'id': 's1',
          'titleSw': 'Live',
          'titleEn': 'Live',
          'mediaUrl': 'https://youtu.be/abcdefghijk',
        },
      ],
    });
    expect(v1.congregations, isEmpty);
    expect(v1.sermons.first.isLive, isFalse);
    expect(youtubeVideoId(v1.sermons.first.mediaUrl), 'abcdefghijk');
  });
}
