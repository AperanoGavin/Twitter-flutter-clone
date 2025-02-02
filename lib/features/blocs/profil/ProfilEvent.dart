
abstract class ProfilEvent  {
  const ProfilEvent();
}

class LoadProfil extends ProfilEvent {
    final String? userId;

  const LoadProfil({this.userId});


}

class UpdateProfil extends ProfilEvent {
  final String username;
  final String? description;
  final String? avatar;

  const UpdateProfil({
    required this.username,
    this.description,
    this.avatar,
  });

}