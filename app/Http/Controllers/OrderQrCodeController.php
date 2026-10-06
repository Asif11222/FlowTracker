<?php

namespace App\Http\Controllers;

use App\Models\FlowJob;
use App\Services\QrCodeService;
use Illuminate\Http\Response;

class OrderQrCodeController extends Controller
{
    public function download(FlowJob $job, QrCodeService $qrService): Response
    {
        $url = $job->trackingUrl();
        $svg = $qrService->downloadSvg($url);
        $filename = 'order-' . ($job->job_number ?: $job->order_number ?: $job->id) . '-qr.svg';

        return response($svg, 200, [
            'Content-Type' => 'image/svg+xml',
            'Content-Disposition' => 'attachment; filename="' . $filename . '"',
            'Cache-Control' => 'no-cache, private',
        ]);
    }
}
