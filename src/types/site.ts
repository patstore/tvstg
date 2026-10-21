import type { PatStoreFile } from '@patstore/core';

/** PatStore class row used by the club site. Fields follow the live module, so most are optional. */
export interface SiteRecord {
	objectId: string;
	title?: string | null;
	label?: string | null;
	text?: string | null;
	description?: string | null;
	subtitle?: string | null;
	state?: string | null;
	date?: unknown;
	image?: unknown;
	gallery?: unknown;
	categories?: unknown;
	path?: string | null;
	type?: string | null;
	content?: unknown;
	content_id?: string | null;
	active?: boolean | null;
	data?: SiteData | null;
	file?: PatStoreFile | null;
	times?: unknown;
	team?: SiteTeam | null;
	/** Trainer object ids. */
	persons?: unknown;
	email?: string | null;
	createdAt?: string;
}

export interface SiteData {
	gender?: string | null;
	start_age?: string | number | null;
	end_age?: string | number | null;
	email?: string | null;
}

export interface SiteTeam {
	id?: string;
	name?: string;
	image?: unknown;
	description?: string;
}

export interface TrainingSlot {
	id?: string;
	weekday: string;
	start: string;
	end?: string;
	text?: string;
	place?: {
		location?: string;
		address?: string;
		online?: string;
	};
}

export interface ContentElement {
	id: string;
	type: string;
	value: unknown;
	active: boolean;
	name?: string;
}

export interface TableColumn {
	id: string;
	name: string;
	textAlign?: string;
}

export interface TableContent {
	columns: TableColumn[];
	rows: { id: string; data: string[] }[];
	settings: {
		title?: string;
		description?: string;
		showHeader?: boolean;
		footer?: string;
	};
}

export interface FormFieldDef {
	name: string;
	type?: string;
	placeholder?: string;
	required?: boolean;
	label?: string;
}

export interface Trainingszeit extends TrainingSlot {
	group_id: string;
	categories: string[];
	group_name: string;
	search_name: string;
	search_time: string;
	search_weekday: string;
	search_location: string;
	search_age: number[];
	search_gender: string;
	location: string;
}
