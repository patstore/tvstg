import type { WebpageStructuredValueEntry } from '@patstore/core';
import { toLocale } from '@patstore/cms-content-plugin';

export const findValueForKey = ({
	key,
	lang,
	content,
}: {
	key: string;
	lang: string;
	content?: WebpageStructuredValueEntry[] | null;
}) => {
	const contentKey = key;
	const langContentKey = `${toLocale(lang)}.${key}`;

	if (!content) {
		return undefined;
	}

	let fullValue = content.find((value) => value.path === langContentKey);

	if (!fullValue) {
		fullValue = content.find((value) => value.path === contentKey);
	}

	return fullValue?.value || undefined;
};
