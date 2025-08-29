import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:portal/components/bottom_sheet.dart';
import 'package:portal/components/container_transparent.dart';
import 'package:portal/components/custom_scaffold.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/assets.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/helper/text_styles.dart';
import 'package:portal/models/event_detail_model.dart';
import 'package:portal/provider/provider_core.dart';
import 'package:portal/provider/theme_notifier.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/screens/portal_featured/component/case_opening_component.dart';
import 'package:portal/screens/portal_featured/component/countdown_timer_component.dart';
import 'package:portal/screens/portal_featured/component/cs-event-model.dart';
import 'package:portal/screens/portal_featured/component/event_banner_component.dart';
import 'package:portal/screens/portal_featured/component/inventory_grid_component.dart';
import 'package:portal/screens/portal_featured/component/tab_selector_component.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';
import 'package:provider/provider.dart';
import 'package:textstyle_extensions/textstyle_extensions.dart';

class CSGOLootScreen extends StatefulWidget {
  const CSGOLootScreen({Key? key}) : super(key: key);

  @override
  State<CSGOLootScreen> createState() => _CSGOLootScreenState();
}

class _CSGOLootScreenState extends State<CSGOLootScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final List<CSGOItem> _items = [];
  List<CSGOItem> _inventory = [];
  List<CSGOItem> _myinventory = [];

  final Random _random = Random();
  bool _isOpening = false;
  CSGOItem? _winningItem;
  late AnimationController _animationController;
  late Animation<double> _animation;
  Timer? _scrollTimer;
  int _selectedTab = 0; // 0 for Roll, 1 for Poll
  Duration defaultDuration = const Duration(hours: 24);
  int pendingChance = 0;

  // Timer for the case opening countdown
  CSGOCase? csCase;
  late Timer _countdownTimer;
  Duration _remainingTime = const Duration(hours: 24, minutes: 00, seconds: 00);

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;
  bool notConnectedSteam = false;
  String eventID = '';
  bool allGifts = true;
  final confettiController = ConfettiController();

  final StreamController<Duration> _timeController = StreamController<Duration>.broadcast();
  Timer? _timer;

  bool showContent = false;

  StreamController<Duration> get timeController => _timeController;

  String tradeUrl = '';
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    // Don't call init() here - move it to didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only initialize once
    if (!_isInitialized) {
      _isInitialized = true;
      init();
    }
  }

  init() async {
    try {
      final dynamic args = ModalRoute.of(context)?.settings.arguments;

      if (args != null && args['id'] != null) {
        eventID = args['id'];
        await Webservice().loadGet(CSGOCase.getCase, context, parameter: '/${args['id']}').then((response) {
          if (mounted) {
            setState(() {
              csCase = response;

              _inventory = csCase?.templates ?? [];
            });
            _generateRandomItems();
            _startCountdownTimer(args['id']);
          }
        });
      } else {
        // Handle case where no arguments are passed
        debugPrint('No arguments passed to CSGOLootScreen');
      }
    } catch (e) {
      debugPrint('Error initializing CSGOLootScreen: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    _scrollTimer?.cancel();
    _countdownTimer.cancel();
    _audioPlayer.dispose();
    _timer?.cancel();
    _timeController.close();
    super.dispose();
  }

  void _startCountdownTimer(String id) async {
    try {
      await Webservice().loadGet(Response.csgoGetMe, context, parameter: '/$id/me').then((response) {
        DateTime startDate = DateTime.parse(csCase!.startDate!).toLocal();
        DateTime lastClaimed;
        tradeUrl = response['steam_trade_url'];
        if (response['last_claimed'] == null) {
          lastClaimed = startDate;
        } else {
          lastClaimed = DateTime.parse(response['last_claimed']).toLocal();
        }

        DateTime now = DateTime.now();

        if (startDate.isAfter(now)) {
          _remainingTime = startDate.difference(now);
        } else {
          _remainingTime = lastClaimed.add(defaultDuration).difference(now);
        }
        debugPrint('---event startdate :$startDate \n---event last claimed :$lastClaimed\n---event time now:$now\n---remaingTime:$_remainingTime');
        DateTime possibleTime = DateTime.now().add(_remainingTime);
        // DateTime possibleTime = lastClaimed.subtract(const Duration(days: 1));
        // _remainingTime = possibleTime.difference(now);
        startTimer(possibleTime);
        pendingChance = response['pending_count'];
      });
    } catch (e) {
      debugPrint('exception:$e');
      setState(() {
        notConnectedSteam = true;
      });
    }
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        if (mounted) {
          setState(() {
            _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
          });
        }
      } else {
        timer.cancel();
      }
    });
    getMyItems();
  }

  getMyItems() async {
    await Webservice().loadGet(Response.csgoGetMe, context, parameter: '/$eventID/gifts').then((response) {
      _myinventory = response.map<CSGOItem>((item) => CSGOItem.fromJson(item['itemTemplateId'])).toList(); // Explicit cast here
      setState(() {});
    });
  }

  Future<void> _playOpeningSound() async {
    try {
      await _audioPlayer.play(AssetSource('sound/csgo-open.mp3'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  getWinningItem() async {
    try {
      Map<String, dynamic> data = {};
      await Webservice().loadPost(Response.csgoGetMe, context, data, parameter: '/claim-box/$eventID').then((response) {
        CSGOItem winningItem = CSGOItem.fromJson(response);
        _openCase(winningItem);
      });
    } catch (e) {
      debugPrint('exception:$e');
    }
  }

  void startTimer(DateTime endTime) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remainingTime = endTime.difference(DateTime.now());

      if (remainingTime.isNegative) {
        _timeController.add(Duration.zero);
        _timer?.cancel(); // Stop the timer
      } else {
        _timeController.add(remainingTime);
      }
    });
  }

  void _openCase(CSGOItem winningItem) async {
    if (_isOpening) return;

    // Reset everything before starting
    _resetCaseOpening();

    setState(() {
      _isOpening = true;
      _winningItem = null; // Clear previous winning item
    });

    await _playOpeningSound();

    // Generate new random items for this opening
    _generateRandomItemsForOpening();

    // Set the winning item at position 80
    setState(() {
      _items[80] = winningItem;
    });

    _startSpinning();

    // Wait for spinning effect
    await Future.delayed(Duration(milliseconds: 1500 + _random.nextInt(1000)));

    // Set winning item and stop
    setState(() {
      _winningItem = winningItem;
    });

    _stopAtWinningItem();

    try {
      await _audioPlayer.play(AssetSource('sound/csgo-spin.mp3'));
      await Future.delayed(const Duration(seconds: 4));
      await _audioPlayer.play(AssetSource('sound/csgo-end.mp3'));
    } catch (e) {
      debugPrint('Error playing winning sound: $e');
    }
    _startCountdownTimer(eventID);
  }

  void _resetCaseOpening() {
    // Cancel any ongoing timers
    _scrollTimer?.cancel();

    // Reset animation controller
    _animationController.reset();

    // Reset scroll position to start
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }

    // Clear winning item
    _winningItem = null;
  }

  void _generateRandomItemsForOpening() {
    // Clear existing items
    _items.clear();

    // Generate fresh random items for this opening
    for (int i = 0; i < 100; i++) {
      CSGOItem item = _inventory[_random.nextInt(_inventory.length)];
      _items.add(item);
    }
  }

  void _startSpinning() {
    _scrollTimer?.cancel();

    // Ensure we start from the beginning
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }

    _scrollTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_scrollController.hasClients && mounted) {
        final newOffset = _scrollController.offset + 8;
        _scrollController.jumpTo(newOffset);
      } else {
        timer.cancel();
      }
    });
  }

  void _stopAtWinningItem() {
    _scrollTimer?.cancel();

    if (!_scrollController.hasClients || !mounted) {
      if (mounted) {
        setState(() {
          _isOpening = false;
        });
      }
      return;
    }

    final viewportWidth = MediaQuery.of(context).size.width;
    const itemWidth = 132.0;
    const winningItemIndex = 80;

    // Calculate target position to center the winning item
    final targetPosition = (winningItemIndex * itemWidth) - (viewportWidth / 2) + (itemWidth / 2);

    // Clamp to valid scroll range
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final minScrollExtent = _scrollController.position.minScrollExtent;
    final clampedTargetPosition = targetPosition.clamp(minScrollExtent, maxScrollExtent);

    _scrollController
        .animateTo(
      clampedTargetPosition,
      duration: const Duration(seconds: 3),
      curve: Curves.easeOutCubic,
    )
        .then((_) {
      if (mounted) {
        confettiController.play();

        // Add a small delay before showing win animation
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _animationController.forward();
            setState(() {
              _isOpening = false;
              confettiController.stop();
            });
          }
        });
      }
    }).catchError((error) {
      debugPrint('Error animating to winning item: $error');
      if (mounted) {
        setState(() {
          _isOpening = false;
        });
      }
    });
  }

  void _generateRandomItems() {
    _items.clear(); // Clear existing items first
    for (int i = 0; i < 100; i++) {
      CSGOItem item = _inventory[_random.nextInt(_inventory.length)];
      _items.add(item);
    }
  }

  claimFree() async {
    Map<String, dynamic> data = {};

    await Webservice().loadPost(Response.csgoClaimDaily, context, data, parameter: eventID).then((response) {
      NavKey.navKey.currentState!.pop();
      _startCountdownTimer(eventID);
    });
  }

  buyChance(int count) async {
    // String idToken = await application.getIdToken();
    Map<String, dynamic> data = {};
    data['eventId'] = eventID;
    data['qty'] = count;
    data['lang'] = Provider.of<ProviderCoreModel>(context, listen: false).isEnglish ? 'en' : 'mn';
    // data['idToken'] = idToken;

    EventDetail dumpDetail = await getEvent('683d7c8588eb132b61d2e6dc');

    Future.delayed(const Duration(seconds: 1), () {
      NavKey.navKey.currentState!.pushNamed(paymentRoute, arguments: {'data': data, 'event': dumpDetail, 'promo': '', 'ebarimt': '', 'csox': true});
    });
  }

  FutureOr<EventDetail> getEvent(String eventId) async {
    late EventDetail event;
    await Webservice().loadGet(EventDetail.eventDetail, context, parameter: eventId).then((response) {
      event = response;
    });
    return event;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Provider.of<ThemeNotifier>(context, listen: false).getTheme();
    return CustomScaffold(
      padding: EdgeInsets.zero,
      body: SafeArea(
          bottom: false,
          child: csCase == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )

              // Main content with scrolling
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: constraints.maxHeight),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Back Button Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      NavKey.navKey.currentState!.pop();
                                    },
                                    child: const ContainerTransparent(
                                      margin: EdgeInsets.only(left: 16, top: 16),
                                      padding: EdgeInsets.fromLTRB(10, 12, 10, 12),
                                      width: 48,
                                      bRadius: 60,
                                      child: Icon(
                                        Icons.keyboard_arrow_left_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                ],
                              ),

                              // Divider
                              const Divider(
                                color: Colors.grey,
                                thickness: 0.3,
                              ),

                              // Event Banner
                              if (csCase != null)
                                EventBannerComponent(
                                  csgoCase: csCase!,
                                ),

                              const SizedBox(height: 20),

                              // Toggle Selector
                              ToggleSelector(
                                initialSelection: _selectedTab,
                                onChanged: (index) {
                                  setState(() {
                                    _selectedTab = index;
                                  });
                                },
                              ),

                              const SizedBox(height: 20),

                              // Content
                              _selectedTab == 0 ? _buildRollContent(theme) : _buildPollContent(theme),

                              const SizedBox(height: 40), // Padding at bottom
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )),
    );
  }

  Widget _buildRollContent(ThemeData theme) {
    return Column(
      children: [
        // Prize indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Image.asset(Assets.magic),
            ),
            const SizedBox(width: 4),
            Text(
              'Танд Roll хийх $pendingChance эрх байна',
              style: TextStyles.textFt16Med.textColor(theme.colorScheme.whiteColor),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Case Opening Component
        SizedBox(
          width: double.maxFinite,
          height: 217, // Fixed height to prevent overflow
          child: CaseOpeningComponent(
            items: _items,
            scrollController: _scrollController,
            isOpening: _isOpening,
            winningItem: _winningItem,
            animation: _animation,
          ),
        ),
        ConfettiWidget(
          numberOfParticles: 32,
          maximumSize: const Size(35, 20),
          shouldLoop: true,
          confettiController: confettiController,
          blastDirectionality: BlastDirectionality.explosive,
        ),
        const SizedBox(
          height: 16,
        ),
        // Countdown Timer
        InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              application.showToast('Эвент дууссан байна.');

              // if (pendingChance <= 0) {
              //   application.showToastAlert('Эрхээ нэмнэ үү');
              // } else {
              //   getWinningItem();
              // }
            },
            child: CountdownTimerComponent(
              remainingTime: _remainingTime,
              isError: notConnectedSteam,
            )),
        const SizedBox(
          height: 8,
        ),
        Center(
          child: InkWell(
              onTap: () {
                ModalAlert().showRollChanceBuy(
                    context,
                    _remainingTime,
                    theme,
                    () {
                      // print('*********************clicked');
                      claimFree();
                    },
                    timeController,
                    showContent,
                    (int cnt) {
                      buyChance(cnt);
                    });
              },
              child: const Text(
                'Эрх авах',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white),
              )),
        ),
        const SizedBox(height: 20),

        // Inventory Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 35,
            ),
            InkWell(
                onTap: () {
                  if (!allGifts) {
                    allGifts = true;
                    setState(() {});
                  }
                },
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: theme.colorScheme.backgroundColor,
                      border: const Border(
                          top: BorderSide(color: Colors.white, width: 0.2),
                          left: BorderSide(color: Colors.white, width: 0.2),
                          right: BorderSide(color: Colors.white, width: 0.2)),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                  child: Row(
                    children: [
                      Text(
                        'Бүх бэлэг ${_inventory.length}  ',
                        style: TextStyles.textFt14Reg.textColor(allGifts ? theme.colorScheme.whiteColor : theme.colorScheme.greyText),
                      ),
                      Icon(
                        Icons.card_giftcard_rounded,
                        color: allGifts ? theme.colorScheme.whiteColor : theme.colorScheme.greyText,
                      )
                    ],
                  ),
                )),
            const SizedBox(
              width: 8,
            ),
            InkWell(
                onTap: () {
                  if (allGifts) {
                    setState(() {
                      allGifts = false;
                    });
                  }
                },
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: theme.colorScheme.backgroundColor,
                      border: const Border(
                          top: BorderSide(color: Colors.white, width: 0.2),
                          left: BorderSide(color: Colors.white, width: 0.2),
                          right: BorderSide(color: Colors.white, width: 0.2)),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                  child: Row(
                    children: [
                      Text(
                        'Миний бэлэг ${_myinventory.length}  ',
                        style: TextStyles.textFt14Reg.textColor(allGifts ? theme.colorScheme.greyText : theme.colorScheme.whiteColor),
                      ),
                      Icon(
                        Icons.card_giftcard_rounded,
                        color: allGifts ? theme.colorScheme.greyText : theme.colorScheme.whiteColor,
                      )
                    ],
                  ),
                ))
          ],
        ),

        // Inventory Grid with fixed height
        InventoryGridComponent(
          items: allGifts ? _inventory : _myinventory,
          isAllGifts: allGifts,
          tradeUrl: tradeUrl,
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPollContent(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Санал өгөх',
            style: TextStyles.textFt24Bold.textColor(theme.colorScheme.whiteColor),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.whiteColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Дараагийн эвент юу байвал сайн вэ?',
              style: TextStyles.textFt16Med.textColor(theme.colorScheme.whiteColor),
              textAlign: TextAlign.center,
            ),
          ),
          // Add poll options here
        ],
      ),
    );
  }
}
