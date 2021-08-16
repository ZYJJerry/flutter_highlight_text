import 'package:flutter/cupertino.dart';

extension ExtensionString on String {
  _calculateNext(String string, List<int> next) {
    int len = string.length;
    next[0] = -1;
    int k = -1;
    for (int q = 1; q <= len - 1; q++) {
      while (k > -1 && string[k + 1] != string[q]) {
        k = next[k];
      }
      if (string[k + 1] == string[q]) {
        k = k + 1;
      }
      next[q] = k;
    }
  }

  List<TextRange> kmpSearchTextRange(String string) {
    List<TextRange> list = [];
    var m = this.length;
    var n = string.length;
    if (n > m) return list;
    List<int> next = List.filled(n, 0, growable: false);
    _calculateNext(string, next);
    int k = -1;
    for (int i = 0; i < m; i++) {
      while (k > -1 && string[k + 1] != this[i]) k = next[k];
      if (string[k + 1] == this[i]) k = k + 1;
      if (k == n - 1) {
        k = -1; //重新初始化，寻找下一个
        list.add(TextRange(start: i - n + 1, end:  i + 1));
      }
    }
    return list;
  }
}



