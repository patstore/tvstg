import { getDefaultLanguage } from '../content/index.ts';
import { matchRoute, normalizeRoutePath, type RouteMatch } from '@pages/.generated/routes.ts';

function stripLangPrefix(path: string, match: RouteMatch): string {
	if (!match.params.lang) {
		return path;
	}

	const prefix = `/${match.params.lang}`;
	if (path === prefix) {
		return '/';
	}
	if (path.startsWith(`${prefix}/`)) {
		return path.slice(prefix.length) || '/';
	}

	return path;
}

/** Strips this route's `$lang` prefix (if any), returning the canonical, language-agnostic page path used to key CMS content (matches `plugins/cms-content`'s manifest paths). */
export function canonicalPagePath(pathname: string): string {
	const path = normalizeRoutePath(pathname);
	const match = matchRoute(path);
	if (!match) {
		return path;
	}
	return stripLangPrefix(path, match);
}

/** Maps the current route to the equivalent URL for `targetLang`. */
export function localizePath(pathname: string, targetLang: string): string {
	const path = normalizeRoutePath(pathname);
	const defaultLang = getDefaultLanguage();
	const match = matchRoute(path);

	if (!match) {
		return targetLang === defaultLang ? '/' : `/${targetLang}`;
	}

	if (path === '/' || match.id === 'index') {
		return targetLang === defaultLang ? '/' : `/${targetLang}`;
	}

	const basePath = stripLangPrefix(path, match);

	if (targetLang === defaultLang) {
		return basePath;
	}

	if (basePath === '/') {
		return `/${targetLang}`;
	}

	return `/${targetLang}${basePath}`;
}

export function isRoutablePath(pathname: string): boolean {
	return matchRoute(normalizeRoutePath(pathname)) !== null;
}

/** Localized URL for `canonicalPath` in `lang`, falling back to `canonicalPath` when no prefixed route exists. */
export function resolveLocalizedPath(canonicalPath: string, lang: string): string {
	const localized = localizePath(canonicalPath, lang);
	return isRoutablePath(localized) ? localized : canonicalPath;
}

/** Whether `currentPath` and `canonicalPath` refer to the same page (ignoring a `$lang` prefix). */
export function isSamePagePath(currentPath: string, canonicalPath: string): boolean {
	return canonicalPagePath(currentPath) === canonicalPagePath(canonicalPath);
}
