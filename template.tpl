___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.

___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Addrevenue",
  "categories": ["AFFILIATE_MARKETING", "CONVERSIONS"],
  "brand": {
    "id": "brand_dummy",
    "displayName": "New North Digital",
    "thumbnail": ""
  },
  "description": "Addrevenue affiliate tracking. Loads the base script on all pages and sends conversion events (Purchase, signup, or custom) on order confirmation.",
  "containerContexts": ["WEB"]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "actionType",
    "displayName": "Action type",
    "macrosInSelect": false,
    "selectItems": [
      {"value": "base", "displayValue": "Base script (all pages)"},
      {"value": "conversion", "displayValue": "Conversion event"}
    ],
    "simpleValueType": true,
    "help": "Base script fires on all pages to capture affiliate clicks from URL parameters. Conversion event fires on the order confirmation / thank-you page."
  },
  {
    "type": "TEXT",
    "name": "eventName",
    "displayName": "Conversion Event Name",
    "simpleValueType": true,
    "defaultValue": "Purchase",
    "help": "The event name must match the Conversion Event ID configured in your Addrevenue commission program (e.g. Purchase, My signup).",
    "valueValidators": [{"type": "NON_EMPTY"}],
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "TEXT",
    "name": "orderId",
    "displayName": "Order ID",
    "simpleValueType": true,
    "help": "Unique order or transaction ID. Required for all conversion events.",
    "valueValidators": [{"type": "NON_EMPTY"}],
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "TEXT",
    "name": "orderValue",
    "displayName": "Order Value (optional)",
    "simpleValueType": true,
    "help": "Order value excluding VAT and excluding shipping. Required for variable commission programs.",
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "TEXT",
    "name": "currency",
    "displayName": "Currency (optional)",
    "simpleValueType": true,
    "help": "Three-letter ISO 4217 currency code (e.g. EUR, SEK, USD).",
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "TEXT",
    "name": "discountCodes",
    "displayName": "Discount / Coupon Code (optional)",
    "simpleValueType": true,
    "help": "Discount or coupon code used in the order. Used by Addrevenue to attribute conversions via coupon-based tracking.",
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "TEXT",
    "name": "commissionAmount",
    "displayName": "Commission Amount (optional)",
    "simpleValueType": true,
    "help": "Custom commission amount for programs of type Custom. Overrides automatic commission calculation.",
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "TEXT",
    "name": "products",
    "displayName": "Products (optional)",
    "simpleValueType": true,
    "help": "A GTM variable returning an array of product/item objects for the order.",
    "enablingConditions": [{"paramName": "actionType", "paramValue": "conversion", "type": "EQUALS"}]
  },
  {
    "type": "GROUP",
    "name": "debugging",
    "displayName": "Debugging",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {"type": "CHECKBOX", "name": "debug", "checkboxText": "Log debug messages to console", "simpleValueType": true}
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

var log = require('logToConsole');
var injectScript = require('injectScript');
var callInWindow = require('callInWindow');
var copyFromWindow = require('copyFromWindow');
var makeString = require('makeString');
var makeNumber = require('makeNumber');
var getType = require('getType');

var enableDebug = data.debug;
var debugLog = function(msg) {
  if (enableDebug) log('Addrevenue GTM - ' + msg);
};

var scriptUrl = 'https://addrevenue.io/track.js';
var actionType = data.actionType;

debugLog('Action: ' + actionType);

if (actionType === 'base') {
  injectScript(scriptUrl, function() {
    debugLog('Base script loaded');
    data.gtmOnSuccess();
  }, function() {
    debugLog('Base script failed to load');
    data.gtmOnFailure();
  }, 'addrevenue-base');

} else if (actionType === 'conversion') {
  var eventName = makeString(data.eventName || 'Purchase');
  var eventData = {};

  eventData.orderId = makeString(data.orderId);

  if (data.orderValue) {
    eventData.value = makeNumber(data.orderValue);
  }
  if (data.currency) {
    eventData.currency = makeString(data.currency);
  }
  if (data.discountCodes) {
    eventData.discountCodes = makeString(data.discountCodes);
  }
  if (data.commissionAmount) {
    eventData.commissionAmount = makeNumber(data.commissionAmount);
  }
  if (data.products && getType(data.products) === 'array') {
    eventData.products = data.products;
  }

  debugLog('Event: ' + eventName + ', Order: ' + eventData.orderId);

  var loaded = copyFromWindow('ADDREVENUE_scriptLoaded');
  if (loaded) {
    debugLog('Script already loaded, sending event directly');
    callInWindow('ADDREVENUE.sendEvent', eventName, eventData);
    data.gtmOnSuccess();
  } else {
    injectScript(scriptUrl, function() {
      debugLog('Script loaded, sending event');
      callInWindow('ADDREVENUE.sendEvent', eventName, eventData);
      data.gtmOnSuccess();
    }, function() {
      debugLog('Script failed to load');
      data.gtmOnFailure();
    }, 'addrevenue-conversion');
  }

} else {
  debugLog('Unknown action type');
  data.gtmOnFailure();
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "vpiVersion": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://addrevenue.io/track.js*"
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
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "vpiVersion": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ADDREVENUE_scriptLoaded"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ADDREVENUE.sendEvent"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
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
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "vpiVersion": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
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

scenarios:
- name: "Base script loads successfully on all pages"
  code: |-
    var mockData = {
      actionType: 'base',
      debug: false
    };

    mock('injectScript', function(url, success, failure, token) {
      success();
    });

    runCode(mockData);

    assertApi('gtmOnSuccess').wasCalled();

- name: "Conversion event with full order data"
  code: |-
    var mockData = {
      actionType: 'conversion',
      eventName: 'Purchase',
      orderId: 'ORD-12345',
      orderValue: '319.20',
      currency: 'SEK',
      discountCodes: 'SUMMER10',
      commissionAmount: '',
      products: [],
      debug: false
    };

    mock('copyFromWindow', function(key) {
      return false;
    });

    mock('injectScript', function(url, success, failure, token) {
      success();
    });

    mock('callInWindow', function() {
      return undefined;
    });

    runCode(mockData);

    assertApi('gtmOnSuccess').wasCalled();

- name: "Conversion event when base script is already loaded"
  code: |-
    var mockData = {
      actionType: 'conversion',
      eventName: 'Purchase',
      orderId: 'ORD-99999',
      orderValue: '50.00',
      currency: 'EUR',
      discountCodes: '',
      commissionAmount: '',
      debug: true
    };

    mock('copyFromWindow', function(key) {
      if (key === 'ADDREVENUE_scriptLoaded') return true;
      return undefined;
    });

    mock('callInWindow', function() {
      return undefined;
    });

    runCode(mockData);

    assertApi('gtmOnSuccess').wasCalled();

- name: "Script failure calls gtmOnFailure"
  code: |-
    var mockData = {
      actionType: 'base',
      debug: false
    };

    mock('injectScript', function(url, success, failure, token) {
      failure();
    });

    runCode(mockData);

    assertApi('gtmOnFailure').wasCalled();

- name: "Custom conversion event with commission amount"
  code: |-
    var mockData = {
      actionType: 'conversion',
      eventName: 'My signup',
      orderId: 'SIGNUP-001',
      orderValue: '200.00',
      currency: 'SEK',
      discountCodes: '',
      commissionAmount: '83.88',
      debug: false
    };

    mock('copyFromWindow', function(key) {
      return false;
    });

    mock('injectScript', function(url, success, failure, token) {
      success();
    });

    mock('callInWindow', function() {
      return undefined;
    });

    runCode(mockData);

    assertApi('gtmOnSuccess').wasCalled();


___NOTES___

Created on 2026-04-04 by New North Digital (newnorth.digital).
