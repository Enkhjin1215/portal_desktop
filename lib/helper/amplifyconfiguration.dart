const amplifyconfig = '''{
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "IdentityManager": {
          "Default": {}
        },
         "CredentialsProvider": {
   "CognitoIdentity": {
     "Default": {
       "PoolId": "us-east-2_OPL56uNAK",
      "Region": "us-east-2"
     }
  }
 },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "us-east-2_OPL56uNAK",
            "AppClientId": "24h79meo9dgcvuvla2kik4m5m9",
            "Region": "us-east-2"
          }
        },
        "Auth": {
          "Default": {
            "authenticationFlowType": "USER_SRP_AUTH",
            "usernameAttributes": ["email"],
            "signupAttributes": ["email", "name"],
            "passwordProtectionSettings": {
              "passwordPolicyMinLength": 8,
              "passwordPolicyCharacters": []
            }
          },
          "OAuth": {
  "WebDomain": "st-auth.portal.mn",
  "AppClientId": "24h79meo9dgcvuvla2kik4m5m9",
  "SignInRedirectURI": "portalmn://callback/",
  "SignOutRedirectURI": "portalmn://signout/",
  "Scopes": ["openid", "email", "profile"],
  "SignInURI": "https://st-auth.portal.mn/oauth2/authorize",
  "SignOutURI": "https://st-auth.portal.mn/logout",
  "TokenURI": "https://st-auth.portal.mn/oauth2/token",
  "UserInfoURI": "https://st-auth.portal.mn/oauth2/userInfo"

          }
        }
      }
    }
  }
}''';
