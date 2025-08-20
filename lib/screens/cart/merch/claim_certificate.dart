import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal/components/custom_text_input.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/ticket_list_requests.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class ClaimCertificate extends StatefulWidget {
  final String merchId;
  const ClaimCertificate({super.key, required this.merchId});

  @override
  State<ClaimCertificate> createState() => _ClaimCertificateState();
}

class _ClaimCertificateState extends State<ClaimCertificate> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressDetailController = TextEditingController();

  // Address related variables
  List<Map<String, dynamic>> cities = [];
  List<Map<String, dynamic>> districts = [];
  List<Map<String, dynamic>> quarters = [];

  Map<String, dynamic>? selectedCity;
  Map<String, dynamic>? selectedDistrict;
  Map<String, dynamic>? selectedQuarter;

  List<Map<String, dynamic>> filteredDistricts = [];
  List<Map<String, dynamic>> filteredQuarters = [];
  bool isForeigner = false;
  TicketListRequests ticketListRequests = TicketListRequests();

  @override
  void initState() {
    super.initState();
    loadAddressData();
  }

  getCertificate() async {
    Map<String, dynamic> address = {};
    if (isForeigner) {
      address['description'] = addressDetailController.text;
    } else {
      address['city'] = selectedCity!['name'];
      address['district'] = selectedDistrict!['name'];
      address['quarter'] = selectedQuarter!['name'];
      address['description'] = addressDetailController.text;
    }

    Map<String, dynamic> data = {};
    data['merchId'] = widget.merchId;
    data['email'] = emailController.text.trim();
    data['name'] = nameController.text.trim();
    data['tagname'] = tagController.text;
    data['phone'] = phoneController.text;
    data['address'] = address;

    await Webservice().loadPost(Response.merchCert, context, data, parameter: '').then((response) {
      application.showToast(getTranslated(context, 'successful'));
      ticketListRequests.getMerchList(context);
      NavKey.navKey.currentState!.pop();
    });
  }

  Future<void> loadAddressData() async {
    try {
      // Load city data
      final cityData = await rootBundle.loadString('lib/screens/cart/merch/city.json');
      final cityList = json.decode(cityData) as List;

      // Load district data
      final districtData = await rootBundle.loadString('lib/screens/cart/merch/district.json');
      final districtList = json.decode(districtData) as List;

      // Load quarter data
      final quarterData = await rootBundle.loadString('lib/screens/cart/merch/quarter.json');
      final quarterList = json.decode(quarterData) as List;

      setState(() {
        cities = cityList.cast<Map<String, dynamic>>();
        districts = districtList.cast<Map<String, dynamic>>();
        quarters = quarterList.cast<Map<String, dynamic>>();
      });
    } catch (e) {
      print('Error loading address data: $e');
    }
  }

  void onCityChanged(Map<String, dynamic>? city) {
    setState(() {
      selectedCity = city;
      selectedDistrict = null;
      selectedQuarter = null;

      if (city != null) {
        filteredDistricts = districts.where((district) => district['parent'] == city['id']).toList();
      } else {
        filteredDistricts = [];
      }
      filteredQuarters = [];
    });
  }

  void onDistrictChanged(Map<String, dynamic>? district) {
    setState(() {
      selectedDistrict = district;
      selectedQuarter = null;

      if (district != null) {
        filteredQuarters = quarters.where((quarter) => quarter['parent'] == district['id']).toList();
      } else {
        filteredQuarters = [];
      }
    });
  }

  void onQuarterChanged(Map<String, dynamic>? quarter) {
    setState(() {
      selectedQuarter = quarter;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return AlertDialog(
      backgroundColor: theme.colorScheme.blackColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          InkWell(
            onTap: () {
              NavKey.navKey.currentState!.pop();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  borderRadius: BorderRadius.circular(60)),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Icon(
                Icons.close,
                color: theme.colorScheme.whiteColor,
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name field
              Text(
                '• Нэр',
                style: TextStyle(
                  color: theme.colorScheme.whiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                style: TextStyle(color: theme.colorScheme.whiteColor),
                decoration: InputDecoration(
                  hintText: getTranslated(context, 'insertName'),
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
              ),
              const SizedBox(height: 16),

              // Email field
              Text(
                '• ${getTranslated(context, 'email')}',
                style: TextStyle(
                  color: theme.colorScheme.whiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                style: TextStyle(color: theme.colorScheme.whiteColor),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'discordcontent@mentor.com',
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
              ),
              const SizedBox(height: 16),

              // Phone field
              Text(
                '• ${getTranslated(context, 'phone')}',
                style: TextStyle(
                  color: theme.colorScheme.whiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: phoneController,
                style: TextStyle(color: theme.colorScheme.whiteColor),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '+976',
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '• Tag',
                style: TextStyle(
                  color: theme.colorScheme.whiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: tagController,
                style: TextStyle(color: theme.colorScheme.whiteColor),
                decoration: InputDecoration(
                  hintText: getTranslated(context, 'wordHang'),
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    getTranslated(context, 'foreigner'),
                    style: TextStyles.textFt14Reg.textColor(theme.colorScheme.whiteColor),
                  ),
                  Checkbox(
                      activeColor: Colors.white,
                      checkColor: Colors.blue,
                      fillColor: const WidgetStatePropertyAll(Colors.white),
                      value: isForeigner,
                      onChanged: (value) {
                        setState(() {
                          isForeigner = value ?? false;
                        });
                      })
                ],
              ),
              const SizedBox(height: 16),

              // City dropdown
              if (!isForeigner)
                Text(
                  getTranslated(context, 'city'),
                  style: TextStyle(
                    color: theme.colorScheme.whiteColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (!isForeigner) const SizedBox(height: 8),
              if (!isForeigner)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Map<String, dynamic>>(
                      value: selectedCity,
                      hint: Text('Аймаг, хот сонгох', style: TextStyle(color: Colors.grey[600])),
                      dropdownColor: theme.colorScheme.blackColor,
                      style: TextStyle(color: theme.colorScheme.whiteColor),
                      icon: Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.whiteColor),
                      onChanged: onCityChanged,
                      items: cities.map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> city) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: city,
                          child: Text(Provider.of<ProviderCoreModel>(context, listen: false).isEnglish ? city['name_en'] : city['name']),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              if (!isForeigner) const SizedBox(height: 16),

              // District dropdown
              if (!isForeigner)
                Text(
                  getTranslated(context, 'disctrict'),
                  style: TextStyle(
                    color: theme.colorScheme.whiteColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (!isForeigner) const SizedBox(height: 8),
              if (!isForeigner)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Map<String, dynamic>>(
                      value: selectedDistrict,
                      hint: Text('Сум, дүүрэг сонгох', style: TextStyle(color: Colors.grey[600])),
                      dropdownColor: theme.colorScheme.blackColor,
                      style: TextStyle(color: theme.colorScheme.whiteColor),
                      icon: Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.whiteColor),
                      onChanged: selectedCity != null ? onDistrictChanged : null,
                      items: filteredDistricts.map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> district) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: district,
                          child: Text(Provider.of<ProviderCoreModel>(context, listen: false).isEnglish ? district['name_en'] : district['name']),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              if (!isForeigner) const SizedBox(height: 16),

              // Quarter dropdown
              if (!isForeigner)
                Text(
                  getTranslated(context, 'khoroo'),
                  style: TextStyle(
                    color: theme.colorScheme.whiteColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (!isForeigner) const SizedBox(height: 8),
              if (!isForeigner)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Map<String, dynamic>>(
                      value: selectedQuarter,
                      hint: Text('Баг, хороо сонгох', style: TextStyle(color: Colors.grey[600])),
                      dropdownColor: theme.colorScheme.blackColor,
                      style: TextStyle(color: theme.colorScheme.whiteColor),
                      icon: Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.whiteColor),
                      onChanged: selectedDistrict != null ? onQuarterChanged : null,
                      items: filteredQuarters.map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> quarter) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: quarter,
                          child: Text(Provider.of<ProviderCoreModel>(context, listen: false).isEnglish ? quarter['name_en'] : quarter['name']),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              if (!isForeigner) const SizedBox(height: 16),

              // Address detail field (larger text area)
              Text(
                getTranslated(context, 'detailedAddress'),
                style: TextStyle(
                  color: theme.colorScheme.whiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: addressDetailController,
                style: TextStyle(color: theme.colorScheme.whiteColor),
                maxLines: 4,
                minLines: 4,
                decoration: InputDecoration(
                  hintText: getTranslated(context, 'addressDeatilHint'),
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate form
                    if (isForeigner) {
                      if (nameController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          phoneController.text.isEmpty ||
                          addressDetailController.text.isEmpty) {
                        application.showToastAlert(getTranslated(context, 'emptyWarning'));
                        return;
                      }
                    } else if (nameController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        phoneController.text.isEmpty ||
                        selectedCity == null ||
                        selectedDistrict == null ||
                        selectedQuarter == null ||
                        addressDetailController.text.isEmpty) {
                      application.showToastAlert(getTranslated(context, 'emptyWarning'));
                      return;
                    }

                    // Basic email validation
                    if (!emailController.text.contains('@')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('И-мэйл хаягийн формат буруу байна'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    getCertificate();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    getTranslated(context, 'getCert'),
                    style: TextStyle(
                      color: theme.colorScheme.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
