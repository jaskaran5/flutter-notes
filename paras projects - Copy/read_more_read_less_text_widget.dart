import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:socialcrib/app/data/common/common_logger.dart';
import 'package:socialcrib/app/data/common/util/external_launcher.dart';
import 'package:socialcrib/app/data/common/values/app_colors.dart';
import 'package:socialcrib/app/data/common/values/styles/app_fonts.dart';

class ReadMoreReadLessTextWidget extends StatelessWidget {
  final String message;
  final Function(dynamic) onChange;
  final bool isReadMore;
  final int minLines, maxLines, charCount;
  final TextStyle? style;

  const ReadMoreReadLessTextWidget({
    super.key,
    this.isReadMore = false,
    this.minLines = 5,
    this.maxLines = 15,
    this.charCount = 250,
    this.style,
    this.message = "",
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    // Regular expression to find URLs
    final RegExp urlRegExp = RegExp(
      r'(https?:\/\/[^\s]+)',
      caseSensitive: false,
    );

    // Helper function to build text spans
    List<TextSpan> buildTextSpans(String text) {
      final List<TextSpan> spans = [];
      final matches = urlRegExp.allMatches(text);
      int lastMatchEnd = 0;

      for (final match in matches) {
        if (match.start > lastMatchEnd) {
          // Add regular text before the URL
          spans.add(TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: style ?? AppFonts.madeTommyRegularDarkGray12FW400,
          ));
        }

        // Add URL with blue and underlined style
        final String url = text.substring(match.start, match.end);
        spans.add(TextSpan(
          text: url,
          style: AppFonts.hyperLinkChatStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              logConsole("Clicked URL: $url");

              launchApp(uri: url);
            },
        ));

        lastMatchEnd = match.end;
      }

      // Add remaining text after the last URL
      if (lastMatchEnd < text.length) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd),
          style: style ?? AppFonts.madeTommyRegularDarkGray12FW400,
        ));
      }

      return spans;
    }

    return SizedBox(
      child: message.trim().length < charCount
          ? InkWell(
        onTap: () {
          logConsole("Message length: ${message.length}");
        },
        child: Text.rich(
          TextSpan(
            children: buildTextSpans(message),
          ),
        ),
      )
          : isReadMore
          ? Text.rich(
        TextSpan(
          children: [
            ...buildTextSpans(
              message.substring(0, charCount),
            ),
            TextSpan(
              text: '... Read More',
              style: AppFonts.madeTommyMediumDarkGray12FW500,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  onChange(isReadMore);
                },
            ),
          ],
        ),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      )
          : Text.rich(
        TextSpan(
          children: [
            ...buildTextSpans(message),
            TextSpan(
              text: ' Read Less',
              style: AppFonts.madeTommyMediumDarkGray12FW500,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  onChange(isReadMore);
                },
            ),
          ],
        ),
      ),
    );
  }
}

