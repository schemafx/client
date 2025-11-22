import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scaffoldMessengerKeyProvider = Provider(
  (ref) => GlobalKey<ScaffoldMessengerState>(),
);

class EditorSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}

final editorSearchQueryProvider =
    NotifierProvider<EditorSearchQueryNotifier, String>(
      EditorSearchQueryNotifier.new,
    );

class DesignPagesSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}

final designPagesSearchQueryProvider =
    NotifierProvider<DesignPagesSearchQueryNotifier, String>(
      DesignPagesSearchQueryNotifier.new,
    );

class DataSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}

final dataSearchQueryProvider =
    NotifierProvider<DataSearchQueryNotifier, String>(
      DataSearchQueryNotifier.new,
    );
