@extends('tracking.layout')

@section('title', 'Track Your Order — STEP PROMO')

@section('content')
@php
    $currentTab = old('identifier_type', $identifierType ?? 'order_number');
@endphp
<div class="ft-lookup-layout">
    <div class="ft-lookup-card">
        <h1 class="ft-lookup-title">Track your order</h1>
        <p class="ft-lookup-intro">Check the latest progress of your order.</p>

        @if ($errors->has('lookup'))
            <div class="ft-lookup-error" role="alert">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                <span>{{ $errors->first('lookup') }}</span>
            </div>
        @endif

        <form method="POST" action="{{ route('order.track.lookup') }}">
            @csrf

            <div class="ft-segmented-toggle" role="tablist" aria-label="Search identifier type">
                <button
                    type="button"
                    id="tab-btn-order"
                    class="ft-segmented-btn {{ $currentTab === 'order_number' ? 'active' : '' }}"
                    role="tab"
                    aria-selected="{{ $currentTab === 'order_number' ? 'true' : 'false' }}"
                >
                    Order number
                </button>
                <button
                    type="button"
                    id="tab-btn-reference"
                    class="ft-segmented-btn {{ $currentTab === 'reference_number' ? 'active' : '' }}"
                    role="tab"
                    aria-selected="{{ $currentTab === 'reference_number' ? 'true' : 'false' }}"
                >
                    Reference number
                </button>
            </div>

            <input type="hidden" name="identifier_type" id="identifier_type" value="{{ $currentTab }}">

            <div class="ft-form-field">
                <label for="identifier" id="identifier_label">{{ $currentTab === 'order_number' ? 'Order number' : 'Reference number' }}</label>
                <input
                    id="identifier"
                    name="identifier"
                    type="text"
                    required
                    class="ft-form-input"
                    placeholder="{{ $currentTab === 'order_number' ? 'e.g. FO-337118 or ORDER-00942' : 'e.g. JOB-2026-00109 or NP-2026-0148' }}"
                    value="{{ old('identifier', $identifier ?? '') }}"
                    autofocus
                >
                @error('identifier')
                    <p class="ft-field-error" style="color:#b91c1c;font-size:12px;margin:4px 0 0;">{{ $message }}</p>
                @enderror
            </div>

            <div class="ft-form-field">
                <label for="email">Email address</label>
                <input
                    id="email"
                    name="email"
                    type="email"
                    required
                    class="ft-form-input"
                    placeholder="Email used for this order"
                    value="{{ old('email', $email ?? '') }}"
                >
                @error('email')
                    <p class="ft-field-error" style="color:#b91c1c;font-size:12px;margin:4px 0 0;">{{ $message }}</p>
                @enderror
            </div>

            <button type="submit" class="ft-btn-lookup-submit">Track order</button>

            <p class="ft-lookup-helper-note">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                <span>Enter the email address linked to your order.</span>
            </p>

            <div class="ft-qr-callout-card">
                <div class="ft-qr-callout-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                </div>
                <div class="ft-qr-callout-texts">
                    <h4>Have a QR code?</h4>
                    <p>Scan the QR code on your order confirmation to open tracking directly without signing in.</p>
                </div>
            </div>
        </form>
    </div>

    <div class="ft-lookup-info-side" style="display:flex;flex-direction:column;gap:18px;">
        <div class="ft-track-card" style="padding:32px 36px;">
            <h2 style="font-size:18px;font-weight:750;color:#0f172a;margin:0 0 10px;letter-spacing:-0.2px;">Realtime Promotional Order Tracking</h2>
            <p style="font-size:13.5px;color:#475569;line-height:1.55;margin:0 0 24px;">
                Follow every quote, artwork proof, sample, production milestone and courier delivery from one clear view.
            </p>

            <div style="display:grid;grid-template-columns:repeat(auto-fit, minmax(210px, 1fr));gap:14px;">
                <div style="background:#f8fafc;border:1px solid #e2e8f0;border-radius:10px;padding:16px;">
                    <div style="color:#2d72d9;font-size:13px;font-weight:700;margin-bottom:4px;">01 · New Order</div>
                    <div style="color:#64748b;font-size:12px;line-height:1.4;">Order details received, entered into processing queue, and operational setup initiated.</div>
                </div>
                <div style="background:#f8fafc;border:1px solid #e2e8f0;border-radius:10px;padding:16px;">
                    <div style="color:#7b61c9;font-size:13px;font-weight:700;margin-bottom:4px;">02 · Artwork</div>
                    <div style="color:#64748b;font-size:12px;line-height:1.4;">Instant notice when digital proof is ready for review, revision, or client approval.</div>
                </div>
                <div style="background:#f8fafc;border:1px solid #e2e8f0;border-radius:10px;padding:16px;">
                    <div style="color:#d17b1f;font-size:13px;font-weight:700;margin-bottom:4px;">03 · Production</div>
                    <div style="color:#64748b;font-size:12px;line-height:1.4;">Live production progress, scheduled manufacturing milestones, and fabrication status.</div>
                </div>
                <div style="background:#f8fafc;border:1px solid #e2e8f0;border-radius:10px;padding:16px;">
                    <div style="color:#138d7a;font-size:13px;font-weight:700;margin-bottom:4px;">04 · QC</div>
                    <div style="color:#64748b;font-size:12px;line-height:1.4;">Quality inspection check, specification testing, and packaging sign-off confirmations.</div>
                </div>
                <div style="background:#f8fafc;border:1px solid #e2e8f0;border-radius:10px;padding:16px;">
                    <div style="color:#1873a8;font-size:13px;font-weight:700;margin-bottom:4px;">05 · Shipment</div>
                    <div style="color:#64748b;font-size:12px;line-height:1.4;">Direct courier tracking numbers, package dispatch, and live transit updates.</div>
                </div>
                <div style="background:#f8fafc;border:1px solid #e2e8f0;border-radius:10px;padding:16px;">
                    <div style="color:#b65983;font-size:13px;font-weight:700;margin-bottom:4px;">06 · Billing</div>
                    <div style="color:#64748b;font-size:12px;line-height:1.4;">Commercial invoice delivery, accounting audit, and payment instructions.</div>
                </div>
                <div style="background:#f8fafc;border:1px solid #e2e8f0;border-radius:10px;padding:16px;">
                    <div style="color:#27855a;font-size:13px;font-weight:700;margin-bottom:4px;">07 · Payment</div>
                    <div style="color:#64748b;font-size:12px;line-height:1.4;">Electronic payment confirmation receipts and order financial settlement.</div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
