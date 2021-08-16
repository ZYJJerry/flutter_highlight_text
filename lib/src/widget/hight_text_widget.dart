import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight_text/src/util/highlight_util.dart';
import 'package:flutter_highlight_text/src/util/kmp_util.dart';
import 'package:flutter_highlight_text/src/widget/string_parser.dart';

class HighLightText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final HighLightType highLightType;
  final TextStyle? highLightTextStyle;
  final List<String>? highLightWords;
  final String? splitString;
  final WordClickAction? wordClickAction;

  const HighLightText(
      {Key? key,
      required this.text,
      required this.style,
      this.highLightTextStyle,
      required this.highLightType,
      this.highLightWords,
      this.splitString,
      this.wordClickAction})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _HighLightTextState();
}

class _HighLightTextState extends State<HighLightText> {
  late InlineSpan span;
  late StringParser parser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(buildSpan());
  }

  InlineSpan buildSpan() {
    if (widget.highLightType == HighLightType.keyWords) {
      if (widget.highLightWords == null) {
        return TextSpan(children: [
          TextSpan(
            style: widget.style,
            text: widget.text,
          )
        ]);
      } else {
        return TextSpan(children: buildKeyWordsSpans());
      }
    } else {
      parser = StringParser(
        content: widget.text,
        splitString: widget.splitString ?? '',
        style: widget.style,
        highLightStyle: widget.highLightTextStyle ?? widget.style,
        wordClickAction: widget.wordClickAction,
      );
      span = parser.parser();
      return span;
    }
  }

  List<TextSpan> buildKeyWordsSpans() {
    List<TextRange> _ranges = [];
    List<TextSpan> spans = <TextSpan>[];
    widget.highLightWords!.forEach((element) {
      _ranges.addAll(KMP.kmpSearchTextRange(widget.text, element));
    });
    _ranges.sort((left, right) => left.start.compareTo(right.start));
    int currentPosition = 0;
    for (var i = 0; i < _ranges.length; i++) {
      TextRange range = _ranges[i];
      spans.add(TextSpan(
        style: widget.style,
        text: widget.text.substring(currentPosition, range.start),
      ));
      spans.add(TextSpan(
          text: widget.text.substring(range.start, range.end),
          style: widget.highLightTextStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (widget.wordClickAction != null) widget.wordClickAction!(widget.text.substring(range.start, range.end));
            }));
      currentPosition = range.end;
    }
    return spans;
  }
}

