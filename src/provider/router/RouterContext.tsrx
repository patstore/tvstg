import { useCallback, useEffect, useMemo, useRef, useState } from 'octane';
import type { WebpageStructuredValueEntry } from '@patstore/core';
import { fetchLivePageContent, isPreviewEnabled } from '../content/index.ts';
import { PageValuesContext } from '@ui';
import { applyDocumentLang, resolveDocumentLang } from './documentLang.ts';
import { canonicalPagePath } from './localizePath.ts';
import { RouterContext, type RoutePath } from './router.ts';
import cmsContent from '../../../data/cms-content.json';

/** How often to re-poll PatStore for edits while `PREVIEW_ENABLED=true`. */
const PREVIEW_POLL_MS = 5000;

function normalizePath(pathname: string): RoutePath {
	const path = pathname.split('?')[0]?.split('#')[0] ?? '/';
	if (path === '/' || path === '') {
		return '/';
	}
	return path.replace(/\/+$/, '') || '/';
}

function readPageData(canonicalPath: string): WebpageStructuredValueEntry[] {
	const pages = cmsContent.pages as Record<string, WebpageStructuredValueEntry[] | undefined>;
	return pages[canonicalPath] ?? [];
}

/**
 * Synchronous read of the bundled `cms-content.json` snapshot. Used as
 * `useState`'s lazy initializer to avoid a first-paint flash of JSX defaults.
 */
function initialPageValues(): WebpageStructuredValueEntry[] {
	const path = normalizePath(window.location.pathname);
	return readPageData(canonicalPagePath(path));
}

export function RouterProvider(props: { children: unknown }) @{
	const [path, setPath] = useState<RoutePath>(() => normalizePath(window.location.pathname));
	const [pageValues, setPageValues] = useState<WebpageStructuredValueEntry[]>(initialPageValues);
	const contentRef = useRef<HTMLDivElement | null>(null);
	const isAnimating = useRef(false);
	const isFirstContentEffect = useRef(true);

	useEffect(() => {
		const onPopState = () => {
			setPath(normalizePath(window.location.pathname));
		};

		window.addEventListener('popstate', onPopState);
		return () => window.removeEventListener('popstate', onPopState);
	});

	useEffect(() => {
		applyDocumentLang(path);
	}, [path]);

	useEffect(() => {
		// CMS content is keyed by the canonical, language-agnostic page path
		// (e.g. `/`), not the raw URL (`/en`) — `(lang)/` routes collapse
		// multiple URLs onto one canonical path, differentiated by `lang`.
		const contentPath = canonicalPagePath(path);

		// The initial value is already computed synchronously by `useState`'s
		// lazy initializer (`initialPageValues`, above) to avoid a first-paint
		// flash of JSX defaults — skip recomputing/re-setting the identical
		// value here on mount, only react to actual path changes.
		if (isFirstContentEffect.current) {
			isFirstContentEffect.current = false;
		} else {
			setPageValues(readPageData(contentPath));
		}

		if (!isPreviewEnabled()) {
			return;
		}

		// Preview mode: overlay live PatStore content on top, bypassing the
		// static snapshot, and keep polling so CMS edits show up without a
		// rebuild or manual reload while this route stays mounted.
		let cancelled = false;

		const refreshFromCms = () => {
			fetchLivePageContent(contentPath).then((liveContent) => {
				if (!cancelled && liveContent) {
					setPageValues(liveContent);
				}
			}).catch((error) => {
				console.warn(`[cms-preview] live content fetch failed for "${path}":`, error);
			});
		};

		refreshFromCms();
		const interval = window.setInterval(refreshFromCms, PREVIEW_POLL_MS);

		return () => {
			cancelled = true;
			window.clearInterval(interval);
		};
	}, [path]);

	const currentLanguage = useMemo(() => resolveDocumentLang(path), [path]);

	const navigate = useCallback((to: RoutePath) => {
		if (to === path || isAnimating.current) {
			return;
		}

		const element = contentRef.current;
		const parent = element?.parentElement;
		const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
		const commit = () => {
			setPageValues(readPageData(canonicalPagePath(to)));
			history.pushState(null, '', to);
			setPath(to);
		};

		if (!element || !parent || prefersReducedMotion) {
			commit();
			return;
		}

		// uncomment this to use the page transitions

		// isAnimating.current = true;
		// currentPageTransition({
		// 	element,
		// 	commit,
		// 	done: () => {
		// 		isAnimating.current = false;
		// 	},
		// });
		commit();
	}, [path]);

	const routerContextValue = useMemo(() => ({ path, navigate, contentRef }), [
		path,
		navigate,
		contentRef,
	]);

	<RouterContext value={routerContextValue}>
		<PageValuesContext
			value={{ pageData: pageValues, currentLanguage }}
		>{props.children}</PageValuesContext>
	</RouterContext>
}
