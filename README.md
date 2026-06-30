# Addrevenue - GTM Web Tag Template

A Google Tag Manager web tag template for [Addrevenue](https://addrevenue.io) affiliate tracking. Supports base click tracking on all pages and conversion events on order confirmation.

## Features

- **Base script** - Loads `track.js` on all pages to capture affiliate click parameters from URLs
- **Conversion tracking** - Sends purchase or custom conversion events to Addrevenue
- **Flexible event types** - Supports Purchase, signup, or any custom Conversion Event ID
- **Variable and fixed commissions** - Pass order value for variable programs or custom commission amounts
- **Coupon-based attribution** - Optional discount code field for coupon-based affiliate attribution
- **Product-level data** - Optionally pass an array of product items

## Installation

### Via the Community Template Gallery

1. In your GTM container, go to **Templates** > **Search Gallery**
2. Search for **Addrevenue** and click **Add to workspace**

### Manual Installation

1. Download `template.tpl` from this repository
2. In GTM, go to **Templates** > **New**
3. Click the three-dot menu > **Import**
4. Select the downloaded file

## Setup

### Base Script Tag (required on all pages)

1. Create a new tag using the **Addrevenue** template
2. Set **Action type** to **Base script (all pages)**
3. Set the trigger to **All Pages - Page View**

### Conversion Tag (order confirmation page)

1. Create a new tag using the **Addrevenue** template
2. Set **Action type** to **Conversion event**
3. Fill in the fields:
   - **Conversion Event Name** - Must match your Addrevenue commission program (default: `Purchase`)
   - **Order ID** - Unique transaction/order ID
   - **Order Value** - Order value excluding VAT and shipping (for variable commission programs)
   - **Currency** - ISO 4217 code (e.g. `EUR`, `SEK`, `USD`)
   - **Discount / Coupon Code** - Optional, for coupon-based attribution
   - **Commission Amount** - Optional, for Custom commission programs only
   - **Products** - Optional, GTM variable returning an array of item objects
4. Set the trigger to fire on your purchase/thank-you page

## Field Reference

| Field | Required | Description |
|-------|----------|-------------|
| Action type | Yes | Base script (all pages) or Conversion event |
| Conversion Event Name | Yes (conversion) | Must match Conversion Event ID in your Addrevenue program |
| Order ID | Yes (conversion) | Unique order or transaction identifier |
| Order Value | No | Order value excl. VAT and shipping |
| Currency | No | ISO 4217 currency code |
| Discount / Coupon Code | No | Coupon code for coupon-based attribution |
| Commission Amount | No | Custom commission amount (Custom programs only) |
| Products | No | Array of product objects |

## Permissions

This template requires:

- **Inject Script** - Loads `https://addrevenue.io/track.js`
- **Access Globals** - Reads `ADDREVENUE_scriptLoaded` and executes `ADDREVENUE.sendEvent`
- **Logging** - Debug console logging (only in GTM Preview mode)

## Resources

- [Addrevenue tracking code documentation](https://addrevenue.io/en/trackingCode)
- [Addrevenue GTM setup guide](https://addrevenue.io/app/trackingCodeGTM)

## Author

Created and maintained by [Freek Kampen](https://freekkampen.com) at [New North Digital](https://newnorth.digital/?utm_source=github&utm_medium=referral&utm_campaign=gtm-templates).

## License

Apache 2.0 - see [LICENSE](LICENSE).
