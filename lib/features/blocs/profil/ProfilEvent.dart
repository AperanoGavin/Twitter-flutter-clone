
abstract class ProfilEvent  {
  const ProfilEvent();
}

class LoadProfil extends ProfilEvent {

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