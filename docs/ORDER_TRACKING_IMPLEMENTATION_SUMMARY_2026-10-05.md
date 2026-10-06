# Order Tracking System — Technical Implementation & Operational Guide

**Date:** October 5, 2026  
**Status:** Completed & Verified  
**Test Suite:** `Tests\Feature\OrderTrackingTest` (9 tests, 47 assertions passing)  
**Reference Source:** `Sample_image/` & `Order-Tracking-Status-Map.xlsx`  

---

## 1. Executive Summary

This document describes the complete technical implementation of **Internal and External Order Tracking** for FlowTrack. The system provides:

1. **Internal Staff Tracking Card:** Embedded into the internal Order Details page (`/jobs/{id}`), displaying a high-contrast vector SVG QR code, pill tags with one-click copy buttons for both Order and Reference numbers, direct "Open tracking" link, downloadable vector QR code SVG, and instant tracking link clipboard copy with visual feedback.
2. **External Public Customer Tracking Portal:** A responsive, modern customer experience matching Step Promo brand aesthetics, accessible via opaque, unguessable 32-character tokens (`/track/{token}`) or manual lookup (`/track`).
3. **Strict Customer Data Redaction:** Complete stripping of internal staff names, internal notes, supplier costs, and recipient street addresses, preventing data leakage.
4. **Anti-Enumeration Security:** Rate-limited lookup (`throttle:10,1`) with generic error copy that prevents malicious discovery of valid orders or customer email addresses.
5. **Canonical 7-Stage State Machine:** Fully mapped against FlowTrack operational workflow tasks and statuses into 7 clean customer stages with 3 independent metrics (Delivery, Billing, Payment).

---

## 2. Architecture & Design Decisions

### 2.1 Dual Token Architecture (Internal ID vs Opaque Token)
- **Problem:** Exposing database primary keys (`/track/125`) or sequential order numbers allows scrapers or competitors to iterate through all company orders.
- **Solution:** Every `FlowJob` receives a cryptographically secure 32-character alphanumeric random token (`tracking_token`).
- Public URLs strictly use `/track/{token}`.
- Database has a composite index on `['job_number', 'tracking_token']` for sub-millisecond retrieval.

### 2.2 Anti-Enumeration Lookup (Rule #5)
- External lookup requires both an **Identifier** (Order number or Client Reference number) AND the **Client Email**.
- Queries verify matches against both primary `client.email` and `client_delivery_contacts.email` (case-insensitive).
- **Security Rule:** If an order does not exist or the email does not match, the response **must never** disclose whether the order or email exists. It displays:
  > *"We could not find a matching order. Check your number and email address."*
- Rate limiting is enforced via Laravel's `throttle:10,1` middleware (maximum 10 attempts per minute per IP).

### 2.3 The 7 Canonical Stages vs 3 Independent Metrics (Rule #12)
- **7 Stepper Stages:**
  1. `New Order` (Blue `#2563eb`)
  2. `Artwork` (Purple `#9333ea`)
  3. `Production` (Amber/Orange `#f97316`)
  4. `QC` (Emerald `#059669`)
  5. `Shipment` (Cyan/Sky `#0284c7`)
  6. `Billing` (Pink `#db2777`)
  7. `Payment` (Green `#10b981`)
- **3 Independent Metrics:**
  - `Delivery`: *Preparing / Dispatched / In Transit / Out for Delivery / Delivered*
  - `Billing`: *Upcoming / Preparing invoice / Invoice sent*
  - `Payment`: *Upcoming / Awaiting payment / Payment received*
  - *Critical Rule:* Progress in Billing/Payment never overwrites or resets the Delivery progress summary.

### 2.4 Vector SVG QR Code Engine
- Uses `chillerlan/php-qrcode` (v6.0) configured with `QRMarkupSVG`.
- Outputs clean vector XML without server-side file writes, GD extension dependencies, or external API calls.
- Rendered inline in Blade templates for zero latency, and streamed as an attachment via `GET /orders/{job}/qr-code/download` for print/export.

