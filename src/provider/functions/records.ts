import type { PatStoreFile } from '@patstore/core';
import type {
	ContentElement,
	FormFieldDef,
	SiteRecord,
	TableContent,
	TrainingSlot,
} from '@types';
import { slugify } from './slugify.ts';

export function idList(value: unknown): string[] {
	if (!value) {
		return [];
	}
	if (typeof value === 'string') {
		return [value];
	}
	if (Array.isArray(value)) {
		return value.flatMap((item) => idList(item));
	}
	if (typeof value === 'object') {
		const record = value as { objectId?: unknown; value?: unknown };
		if (typeof record.objectId === 'string') {
			return [record.objectId];
		}
		if ('value' in record) {
			return idList(record.value);
		}
	}
	return [];
}

export function fileUrl(file: unknown): string {
	if (!file || typeof file !== 'object') {
		return '';
	}
	const url = (file as PatStoreFile).url;
	return typeof url === 'string' ? url : '';
}

export function mediaUrl(value: unknown, images: SiteRecord[]): string {
	if (!value) {
		return '';
	}
	if (typeof value === 'string') {
		if (value.startsWith('http') || value.startsWith('/')) {
			return value;
		}
		const image = images.find((item) => item.objectId === value);
		return fileUrl(image?.file) || mediaUrl(image?.image, []);
	}
	if (typeof value === 'object') {
		const record = value as { url?: unknown; file?: unknown; objectId?: unknown };
		if (typeof record.url === 'string') {
			return record.url;
		}
		const nested = fileUrl(record.file);
		if (nested) {
			return nested;
		}
		if (typeof record.objectId === 'string') {
			return mediaUrl(record.objectId, images);
		}
	}
	return '';
}

export function downloadUrl(record: SiteRecord): string {
	return fileUrl(record.file) || mediaUrl(record.image, []);
}

export function publishedArticles(articles: SiteRecord[]): SiteRecord[] {
	return articles
		.filter((article) => article.state === 'published')
		.sort((a, b) => new Date(eventDate(b)).getTime() - new Date(eventDate(a)).getTime());
}

function eventDate(record: SiteRecord): string {
	if (typeof record.date === 'string') {
		return record.date;
	}
	return '';
}

export function categoryTitles(ids: unknown, categories: SiteRecord[]): string[] {
	return idList(ids)
		.map((id) => categories.find((category) => category.objectId === id)?.title)
		.filter((title): title is string => Boolean(title));
}

export function findWebpage(webpages: SiteRecord[], path: string): SiteRecord | undefined {
	const needle = path.replace(/^\/+|\/+$/g, '');
	const slug = needle.split('/').pop() || needle;
	return webpages.find((page) => {
		const pagePath = String(page.path ?? '').replace(/^\/+|\/+$/g, '');
		return pagePath === needle || pagePath.endsWith('/' + slug) || slugify(page.title || '') === slug;
	});
}

const SPORT_KEYWORDS: Record<string, string[]> = {
	ballsport: ['volleyball', 'tischtennis', 'prellball'],
	prellball: ['prellball'],
	volleyball: ['volleyball'],
	tischtennis: ['tischtennis'],
	turnen: ['turnen'],
	'tanz-und-rope-skipping': ['tanz', 'rope', 'skipping'],
	gesundheitssport: ['gesund', 'fitness', 'senior', 'fit am'],
	leichtathletik: ['leichtathletik'],
};

export function sportKeywords(slug: string): string[] {
	const key = slug.replace(/^\/+|\/+$/g, '').split('/').pop() || slug;
	return SPORT_KEYWORDS[key] ?? [key.replace(/-/g, ' ')];
}

export function matchesSport(record: SiteRecord, slug: string, categories: SiteRecord[] = []): boolean {
	const words = sportKeywords(slug);
	const labels = categoryTitles(record.categories, categories).join(' ');
	const haystack = `${record.title ?? ''} ${record.description ?? ''} ${labels}`.toLowerCase();
	return words.some((word) => haystack.includes(word));
}

