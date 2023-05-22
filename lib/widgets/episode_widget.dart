import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/webtoon_episode_model.dart';

class Episode extends StatelessWidget {
  const Episode({
    Key? key,
    required this.episode,
    required this.webtonId,
  }) : super(key: key);

  final WebtoonEpisodeModel episode;
  final String webtonId;

  onButtonTap() async {
    final String url = 'https://comic.naver.com/webtoon/detail?titleId=${webtonId}&no=${episode.id}';
    await launchUrlString(url);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonTap,
      child: Container(
        decoration: BoxDecoration(
          //color: Colors.cyanAccent.shade700,
          border: Border.symmetric(
            horizontal: BorderSide(
              color: Colors.grey.shade400,
              width: 0.5,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(episode.thumb,
                width: 80,
                height: 50,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                width: 220,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(episode.title.length > 17 ? '${episode.title.substring(0, 17)}...' : episode.title,
                        style: TextStyle(
                          color: Colors.cyan.shade900,
                          fontSize: 16,
                        )
                    ),
                    Icon((Icons.chevron_right_outlined),
                      color: Colors.cyan.shade900,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}