### 2.5 Stage Synchronization with FlowTrack Internal Runtime (`OrderStageResolver`)
- **Challenge:** FlowTrack orders can be assigned historical or snapshot workflow phases (e.g. `Order Intake`, `Swatch / Sample`, `Invoice & Payment`, or sequence IDs > 7).
- **Solution:** `OrderTrackingService::determineCurrentStageNumber()` delegates directly to `App\Support\OrderStageResolver::resolve()`.
- **Result:** The 7 stage cards in the internal Orders dashboard (`STAGE 1 New Order`, `STAGE 2 Artwork`, `STAGE 3 Production`, `STAGE 4 QC`, `STAGE 5 Shipment`, `STAGE 6 Billing`, `STAGE 7 Payment`) match the customer tracking portal's active stage with 0 mismatches across all active database orders.

---

## 3. Database Schema Changes

### Migration: `2026_10_05_190000_add_tracking_token_to_flow_jobs_table.php`
```sql
ALTER TABLE `flow_jobs` 
  ADD `tracking_token` VARCHAR(64) NULL AFTER `order_number`,
  ADD `tracking_token_created_at` DATETIME NULL AFTER `tracking_token`,
  ADD INDEX `flow_jobs_job_number_tracking_token_idx` (`job_number`, `tracking_token`);
```
- Existing rows are backfilled with random 32-character tokens.
- Future orders auto-generate the token via `FlowJob::booted()` on creation.

---

## 4. File Manifest & Key Implementations

