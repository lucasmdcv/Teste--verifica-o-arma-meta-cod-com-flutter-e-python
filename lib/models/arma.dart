class Arma {
  final String nome;
  final String status;
  final String urlImagem;
  final List<String> build;

  Arma({required this.nome, required this.status, required this.urlImagem, required this.build});

  // Factory para converter o JSON do Python em um objeto do Flutter
  factory Arma.fromJson(Map<String, dynamic> json) {
    return Arma(
      nome: json['nome'],
      status: json['status'],
      urlImagem: json['url_imagem'],
      build: List<String>.from(json['build']),
    );
  }
}
