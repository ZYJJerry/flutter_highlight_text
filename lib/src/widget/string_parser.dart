import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight_text/src/util/highlight_util.dart';
import 'package:string_scanner/string_scanner.dart';

class StringParser {
  final String content;
  final String splitString;
  final TextStyle style;
  final TextStyle highLightStyle;
  final WordClickAction? wordClickAction;
  late StringScanner _scanner;
  List<SpanBean> _spans = [];

  StringParser(
      {required this.content,
        required this.splitString,
        required this.style,
        required this.highLightStyle, this.wordClickAction});

  void parseContent() {
    while (!_scanner.isDone) {
      if (_scanner.scan(RegExp("$splitString.*?$splitString"))) {
        int startIndex = _scanner.lastMatch!.start;
        int endIndex = _scanner.lastMatch!.end;
        _spans.add(SpanBean(startIndex, endIndex));
      }
      if (!_scanner.isDone) {
        _scanner.position++;
      }
    }
  }

  InlineSpan parser() {
    _scanner = StringScanner(content);
    if (splitString.isEmpty) return TextSpan(style: style, children: [TextSpan(text: content, style: style)]);
    parseContent();
    final List<TextSpan> spans = <TextSpan>[];
    int currentPosition = 0;
    for (SpanBean span in _spans) {
      if (currentPosition != span.start)
        spans.add(
            TextSpan(text: content.substring(currentPosition, span.start), style: style));
      spans.add(TextSpan(
          style: highLightStyle,
          text: span.text(content),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (wordClickAction != null) wordClickAction!(span.text(content));
            }));
      currentPosition = span.end;
    }
    if (currentPosition != content.length)
      spans.add(TextSpan(
        text: content.substring(currentPosition, content.length),
        style: style
      ));
    return TextSpan(children: spans);
  }
}

class SpanBean {
  SpanBean(this.start, this.end);

  final int start;
  final int end;

  String text(String src) {
    return src.substring(start + 1, end - 1);
  }
}