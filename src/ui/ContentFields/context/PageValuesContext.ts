import type { WebpageStructuredValueEntry } from '@patstore/core';
import { createContext } from 'octane';

/** Raw `page_data` rows for the current page, plus the active route language. */
export const PageValuesContext = createContext<{
	pageData: WebpageStructuredValueEntry[] | null | undefined;
	currentLanguage: string;
}>({ pageData: [], currentLanguage: '' });
