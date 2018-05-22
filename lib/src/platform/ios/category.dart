class IOSActionDetails {
  final bool foreground;
  final String id;
  final String title;

  IOSActionDetails({this.foreground = true, this.id, this.title});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'foreground': foreground,
    };
  }
}

class IOSCategoryDetails {
  final String id;
  final List<IOSActionDetails> actions;
  final List<String> intentIdentifiers;
  final bool foreground;

  IOSCategoryDetails(
      {this.id,
      this.actions = const [],
      this.intentIdentifiers = const [],
      this.foreground = true});

  Map<String, dynamic> toMap() {
     return <String, dynamic>{
      'id': id,
      'intentIdentifiers': intentIdentifiers,
      'foreground': foreground,
      'actions': actions.map((IOSActionDetails detail) => detail.toMap()).toList(),
    };
  }
}
