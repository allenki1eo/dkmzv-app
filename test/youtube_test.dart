import 'package:dkmzv_app/data/models.dart';
import 'package:dkmzv_app/data/youtube.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses watch, short, live and embed YouTube urls', () {
    expect(youtubeVideoId('https://www.youtube.com/watch?v=8XUYZoguhEQ'),
        '8XUYZoguhEQ');
    expect(youtubeVideoId('https://youtu.be/8XUYZoguhEQ'), '8XUYZoguhEQ');
    expect(youtubeVideoId('https://www.youtube.com/live/8XUYZoguhEQ'),
        '8XUYZoguhEQ');
    expect(youtubeVideoId('https://www.youtube.com/embed/8XUYZoguhEQ'),
        '8XUYZoguhEQ');
    expect(youtubeVideoId('https://www.youtube.com/shorts/8XUYZoguhEQ'),
        '8XUYZoguhEQ');
    expect(
        youtubeVideoId(
            'https://www.youtube.com/results?search_query=KKKT+live'),
        isNull);
    expect(youtubeEmbedUrl('8XUYZoguhEQ'), contains('youtube-nocookie.com'));
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
        }
      ],
    });
    expect(v1.congregations, isEmpty);
    expect(v1.sermons.first.isLive, isFalse);
    expect(youtubeVideoId(v1.sermons.first.mediaUrl), 'abcdefghijk');
  });
}
