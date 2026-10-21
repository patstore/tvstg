/** @jsxImportSource octane */
import { use, useMemo } from 'octane';
import { fetchPatStoreObject, usePatStoreCollection } from '@patstore/core';
import type { SiteRecord } from '@types';

export function useArticles(): SiteRecord[] {
	return usePatStoreCollection<SiteRecord>('Article', { limit: 200 });
}

export function useCategories(): SiteRecord[] {
	return usePatStoreCollection<SiteRecord>('Category');
}

export function useImages(): SiteRecord[] {
	return usePatStoreCollection<SiteRecord>('Image', { limit: 400 });
}

/**
 * Project image list, plus any requested image ids that live outside that list.
 * Group photos are often stored on another project, so a project-scoped find misses them.
 */
export function useImagesFor(ids: string[]): SiteRecord[] {
	const images = useImages();
	const known = new Set(images.map((image) => image.objectId));
	const missingKey = [...new Set(ids.filter((id) => id && !known.has(id)))].sort().join('|');
	const extra = useMemo(() => {
		const missing = missingKey ? missingKey.split('|') : [];
		return Promise.all(
			missing.map((id) =>
				fetchPatStoreObject<SiteRecord>('Image', id, { source: 'dynamic' }).catch(() => null),
			),
		);
	}, [missingKey]);
	const fetched = use(extra).filter((image): image is SiteRecord => image != null);
	return [...images, ...fetched];
}

export function useDownloads(): SiteRecord[] {
	return usePatStoreCollection<SiteRecord>('Download');
}

export function useWebpages(): SiteRecord[] {
	return usePatStoreCollection<SiteRecord>('Webpage');
}

export function useContents(): SiteRecord[] {
	return usePatStoreCollection<SiteRecord>('Content');
}

export function useAppointments(): SiteRecord[] {
	return usePatStoreCollection<SiteRecord>('Appointment');
}

export function useGroups(): SiteRecord[] {
	return usePatStoreCollection<SiteRecord>('Group', { limit: 200 });
}

export function useLocations(): SiteRecord[] {
	return usePatStoreCollection<SiteRecord>('Location');
}

export function useEntries(): SiteRecord[] {
	return usePatStoreCollection<SiteRecord>('Entry');
}

export function usePersons(): SiteRecord[] {
	return usePatStoreCollection<SiteRecord>('Person', { limit: 200 });
}

/** Person rows for the given ids, including trainers stored outside this project. */
export function usePersonsFor(ids: string[]): SiteRecord[] {
	const people = usePersons();
	const known = new Set(people.map((person) => person.objectId));
	const missingKey = [...new Set(ids.filter((id) => id && !known.has(id)))].sort().join('|');
	const extra = useMemo(() => {
		const missing = missingKey ? missingKey.split('|') : [];
		return Promise.all(
			missing.map((id) =>
				fetchPatStoreObject<SiteRecord>('Person', id, { source: 'dynamic' }).catch(() => null),
			),
		);
	}, [missingKey]);
	const fetched = use(extra).filter((person): person is SiteRecord => person != null);
	return [...people, ...fetched];
}

export function useForms(): SiteRecord[] {
	return usePatStoreCollection<SiteRecord>('Form');
}
