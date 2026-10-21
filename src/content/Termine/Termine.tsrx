import { useEffect, useState } from 'octane';
import { isPatStoreConfigured } from '@patstore/core';
import { Seo } from '@components';
import { lenis } from '../../lenis.ts';
import {
	MONTHS,
	categoryTitles,
	eventStart,
	getDateString,
	useAppointments,
	useCategories,
	useLocations,
} from '@provider';
import type { SiteRecord } from '@types';
import { HeadContent, Loading, SwitchButton } from '@ui';

export function Termine(props: { language: string }) @{
	<>
		<Seo
			data={{
				title: 'Termine',
				description: 'Kommende Termine und Veranstaltungen unseres Vereins und der Abteilungen.',
				language: props.language,
			}}
		/>
		@if (!isPatStoreConfigured()) {
			<p class="club-status">PatStore ist nicht konfiguriert.</p>
		} @else {
			<TermineData />
		}
	</>
}

function TermineData() @{
	const currentYear = new Date().getFullYear();
	const [year, setYear] = useState(currentYear);
	const years = [currentYear - 1, currentYear, currentYear + 1];

	@try {
		const appointments = [...useAppointments()].sort(
			(a, b) => new Date(eventStart(a.date)).getTime() - new Date(eventStart(b.date)).getTime(),
		);
		console.log(appointments);
		const categories = useCategories();
		const locations = useLocations();
		const currentMonth = new Date().getMonth() + 1;
		const targetMonth =
			MONTHS.find(
				(month) =>
					month.number >= currentMonth &&
					appointments.some((event) => inMonth(event, month.number, year)),
			)?.number ?? currentMonth;

		<div class="club-page">
			<HeadContent
				title="Termine"
				text="Was steht an? Kommende Termine und Veranstaltungen unseres Vereins und der Abteilungen siehst Du hier."
				center
			/>
			<div class="club-switches">
				@for (const value of years; key value) {
					<SwitchButton
						text={String(value)}
						active={year === value}
						onClick={() => setYear(value)}
					/>
				}
			</div>
			<ScrollToMonth id={'month-' + targetMonth} />
			@for (const month of MONTHS; key month.number) {
				<MonthBlock
					name={month.name}
					number={month.number}
					year={year}
					events={appointments.filter((event) => inMonth(event, month.number, year))}
					categories={categories}
					locations={locations}
				/>
			}
			<MonthBlock
				name="Weitere Termine"
				number={0}
				year={year}
				events={appointments.filter((event) => !eventStart(event.date))}
				categories={categories}
				locations={locations}
			/>
		</div>
	} @pending {
		<Loading />
	} @catch (_error) {
		<p class="club-status">Termine konnten nicht geladen werden.</p>
	}
}

function inMonth(event: SiteRecord, month: number, year: number): boolean {
	const start = new Date(eventStart(event.date));
	return start.getFullYear() === year && start.getMonth() + 1 === month;
}

function MonthBlock(props: {
	name: string;
	number: number;
	year: number;
	events: SiteRecord[];
	categories: SiteRecord[];
	locations: SiteRecord[];
}) @{
	const events = [...props.events].sort(
		(a, b) => new Date(eventStart(a.date)).getTime() - new Date(eventStart(b.date)).getTime(),
	);

	@if (props.number !== 0 || events.length > 0) {
		<section id={'month-' + props.number}>
			<h2 class="club-section-title">
				{(props.number === 0 ? props.name : props.name + ' ' + props.year) as string}
			</h2>
			@for (const event of events; key event.objectId) {
				<div class="club-event">
					<strong>{(event.title || '') as string}</strong>
					<span>{(categoryTitles(event.categories, props.categories)[0] || '') as string}</span>
					<span>{getDateString(eventStart(event.date)).date as string}</span>
					<span>{getDateString(eventStart(event.date)).time as string}</span>
					<span>{placeLabel(event, props.locations) as string}</span>
				</div>
			}
		</section>
	}
}

function ScrollToMonth(props: { id: string }) @{
	useEffect(() => {
		const node = document.getElementById(props.id);
		if (node) {
			lenis.scrollTo(node, { offset: -110 });
		}
	}, [props.id]);

	<span hidden />
}

function placeLabel(event: SiteRecord, locations: SiteRecord[]): string {
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
