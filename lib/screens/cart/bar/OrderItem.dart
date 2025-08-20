import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

import '../../../helper/responsive_flutter.dart';
import '../../../helper/text_styles.dart';
import '../../../language/language_constant.dart';
import '../../../models/order_model.dart';
import '../../../provider/theme_notifier.dart';

class OrderItem extends StatefulWidget {
  BarItems? mBarItems;
  int index;

  OrderItem({super.key, required this.mBarItems, required this.index});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool isShow = true;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
            color: theme.colorScheme.backColor,
            width: .5,
          )),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${getTranslated(context, 'order')} : ${widget.index + 1}",
                    style: TextStyles.textFt20Bold.textColor(Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    width: ResponsiveFlutter.of(context).wp(45),
                    child: Text(
                      convertDate(widget.mBarItems?.createdAt ?? ""),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.textFt18Med.textColor(Colors.white),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isShow = !isShow;
                  });
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      border: Border.all(
                        color: theme.colorScheme.backColor,
                        width: .5,
                      )),
                  child: isShow == false
                      ? Icon(Icons.keyboard_arrow_down_outlined, color: theme.colorScheme.whiteColor)
                      : Icon(Icons.keyboard_arrow_up, color: theme.colorScheme.whiteColor),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          if (isShow) orderItems(widget.mBarItems?.items, theme),
          GestureDetector(
            onTap: () {
              print("qr clcik");
            },
            child: Container(
              height: 40,
              width: ResponsiveFlutter.of(context).wp(100),
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  color: theme.colorScheme.whiteColor,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: theme.colorScheme.whiteColor)),
              child: IconButton(
                icon: const Icon(Icons.qr_code, color: Colors.black),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget orderItems(List<Items>? items, ThemeData theme) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: items?.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            items?[index].cover != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      items?[index].cover ?? "",
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(width: 40, height: 40, color: Colors.blue),
            const SizedBox(width: 10),
            SizedBox(
              width: ResponsiveFlutter.of(context).wp(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    items?[index].name ?? "",
                    style: TextStyles.textFt15Bold.textColor(theme.colorScheme.whiteColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    width: ResponsiveFlutter.of(context).wp(45),
                    child: Text(
                      items?[index].name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.textFt14Bold.textColor(theme.colorScheme.whiteColor),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  border: Border.all(
                    color: theme.colorScheme.backColor,
                    width: .5,
                  )),
              child: Center(
                child: Text(
                  "${items?[index].qty ?? ""}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.textFt14Bold.textColor(Colors.white),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  String convertDate(String? dateString) {
    if (dateString == "" || dateString == null) return "";
    DateTime date = DateTime.parse(dateString);
    String formattedDate = DateFormat('yyyy/MM/dd HH:mm').format(date);
    return formattedDate;
  }
}
