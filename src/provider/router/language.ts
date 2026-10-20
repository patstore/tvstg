import { getDefaultLanguage, getProjectLanguages } from '../content/index.ts';
import { normalizeRoutePath } from '@pages/.generated/routes.ts';

/** From `DEFAULT_LANG` in `.env` (injected via Vite `define`). */
export const DEFAULT_LANG = import.meta.env.DEFAULT_LANG;

function languageFromPathname(pathname: string): string | null {
	const languages = getProjectLanguages();
	const firstSegment = normalizeRoutePath(pathname).split('/').filter(Boolean)[0];

	if (firstSegment && languages.includes(firstSegment)) {
		return firstSegment;
	}

	return null;
}

/**
 * Route `params.lang` when the URL has a language prefix; otherwise the first
 * path segment when it matches a project language (e.g. `/en`); otherwise
 * `Project.settings.default_language`.
 */
export function resolveRouteLanguage(
	params: Record<string, string> | undefined,
	pathname?: string,
): string {
	if (params?.lang) {
		return params.lang;
	}

	const resolvedPath =
		pathname ?? (typeof window !== 'undefined' ? window.location.pathname : undefined);

	if (resolvedPath) {
		const fromPath = languageFromPathname(resolvedPath);
		if (fromPath) {
			return fromPath;
		}
	}

	return getDefaultLanguage();
}
