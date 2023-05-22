import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webtoon_app/services/api_service.dart';
import 'package:webtoon_app/widgets/episode_widget.dart';

import '../models/webtoon_detail_model.dart';
import '../models/webtoon_episode_model.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  final String thumb;
  final String id;


  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;

  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likeToons = prefs.getStringList('likeToons');
    if (likeToons != null) {
      if (likeToons.contains(widget.id) == true) {
        setState(() {
          isLiked = true;
        });
      }
    } else {
      await prefs.setStringList('likeToons', []);
    }
  }

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
    initPrefs();
  }

  onHeartTap() async {
    final likeToons = prefs.getStringList('likeToons');

    if (likeToons != null) {
      if (isLiked) {
        likeToons.remove(widget.id);
      } else {
        likeToons.add(widget.id);
      }
      await prefs.setStringList('likeToons', likeToons);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 2,
          foregroundColor: Colors.cyan,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: onHeartTap,
              icon: Icon(isLiked ? Icons.favorite : Icons.favorite_outline,),
            )
          ],
          title: Text(widget.title,
            style: const TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
                    child: Container(
                        width: 250,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 15,
                                offset: const Offset(10, 10),
                                color: Colors.black.withOpacity(0.5),
                              )
                            ]
                        ),
                        child: loadImage()
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: webtoon,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data!.about,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text('${snapshot.data!.genre} / ${snapshot.data!.age}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(
                height: 50,
              ),
              FutureBuilder(
                  future: episodes,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          const Column(
                            children: [
                              Text(
                                '에피소드',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                          for (var episode in snapshot.data!)
                            Episode(
                              episode: episode,
                              webtonId: widget.id,
                            )
                        ],
                      );
                    }
                    return const CircularProgressIndicator();
                  }
              )
            ],
          ),
        ),
      ),
    );
  }

  Image loadImage() {
    return Image.network(widget.thumb,
      headers: const {
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
      },
    );
  }
}