(function () {
    function initTrackingTabs() {
        var btnOrder = document.getElementById('tab-btn-order');
        var btnRef = document.getElementById('tab-btn-reference');
        var inputType = document.getElementById('identifier_type');
        var label = document.getElementById('identifier_label');
        var input = document.getElementById('identifier');

        if (!btnOrder || !btnRef || !inputType || !label || !input) {
            return;
        }

        var config = {
            order_number: {
                label: 'Order number',
                placeholder: 'e.g. FO-337118 or ORDER-00942'
            },
            reference_number: {
                label: 'Reference number',
                placeholder: 'e.g. JOB-2026-00109 or NP-2026-0148'
            }
        };

        function switchTab(type) {
            if (!config[type]) return;

            inputType.value = type;
            label.textContent = config[type].label;
            input.placeholder = config[type].placeholder;

            if (type === 'order_number') {
                btnOrder.classList.add('active');
                btnOrder.setAttribute('aria-selected', 'true');
                btnRef.classList.remove('active');
                btnRef.setAttribute('aria-selected', 'false');
            } else {
                btnRef.classList.add('active');
                btnRef.setAttribute('aria-selected', 'true');
                btnOrder.classList.remove('active');
                btnOrder.setAttribute('aria-selected', 'false');
            }

            input.focus();
        }

        btnOrder.addEventListener('click', function () {
            switchTab('order_number');
        });

        btnRef.addEventListener('click', function () {
            switchTab('reference_number');
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initTrackingTabs);
    } else {
        initTrackingTabs();
    }
})();
</script>
@endpush
