import PassKit
import Flutter
import Foundation

class ApplePayHandler: NSObject {
    private var flutterResult: FlutterResult?
    private var orderId: String?
    private var bearerToken: String?
    private var paymentItems: [PKPaymentSummaryItem] = []
    
    func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.flutterResult = result
        
        switch call.method {
        case "initApplePay":
            handleInitApplePay(call: call)
        case "presentApplePay":
            startApplePay()
        case "testConnection":
            result("Connected to native iOS")
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func handleInitApplePay(call: FlutterMethodCall) {
        guard let args = call.arguments as? [String: Any],
              let orderId = args["orderId"] as? String,
              let bearerToken = args["bearerToken"] as? String,
              let items = args["items"] as? [[String: Any]] else {
            flutterResult?(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
            return
        }
        self.orderId = orderId
        self.bearerToken = bearerToken
        self.paymentItems = items.compactMap {
            guard let label = $0["label"] as? String,
                  let amount = $0["amount"] as? Double else { return nil }
            return PKPaymentSummaryItem(label: label, amount: NSDecimalNumber(value: amount))
        }
        
        flutterResult?(nil)
    }
    
    private func startApplePay() {
        guard PKPaymentAuthorizationController.canMakePayments() else {
            flutterResult?(FlutterError(code: "APPLE_PAY_NOT_AVAILABLE", message: "Apple Pay is not available on this device.", details: nil))
            return
        }
        
        guard PKPaymentAuthorizationController.canMakePayments(usingNetworks: [.masterCard, .visa, .amex]) else {
            flutterResult?(FlutterError(code: "NO_SUPPORTED_CARDS", message: "Apple Pay is not set up with a supported card.", details: nil))
            return
        }
        
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = "merchant.mn.portal.inapp"
        paymentRequest.supportedNetworks = [.masterCard, .visa, .amex]
        paymentRequest.merchantCapabilities = [.threeDSecure]
        paymentRequest.countryCode = "MN"
        paymentRequest.currencyCode = "MNT"
        paymentRequest.paymentSummaryItems = paymentItems
        
        let paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController.delegate = self
        
        paymentController.present { [weak self] success in
            if success {
                print("Payment sheet presented successfully.")
            } else {
                print("Failed to present payment sheet.")
                self?.flutterResult?(FlutterError(code: "PRESENTATION_ERROR", message: "Failed to present payment sheet", details: nil))
            }
        }
    }
    
    private func processPaymentData(_ payment: PKPayment, completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        guard let orderId = self.orderId else {
            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            return
        }
        
        // Create the URL
        let urlString = "https://client.portal.mn/v1/applepay/process/\(orderId)"
        print(urlString)
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            return
        }
        
        // Create the payload
        let jsonPayload = convertPKPaymentToJSON(payment: payment, orderId: orderId)
        
        // Log the payload for debugging
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonPayload, options: .prettyPrinted) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("Payload data: \(jsonString ?? "No payload")")
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Set authorization header if we have a bearer token
        if let bearerToken = self.bearerToken {
            request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
            print("TESTTEST: Bearer \(bearerToken)")
        } else {
            print("No token found")
        }
        
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        // Add the payload as JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonPayload ?? [:], options: [])
        } catch {
            print("Failed to serialize payload: \(error)")
            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            return
        }
        
        // Create and start the task
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            if let error = error {
                print("Payment API Error: \(error.localizedDescription)")
                completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                
                DispatchQueue.main.async {
                    self?.flutterResult?(FlutterError(code: "API_ERROR",
                                                     message: error.localizedDescription,
                                                     details: nil))
                }
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                return
            }
            
            // Process the response
            do {
                let responseObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print("Payment API Response: \(responseObject ?? [:])")
                
                if let success = responseObject?["success"] as? Bool {
                    let status: PKPaymentAuthorizationStatus = success ? .success : .failure
                    completion(PKPaymentAuthorizationResult(status: status, errors: nil))
                    
                    // Send result back to Flutter
                    DispatchQueue.main.async {
                        self?.flutterResult?(responseObject)
                    }
                } else {
                    print("Invalid response format")
                    completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                    
                    DispatchQueue.main.async {
                        self?.flutterResult?(FlutterError(code: "INVALID_RESPONSE",
                                                         message: "Invalid response format from server",
                                                         details: nil))
                    }
                }
            } catch {
                print("Failed to parse response: \(error)")
                completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                
                DispatchQueue.main.async {
                    self?.flutterResult?(FlutterError(code: "PARSE_ERROR",
                                                     message: "Failed to parse server response",
                                                     details: nil))
                }
            }
        }
        
        task.resume()
    }
}

// MARK: - PKPaymentAuthorizationControllerDelegate
extension ApplePayHandler: PKPaymentAuthorizationControllerDelegate {
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController,
                                      didAuthorizePayment payment: PKPayment,
                                      handler: @escaping (PKPaymentAuthorizationResult) -> Void) {
        print("Payment authorized: \(payment.token)")
        print("Payment Network: \(String(describing: payment.token.paymentMethod.network))")
        print("Payment Transaction Identifier: \(payment.token.transactionIdentifier)")
        
        processPaymentData(payment) { result in
            DispatchQueue.main.async {
                handler(result)
            }
        }
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            print("Apple Pay sheet dismissed")
        }
    }
    
    private func convertPKPaymentToJSON(payment: PKPayment, orderId: String) -> [String: Any] {
        var jsonObject: [String: Any] = [:]
        
        // Payment token information
        jsonObject["token"] = [
            "paymentData": convertToJson(data: payment.token.paymentData) ?? [:],
            "transactionIdentifier": payment.token.transactionIdentifier,
            "paymentMethod": [
                "displayName": payment.token.paymentMethod.displayName ?? "",
                "network": payment.token.paymentMethod.network?.rawValue ?? "",
                "type": payment.token.paymentMethod.type == .debit ? "debit" :
                    payment.token.paymentMethod.type == .credit ? "credit" : "unknown"
            ]
        ]
        
        // Billing contact information
        if let billing = payment.billingContact {
            jsonObject["billingContact"] = [
                "givenName": billing.name?.givenName ?? "",
                "familyName": billing.name?.familyName ?? "",
                "emailAddress": billing.emailAddress ?? "",
                "phoneNumber": billing.phoneNumber?.stringValue ?? ""
            ]
        }
        
        // Shipping contact information
        if let shipping = payment.shippingContact {
            jsonObject["shippingContact"] = [
                "givenName": shipping.name?.givenName ?? "",
                "familyName": shipping.name?.familyName ?? "",
                "emailAddress": shipping.emailAddress ?? "",
                "phoneNumber": shipping.phoneNumber?.stringValue ?? ""
            ]
        }
        if let promoValue: Optional = orderId {
            // jsonObject["promo"] = ""
        }
        
        // jsonObject["order_id"] = orderId
        return jsonObject
    }
    
    private func convertToJson(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch {
            print("Failed to convert Data to JSON object: \(error.localizedDescription)")
            return nil
        }
    }
}
