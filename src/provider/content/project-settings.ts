import content from '../../../data/cms-content.json';
import { graphqlGet, isPatStoreConfigured, readPatStoreEnv } from '@patstore/core';

interface ProjectSettingsRecord {
	objectId: string;
	settings?: {
		languages?: unknown;
		default_language?: unknown;
	};
	[key: string]: unknown;
}

interface CmsContentMeta {
	languages?: string[];
}

export interface ProjectLanguageSettings {
	languages: string[];
	defaultLanguage: string;
}

let cachedSettings: ProjectLanguageSettings | null = null;

function envDefaultLang(): string {
	return import.meta.env.DEFAULT_LANG ?? 'en';
}

/** `de-DE` → `de`. Short route codes stay unchanged. `default` is not a URL language. */
function routeLanguage(value: string): string | null {
	const trimmed = value.trim();
	if (!trimmed || trimmed.toLowerCase() === 'default') {
		return null;
	}
	const language = trimmed.split(/[-_]/).filter(Boolean)[0]?.toLowerCase();
	return language || null;
}

function routeLanguages(values: string[]): string[] {
	return [...new Set(values.map(routeLanguage).filter((lang): lang is string => Boolean(lang)))];
}

function settingsFromCmsContent(): ProjectLanguageSettings {
	const meta = (content as { _meta?: CmsContentMeta })._meta;
	const fromMeta =
		meta?.languages?.length && meta.languages.every((lang) => typeof lang === 'string')
			? routeLanguages(meta.languages)
			: [];
	const languages = fromMeta.length > 0 ? fromMeta : [envDefaultLang()];

	return {
		languages,
		defaultLanguage: languages[0] ?? envDefaultLang(),
	};
}

function normalizeLanguages(value: unknown, fallback: string[]): string[] {
	if (!Array.isArray(value) || value.length === 0) {
		return fallback;
	}
	const languages = routeLanguages(
		value.filter((lang): lang is string => typeof lang === 'string'),
	);
	return languages.length > 0 ? languages : fallback;
}

/** Languages from `Project.settings.languages` (synced into `cms-content.json` at build time). */
export function getProjectLanguages(): string[] {
	return cachedSettings?.languages ?? settingsFromCmsContent().languages;
}

/** Default language from `Project.settings.default_language`, loaded before the app boots. */
export function getDefaultLanguage(): string {
	return cachedSettings?.defaultLanguage ?? settingsFromCmsContent().defaultLanguage;
}

/** Loads live project language settings from PatStore when configured. */
export async function loadProjectSettings(): Promise<ProjectLanguageSettings> {
	const fallback = settingsFromCmsContent();

	if (!isPatStoreConfigured()) {
		cachedSettings = fallback;
		return cachedSettings;
	}

	try {
		const { PROJECT_ID } = readPatStoreEnv();
		const project = await graphqlGet<ProjectSettingsRecord>('Project', PROJECT_ID, 'settings');
		const languages = normalizeLanguages(project?.settings?.languages, fallback.languages);
		const defaultFromSettings =
			typeof project?.settings?.default_language === 'string'
				? routeLanguage(project.settings.default_language)
				: null;
		const defaultLanguage =
			defaultFromSettings && languages.includes(defaultFromSettings)
				? defaultFromSettings
				: languages.includes(fallback.defaultLanguage)
					? fallback.defaultLanguage
					: (languages[0] ?? fallback.defaultLanguage);

		cachedSettings = { languages, defaultLanguage };
	} catch {
		cachedSettings = fallback;
	}

	return cachedSettings;
}
