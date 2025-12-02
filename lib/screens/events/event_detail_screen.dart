// event_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:portal/helper/utils.dart';
import 'package:portal/models/event_children_model.dart';
import 'package:portal/models/event_detail_model.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/screens/events/event_collaborate.dart';
import 'package:portal/screens/events/event_map_time.dart';
import 'package:portal/screens/events/event_sponsors.dart';
import 'package:provider/provider.dart';

class EventDetailScreen extends StatefulWidget {
  final List<EventChildren> childrenList;
  final EventDetail detail;
  final Function onTap;
  const EventDetailScreen({super.key, required this.detail, required this.childrenList, required this.onTap});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final staticAnchorKeyPlace = GlobalKey();
  final QuillController _controller = QuillController.basic();
  bool isNewDashboard = false;

  @override
  void initState() {
    super.initState();
    print('widget.detail.description :${widget.detail.description}');
    if (widget.detail.description.toString().startsWith('[')) {
      isNewDashboard = true;
    } else {
      isNewDashboard = false;
    }
    if (isNewDashboard) {
      _controller.document =
          Document.fromJson(isNewDashboard ? widget.detail.description : '[{"attributes":{"bold":true},"insert":"Телевизийн хамгийн}]');
      _controller.readOnly = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextStyle getStyle(var attribute) {
    Attribute attr = attribute as Attribute;
    if (attr.key == 'color') {
      if (attr.value.toString().contains('#')) {
        Color color = Utils.hexToColor(attr.value.toString());
        return TextStyle(color: color);
      } else {
        return TextStyle(color: Utils.parseNamedColor(attr.value.toString()));
      }
    }

    return TextStyle(color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return Container(
      color: Colors.transparent,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        // padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 160,
            ),
            EventMapTime(
                eventDetail: widget.detail,
                childrenList: widget.childrenList,
                onTap: (val) {
                  widget.onTap(val);
                }),
            const SizedBox(height: 24),
            EventCollaborate(
              eventDetail: widget.detail,
            ),
            const SizedBox(height: 24),
            EventSponsor(
              eventDetail: widget.detail,
            ),
            const SizedBox(height: 12),
            isNewDashboard
                ? IgnorePointer(
                    ignoring: true,
                    child: QuillEditor.basic(
                      controller: _controller,
                      config: QuillEditorConfig(
                        scrollPhysics: const NeverScrollableScrollPhysics(),
                        scrollable: false,
                        customStyleBuilder: getStyle,
                      ),
                    ))
                : html.Html(shrinkWrap: true, anchorKey: staticAnchorKeyPlace, data: widget.detail.description ?? "", style: {
                    'body': html.Style(
                        padding: html.HtmlPaddings.zero,
                        margin: html.Margins.zero,
                        textAlign: TextAlign.justify,
                        color: theme.colorScheme.whiteColor),
                    'p': html.Style(color: theme.colorScheme.whiteColor),
                  }),
            const SizedBox(height: 120)
          ],
        ),
      ),
    );
  }
}
