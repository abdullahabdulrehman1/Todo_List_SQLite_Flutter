class Todomodel {
  final int? id;
  final String? title;
  final String? desc;

  Todomodel({this.id, this.title, this.desc});

  Todomodel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        desc = res['desc'];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "desc": desc,
    };
  }
}
