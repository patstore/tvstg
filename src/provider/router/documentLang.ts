import { resolveRouteLanguage } from './language.ts';
import { matchRoute } from '@pages/.generated/routes.ts';

export function resolveDocumentLang(pathname: string): string {
	const match = matchRoute(pathname);
	return resolveRouteLanguage(match?.params, pathname);
}

export function applyDocumentLang(pathname: string): void {
	document.documentElement.lang = resolveDocumentLang(pathname);
}
