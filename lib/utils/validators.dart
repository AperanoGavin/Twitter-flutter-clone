bool isValidUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri != null && uri.hasAbsolutePath && (uri.scheme == 'http' || uri.scheme == 'https')) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif'];
    return imageExtensions.any((ext) => uri.path.endsWith(ext));
  }
  return false;
}