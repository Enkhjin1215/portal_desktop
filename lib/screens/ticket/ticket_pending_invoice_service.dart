import 'dart:async';

import 'package:flutter/material.dart';
import 'package:portal/components/bottom_sheet.dart';
import 'package:portal/helper/application.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/language/language_constant.dart';
import 'package:portal/models/event_detail_model.dart';
import 'package:portal/models/pending_invoice_model.dart';
import 'package:portal/router/route_path.dart';
import 'package:portal/service/response.dart';
import 'package:portal/service/web_service.dart';

class TicketPendingInvoiceService {
  final StreamController<Duration> _timeController = StreamController<Duration>.broadcast();
  Timer? _timer;

  StreamController<Duration> get timeController => _timeController;

  /// Dispose of resources when the service is no longer needed
  void dispose() {
    _timer?.cancel();
    _timeController.close();
  }

  /// Check for pending invoices
  Future<PendingInvoiceModel?> checkPendingInvoice(BuildContext context) async {
    try {
      late PendingInvoiceModel pendingInvoice;
      await Webservice().loadGet(PendingInvoiceModel.getPendingInvoice, context).then((response) {
        pendingInvoice = response;
      });
      return pendingInvoice;
    } catch (e) {
      return null;
    }
  }

  /// Delete an invoice by ID
  Future<void> deleteInvoice(BuildContext context, String id, {bool doPop = true}) async {
    try {
      await Webservice().loadDelete(Response.deleteInvoice, context, parameter: id).then((response) {
        if (doPop) {
          NavKey.navKey.currentState!.pop();
        }
      });
    } catch (e) {
      debugPrint('Error deleting invoice: $e');
    }
  }

  /// Start a timer for the pending invoice
  void startTimer(DateTime endTime) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final remainingTime = endTime.difference(DateTime.now());

      if (remainingTime.isNegative) {
        _timeController.add(Duration.zero);
        _timer?.cancel(); // Stop the timer
      } else {
        _timeController.add(remainingTime);
      }
    });
  }

  /// Convert PendingInvoiceModel to the simplified format needed for payment
  Map<String, dynamic> simplifyPendingInvoice(PendingInvoiceModel? model) {
    if (model == null) {
      return {};
    }

    final List<Map<String, dynamic>> simplifiedTemplates = model.templates?.map((template) {
          return {
            'templateId': template.templateId?.id,
            'seats': template.seats,
          };
        }).toList() ??
        [];

    return {
      'templates': simplifiedTemplates,
      'eventId': model.eventId?.id,
    };
  }

  /// Handle pending invoice flow
  /// Returns true if a pending invoice was found and handled, false otherwise
  Future<bool> handlePendingInvoice({
    required BuildContext context,
    required ThemeData theme,
    required EventDetail? currentEventDetail,
  }) async {
    final pendingInvoiceModel = await checkPendingInvoice(context);

    if (pendingInvoiceModel != null) {
      // Calculate end time (10 minutes from creation)
      DateTime endTime = DateTime.parse(pendingInvoiceModel.createdAt ?? DateTime.now().toString()).toLocal().add(const Duration(minutes: 10));

      // Start the timer
      startTimer(endTime);

      if (context.mounted) {
        // Show the pending invoice modal
        ModalAlert().pendingInvoice(
          context: context,
          theme: theme,
          // Cancel button handler
          onTap: () {
            deleteInvoice(context, pendingInvoiceModel.id ?? '');
          },
          // Continue button handler
          onSecondTap: () async {
            // Check if invoice belongs to current event
            if (pendingInvoiceModel.eventId?.id != currentEventDetail?.id) {
              application.showToastAlert('Өөр эвентийн нэхэмжлэх байна.');
              return;
            }

            // Prepare data for payment screen
            Map<String, dynamic> data = simplifyPendingInvoice(pendingInvoiceModel);

            // Delete the old invoice ID
            await deleteInvoice(context, pendingInvoiceModel.id ?? '', doPop: false);
            NavKey.navKey.currentState!.pop();
            // Navigate to payment screen
            NavKey.navKey.currentState!.pushNamed(paymentRoute, arguments: {
              'data': data,
              'event': currentEventDetail,
              'promo': pendingInvoiceModel.promo ?? '',
              'ebarimt': pendingInvoiceModel.ebarimtReceiver ?? ''
            });
          },
          secondButtonText: getTranslated(context, 'buyTxt'),
          firstButtonText: getTranslated(context, 'cancelTxt'),
          invoice: pendingInvoiceModel,
          timeController: _timeController,
          endTime: endTime,
        );
      }

      return true; // Pending invoice found and handled
    }

    // No pending invoice found
    return false;
  }
}
