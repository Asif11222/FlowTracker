<?php

namespace App\Http\Controllers;

use App\Services\OrderTrackingService;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class OrderTrackingController extends Controller
{
    public function __construct(
        protected OrderTrackingService $trackingService
    ) {}

    /**
     * Show the manual tracking lookup page.
     */
    public function index(Request $request): View
    {
        return view('tracking.index', [
            'identifier' => (string) $request->query('number', ''),
            'identifierType' => (string) $request->query('type', 'order_number'),
            'email' => (string) $request->query('email', ''),
        ]);
    }

    /**
     * Handle manual lookup submission.
     */
    public function lookup(Request $request): View|RedirectResponse
    {
        $validated = $request->validate([
            'identifier' => ['required', 'string', 'max:100'],
            'email' => ['required', 'string', 'email:rfc,filter', 'max:160'],
            'identifier_type' => ['nullable', 'string', 'in:order_number,reference_number'],
        ]);

        $matches = $this->trackingService->lookup($validated['identifier'], $validated['email']);

        if ($matches->isEmpty()) {
            return back()
                ->withInput()
                ->withErrors([
                    'lookup' => 'We could not find a matching order. Check your number and email address.',
                ]);
        }

        // If exactly one order matched, redirect to its dedicated token tracking page
        if ($matches->count() === 1) {
            $order = $matches->first();
            return redirect()->route('order.track.show', ['token' => $order->ensureTrackingToken()]);
        }

        // If multiple orders match (Rule #4), show disambiguation list
        return view('tracking.multiple', [
            'orders' => $matches,
            'identifier' => $validated['identifier'],
            'email' => $validated['email'],
        ]);
    }

    /**
     * Show tracking dashboard for a given opaque token.
     */
    public function show(string $token): View|RedirectResponse
    {
        $order = $this->trackingService->findByToken($token);

        if (! $order) {
            return redirect()
                ->route('order.track')
                ->withErrors([
                    'lookup' => 'This tracking link is unavailable. Use your order or reference number and email address.',
                ]);
        }

        $trackingData = $this->trackingService->getCustomerTrackingData($order);

        return view('tracking.show', [
            'tracking' => $trackingData,
            'token' => $token,
        ]);
    }
}
