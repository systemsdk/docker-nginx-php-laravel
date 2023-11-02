<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class LocaleMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param Closure(Request): (Response) $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        if ($this->isLocaleHeader($request)) {
            $locale = $this->getLocaleFromRequest($request);

            !$this->isAvailableLocale($locale)
                ?: app()->setLocale($locale);
        }

        return $next($request);
    }

    private function isLocaleHeader($request): bool
    {
        return isset($request->headers->get('locale')[0]);
    }

    private function isAvailableLocale($locale): bool
    {
        return in_array($locale, config('app.available_locales'));
    }

    private function getLocaleFromRequest($request)
    {
        return $request->headers->get('locale');
    }
}
