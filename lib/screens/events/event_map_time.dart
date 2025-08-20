import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:portal/components/container_transparent.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/helper/utils.dart';
import 'package:portal/models/event_children_model.dart';
import 'package:portal/models/event_detail_model.dart';
import 'package:portal/provider/theme_notifier.dart';

class EventMapTime extends StatefulWidget {
  final EventDetail eventDetail;
  final List<EventChildren> childrenList;
  final Function? onTap;
  const EventMapTime({super.key, required this.eventDetail, required this.childrenList, this.onTap});

  @override
  State<EventMapTime> createState() => _EventMapTimeState();
}

class _EventMapTimeState extends State<EventMapTime> {
  EventChildren? selectedChild;
  List<Marker> markers = [];
  LatLng? latLong;
  int endHour = 00;
  int endMin = 00;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  @override
  void initState() {
    latLong = LatLng(widget.eventDetail.location?.lat ?? 47.9181062, widget.eventDetail.location?.lng ?? 106.9171131);
    markers.add(Marker(point: latLong!, child: const Icon(Icons.location_pin, color: Colors.red)));
    startTime = widget.eventDetail.date!;
    endTime = startTime.add(Duration(hours: widget.eventDetail.eventDuration?.hour ?? 12, minutes: widget.eventDetail.eventDuration?.min ?? 00));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    bool isEnglish = Provider.of<ProviderCoreModel>(context, listen: true).isEnglish;

    return ContainerTransparent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: widget.childrenList.isNotEmpty,
            child: SizedBox(
              width: double.maxFinite,
              height: 88,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.childrenList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DateTime dateTime = DateTime.parse(widget.childrenList[index].startDate!).toLocal();
                  return InkWell(
                    onTap: () {
                      selectedChild = widget.childrenList[index];
                      widget.onTap!(widget.childrenList[index]);
                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: selectedChild == widget.childrenList[index] ? Colors.white : Colors.white.withValues(alpha: 0.15),
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                            decoration: BoxDecoration(
                              color: selectedChild == widget.childrenList[index]
                                  ? Colors.grey.withValues(alpha: 0.5)
                                  : Colors.white.withValues(alpha: 0.3),
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                            ),
                            child: Text(
                              '${dateTime.month} сар',
                              style: TextStyles.textFt12Med.textColor(
                                selectedChild == widget.childrenList[index] ? theme.colorScheme.blackColor : theme.colorScheme.hintGrey,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              dateTime.day.toString(),
                              style: TextStyles.textFt20Medium.textColor(
                                selectedChild == widget.childrenList[index] ? theme.colorScheme.blackColor : theme.colorScheme.whiteColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(Utils.weekDay(dateTime.weekday, isEnglish), style: TextStyles.textFt12Med.textColor(theme.colorScheme.weekDayColor)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Visibility(
            visible: widget.childrenList.isEmpty,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.eventDetail.date!.month}-р сар ${widget.eventDetail.date!.day}, ${Utils.weekDay(widget.eventDetail.date!.weekday, isEnglish)}',
                      style: TextStyles.textFt16Med.textColor(theme.colorScheme.whiteColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')} - ${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}',
                      style: TextStyles.textFt14Reg.textColor(theme.colorScheme.whiteColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Colors.white, thickness: 0.2),
          const SizedBox(height: 8),
          selectedChild != null && widget.childrenList.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 80,
                      child: ContainerTransparent(
                        bRadius: 12,
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Text(
                          DateFormat('HH:mm').format(DateTime.parse(selectedChild!.startDate!).toLocal()),
                          style: TextStyles.textFt20Bold.textColor(Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: Colors.white, thickness: 0.2),
                    const SizedBox(height: 8),
                  ],
                )
              : const SizedBox(),
          Visibility(
            visible: widget.childrenList.isEmpty,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.eventDetail.location?.name ?? '', style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor)),
                const SizedBox(height: 4),
                // Text(
                //   widget.eventDetail.location?.hallPlan ?? '',
                //   style: TextStyles.textFt14Reg.textColor(theme.colorScheme.whiteColor),
                //   maxLines: 1,
                // ),
                // const SizedBox(
                //   height: 4,
                // ),
              ],
            ),
          ),
          Visibility(
            visible: widget.childrenList.isNotEmpty,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.eventDetail.location?.name ?? '', style: TextStyles.textFt16Bold.textColor(theme.colorScheme.whiteColor)),
                    // const SizedBox(
                    //   height: 4,
                    // ),
                    // Text(
                    //   widget.eventDetail.location?.hallPlan ?? '',
                    //   style: TextStyles.textFt14Reg.textColor(theme.colorScheme.whiteColor),
                    //   maxLines: 1,
                    //   overflow: TextOverflow.fade,
                    // ),
                    const SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            height: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: FlutterMap(
                options: MapOptions(initialCenter: latLong!, initialZoom: 14),
                children: [
                  TileLayer(
                    urlTemplate: "https://cartodb-basemaps-a.global.ssl.fastly.net/dark_all/{z}/{x}/{y}{r}.png",
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'portal.mn.ticket',
                    retinaMode: RetinaMode.isHighDensity(context),
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
