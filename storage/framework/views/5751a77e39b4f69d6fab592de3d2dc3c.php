<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?php echo $__env->yieldContent('title', 'Order Tracking — STEP PROMO'); ?></title>
    <link rel="icon" href="<?php echo e(asset('images/step-promo/step-promo-icon.webp')); ?>">
    <script
        src="<?php echo e(asset('js/flowtrack-image-fallback.js')); ?>?v=<?php echo e(\App\Support\FrontendBuildVersion::current()); ?>"
        data-fallback-src="<?php echo e(asset('images/flowtrack-image-fallback.svg')); ?>"
    ></script>
    <?php echo app('Illuminate\Foundation\Vite')(['resources/css/tracking.css', 'resources/theme/flowtrack/core.css']); ?>
</head>
<body class="ft-tracking-body">
    <header class="ft-track-header">
        <a href="<?php echo e(route('order.track')); ?>" class="ft-track-brand-group">
            <img src="<?php echo e(asset('images/step-promo/step-promo-logo.webp')); ?>" alt="STEP PROMO" class="ft-track-brand-logo">
            <div class="ft-track-brand-divider"></div>
            <span class="ft-track-brand-title">Order tracking</span>
        </a>

        <div class="ft-track-header-actions">
            <a href="<?php echo e(route('login')); ?>" class="ft-track-header-btn">Staff Sign In &rarr;</a>
        </div>
    </header>

    <main class="ft-track-container">
        <?php echo $__env->yieldContent('content'); ?>
    </main>

    <?php echo $__env->yieldPushContent('scripts'); ?>
</body>
</html>
<?php /**PATH C:\xampp\htdocs\FlowTracker-main\FlowTracker-main\resources\views/tracking/layout.blade.php ENDPATH**/ ?>