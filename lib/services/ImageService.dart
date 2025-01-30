import 'dart:math';

class ImageService {
  final List<String> _imageUrls = [
    'https://imgflip.com/s/meme/X-X-Everywhere.jpg',
    'https://i.imgflip.com/58z4ab.jpg',
    'https://i.imgflip.com/9i6tk0.jpg',
    'https://i.imgflip.com/9hxlxy.jpg',
    'https://i.imgflip.com/9gldwp.jpg',
    'https://imgflip.com/s/meme/X-X-Everywhere.jpg',

 
  ];

  String getRandomImageUrl() {
    final random = Random();
    return _imageUrls[random.nextInt(_imageUrls.length)];
  }
}