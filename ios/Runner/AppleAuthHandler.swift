import AuthenticationServices
import Flutter
import Foundation

@available(iOS 13.0, *)
class AppleAuthHandler: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private var flutterResult: FlutterResult?
    
    func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.flutterResult = result
        
        switch call.method {
        case "initiateAppleSignIn":
            handleAppleSignIn()
        case "getFederatedToken":
            if let args = call.arguments as? [String: Any], 
               let token = args["token"] as? String {
                handleGetFederatedToken(token: token)
            } else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing token", details: nil))
            }
        case "testAppleAuthConnection":
            result("Connected to Apple Auth iOS")
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func handleAppleSignIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func handleGetFederatedToken(token: String) {
        // This method would handle getting Cognito tokens using the Apple identity token
        // In a "Bring Your Own Identity" scenario, your backend would need to validate the token
        // and return Cognito tokens
        
        // For this example, we'll just pass the Apple token back to Flutter
        flutterResult?(["appleIdToken": token])
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Extract data from the credential
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // Convert identity token to string
            var idToken: String? = nil
            if let tokenData = appleIDCredential.identityToken {
                idToken = String(data: tokenData, encoding: .utf8)
            }
            
            // Prepare result data
            var resultData: [String: Any] = [
                "userIdentifier": userIdentifier,
                "identityToken": idToken ?? "",
            ]
            
            // Add optional data if available
            if let givenName = fullName?.givenName {
                resultData["givenName"] = givenName
            }
            
            if let familyName = fullName?.familyName {
                resultData["familyName"] = familyName
            }
            
            if let email = email {
                resultData["email"] = email
            }
            
            flutterResult?(resultData)
        } else {
            flutterResult?(FlutterError(code: "AUTH_FAILED", message: "Authorization failed", details: nil))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        flutterResult?(FlutterError(code: "AUTH_ERROR", message: error.localizedDescription, details: nil))
    }
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // Get the key window
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return UIApplication.shared.windows.first!
        }
        return window
    }
}