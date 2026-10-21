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
 * Records from a project list, plus any requested ids stored on another project.
 * A project-scoped find does not return those rows.
 */
function useLinkedRecords(className: string, ids: string[], records: SiteRecord[]): SiteRecord[] {
	const known = new Set(records.map((record) => record.objectId));
	const missingKey = [...new Set(ids.filter((id) => id && !known.has(id)))].sort().join('|');
	const extra = useMemo(() => {
		const missing = missingKey ? missingKey.split('|') : [];
		return Promise.all(
			missing.map((id) =>
				fetchPatStoreObject<SiteRecord>(className, id, { source: 'dynamic' }).catch(() => null),
			),
		);
	}, [className, missingKey]);
	const fetched = use(extra).filter((record): record is SiteRecord => record != null);
	return [...records, ...fetched];
}

/** Project image list, plus photos referenced by id from outside that list. */
export function useImagesFor(ids: string[]): SiteRecord[] {
	return useLinkedRecords('Image', ids, useImages());
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

/** Project locations, plus halls referenced by training times outside that list. */
export function useLocationsFor(ids: string[]): SiteRecord[] {
	return useLinkedRecords('Location', ids, useLocations());
}

export function useEntries(): SiteRecord[] {
	return usePatStoreCollection<SiteRecord>('Entry');
}

export function usePersons(): SiteRecord[] {
	return usePatStoreCollection<SiteRecord>('Person', { limit: 200 });
}

/** Person rows for the given ids, including trainers stored outside this project. */
export function usePersonsFor(ids: string[]): SiteRecord[] {
	return useLinkedRecords('Person', ids, usePersons());
}

export function useForms(): SiteRecord[] {
	return usePatStoreCollection<SiteRecord>('Form');
}
