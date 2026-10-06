@props(['job'])
@php
    $orderNumber = $job->displayOrderNumber() ?: ($job->job_number ?: $job->order_number ?: 'ORDER-' . $job->id);
    $rawOrderNumber = $job->job_number ?: $job->order_number ?: ('FO-' . $job->id);
    $refNumber = $job->reference_number ?: $rawOrderNumber;
    $trackingUrl = $job->trackingUrl();
    $qrSvg = app(\App\Services\QrCodeService::class)->renderSvg($trackingUrl, 130);
@endphp
<section
    class="section-card ft-order-section-card ft-order-tracking-card"
    x-data="{
        copiedLink: false,
        copiedOrder: false,
        copiedRef: false,
        copyText(text, type) {
            navigator.clipboard.writeText(text).then(() => {
                if (type === 'link') { this.copiedLink = true; setTimeout(() => this.copiedLink = false, 2000); }
                if (type === 'order') { this.copiedOrder = true; setTimeout(() => this.copiedOrder = false, 1500); }
                if (type === 'ref') { this.copiedRef = true; setTimeout(() => this.copiedRef = false, 1500); }
            }).catch(() => {
                const el = document.createElement('textarea');
                el.value = text;
                document.body.appendChild(el);
                el.select();
                document.execCommand('copy');
                document.body.removeChild(el);
                if (type === 'link') { this.copiedLink = true; setTimeout(() => this.copiedLink = false, 2000); }
            });
        }
    }"
>
    <div class="section-head ft-order-section-head">
        <h2>Order tracking</h2>
        <a href="{{ $trackingUrl }}" target="_blank" rel="noopener noreferrer" class="btn small" title="Open customer tracking view" aria-label="Open tracking view">›</a>
    </div>

    <div class="section-body ft-order-tracking-body">
        <div class="ft-qr-preview-container">
            <div class="ft-qr-box">
                {!! $qrSvg !!}
            </div>
            <span class="ft-qr-caption">QR preview</span>
        </div>

        <h3 class="ft-tracking-title">Scan to track this order</h3>

        <div class="ft-tracking-meta-list">
            <div class="ft-tracking-meta-row">
                <span class="ft-meta-label">Order number</span>
                <div class="ft-meta-value-wrap">
                    <span class="ft-meta-value">{{ $rawOrderNumber }}</span>
                    <button
                        type="button"
                        class="ft-copy-mini-btn"
                        x-on:click="copyText('{{ $rawOrderNumber }}', 'order')"
                        title="Copy order number"
                    >
                        <svg x-show="!copiedOrder" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path></svg>
                        <svg x-show="copiedOrder" x-cloak width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#059669" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    </button>
                </div>
            </div>

            <div class="ft-tracking-meta-row">
                <span class="ft-meta-label">Reference number</span>
                <div class="ft-meta-value-wrap">
                    <span class="ft-meta-value">{{ $refNumber }}</span>
                    <button
                        type="button"
                        class="ft-copy-mini-btn"
                        x-on:click="copyText('{{ $refNumber }}', 'ref')"
                        title="Copy reference number"
                    >
                        <svg x-show="!copiedRef" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path></svg>
                        <svg x-show="copiedRef" x-cloak width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#059669" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    </button>
                </div>
            </div>
        </div>

        <p class="ft-tracking-hint">Opens the customer tracking view.</p>

        <div class="ft-tracking-actions">
            <a
                href="{{ $trackingUrl }}"
                target="_blank"
                rel="noopener noreferrer"
                class="ft-btn-tracking-primary"
            >
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg>
                <span>Open tracking</span>
            </a>

            <a
                href="{{ route('orders.qr.download', $job->id) }}"
                download
                class="ft-btn-tracking-secondary"
            >
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg>
                <span>Download QR</span>
            </a>
        </div>

        <div class="ft-tracking-link-wrap">
            <button
                type="button"
                class="ft-copy-link-btn"
                x-on:click="copyText('{{ $trackingUrl }}', 'link')"
            >
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"></path><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"></path></svg>
                <span x-text="copiedLink ? 'Link copied to clipboard!' : 'Copy tracking link'"></span>
            </button>
        </div>
    </div>
</section>

<style>
.ft-order-tracking-card {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
}
.ft-order-tracking-card .ft-order-tracking-body {
    padding: 16px 18px 20px;
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
}
.ft-qr-preview-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-bottom: 12px;
}
.ft-qr-box {
    background: #ffffff;
    border: 1.5px solid #e2e8f0;
    border-radius: 10px;
    padding: 10px;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
    display: flex;
    align-items: center;
    justify-content: center;
    width: 140px;
    height: 140px;
}
.ft-qr-box svg {
    max-width: 100%;
    max-height: 100%;
    height: auto;
    display: block;
}
.ft-qr-caption {
    font-size: 11px;
    color: #94a3b8;
    margin-top: 6px;
    font-weight: 500;
}
.ft-tracking-title {
    font-size: 15px;
    font-weight: 700;
    color: #1e293b;
    margin: 4px 0 14px;
    letter-spacing: -0.2px;
}
.ft-tracking-meta-list {
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 8px;
    margin-bottom: 10px;
}
.ft-tracking-meta-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 100%;
    font-size: 12px;
}
.ft-meta-label {
    color: #64748b;
    font-weight: 500;
}
.ft-meta-value-wrap {
    display: flex;
    align-items: center;
    gap: 6px;
}
.ft-meta-value {
    font-weight: 650;
    color: #0f172a;
    font-family: monospace;
    font-size: 12.5px;
    background: #f1f5f9;
    padding: 2px 7px;
    border-radius: 6px;
    border: 1px solid #e2e8f0;
}
.ft-copy-mini-btn {
    border: none;
    background: transparent;
    cursor: pointer;
    padding: 3px;
    display: flex;
    align-items: center;
    color: #64748b;
    border-radius: 4px;
    transition: background 0.15s ease, color 0.15s ease;
}
.ft-copy-mini-btn:hover {
    background: #e2e8f0;
    color: #0f172a;
}
.ft-tracking-hint {
    font-size: 11.5px;
    color: #94a3b8;
    margin: 4px 0 16px;
}
.ft-tracking-actions {
    display: flex;
    gap: 10px;
    width: 100%;
    margin-bottom: 12px;
}
.ft-btn-tracking-primary {
    flex: 1;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    background: #007a64;
    color: #ffffff !important;
    text-decoration: none;
    font-size: 12.5px;
    font-weight: 600;
    padding: 9px 12px;
    border-radius: 8px;
    transition: background 0.15s ease, transform 0.1s ease;
    box-shadow: 0 1px 2px rgba(0, 122, 100, 0.2);
}
.ft-btn-tracking-primary:hover {
    background: #006653;
}
.ft-btn-tracking-secondary {
    flex: 1;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    background: #ffffff;
    color: #334155 !important;
    text-decoration: none;
    font-size: 12.5px;
    font-weight: 600;
    padding: 9px 12px;
    border: 1px solid #cbd5e1;
    border-radius: 8px;
    transition: background 0.15s ease, border-color 0.15s ease;
}
.ft-btn-tracking-secondary:hover {
    background: #f8fafc;
    border-color: #94a3b8;
}
.ft-tracking-link-wrap {
    margin-top: 2px;
}
.ft-copy-link-btn {
    border: none;
    background: transparent;
    color: #007a64;
    font-size: 12.5px;
    font-weight: 600;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 4px 8px;
    border-radius: 6px;
    transition: background 0.15s ease;
}
.ft-copy-link-btn:hover {
    background: #e6f4f1;
}
</style>