### Backend Services & Controllers
| File | Responsibility |
|---|---|
| [`app/Services/OrderTrackingService.php`](file:///c:/xampp/htdocs/FlowTracker-main/FlowTracker-main/app/Services/OrderTrackingService.php) | Central 27-state mapping, 7-stage resolver, 3-metric compiler, carrier auto-detection, and data redaction. |
| [`app/Services/QrCodeService.php`](file:///c:/xampp/htdocs/FlowTracker-main/FlowTracker-main/app/Services/QrCodeService.php) | Vector SVG generator for inline display (`renderSvg`) and file download (`downloadSvg`). |
| [`app/Http/Controllers/OrderTrackingController.php`](file:///c:/xampp/htdocs/FlowTracker-main/FlowTracker-main/app/Http/Controllers/OrderTrackingController.php) | Public routes: `index()` (lookup form), `lookup()` (anti-enumeration check), and `show()` (token dashboard). |
| [`app/Http/Controllers/OrderQrCodeController.php`](file:///c:/xampp/htdocs/FlowTracker-main/FlowTracker-main/app/Http/Controllers/OrderQrCodeController.php) | Staff route: streams SVG QR file download with proper attachment headers. |
| [`app/Models/FlowJob.php`](file:///c:/xampp/htdocs/FlowTracker-main/FlowTracker-main/app/Models/FlowJob.php) | Added `tracking_token` auto-generation, `ensureTrackingToken()`, `trackingUrl()`, and `reference_number` accessor. |

### Blade Views & Components
| File | Description |
|---|---|
| [`resources/views/components/jobs/order-detail/tracking.blade.php`](file:///c:/xampp/htdocs/FlowTracker-main/FlowTracker-main/resources/views/components/jobs/order-detail/tracking.blade.php) | Internal sidebar card with QR box, order & reference pills, copy actions, open tracking, and download buttons. |
| [`resources/views/components/jobs/detail-overview.blade.php`](file:///c:/xampp/htdocs/FlowTracker-main/FlowTracker-main/resources/views/components/jobs/detail-overview.blade.php) | Placed tracking sidebar component directly between Planning and Shipping cards. |
| [`resources/views/auth/login.blade.php`](file:///c:/xampp/htdocs/FlowTracker-main/FlowTracker-main/resources/views/auth/login.blade.php) | Added public entry point *"Just checking an order? Track your order →"* below the sign-in form. |
| [`resources/views/tracking/layout.blade.php`](file:///c:/xampp/htdocs/FlowTracker-main/FlowTracker-main/resources/views/tracking/layout.blade.php) | Step Promo responsive branded public shell. |
| [`resources/views/tracking/index.blade.php`](file:///c:/xampp/htdocs/FlowTracker-main/FlowTracker-main/resources/views/tracking/index.blade.php) | Manual lookup form with segmented Order/Reference number switch and *"Have a QR code?"* callout. |
| [`resources/views/tracking/show.blade.php`](file:///c:/xampp/htdocs/FlowTracker-main/FlowTracker-main/resources/views/tracking/show.blade.php) | Public order tracking dashboard: Hero banner, 3 metrics, 7-stage interactive stepper, live updates timeline, courier shipment card, *"What happens next?"* CTA card, and bottom banner. |
| [`resources/views/tracking/multiple.blade.php`](file:///c:/xampp/htdocs/FlowTracker-main/FlowTracker-main/resources/views/tracking/multiple.blade.php) | Disambiguation view when multiple orders match the provided reference number and email. |

### Styling & Routing
| File | Description |
|---|---|
| [`resources/css/tracking.css`](file:///c:/xampp/htdocs/FlowTracker-main/FlowTracker-main/resources/css/tracking.css) | Custom styling for public tracking layout, stepper cards, timeline, hero banners, and mobile responsiveness. |
| [`resources/css/login.css`](file:///c:/xampp/htdocs/FlowTracker-main/FlowTracker-main/resources/css/login.css) | Styling for the tracking link below the login box. |
| [`vite.config.js`](file:///c:/xampp/htdocs/FlowTracker-main/FlowTracker-main/vite.config.js) | Registered `resources/css/tracking.css` for production Vite compilation. |
| [`routes/web.php`](file:///c:/xampp/htdocs/FlowTracker-main/FlowTracker-main/routes/web.php) | Registered `/track`, `/track/lookup`, `/track/{token}`, and `/orders/{job}/qr-code/download`. |

---

## 5. Web Routes

```php
// Public Order Tracking
Route::get('/track', [OrderTrackingController::class, 'index'])->name('order.track');
Route::post('/track/lookup', [OrderTrackingController::class, 'lookup'])
    ->middleware('throttle:10,1')
    ->name('order.track.lookup');
Route::get('/track/{token}', [OrderTrackingController::class, 'show'])->name('order.track.show');

// Internal Staff QR Code Download
Route::middleware(['auth', 'verified'])->group(function () {
    Route::get('/orders/{job}/qr-code/download', [OrderQrCodeController::class, 'download'])
        ->name('orders.qr.download');
});
```

---

## 6. Verification & Automated Test Suite

A comprehensive test suite is located at [`tests/Feature/OrderTrackingTest.php`](file:///c:/xampp/htdocs/FlowTracker-main/FlowTracker-main/tests/Feature/OrderTrackingTest.php).

### Test Coverage:
1. `test_login_page_renders_track_order_entry_point`: Verifies the login page contains the tracking link to `/track`.
2. `test_tracking_lookup_page_renders_successfully`: Verifies `/track` returns 200 with segmented tabs and QR instructions.
3. `test_invalid_lookup_returns_anti_enumeration_error`: Verifies invalid number/email combinations return the exact required anti-enumeration error.
4. `test_valid_lookup_redirects_to_token_dashboard`: Verifies matching identifier + email redirects to `/track/{token}`.
5. `test_tracking_dashboard_renders_7_stages_and_3_metrics`: Verifies the customer view contains all 7 stages, 3 metrics, and order details.
6. `test_invalid_token_redirects_to_lookup`: Verifies tampering with tracking token redirects cleanly to `/track`.
7. `test_download_qr_code_returns_svg`: Verifies authorized staff can download raw vector SVG with correct headers.
8. `test_disambiguation_view_renders_when_multiple_orders_match`: Verifies that multiple orders sharing a reference number show the disambiguation selector.
9. `test_customer_tracking_redacts_sensitive_internal_fields`: Verifies internal staff notes and street addresses are never rendered in public tracking HTML.

### Test Execution Output:
```bash
$ php artisan test --filter=OrderTrackingTest

PASS  Tests\Feature\OrderTrackingTest
✓ login page renders track order entry point
✓ tracking lookup page renders successfully
✓ invalid lookup returns anti enumeration error
✓ valid lookup redirects to token dashboard
✓ tracking dashboard renders 7 stages and 3 metrics
✓ invalid token redirects to lookup
✓ download qr code returns svg
✓ disambiguation view renders when multiple orders match
✓ customer tracking redacts sensitive internal fields

Tests:    9 passed (47 assertions)
Duration: 1.87s
```

---

## 7. Operational URLs
- **Sign-in Page with Tracking Entry Point:** `http://localhost:8000/login`
- **Public Order Lookup:** `http://localhost:8000/track`
- **Sample Live Customer Tracking:** `http://localhost:8000/track/JMA5akPXRYrwyLtx795sWfW3wnTopTRI`
