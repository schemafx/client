import 'package:flutter_riverpod/flutter_riverpod.dart';

class RedirectUrlNotifier extends Notifier<Uri?> {
  @override
  Uri? build() => null;

  void set(Uri? url) {
    state = url;
  }

  void clear() {
    state = null;
  }
}

final redirectUrlProvider = NotifierProvider<RedirectUrlNotifier, Uri?>(
  RedirectUrlNotifier.new,
);
