<?php $__env->startSection('title', 'Track Your Order — STEP PROMO'); ?>

<?php $__env->startSection('content'); ?>
<div class="ft-lookup-layout" x-data="{
    tab: '<?php echo e(old('identifier_type', $identifierType ?? 'order_number')); ?>',
    setTab(t) {
        this.tab = t;
    }
}">
    <div class="ft-lookup-card">
        <h1 class="ft-lookup-title">Track your order</h1>
        <p class="ft-lookup-intro">Check the latest progress of your order.</p>

        <?php if(\Livewire\Mechanisms\ExtendBlade\ExtendBlade::isRenderingLivewireComponent()): ?><!--[if BLOCK]><![endif]--><?php endif; ?><?php if($errors->has('lookup')): ?>
            <div class="ft-lookup-error" role="alert">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                <span><?php echo e($errors->first('lookup')); ?></span>
            </div>
        <?php endif; ?><?php if(\Livewire\Mechanisms\ExtendBlade\ExtendBlade::isRenderingLivewireComponent()): ?><!--[if ENDBLOCK]><![endif]--><?php endif; ?>

        <form method="POST" action="<?php echo e(route('order.track.lookup')); ?>">
            <?php echo csrf_field(); ?>

            <div class="ft-segmented-toggle">
                <button
                    type="button"
                    class="ft-segmented-btn"
                    :class="{ 'active': tab === 'order_number' }"
                    x-on:click="setTab('order_number')"
                >
                    Order number
                </button>
                <button
                    type="button"
                    class="ft-segmented-btn"
                    :class="{ 'active': tab === 'reference_number' }"
                    x-on:click="setTab('reference_number')"
                >
                    Reference number
                </button>
            </div>

            <input type="hidden" name="identifier_type" :value="tab">

            <div class="ft-form-field">
                <label for="identifier" x-text="tab === 'order_number' ? 'Order number' : 'Reference number'"></label>
                <input
                    id="identifier"
                    name="identifier"
                    type="text"
                    required
                    class="ft-form-input"
                    :placeholder="tab === 'order_number' ? 'e.g. FO-337118 or ORDER-00942' : 'e.g. JOB-2026-00109 or NP-2026-0148'"
                    value="<?php echo e(old('identifier', $identifier ?? '')); ?>"
                    autofocus
                >
                <?php if(\Livewire\Mechanisms\ExtendBlade\ExtendBlade::isRenderingLivewireComponent()): ?><!--[if BLOCK]><![endif]--><?php endif; ?><?php $__errorArgs = ['identifier'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                    <p class="ft-field-error" style="color:#b91c1c;font-size:12px;margin:4px 0 0;"><?php echo e($message); ?></p>
                <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?><?php if(\Livewire\Mechanisms\ExtendBlade\ExtendBlade::isRenderingLivewireComponent()): ?><!--[if ENDBLOCK]><![endif]--><?php endif; ?>
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
                    value="<?php echo e(old('email', $email ?? '')); ?>"
                >
                <?php if(\Livewire\Mechanisms\ExtendBlade\ExtendBlade::isRenderingLivewireComponent()): ?><!--[if BLOCK]><![endif]--><?php endif; ?><?php $__errorArgs = ['email'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                    <p class="ft-field-error" style="color:#b91c1c;font-size:12px;margin:4px 0 0;"><?php echo e($message); ?></p>
                <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?><?php if(\Livewire\Mechanisms\ExtendBlade\ExtendBlade::isRenderingLivewireComponent()): ?><!--[if ENDBLOCK]><![endif]--><?php endif; ?>
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
<?php $__env->stopSection(); ?>

<?php echo $__env->make('tracking.layout', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH C:\xampp\htdocs\FlowTracker-main\FlowTracker-main\resources\views/tracking/index.blade.php ENDPATH**/ ?>