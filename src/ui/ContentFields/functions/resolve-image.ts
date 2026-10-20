import { findByObjectId } from '@data';

type CmsImageRecord = {
	file?: { url?: string } | null;
	file_local?: string | string[] | null;
};

/** A stored value that is already a path or URL, not an `Image` objectId. */
export function isDirectImageSrc(value: string): boolean {
	return (
		value.startsWith('/') ||
		value.startsWith('http://') ||
		value.startsWith('https://') ||
		value.startsWith('data:')
	);
}

/**
 * Local snapshot records carry `file_local` (`/asset/...`). Live GraphQL
 * records only have the remote `file.url`.
 */
export function imageRecordSrc(record: CmsImageRecord | null | undefined): string | undefined {
	const local = record?.file_local;
	if (typeof local === 'string' && local) {
		return local;
	}
	if (Array.isArray(local)) {
		const first = local.find((entry) => typeof entry === 'string' && entry);
		if (first) {
			return first;
		}
	}
	return record?.file?.url || undefined;
}

/**
 * Resolves a CMS image field's stored value to a usable `src`. Unedited
 * fields keep the scanned JSX default (already a real path/URL). Once edited
 * via PatStore's image picker, the stored value is the `Image` record's
 * `objectId`. That id is looked up in the build-time snapshot, where the SSG
 * plugin has already downloaded the file to `/asset/...` (`file_local`).
 * Falls back to the raw value when it is not a known objectId.
 */
export function resolveImageSrc(value: string): string {
	if (isDirectImageSrc(value)) {
		return value;
	}

	const record = findByObjectId(value) as CmsImageRecord | null;
	return imageRecordSrc(record) ?? value;
}
