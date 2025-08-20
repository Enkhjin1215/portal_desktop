import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portal/components/custom_app_bar.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/responsive_flutter.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/models/faq_model.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();
    return CustomScaffold(
        canPopWithSwipe: true,
        padding: EdgeInsets.zero,
        appBar: tittledAppBar(context: context, tittle: 'support', backShow: true),
        resizeToAvoidBottomInset: false,
        body: Container(
            width: ResponsiveFlutter.of(context).wp(100),
            height: ResponsiveFlutter.of(context).hp(100),
            color: theme.colorScheme.profileBackground,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: ResponsiveFlutter.of(context).hp(5),
                  ),
                  // Contact info card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: theme.colorScheme.blackColor, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        _buildContactRow(
                          context,
                          Assets.buttonSvg,
                          '+976 7272 0022',
                          onTap: () async {
                            final Uri phoneUri = Uri.parse('tel:+97672720022');
                            try {
                              if (await canLaunchUrl(phoneUri)) {
                                await launchUrl(phoneUri);
                              } else {
                                // Show feedback to the user
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Could not launch phone app')),
                                );
                              }
                            } catch (e) {
                              // Show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildContactRow(
                          context,
                          Assets.button1Svg,
                          'info@portal.mn',
                          onTap: () async {
                            final Uri emailUri = Uri.parse(
                                'mailto:info@portal.mn?subject=Support%20Request&body=Сайн%20байна%20уу?%20Надад%20дараах%20зүйлүүд%20дээр%20тусламж%20хэрэгтэй%20байна.');
                            try {
                              if (await canLaunchUrl(emailUri)) {
                                await launchUrl(emailUri);
                              } else {
                                // Show some feedback to the user
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('No email app found')),
                                );
                              }
                            } catch (e) {
                              // Show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Could not open email: $e')),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildContactRow(
                          context,
                          Assets.button2Svg,
                          'fb.com/Portal.mnofficial',
                          onTap: () async {
                            final Uri url = Uri.parse('https://www.facebook.com/Portal.mnofficial');
                            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                              throw Exception('Could not launch $url');
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildContactRow(
                          context,
                          Assets.button3Svg,
                          'instagram.com/portal.mn',
                          onTap: () async {
                            final Uri url = Uri.parse('https://www.instagram.com/portal.mn');
                            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                              throw Exception('Could not launch $url');
                            }
                          },
                        )
                      ],
                    ),
                  ),

                  // FAQ Section
                  const FAQSection(),
                ],
              ),
            )));
  }

  Widget _buildContactRow(BuildContext context, String iconAsset, String text, {required Function() onTap}) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: true).getTheme();

    return InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(iconAsset),
            Text(
              text,
              style: TextStyles.textFt15Bold.textColor(theme.colorScheme.greyText),
            )
          ],
        ));
  }
}

class FAQSection extends StatefulWidget {
  const FAQSection({super.key});

  @override
  State<FAQSection> createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  List<FAQ> faqs = [];
  bool isLoading = true;
  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    _loadFAQs();
  }

  Future<void> _loadFAQs() async {
    setState(() {
      isLoading = true;
    });

    try {
      // For testing with static data:
      List<FAQ> loadedFaqs = faqData.map((data) => FAQ.fromJson(data)).toList();

      // For production using API:
      // final loadedFaqs = await WebService().load(FAQ.getFaqs);

      setState(() {
        faqs = loadedFaqs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Асуултуудыг ачааллахад алдаа гарлаа: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 10),
          child: Text(
            'FAQ',
            style: TextStyles.textFt18Bold.textColor(Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: faqs.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  FAQ faq = faqs[index];
                  bool isExpanded = expandedIndex == index;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        // Question
                        InkWell(
                          onTap: () {
                            setState(() {
                              expandedIndex = isExpanded ? null : index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    faq.question,
                                    style: TextStyles.textFt15Bold.textColor(Colors.white),
                                  ),
                                ),
                                Icon(
                                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Answer
                        if (isExpanded)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(height: 1, color: Colors.grey),
                                const SizedBox(height: 16),
                                ...faq.answers
                                    .map((answer) => Html(
                                          data: answer,
                                          style: {
                                            "body": Style(
                                              color: Colors.grey,
                                              fontSize: FontSize(14),
                                              fontFamily: 'Montserrat',
                                            ),
                                            "strong": Style(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          },
                                        ))
                                    .toList(),
                                if (faq.link != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final Uri url = Uri.parse(faq.link!);
                                        try {
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url, mode: LaunchMode.externalApplication);
                                          } else {
                                            throw Exception('Could not launch $url');
                                          }
                                        } catch (e) {
                                          print('excep:$e');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Холбоосыг нээхэд алдаа гарлаа: $e')),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF222222),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        'Видеог үзэх',
                                        style: TextStyles.textFt14Med.textColor(Colors.white),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
        const SizedBox(
          height: 60,
        )
      ],
    );
  }
}
