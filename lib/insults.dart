class Insults {
  String number;
  String language;
  String insult;
  String created;
  String shown;
  String createdby;
  String active;
  String comment;

  Insults(
      {this.number,
        this.language,
        this.insult,
        this.created,
        this.shown,
        this.createdby,
        this.active,
        this.comment});

  Insults.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    language = json['language'];
    insult = json['insult'];
    created = json['created'];
    shown = json['shown'];
    createdby = json['createdby'];
    active = json['active'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['language'] = this.language;
    data['insult'] = this.insult;
    data['created'] = this.created;
    data['shown'] = this.shown;
    data['createdby'] = this.createdby;
    data['active'] = this.active;
    data['comment'] = this.comment;
    return data;
  }
}