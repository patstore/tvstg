import { getPageContent, isCmsContentReady } from '@cms-content';

export { isCmsContentReady };

/** Resolved `data-cms` content for a route path in `lang` (CMS value, falling back to the scanned default). */
export function getContentForPath(pagePath: string, lang: string): Record<string, unknown> {
	return getPageContent(pagePath, lang);
}