export function findBySlug(records: SiteRecord[], slug: string): SiteRecord | undefined {
	return records.find((record) => slugifyTitle(record.title) === slug || record.objectId === slug);
}

function slugifyTitle(title: string | null | undefined): string {
	if (!title) {
		return '';
	}
	const from =
		'àáâäæãåāăąçćčđďèéêëēėęěğǵḧîïíīįìłḿñńǹňôöòóœøōõőṕŕřßśšşșťțûüùúūǘůűųẃẍÿýžźż·/_,:;';
	const to =
		'aaaaaaaaaacccddeeeeeeeegghiiiiiilmnnnnoooooooooprrsssssttuuuuuuuuuwxyyzzz------';
	const pattern = new RegExp(from.split('').join('|'), 'g');
	return title
		.toString()
		.toLowerCase()
		.replace(/\s+/g, '-')
		.replace(pattern, (char) => to.charAt(from.indexOf(char)))
		.replace(/&/g, '-and-')
		.replace(/[^\w-]+/g, '')
		.replace(/--+/g, '-')
		.replace(/^-+/, '')
		.replace(/-+$/, '');
}

export function contentElements(value: unknown): ContentElement[] {
	if (!Array.isArray(value)) {
		return [];
	}
	return value.flatMap((item, index) => {
		if (!item || typeof item !== 'object') {
			return [];
		}
		const element = item as {
			id?: unknown;
			type?: unknown;
			value?: unknown;
			active?: unknown;
			name?: unknown;
		};
		return [
			{
				id: typeof element.id === 'string' ? element.id : `content-${index}`,
				type: typeof element.type === 'string' ? element.type : 'text',
				value: element.value,
				active: element.active !== false,
				name: typeof element.name === 'string' ? element.name : undefined,
			},
		];
	});
}

export function asTable(value: unknown): TableContent | null {
	if (!value || typeof value !== 'object') {
		return null;
	}
	const table = value as TableContent;
	if (!Array.isArray(table.columns) || !Array.isArray(table.rows)) {
		return null;
	}
	return table;
}

export function trainingSlots(value: unknown): TrainingSlot[] {
	const list = Array.isArray(value) ? value : value && typeof value === 'object' ? [value] : [];
	if (list.length === 0) {
		return [];
	}
	value = list;
	if (!Array.isArray(value)) {
		return [];
	}
	return value.flatMap((item) => {
		if (!item || typeof item !== 'object') {
			return [];
		}
		const slot = item as TrainingSlot;
		if (!slot.weekday || !slot.start) {
			return [];
		}
		return [slot];
	});
}

export function formFields(value: unknown): FormFieldDef[] {
	if (!Array.isArray(value)) {
		return [];
	}
	return value.flatMap((item) => {
		if (!item || typeof item !== 'object') {
			return [];
		}
		const field = item as FormFieldDef;
		if (!field.name) {
			return [];
		}
		return [field];
	});
}

export function htmlString(value: unknown): string {
	return typeof value === 'string' ? value : '';
}

export function agesInGroup(record: SiteRecord): number[] {
	const start = Number(record.data?.start_age);
	const end = Number(record.data?.end_age) || 99;
	if (!start) {
		return [];
	}
	const ages: number[] = [];
	for (let age = start; age <= end; age += 1) {
		ages.push(age);
	}
	return ages;
}

export function agesInGroups(groups: SiteRecord[]): number[] {
	const ages = new Set<number>();
	for (const group of groups) {
		const start = Number(group.data?.start_age);
		const end = Number(group.data?.end_age);
		if (!start || !end) {
			continue;
		}
		for (let age = start; age <= end; age += 1) {
			ages.add(age >= 19 ? 19 : age);
		}
	}
	return [...ages].sort((a, b) => a - b);
}
