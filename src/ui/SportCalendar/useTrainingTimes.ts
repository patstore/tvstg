/** @jsxImportSource octane */
import { useMemo } from 'octane';
import Fuse from 'fuse.js';
import {
	agesInGroup,
	agesInGroups,
	categoryTitles,
	getWeekday,
	idList,
	trainingSlots,
	useCategories,
	useGroups,
	useLocationsFor,
} from '@provider';
import type { SiteRecord, Trainingszeit } from '@types';

export function useTrainingTimes(options: {
	categories: string[];
	keywords: string[];
	search: string;
	age: number | null;
	gender: string;
}): { trainingszeiten: Trainingszeit[]; ages: number[]; groups: SiteRecord[]; locations: SiteRecord[] } {
	const categories = useCategories();
	const groups = useGroups();
	const locations = useLocationsFor(locationIds(groups));

	const trainingszeiten = useMemo(() => {
		const slots: Trainingszeit[] = [];
		for (const group of groups) {
			const groupCategories = idList(group.categories);
			if (options.categories.length > 0 && !groupCategories.some((id) => options.categories.includes(id))) {
				continue;
			}
			if (
				options.keywords.length > 0 &&
				!options.keywords.some((word) => (group.title || '').toLowerCase().includes(word))
			) {
				continue;
			}
			if (!group.title || group.state !== 'published') {
				continue;
			}
			for (const time of trainingSlots(group.times)) {
				const locationId = time.place?.location;
				const location =
					locations.find((item) => item.objectId === locationId)?.title || time.place?.address || '';
				slots.push({
					...time,
					group_id: group.objectId,
					categories: categoryTitles(group.categories, categories),
					group_name: group.title,
					search_name: group.title.toLowerCase(),
					search_time: time.start.toLowerCase(),
					search_weekday: getWeekday(time.weekday).toLowerCase(),
					search_location: location,
					search_age: agesInGroup(group),
					search_gender: group.data?.gender || 'mixed',
					location,
				});
			}
		}
		return slots;
	}, [groups, locations, categories, options.categories, options.keywords]);

	const filtered = useMemo(() => {
		const fuse = new Fuse(trainingszeiten, {
			includeScore: true,
			threshold: 0.3,
			keys: [
				{ name: 'categories', weight: 0.3 },
				{ name: 'search_name', weight: 0.3 },
				{ name: 'search_weekday', weight: 0.2 },
				{ name: 'search_time', weight: 0.1 },
				{ name: 'location', weight: 0.1 },
			],
		});
		let result = options.search ? fuse.search(options.search).map((item) => item.item) : trainingszeiten;
		if (options.search && result.length === 0) {
			result = trainingszeiten;
		}
		if (options.gender !== 'all') {
			result = result.filter((item) => item.search_gender === options.gender);
		}
		if (options.age !== null) {
			const age = options.age;
			result =
				age < 19
					? result.filter((item) => item.search_age.includes(age) || item.search_age.length === 0)
					: result.filter((item) => item.search_age.some((value) => value >= 19));
		}
		return result;
	}, [trainingszeiten, options.search, options.gender, options.age]);

	return {
		trainingszeiten: filtered,
		ages: agesInGroups(groups),
		groups,
		locations,
	};
}

function locationIds(groups: SiteRecord[]): string[] {
	const ids: string[] = [];
	for (const group of groups) {
		for (const time of trainingSlots(group.times)) {
			if (time.place?.location) {
				ids.push(time.place.location);
			}
		}
	}
	return ids;
}
