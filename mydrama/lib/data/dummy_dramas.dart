import '../models/drama.dart';

List<Drama> initialDramas() {
  return const [
    Drama(
      id: '1',
      title: 'Bloody Flower',
      year: 2021,
      rating: 8.7,
      genre: 'Thriller',
      tags: ['18+', 'Life'],
      synopsis: 'A mystery thriller about hidden secrets inside a small city.',
      posterAsset: 'assets/images/bloody_flower.jpg',
      isFavorite: true,
      isInMyList: true,
      mainCast: ['Song Kang', 'Han So Hee'],
    ),
    Drama(
      id: '2',
      title: 'Our Universe',
      year: 2020,
      rating: 8.4,
      genre: 'Romance',
      tags: ['Life'],
      synopsis:
          'A warm romance story that starts from a simple campus friendship.',
      posterAsset: 'assets/images/our_universe.jpg',
      isFavorite: true,
      isInMyList: false,
      mainCast: ['Kim Woo Bin', 'Bae Suzy'],
    ),
    Drama(
      id: '3',
      title: 'Mouse',
      year: 2021,
      rating: 8.9,
      genre: 'Thriller',
      tags: ['Crime'],
      synopsis: 'A detective drama that follows a string of shocking murders.',
      posterAsset: 'assets/images/mouse.jpg',
      isFavorite: false,
      isInMyList: true,
      mainCast: ['Lee Seung Gi', 'Lee Hee Joon'],
    ),
    Drama(
      id: '4',
      title: 'Sweet Home',
      year: 2020,
      rating: 8.3,
      genre: 'Horror',
      tags: ['Action'],
      synopsis: 'Humans fight monsters while searching for hope and survival.',
      posterAsset: 'assets/images/sweet_home.jpg',
      isFavorite: true,
      isInMyList: true,
      mainCast: ['Song Kang', 'Lee Jin Wook'],
    ),
  ];
}
