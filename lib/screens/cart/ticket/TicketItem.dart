// import 'package:flutter/material.dart';
// import 'package:portal/screens/cart/ticket/ticketShape/DashLine.dart';
// import 'package:portal/screens/cart/ticket/ticketShape/GradientBadge.dart';
// import 'package:provider/provider.dart';
// import 'package:textstyle_extensions/textstyle_extensions.dart';

// import '../../../helper/responsive_flutter.dart';
// import '../../../helper/text_styles.dart';
// import '../../../language/language_constant.dart';
// import '../../../provider/theme_notifier.dart';

// class TicketItemQR extends StatelessWidget {
//   final String imageUrl;
//   final String badgeText;
//   final String title;
//   final String date;
//   final String sector;
//   final String row;
//   final String seat;
//   Function mcallback;

//   TicketItemQR(
//       {super.key,
//       required this.imageUrl,
//       required this.badgeText,
//       required this.title,
//       required this.date,
//       required this.sector,
//       required this.row,
//       required this.seat,
//       required this.mcallback});

//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.only(top: 20, left: 5),
//           decoration: BoxDecoration(
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//             border: Border(
//               top: BorderSide(
//                 color: theme.colorScheme.backColor,
//                 width: .5,
//               ),
//               left: BorderSide(
//                 color: theme.colorScheme.backColor,
//                 width: .5,
//               ),
//               right: BorderSide(
//                 color: theme.colorScheme.backColor,
//                 width: .5,
//               ),
//             ),
//           ),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   const SizedBox(width: 15),
//                   if (imageUrl != "")
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(15.0),
//                       child: Image.network(
//                         imageUrl,
//                         width: 80,
//                         height: 80,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: theme.colorScheme.darkGrey),
//                             width: 80,
//                             height: 80,
//                           );
//                         },
//                       ),
//                     ),
//                   const SizedBox(width: 20),
//                   Container(
//                     width: ResponsiveFlutter.of(context).wp(46),
//                     margin: const EdgeInsets.only(right: 15),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         GradientBadge(
//                           text: badgeText,
//                         ),
//                         Text(
//                           title,
//                           style: TextStyles.textFt20Bold.textColor(Colors.white),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         Text(
//                           date,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyles.textFt18Med.textColor(Colors.white),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//               const SizedBox(height: 16.0),
//               Container(
//                 margin: const EdgeInsets.only(left: 15, right: 15),
//                 child: Row(
//                   children: [
//                     if (sector.isNotEmpty || sector != "") _buildInfoBox(getTranslated(context, 'sector'), sector, theme),
//                     if (row.isNotEmpty || row != "") _buildInfoBox(getTranslated(context, 'row'), row, theme),
//                     if (seat.isNotEmpty || seat != "")
//                       _buildInfoBox(
//                         getTranslated(context, 'seat'),
//                         seat,
//                         theme,
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         DashLine(borderColor: theme.colorScheme.backColor),
//         Container(
//           padding: const EdgeInsets.only(left: 25, right: 15, top: 10, bottom: 20),
//           decoration: BoxDecoration(
//             borderRadius: const BorderRadius.only(
//               bottomLeft: Radius.circular(20),
//               bottomRight: Radius.circular(20),
//             ),
//             border: Border(
//               bottom: BorderSide(
//                 color: theme.colorScheme.backColor,
//                 width: .5,
//               ),
//               left: BorderSide(
//                 color: theme.colorScheme.backColor,
//                 width: .5,
//               ),
//               right: BorderSide(
//                 color: theme.colorScheme.backColor,
//                 width: .5,
//               ),
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Container(
//                   height: 40,
//                   margin: const EdgeInsets.only(right: 8.0),
//                   decoration: BoxDecoration(
//                       color: theme.colorScheme.backColor,
//                       borderRadius: BorderRadius.circular(8.0),
//                       border: Border.all(color: theme.colorScheme.greyText)),
//                   child: IconButton(
//                     icon: const Icon(Icons.qr_code, color: Colors.white),
//                     onPressed: () {
//                       mcallback("qr_show");
//                     },
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   height: 40,
//                   margin: const EdgeInsets.only(right: 8.0),
//                   decoration: BoxDecoration(
//                       color: theme.colorScheme.backColor,
//                       borderRadius: BorderRadius.circular(8.0),
//                       border: Border.all(color: theme.colorScheme.greyText)),
//                   child: IconButton(
//                     icon: const Icon(Icons.download, color: Colors.white),
//                     onPressed: () {
//                       mcallback("qr_download");
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }

//   Widget _buildInfoBox(String label, String value, ThemeData theme, {int flex = 1}) {
//     return Expanded(
//       flex: 1,
//       child: Container(
//         margin: const EdgeInsets.only(right: 4.0),
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         decoration: BoxDecoration(
//           color: theme.colorScheme.backColor,
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(label, style: TextStyles.textFt12Bold.textColor(theme.colorScheme.greyText)),
//             const SizedBox(width: 4),
//             Text(value, style: TextStyles.textFt14Bold.textColor(theme.colorScheme.whiteColor)),
//           ],
//         ),
//       ),
//     );
//   }
// }
