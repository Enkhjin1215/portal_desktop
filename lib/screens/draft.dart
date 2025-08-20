// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:portal/helper/assets.dart';

// class EventSlider extends StatefulWidget {
//   const EventSlider({super.key});

//   @override
//   State<EventSlider> createState() => _EventSliderState();
// }

// class _EventSliderState extends State<EventSlider> {
//   final List<String> imagePaths = [
//     Assets.taylor,
//     Assets.bilie,
//     Assets.weekend,
//     Assets.taylor,
//     Assets.bilie,
//     // Add more image paths as needed
//   ];
//   final PageController pageController = PageController(initialPage: 0);
//   int centeredIndex = 0;

//   @override
//   void initState() {
//     pageController.addListener(setImage);

//     super.initState();
//   }

//   setImage() async {
//     centeredIndex = pageController.page?.round() ?? 0;
//     debugPrint('centeredIndex:$centeredIndex');
//     // if (centeredIndex > 0) {
//     //   _controller.text = friends[centeredIndex].phone!;
//     // } else if (centeredIndex == 0) {
//     //   _controller.text = '';
//     // }
//     // setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.maxFinite,
//       height: 300,
//       child: Center(
//         child: PageView.builder(
//           itemCount: imagePaths.length,
//           controller: pageController,
//           itemBuilder: (context, index) {
//             return imageStack(
//               index,
//               centeredIndex,
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget imageStack(int index, int centeredIndex) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Positioned(
//           left: 0,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(16),
//             child: ImageFiltered(
//               imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//               child: Image.asset(
//                 imagePaths[centeredIndex - 1 < 0 ? 0 : centeredIndex - 1],
//                 height: 130,
//                 width: 130,
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           right: 0,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(16),
//             child: ImageFiltered(
//               imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//               child: Image.asset(
//                 imagePaths[centeredIndex + 1],
//                 height: 130,
//                 width: 130,
//               ),
//             ),
//           ),
//         ),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(16),
//           child: SizedBox(
//               height: 200,
//               width: 200,
//               child: Stack(
//                 children: [
//                   ImageFiltered(
//                     imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//                     child: Image.asset(
//                       imagePaths[centeredIndex],
//                       height: 200,
//                       width: 200,
//                     ),
//                   ),
//                   Image.asset(
//                     imagePaths[centeredIndex],
//                     opacity: const AlwaysStoppedAnimation(0.7),
//                   )
//                 ],
//               )),
//         ),
//       ],
//     );
//   }
// }

//home draft
// InkWell(
//   onTap: () {
//     setState(() {
//       _isLoading = !_isLoading;
//     });
//   },
//   child: Container(
//     color: _isLoading ? Colors.green : Colors.blue,
//     width: 20,
//     height: 20,
//   ),
// ),
// SizedBox(
//     width: double.maxFinite,
//     height: 200,
//     child: Skeletonizer(
//         enabled: _isLoading,
//         child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             shrinkWrap: true,
//             itemCount: 5,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                   onTapDown: (details) {
//                     setState(() {
//                       selectedIndex = index;
//                     });
//                   },
//                   onTapUp: (details) {
//                     setState(() {
//                       selectedIndex = -1;
//                     });
//                   },
//                   child: Container(
//                     margin: EdgeInsets.all(selectedIndex == index ? 12 : 8),
//                     width: selectedIndex == index ? 95 : 100,
//                     height: selectedIndex == index ? 190 : 200,
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.network('https://i.pinimg.com/236x/73/27/b1/7327b14150f01c822e43fee62c46453f.jpg'),
//                           ),
//                         ),
//                         Text(
//                           'NYC',
//                           textAlign: TextAlign.center,
//                           style: TextStyles.textFt14Med.textColor(Colors.white),
//                         )
//                       ],
//                     ),
//                   ));
//             }))),
// const SizedBox(
//   height: 40,
// ),

// Center(
//   child: InkWell(
//       onTap: () {
//         ModalAlert().showBottomSheetDialog(
//           context: context,
//           theme: theme,
//           title: 'Hello! First bottom sheet',
//           firstButtonText: 'Hide',
//           onTap: () {
//             NavKey.navKey.currentState!.pop();
//           },
//         );
//       },
//       child: Container(
//         width: 150,
//         height: 40,
//         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//         child: const Center(
//             child: Text(
//           'Click me',
//         )),
//       )),
// ),

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:textstyle_extensions/textstyle_extensions.dart';
// import 'package:portal/components/custom_divider.dart';
// import 'package:portal/helper/constant.dart';
// import 'package:portal/helper/func.dart';
// import 'package:portal/helper/text_styles.dart';
// import 'package:portal/models/event_model.dart';
// import 'package:portal/provider/provider_core.dart';
// import 'package:portal/provider/theme_notifier.dart';
// import 'package:portal/router/route_path.dart';
// import 'package:portal/service/web_service.dart';

// class Event extends StatefulWidget {
//   const Event({super.key});

//   @override
//   State<Event> createState() => _EventState();
// }

// class _EventState extends State<Event> {
//   // final List<Map<String, dynamic>> items = [
//   //   {
//   //     'date': '2022-04-16',
//   //     'items': ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5', 'Item 6', 'Item 7', 'Item 8', 'Item 9']
//   //   },
//   //   {
//   //     'date': '2022-04-17',
//   //     'items': ['Item 1', 'Item 2', 'Item 3']
//   //   },
//   //   {
//   //     'date': '2022-04-18',
//   //     'items': ['Item 1']
//   //   },
//   //   {
//   //     'date': '2022-04-19',
//   //     'items': ['Item 1', 'Item 1', 'Item 1']
//   //   },
//   // ];
//   int selectedIndex = 0;
//   @override
//   void initState() {
//     super.initState();
//   }

//   String _weekDay(int week) {
//     if (week == 0) {
//       return 'Дав';
//     } else if (week == 1) {
//       return 'Мяг';
//     } else if (week == 2) {
//       return 'Лха';
//     } else if (week == 3) {
//       return 'Пүр';
//     } else if (week == 4) {
//       return 'Баа';
//     } else if (week == 5) {
//       return 'Бям';
//     } else {
//       return 'Ням';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Events> eventList = Provider.of<ProviderCoreModel>(context, listen: true).getEventList();

//     return ListView.builder(
//       physics: const BouncingScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: eventList.length,
//       itemBuilder: (context, index) {
//         return _item(eventList[index].id!, eventList[index].events!, index);
//       },
//     );
//   }

//   Widget _item(String date, List<EventModel> items, int index) {
//     ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
//     DateTime dateTime = DateTime.parse(date);
//     return Column(
//       children: [
//         MySeparator(
//           color: theme.colorScheme.backgroundColor,
//           isHorizantol: true,
//         ),
//         const SizedBox(
//           height: 12,
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
//               decoration: BoxDecoration(color: theme.colorScheme.backgroundColor, borderRadius: BorderRadius.circular(8)),
//               child: Column(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(bottom: 4),
//                     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
//                     decoration: BoxDecoration(
//                         color: theme.colorScheme.darkGrey,
//                         borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
//                     child: Text('${dateTime.month} сар', style: TextStyles.textFt12Med.textColor(theme.colorScheme.hintGrey)),
//                   ),
//                   Center(
//                     child: Text(
//                       dateTime.day.toString(),
//                       style: TextStyles.textFt20Medium.textColor(theme.colorScheme.whiteColor),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 4,
//                   ),
//                   Text(
//                     _weekDay(dateTime.weekday),
//                     style: TextStyles.textFt12Med.textColor(theme.colorScheme.weekDayColor),
//                   )
//                 ],
//               ),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 physics: const NeverScrollableScrollPhysics(),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: items
//                       .map(
//                         (item) => GestureDetector(
//                             onTap: () {
//                               print("--------->${item.id}");
//                               NavKey.navKey.currentState!.pushNamed(eventRoute, arguments: {'id': item.id});
//                             },
//                             child: Container(
//                               // height: 280,
//                               // width: 280,
//                               margin: const EdgeInsets.only(left: 8),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(32),
//                                     child: Image.network(
//                                       '${item.coverImage}',
//                                       width: 300,
//                                       height: 140,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 4,
//                                   ),
//                                   Text(
//                                     item.name ?? '',
//                                     style: TextStyles.textFt18Med.textColor(theme.colorScheme.whiteColor),
//                                   ),
//                                   const SizedBox(
//                                     height: 4,
//                                   ),
//                                   Row(children: [
//                                     const Icon(
//                                       Icons.location_pin,
//                                       color: Colors.white,
//                                     ),
//                                     const SizedBox(
//                                       width: 4,
//                                     ),
//                                     Text(
//                                       '${item.location!.name}',
//                                       style: TextStyles.textFt14Med.textColor(theme.colorScheme.whiteColor),
//                                     )
//                                   ]),
//                                   const SizedBox(
//                                     height: 4,
//                                   ),
//                                   Container(
//                                     decoration: BoxDecoration(color: theme.colorScheme.darkGreen, borderRadius: BorderRadius.circular(12)),
//                                     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                                     child: Text(Func.toMoneyComma(150000), style: TextStyles.textFt12Bold.textColor(theme.colorScheme.neonGreen)),
//                                   ),
//                                   const SizedBox(
//                                     height: 16,
//                                   ),
//                                   Visibility(
//                                       visible: item != items[items.length - 1],
//                                       child: Divider(
//                                         color: theme.colorScheme.darkGrey,
//                                         thickness: 1,
//                                       ))
//                                 ],
//                               ),
//                             )),
//                       )
//                       .toList(),
//                 ),
//               ),
//             ),
//           ],
//         )
//       ],
//     );
//   }
// }

// Container(
//   padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
//   decoration: BoxDecoration(color: theme.colorScheme.backgroundColor, borderRadius: BorderRadius.circular(8)),
//   child: Column(
//     children: [
//       Container(
//         margin: const EdgeInsets.only(bottom: 4),
//         padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
//         decoration: BoxDecoration(
//             color: theme.colorScheme.darkGrey,
//             borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
//         child: Text('${dateTime.month} сар', style: TextStyles.textFt12Med.textColor(theme.colorScheme.hintGrey)),
//       ),
//       Center(
//         child: Text(
//           dateTime.day.toString(),
//           style: TextStyles.textFt20Medium.textColor(theme.colorScheme.whiteColor),
//         ),
//       ),
//       const SizedBox(
//         height: 4,
//       ),
//       Text(
//         _weekDay(dateTime.weekday),
//         style: TextStyles.textFt12Med.textColor(theme.colorScheme.weekDayColor),
//       )
//     ],
//   ),
// ),

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

///speed dial check
class MyPage extends StatefulWidget {
  final ValueNotifier<ThemeMode> theme;
  const MyPage({Key? key, required this.theme}) : super(key: key);
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with TickerProviderStateMixin {
  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var extend = false;
  var mini = false;
  var rmicons = false;
  var customDialRoot = false;
  var closeManually = false;
  var useRAnimation = true;
  var isDialOpen = ValueNotifier<bool>(false);
  var speedDialDirection = SpeedDialDirection.up;
  var buttonSize = const Size(56.0, 56.0);
  var childrenButtonSize = const Size(56.0, 56.0);
  var selectedfABLocation = FloatingActionButtonLocation.endDocked;
  var items = [
    FloatingActionButtonLocation.startFloat,
    FloatingActionButtonLocation.startDocked,
    FloatingActionButtonLocation.centerFloat,
    FloatingActionButtonLocation.endFloat,
    FloatingActionButtonLocation.endDocked,
    FloatingActionButtonLocation.startTop,
    FloatingActionButtonLocation.centerTop,
    FloatingActionButtonLocation.endTop,
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Flutter Speed Dial Example"),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("SpeedDial Location", style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)),
                            child: DropdownButton<FloatingActionButtonLocation>(
                              value: selectedfABLocation,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 20,
                              underline: const SizedBox(),
                              onChanged: (fABLocation) => setState(() => selectedfABLocation = fABLocation!),
                              selectedItemBuilder: (BuildContext context) {
                                return items.map<Widget>((item) {
                                  return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10), child: Text(item.value)));
                                }).toList();
                              },
                              items: items.map((item) {
                                return DropdownMenuItem<FloatingActionButtonLocation>(
                                  value: item,
                                  child: Text(
                                    item.value,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("SpeedDial Direction", style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)),
                            child: DropdownButton<SpeedDialDirection>(
                              value: speedDialDirection,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 20,
                              underline: const SizedBox(),
                              onChanged: (sdo) {
                                setState(() {
                                  speedDialDirection = sdo!;
                                  selectedfABLocation = (sdo.isUp && selectedfABLocation.value.contains("Top")) ||
                                          (sdo.isLeft && selectedfABLocation.value.contains("start"))
                                      ? FloatingActionButtonLocation.endDocked
                                      : sdo.isDown && !selectedfABLocation.value.contains("Top")
                                          ? FloatingActionButtonLocation.endTop
                                          : sdo.isRight && selectedfABLocation.value.contains("end")
                                              ? FloatingActionButtonLocation.startDocked
                                              : selectedfABLocation;
                                });
                              },
                              selectedItemBuilder: (BuildContext context) {
                                return SpeedDialDirection.values.toList().map<Widget>((item) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                    child: Align(alignment: Alignment.centerLeft, child: Text(describeEnum(item).toUpperCase())),
                                  );
                                }).toList();
                              },
                              items: SpeedDialDirection.values.toList().map((item) {
                                return DropdownMenuItem<SpeedDialDirection>(
                                  value: item,
                                  child: Text(describeEnum(item).toUpperCase()),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!customDialRoot)
                      SwitchListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          value: extend,
                          title: const Text("Extend Speed Dial"),
                          onChanged: (val) {
                            setState(() {
                              extend = val;
                            });
                          }),
                    SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        value: visible,
                        title: const Text("Visible"),
                        onChanged: (val) {
                          setState(() {
                            visible = val;
                          });
                        }),
                    SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        value: mini,
                        title: const Text("Mini"),
                        onChanged: (val) {
                          setState(() {
                            mini = val;
                          });
                        }),
                    SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        value: customDialRoot,
                        title: const Text("Custom dialRoot"),
                        onChanged: (val) {
                          setState(() {
                            customDialRoot = val;
                          });
                        }),
                    SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        value: renderOverlay,
                        title: const Text("Render Overlay"),
                        onChanged: (val) {
                          setState(() {
                            renderOverlay = val;
                          });
                        }),
                    SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        value: closeManually,
                        title: const Text("Close Manually"),
                        onChanged: (val) {
                          setState(() {
                            closeManually = val;
                          });
                        }),
                    SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        value: rmicons,
                        title: const Text("Remove Icons (for children)"),
                        onChanged: (val) {
                          setState(() {
                            rmicons = val;
                          });
                        }),
                    if (!customDialRoot)
                      SwitchListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          value: useRAnimation,
                          title: const Text("Use Rotation Animation"),
                          onChanged: (val) {
                            setState(() {
                              useRAnimation = val;
                            });
                          }),
                    SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        value: switchLabelPosition,
                        title: const Text("Switch Label Position"),
                        onChanged: (val) {
                          setState(() {
                            switchLabelPosition = val;
                            if (val) {
                              if ((selectedfABLocation.value.contains("end") || selectedfABLocation.value.toLowerCase().contains("top")) &&
                                  speedDialDirection.isUp) {
                                selectedfABLocation = FloatingActionButtonLocation.startDocked;
                              } else if ((selectedfABLocation.value.contains("end") || !selectedfABLocation.value.toLowerCase().contains("top")) &&
                                  speedDialDirection.isDown) {
                                selectedfABLocation = FloatingActionButtonLocation.startTop;
                              }
                            }
                          });
                        }),
                    const Text("Button Size"),
                    Slider(
                      value: buttonSize.width,
                      min: 50,
                      max: 500,
                      label: "Button Size",
                      onChanged: (val) {
                        setState(() {
                          buttonSize = Size(val, val);
                        });
                      },
                    ),
                    const Text("Children Button Size"),
                    Slider(
                      value: childrenButtonSize.height,
                      min: 50,
                      max: 500,
                      onChanged: (val) {
                        setState(() {
                          childrenButtonSize = Size(val, val);
                        });
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Navigation", style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 10),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => MyPage(theme: widget.theme),
                                  ),
                                );
                              },
                              child: const Text("Push Duplicate Page")),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
        floatingActionButtonLocation: selectedfABLocation,
        floatingActionButton: SpeedDial(
          // animatedIcon: AnimatedIcons.menu_close,
          // animatedIconTheme: IconThemeData(size: 22.0),
          // / This is ignored if animatedIcon is non null
          // child: Text("open"),
          // activeChild: Text("close"),
          icon: Icons.add,
          activeIcon: Icons.close,
          spacing: 3,
          mini: mini,
          openCloseDial: isDialOpen,
          childPadding: const EdgeInsets.all(5),
          spaceBetweenChildren: 4,
          dialRoot: customDialRoot
              ? (ctx, open, toggleChildren) {
                  return ElevatedButton(
                    onPressed: toggleChildren,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                    ),
                    child: const Text(
                      "Custom Dial Root",
                      style: TextStyle(fontSize: 17),
                    ),
                  );
                }
              : null,
          buttonSize: buttonSize, // it's the SpeedDial size which defaults to 56 itself
          // iconTheme: IconThemeData(size: 22),
          label: extend ? const Text("Open") : null, // The label of the main button.
          /// The active label of the main button, Defaults to label if not specified.
          activeLabel: extend ? const Text("Close") : null,

          /// Transition Builder between label and activeLabel, defaults to FadeTransition.
          // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
          /// The below button size defaults to 56 itself, its the SpeedDial childrens size
          childrenButtonSize: childrenButtonSize,
          visible: visible,
          direction: speedDialDirection,
          switchLabelPosition: switchLabelPosition,

          /// If true user is forced to close dial manually
          closeManually: closeManually,

          /// If false, backgroundOverlay will not be rendered.
          renderOverlay: renderOverlay,
          // overlayColor: Colors.black,
          // overlayOpacity: 0.5,
          onOpen: () => debugPrint('OPENING DIAL'),
          onClose: () => debugPrint('DIAL CLOSED'),
          useRotationAnimation: useRAnimation,
          tooltip: 'Open Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          // foregroundColor: Colors.black,
          // backgroundColor: Colors.white,
          // activeForegroundColor: Colors.red,
          // activeBackgroundColor: Colors.blue,
          elevation: 8.0,
          animationCurve: Curves.elasticInOut,
          isOpenOnStart: false,
          shape: customDialRoot ? const RoundedRectangleBorder() : const StadiumBorder(),
          // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          children: [
            SpeedDialChild(
              child: !rmicons ? const Icon(Icons.accessibility) : null,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              label: 'First',
              onTap: () => setState(() => rmicons = !rmicons),
              onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
            ),
            SpeedDialChild(
              child: !rmicons ? const Icon(Icons.brush) : null,
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              label: 'Second',
              onTap: () => debugPrint('SECOND CHILD'),
            ),
            SpeedDialChild(
              child: !rmicons ? const Icon(Icons.margin) : null,
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              label: 'Show Snackbar',
              visible: true,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(("Third Child Pressed")))),
              onLongPress: () => debugPrint('THIRD CHILD LONG PRESS'),
            ),
          ],
        ),
      ),
    );
  }
}

extension EnumExt on FloatingActionButtonLocation {
  /// Get Value of The SpeedDialDirection Enum like Up, Down, etc. in String format
  String get value => toString().split(".")[1];
}
