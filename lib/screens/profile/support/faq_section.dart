import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/models/faq_model.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

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
    ThemeData theme = Theme.of(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
    ]);
  }
}
