import { getDefaultLanguage } from '@provider';
import type { RoutePath } from '@provider';

export interface HeaderNavItem {
	/** Language-agnostic route path, e.g. `/`, `/about`, `/artikel`. */
	path: RoutePath;
	label: string;
}

const NAV_BY_LANGUAGE: Record<string, HeaderNavItem[]> = {
	de: [
		{ path: '/', label: 'Start' },
		{ path: '/about', label: 'Über uns' },
		{ path: '/artikel', label: 'Artikel' },
	],
	en: [
		{ path: '/', label: 'Home' },
		{ path: '/about', label: 'About' },
	],
};

/** Returns the header navigation items configured for `language`. */
export function getHeaderNavItems(language: string): HeaderNavItem[] {
	return NAV_BY_LANGUAGE[language] ?? NAV_BY_LANGUAGE[getDefaultLanguage()] ?? [];
}
