<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>@yield('title', 'Order Tracking — STEP PROMO')</title>
    <link rel="icon" href="{{ asset('images/step-promo/step-promo-icon.webp') }}">
    <script
        src="{{ asset('js/flowtrack-image-fallback.js') }}?v={{ \App\Support\FrontendBuildVersion::current() }}"
        data-fallback-src="{{ asset('images/flowtrack-image-fallback.svg') }}"
    ></script>
    @vite(['resources/css/tracking.css', 'resources/theme/flowtrack/core.css'])
</head>
<body class="ft-tracking-body">
    <header class="ft-track-header">
        <a href="{{ route('order.track') }}" class="ft-track-brand-group">
            <img src="{{ asset('images/step-promo/step-promo-logo.webp') }}" alt="STEP PROMO" class="ft-track-brand-logo">
            <div class="ft-track-brand-divider"></div>
            <span class="ft-track-brand-title">Order tracking</span>
        </a>

        <div class="ft-track-header-actions">
            <a href="{{ route('login') }}" class="ft-track-header-btn">Staff Sign In &rarr;</a>
        </div>
    </header>

    <main class="ft-track-container">
        @yield('content')
    </main>

    @stack('scripts')
</body>
</html>
