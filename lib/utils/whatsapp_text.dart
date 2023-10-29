import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextSeparator {
  final _urlRegex = RegExp(
    r"^((?:.|\n)*?)((?:https?):\/\/[^\s/$.?#].[^\s]*)",
    caseSensitive: false,
  );

  final _emailRegex = RegExp(
      r"^((?:.|\n)*?)((mailto:)?[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4})",
      caseSensitive: false);

  final _numberRegex =
      RegExp(r"^((?:.|\n)*?)([0-9]{10,12})", caseSensitive: false);

  final _boldRegex = RegExp(r"^((?:.|\n)*?)(\*.*?\*)", caseSensitive: false);

  final _italicRegex = RegExp(r"^((?:.|\n)*?)(\_.*?\_)", caseSensitive: false);

  final _lineThroughRegex =
      RegExp(r"^((?:.|\n)*?)(\~.*?\~)", caseSensitive: false);

  List<TextType> separateText(String sampleString) {
    List<TextType> list = [];
    do {
      var regexMatch = _urlRegex.firstMatch(sampleString);
      if (regexMatch != null) {
        sampleString = _divideStringAddList(
            sampleString, regexMatch, TextTypeEnum.link, list);
      } else {
        //other slab will be st to sampleString.length
        var regexMatch = _emailRegex.firstMatch(sampleString);
        if (regexMatch != null) {
          sampleString = _divideStringAddList(
              sampleString, regexMatch, TextTypeEnum.email, list);
        } else {
          var regexMatch = _numberRegex.firstMatch(sampleString);
          if (regexMatch != null) {
            sampleString = _divideStringAddList(
                sampleString, regexMatch, TextTypeEnum.phone, list);
          } else {
            var regexMatch = _boldRegex.firstMatch(sampleString);
            if (regexMatch != null) {
              sampleString = _divideStringAddList(
                  sampleString, regexMatch, TextTypeEnum.bold, list);
            } else {
              var regexMatch = _italicRegex.firstMatch(sampleString);
              if (regexMatch != null) {
                sampleString = _divideStringAddList(
                    sampleString, regexMatch, TextTypeEnum.italic, list);
              } else {
                var regexMatch = _lineThroughRegex.firstMatch(sampleString);
                if (regexMatch != null) {
                  sampleString = _divideStringAddList(
                      sampleString, regexMatch, TextTypeEnum.lineThrough, list);
                } else {
                  list.add(TextType(
                      text: sampleString.substring(0),
                      textTypeEnum: TextTypeEnum.text));
                  sampleString = '';
                }
              }
            }
          }
        }
      }
    } while (sampleString.isNotEmpty);
    return list;
  }

  String _divideStringAddList(String sampleString, RegExpMatch regexMatch,
      TextTypeEnum TextTypeEnum, List<TextType> list) {
    var startIndex = sampleString.indexOf(regexMatch.group(2)!);
    var endIndex = startIndex + regexMatch.group(2)!.length;
    if (startIndex > 0) {
      //first simple regex will start from st to regexMatch.start
      list.addAll(separateText(sampleString.substring(0, startIndex)));
    }

    // regexMatch.start to regexMatch.end will be the url regex
    list.add(TextType(
        text: sampleString.substring(startIndex, endIndex),
        textTypeEnum: TextTypeEnum));
    sampleString = sampleString.substring(endIndex);
    return sampleString;
  }
}

/// Callback clicked link
typedef LinkClickCallbackCallback = Function(TextType textType);

class WhatsAppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final TextStyle? textStyle;
  final LinkClickCallbackCallback? onLinkClick;

  final TextSeparator _textSeparator = TextSeparator();
  WhatsAppText(
      {Key? key,
      required this.text,
      this.fontSize,
      this.textStyle,
      this.onLinkClick})
      : super(key: key);

  TextSpan genrateTextSpanByTextType(TextType textType, BuildContext context) {
    switch (textType.textTypeEnum) {
      case TextTypeEnum.link:
        return TextSpan(
            text: textType.text,
            recognizer: TapGestureRecognizer()
              ..onTap = () => onLinkClick!(textType),
            style: textStyle!.copyWith(
                fontSize: fontSize,
                color: Colors.blue,
                decoration: TextDecoration.underline));

      case TextTypeEnum.email:
        return TextSpan(
            text: textType.text,
            recognizer: TapGestureRecognizer()
              ..onTap = () => onLinkClick!(textType),
            style: textStyle!.copyWith(
                fontSize: fontSize,
                color: Colors.blue,
                decoration: TextDecoration.underline));

      case TextTypeEnum.phone:
        return TextSpan(
            text: textType.text,
            recognizer: TapGestureRecognizer()
              ..onTap = () => onLinkClick!(textType),
            style: textStyle!.copyWith(fontSize: fontSize, color: Colors.blue));

      case TextTypeEnum.lineThrough:
        return TextSpan(
            text: textType.text.substring(1, textType.text.length - 1),
            style: textStyle!.copyWith(
                fontSize: fontSize, decoration: TextDecoration.lineThrough));

      case TextTypeEnum.bold:
        return TextSpan(
            text: textType.text.substring(1, textType.text.length - 1),
            style: textStyle!
                .copyWith(fontSize: fontSize, fontWeight: FontWeight.bold));

      case TextTypeEnum.italic:
        return TextSpan(
            text: textType.text.substring(1, textType.text.length - 1),
            style: textStyle!
                .copyWith(fontSize: fontSize, fontStyle: FontStyle.italic));

      default:
        {
          return TextSpan(
              text: textType.text,
              style: textStyle!.copyWith(fontSize: fontSize));
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          children: _textSeparator
              .separateText(text)
              .map((t) => genrateTextSpanByTextType(t, context))
              .toList()),
    );
  }
}

enum TextTypeEnum { link, email, phone, bold, italic, lineThrough, text }

class TextType {
  String text;
  TextTypeEnum textTypeEnum;

  TextType({required this.text, required this.textTypeEnum});
}
