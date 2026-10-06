@extends('tracking.layout')

@section('title', 'Order ' . $tracking['order_number'] . ' — Tracking')

@section('content')
<div class="ft-track-card">
    <div class="ft-track-topbar">
        <div class="ft-order-header-left">
            <div class="ft-order-title-row">
                <h1 class="ft-order-title">Order {{ $tracking['order_number'] }}</h1>
                @if ($tracking['is_sample'])
                    <span class="ft-sample-badge">Sample order</span>
                @endif
            </div>
            <div class="ft-order-subtitle">
                Reference: <span>{{ $tracking['reference_number'] }}</span> &nbsp;|&nbsp; Last updated: <span>{{ $tracking['last_updated'] }}</span>
            </div>
        </div>

        <a href="{{ route('order.track') }}" class="ft-track-another-link" style="padding:4px 8px;">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
            <span>New search</span>
        </a>
    </div>

    {{-- Hero Status Banner --}}
    <div class="ft-hero-banner {{ $tracking['hero']['badge_color'] ?? 'teal' }}">
        <div class="ft-hero-left">
            <div class="ft-hero-icon-wrap">
                @if (($tracking['hero']['icon'] ?? '') === 'truck')
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>
                @elseif (($tracking['hero']['icon'] ?? '') === 'settings')
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg>
                @elseif (($tracking['hero']['icon'] ?? '') === 'edit-3')
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg>
                @elseif (($tracking['hero']['icon'] ?? '') === 'search')
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                @elseif (($tracking['hero']['icon'] ?? '') === 'file-text')
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                @elseif (($tracking['hero']['icon'] ?? '') === 'credit-card')
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect><line x1="1" y1="10" x2="23" y2="10"></line></svg>
                @elseif (($tracking['hero']['icon'] ?? '') === 'alert-triangle' || ($tracking['hero']['icon'] ?? '') === 'alert-circle')
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#d97706" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                @else
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                @endif
            </div>

            <div class="ft-hero-content">
                <div class="ft-hero-badge-wrap">
                    <span class="ft-hero-badge">{{ $tracking['hero']['badge'] }}</span>
                </div>
                <p class="ft-hero-message">{{ $tracking['hero']['message'] }}</p>
            </div>
        </div>

        {{-- 3 Independent Status Metrics --}}
        <div class="ft-independent-metrics">
            <div class="ft-metric-item">
                <div class="ft-metric-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>
                </div>
                <div class="ft-metric-texts">
                    <span class="ft-metric-label">Delivery</span>
                    <span class="ft-metric-status">{{ $tracking['metrics']['delivery']['status'] }}</span>
                </div>
            </div>

            <div class="ft-metric-item">
                <div class="ft-metric-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line></svg>
                </div>
                <div class="ft-metric-texts">
                    <span class="ft-metric-label">Billing</span>
                    <span class="ft-metric-status">{{ $tracking['metrics']['billing']['status'] }}</span>
                </div>
            </div>

            <div class="ft-metric-item">
                <div class="ft-metric-icon">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect><line x1="1" y1="10" x2="23" y2="10"></line></svg>
                </div>
                <div class="ft-metric-texts">
                    <span class="ft-metric-label">Payment</span>
                    <span class="ft-metric-status">{{ $tracking['metrics']['payment']['status'] }}</span>
                </div>
            </div>
        </div>
    </div>

    {{-- 7-Stage Horizontal Stepper --}}
    <div class="ft-stepper-grid">
        @foreach ($tracking['stepper'] as $step)
            <div class="ft-step-card {{ $step['state'] }}" style="--step-color: {{ $step['color'] }};">
                <div class="ft-step-card-head">
                    <span class="ft-step-num">STAGE {{ $step['number'] }}</span>
                    @if ($step['is_completed'])
                        <div class="ft-step-check">
                            <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        </div>
                    @elseif ($step['is_current'])
                        <div class="ft-step-pulse"></div>
                    @endif
                </div>

                <div class="ft-step-title">{{ $step['name'] }}</div>
                <div class="ft-step-status-text">{{ $step['status_text'] }}</div>

                <div class="ft-step-bottom-bar"></div>
            </div>
        @endforeach
    </div>

    {{-- Two-Column Content Grid --}}
    <div class="ft-track-content-grid">
        {{-- Left: Live Updates Timeline --}}
        <div class="ft-timeline-card">
            <h2 class="ft-card-heading">Order updates</h2>
            <p class="ft-card-subheading">Live updates for your order.</p>

            <div class="ft-timeline-list">
                @forelse ($tracking['timeline'] as $event)
                    <div class="ft-timeline-item">
                        <div class="ft-timeline-dot {{ $event['is_latest'] ? 'latest' : '' }}"></div>

                        <div class="ft-timeline-time-col">
                            <span class="ft-timeline-date">{{ $event['date'] }}</span>
                            <span class="ft-timeline-time">{{ $event['time'] }}</span>
                        </div>

                        <div class="ft-timeline-desc-col">
                            <h3 class="ft-timeline-title">{{ $event['title'] }}</h3>
                            <p class="ft-timeline-desc">{{ $event['description'] }}</p>
                        </div>
                    </div>
                @empty
                    <div style="font-size:13px;color:#64748b;padding:12px 0;">No updates recorded yet.</div>
                @endforelse
            </div>
        </div>

        {{-- Right: Shipment Details / Next Steps --}}
        <div class="ft-side-cards-stack">
            @if (!empty($tracking['shipment']) && $tracking['shipment']['has_shipment'])
                <div class="ft-shipment-card">
                    <h2 class="ft-card-heading">Shipment details</h2>
                    <p class="ft-card-subheading">Track your shipment with the courier.</p>

                    <div class="ft-shipment-row">
                        <span class="ft-shipment-label">Courier</span>
                        <span class="ft-shipment-val">{{ $tracking['shipment']['courier'] }}</span>
                    </div>

                    <div class="ft-shipment-row">
                        <span class="ft-shipment-label">Tracking number</span>
                        <span class="ft-shipment-val">{{ $tracking['shipment']['tracking_number'] }}</span>
                    </div>

                    @if ($tracking['shipment']['tracking_url'])
                        <a href="{{ $tracking['shipment']['tracking_url'] }}" target="_blank" rel="noopener noreferrer" class="ft-btn-track-courier">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg>
                            <span>Track shipment</span>
                        </a>
                    @endif
                </div>
            @endif

            {{-- Contextual Next Step / Approval CTA Card --}}
            @if (!empty($tracking['next_step']))
                <div class="ft-action-cta-card {{ $tracking['next_step']['type'] === 'info' ? 'info' : '' }}">
                    <div class="ft-cta-header">
                        @if ($tracking['next_step']['type'] === 'action')
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                        @elseif ($tracking['next_step']['type'] === 'completed')
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#10b981" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        @else
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                        @endif
                        <span>{{ $tracking['next_step']['title'] }}</span>
                    </div>

                    <p class="ft-cta-body">{{ $tracking['next_step']['description'] }}</p>

                    @if (!empty($tracking['next_step']['subtext']))
                        <p style="font-size:12px;color:#64748b;margin:0;">{{ $tracking['next_step']['subtext'] }}</p>
                    @endif

                    @if (!empty($tracking['next_step']['action_label']) && !empty($tracking['next_step']['action_url']))
                        <a href="{{ $tracking['next_step']['action_url'] }}" class="ft-btn-cta">
                            {{ $tracking['next_step']['action_label'] }} &rarr;
                        </a>
                    @endif
                </div>
            @endif
        </div>
    </div>

    {{-- Bottom Explanatory Banner --}}
    @if (!empty($tracking['banner']))
        <div class="ft-bottom-banner">
            <div class="ft-bottom-banner-icon">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line></svg>
            </div>
            <div class="ft-bottom-banner-texts">
                <h3 class="ft-bottom-banner-title">{{ $tracking['banner']['title'] }}</h3>
                <p class="ft-bottom-banner-desc">{{ $tracking['banner']['message'] }}</p>
            </div>
        </div>
    @endif

    {{-- Footer Actions --}}
    <div class="ft-track-footer">
        <a href="{{ route('order.track') }}" class="ft-track-another-link">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="1 4 1 10 7 10"></polyline><path d="M3.51 15a9 9 0 1 0 2.13-9.36L1 10"></path></svg>
            <span>Track another order</span>
        </a>
    </div>
</div>
@endsection
