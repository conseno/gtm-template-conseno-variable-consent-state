___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Conseno CMP - Consent State",
  "categories": [
    "UTILITY"
  ],
  "description": "This variable can be used with the Conseno CMP (conseno.com) to simplify the use of consent status (either \"granted\" / \"denied\" or true / false) in Google Tag Manager for a selected consent category.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "consentCategory",
    "displayName": "Select the consent status category",
    "selectItems": [
      {
        "value": "analytics",
        "displayValue": "analytics"
      },
      {
        "value": "advertising",
        "displayValue": "advertising"
      },
      {
        "value": "functional",
        "displayValue": "functional"
      },
      {
        "value": "necessary",
        "displayValue": "necessary"
      },
      {
        "value": "custom",
        "displayValue": "custom"
      }
    ],
    "simpleValueType": true,
    "help": "We recommend creating a separate variable for each consent status category (functional, analytics, advertising). This variable will return website visitor\u0027s consent status (either \"granted\" / \"denied\" or true / false) for the selected category. For example, if you select the \u0027analytics\u0027 category from the drop-down, this variable will return the consent status related to the \u0027analytics\u0027 category. A custom category can be used effectively only if you have defined a custom consent category in your Conseno account.",
    "alwaysInSummary": true
  },
  {
    "type": "TEXT",
    "name": "customCategory",
    "displayName": "Custom category name",
    "simpleValueType": true,
    "help": "A custom category can be used effectively only if you have defined a custom consent category in your Conseno account. If it is not correctly defined, it will return \"denied\" or false by default.",
    "enablingConditions": [
      {
        "paramName": "consentCategory",
        "paramValue": "custom",
        "type": "EQUALS"
      }
    ],
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "RADIO",
    "name": "valueType",
    "displayName": "Select the consent status value format",
    "radioItems": [
      {
        "value": "default",
        "displayValue": "\"granted\" / \"denied\""
      },
      {
        "value": "boolean",
        "displayValue": "true / false"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "default",
    "help": "This setting allows you to choose whether this variable returns \u0027granted\u0027/\u0027denied\u0027 or true/false. If the \u0027conseno_consent\u0027 cookie is missing or if the visitor has not yet made a consent decision, the variable will default to \u0027denied\u0027 or false. An exception is made for the \u0027necessary\u0027 category, which will always return \u0027granted\u0027 or true."
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const queryPermission = require('queryPermission');
const getCookieValues = require('getCookieValues');
const JSON = require('JSON');
const cookieName = 'conseno_consent';
const valueType = data.valueType;
let consentCategory = data.consentCategory;

// If the consentCategory is 'necessary', always return 'granted' or true
if (consentCategory === 'necessary') {
  return valueType === "boolean" ? true : 'granted';
}

// Check if permission to get cookies is granted
if (queryPermission('get_cookies', cookieName) !== false) {
  const conseno_cookie = getCookieValues(cookieName);

  // Check if the cookie exists
  if (conseno_cookie && conseno_cookie.length > 0) {
    const conseno_object = JSON.parse(conseno_cookie);
    if (consentCategory === 'custom') {
      consentCategory = data.customCategory;
    }
    for (var i = 0; i < conseno_object.details.length; i++) {
      if (conseno_object.details[i][consentCategory] !== undefined) {
        let consentStatus = conseno_object.details[i][consentCategory];
        // Return boolean value if valueType is "boolean"
        if (valueType === "boolean") {
          return consentStatus === 'granted';
        }
        // Return the actual value if valueType is "default"
        return consentStatus;
      }
    }
  }
}
// Return 'denied' or false depending on valueType if no matching consent found or if the cookie doesn't exist
return valueType === "boolean" ? false : 'denied';


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "cookieNames",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "conseno_consent"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 10/02/2025, 17:41:56


