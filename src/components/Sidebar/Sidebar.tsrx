import { isPatStoreConfigured } from '@patstore/core';
import {
	categoryTitles,
	eventStart,
	getDateString,
	htmlString,
	idList,
	useAppointments,
	useCategories,
	useEntries,
	useGroups,
	useLocations,
} from '@provider';
import type { SiteRecord } from '@types';
import { SiteLink } from '../SiteLink/index.ts';
import { Html } from '../../ui/Html/index.ts';
import { Label } from '../../ui/Label/index.ts';

export function Sidebar(props: {
	category?: string;
	showNews?: boolean;
	showCalendar?: boolean;
	showTraining?: boolean;
	displayAllNews?: boolean;
	displayAllEvents?: boolean;
}) @{
	<aside class="club-sidebar">
		@if (props.showNews) {
			<SidebarNews category={props.category} displayAll={props.displayAllNews} />
		}
		@if (props.showCalendar) {
			<SidebarCalendar category={props.category} displayAll={props.displayAllEvents} />
		}
		@if (props.showTraining && props.category) {
			<SidebarTraining category={props.category} />
		}
		<div>
			<h3>Folge uns</h3>
			<p>
				<a href="https://www.facebook.com/tvstg" target="_blank" rel="noreferrer">Facebook</a>
				{' · '}
				<a href="https://www.instagram.com/tvstg" target="_blank" rel="noreferrer">Instagram</a>
			</p>
		</div>
	</aside>
}

function SidebarNews(props: { category?: string; displayAll?: boolean }) @{
	@if (!isPatStoreConfigured()) {
		<div />
	} @else {
		<NewsList category={props.category} displayAll={props.displayAll} />
	}
}

function NewsList(props: { category?: string; displayAll?: boolean }) @{
	@try {
		const entries = useEntries();
		const now = Date.now();
		const from = now - 60 * 24 * 60 * 60 * 1000;
		const news = entries
			.filter((entry) => {
				const time = new Date(eventStart(entry.date) || String(entry.date || '')).getTime();
				if (!time || time > now || time < from) {
					return false;
				}
				if (props.displayAll) {
					return true;
				}
				return props.category ? idList(entry.categories).includes(props.category) : false;
			})
			.sort((a, b) => new Date(String(b.date)).getTime() - new Date(String(a.date)).getTime())
			.slice(0, 5);

		<div>
			<h3>Aktuelles</h3>
			@for (const entry of news; key entry.objectId) {
				<div class="club-sidebar__item">
					<Label text={getDateString(eventStart(entry.date) || undefined).date} />
					<h4>{(entry.title || '') as string}</h4>
					@if (entry.text) {
						<Html html={htmlString(entry.text)} />
					}
				</div>
			}
		</div>
	} @pending {
		<p class="club-status">Aktuelles wird geladen…</p>
	} @catch (_error) {
		<p class="club-status">Aktuelles konnte nicht geladen werden.</p>
	}
}

function SidebarCalendar(props: { category?: string; displayAll?: boolean }) @{
	@if (!isPatStoreConfigured()) {
		<div />
	} @else {
		<CalendarList category={props.category} displayAll={props.displayAll} />
	}
}

function CalendarList(props: { category?: string; displayAll?: boolean }) @{
	@try {
		const appointments = useAppointments();
		const categories = useCategories();
		const locations = useLocations();
		const events = upcoming(appointments, props.category, props.displayAll);

		<div>
			<h3>Termine</h3>
			@if (events.length === 0) {
				<p>Im Moment sind keine Termine hinterlegt</p>
			}
			@for (const event of events; key event.objectId) {
				<EventLine event={event} categories={categories} locations={locations} />
			}
			<SiteLink href="/termine" class="club-button">Zu allen Terminen</SiteLink>
		</div>
	} @pending {
		<p class="club-status">Termine werden geladen…</p>
	} @catch (_error) {
		<p class="club-status">Termine konnten nicht geladen werden.</p>
	}
}

function EventLine(props: { event: SiteRecord; categories: SiteRecord[]; locations: SiteRecord[] }) @{
	const start = eventStart(props.event.date);
	const place = eventPlace(props.event, props.locations);
	const labels = categoryTitles(props.event.categories, props.categories);

	<div class="club-sidebar__item">
		<Label text={getDateString(start).date} />
		<h4>{(props.event.title || '') as string}</h4>
		@if (labels[0]) {
			<p>{labels[0] as string}</p>
		}
		@if (place) {
			<p>{place as string}</p>
		}
	</div>
}

function upcoming(appointments: SiteRecord[], category?: string, displayAll?: boolean): SiteRecord[] {
	return appointments
		.filter((event) => {
			const start = new Date(eventStart(event.date)).getTime();
			if (!start || start < Date.now()) {
				return false;
			}
			if (displayAll) {
				return true;
			}
			return category ? idList(event.categories).includes(category) : false;
		})
		.sort((a, b) => new Date(eventStart(a.date)).getTime() - new Date(eventStart(b.date)).getTime())
		.slice(0, 5);
}

function eventPlace(event: SiteRecord, locations: SiteRecord[]): string {
	const date = event.date;
	if (!date || typeof date !== 'object' || !('place' in date)) {
		return '';
	}
	const place = (date as { place?: { location?: string; address?: string } }).place;
	if (place?.address) {
		return place.address;
	}
	if (place?.location) {
		return locations.find((location) => location.objectId === place.location)?.title || '';
	}
	return '';
}

function SidebarTraining(props: { category: string }) @{
	@if (!isPatStoreConfigured()) {
		<div />
	} @else {
		<TrainingList category={props.category} />
	}
}

function TrainingList(props: { category: string }) @{
	@try {
		const groups = useGroups();
		const locations = useLocations();
		const matches = groups.filter(
			(group) => group.state === 'published' && idList(group.categories).includes(props.category),
		);

		<div>
			<h3>Trainingszeiten</h3>
			@for (const group of matches; key group.objectId) {
				<div class="club-sidebar__item">
					<h4>{(group.title || '') as string}</h4>
					@for (const slot of timesOf(group); key (slot.id || slot.start)) {
						<p>
							{(slot.weekday + ' ' + slot.start) as string}
							{slot.place?.location
								? (' · ' + (locations.find((item) => item.objectId === slot.place?.location)?.title || ''))
								: ''}
						</p>
					}
				</div>
			}
		</div>
	} @pending {
		<p class="club-status">Trainingszeiten werden geladen…</p>
	} @catch (_error) {
		<p class="club-status">Trainingszeiten konnten nicht geladen werden.</p>
	}
}

function timesOf(group: SiteRecord): { id?: string; weekday: string; start: string; place?: { location?: string } }[] {
	return Array.isArray(group.times) ? (group.times as { id?: string; weekday: string; start: string; place?: { location?: string } }[]) : [];
}
