import type { WebpageStructuredValueEntry } from '@patstore/core';
import {
	defaultProjectFilter,
	getCollectionKey,
	graphqlFind,
	isPatStoreConfigured,
	readPatStoreEnv,
} from '@patstore/core';

interface WebpageNode {
	objectId: string;
	path: string;
	[fieldName: string]: unknown;
}

function cmsClassName(): string {
	return import.meta.env.VITE_CMS_CONTENT_CLASS || 'Webpage';
}

function cmsFieldName(): string {
	return import.meta.env.VITE_CMS_CONTENT_FIELD || 'page_data';
}

function cmsSchemaFieldName(): string {
	return import.meta.env.VITE_CMS_CONTENT_SCHEMA_FIELD || 'page_content';
}

/** True when `PREVIEW_ENABLED=true` (see `vite.config.ts`) and the browser-safe PatStore env is present. */
export function isPreviewEnabled(): boolean {
	return Boolean(import.meta.env.PREVIEW_ENABLED) && isPatStoreConfigured();
}

/**
 * Fetches the current page for `pagePath` and returns its raw `page_data` rows.
 * One `Webpage` record holds every locale. Returns `[]` when that record does
 * not exist yet (the static snapshot stays in place until a live payload arrives).
 */
export async function fetchLivePageContent(
	pagePath: string,
): Promise<WebpageStructuredValueEntry[]> {
	const className = cmsClassName();
	const fieldName = cmsFieldName();
	const schemaField = cmsSchemaFieldName();
	const { PROJECT_ID } = readPatStoreEnv();

	const selection = `path\n${schemaField}\n${fieldName} {\n... on Element {\nvalue\n}\n}`;
	const [node] = await graphqlFind<WebpageNode>(className, getCollectionKey(className), selection, {
		params: {
			...defaultProjectFilter(PROJECT_ID),
			path: { equalTo: pagePath },
		},
		first: 1,
	});

	if (!node || !node[fieldName]) {
		return [];
	}

	return node[fieldName] as WebpageStructuredValueEntry[];
}
