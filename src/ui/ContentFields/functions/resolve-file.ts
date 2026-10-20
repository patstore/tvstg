import { findByObjectId } from '@data';

type CmsDownloadRecord = {
	objectId: string;
	file?: { url?: string; name?: string };
	title?: string;
};

export interface ResolvedFile {
	url?: string;
	/** Suggested filename for the browser's save dialog — the file's own uploaded filename, when known. */
	filename?: string;
}

export function resolveFile(value: string): ResolvedFile {
	if (
		value.startsWith('/') ||
		value.startsWith('http://') ||
		value.startsWith('https://') ||
		value.startsWith('data:')
	) {
		return { url: value };
	}

	const record = findByObjectId(value) as CmsDownloadRecord | null;
	if (!record?.file?.url) {
		return { url: undefined, filename: undefined };
	}
	return { url: record.file.url, filename: record.title || record.file.name };
}
