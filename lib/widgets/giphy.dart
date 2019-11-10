import 'dart:math';

import 'package:giphy_client/giphy_client.dart';

giphy() async {
  final GiphyClient client =
      new GiphyClient(apiKey: 'ld3KZO5fFhCj5beHTMJ3NcrmBy8nIuNm');
  final GiphyCollection gifs = await client.trending();

  var rng = new Random();
  // Fetch & print a collection with options
  final nsfwGifs = await client.search(
    "loop",
    offset: rng.nextInt(30),
    limit: 30,
    rating: GiphyRating.r,
  );

  print(nsfwGifs.data.first);
  var a = nsfwGifs.data.first.images.fixedHeight;
  return a.url;
}
