import { useEffect, useRef, useState } from 'octane';
import { Building2, Clock } from '@octanejs/lucide';
import { isPatStoreConfigured } from '@patstore/core';
import { getWeekday, idList, mediaUrl, trainingSlots, useImagesFor, usePersonsFor } from '@provider';
import type { SiteRecord, Trainingszeit } from '@types';
import { lenis } from '../../lenis.ts';
import placeholder from '../../assets/training-placeholder.png';
import { ContactPerson } from '../ContactPerson/index.ts';
import { Html } from '../Html/index.ts';
import { Label } from '../Label/index.ts';
import { Loading } from '../Loading/index.ts';
import { SwitchButton } from '../SwitchButton/index.ts';
import { useTrainingTimes } from './useTrainingTimes.ts';

const WEEKDAY_ORDER = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];

type CalendarView = 'grid' | 'list';

type PanelRequest = {
	group: SiteRecord;
	images: SiteRecord[];
	people: SiteRecord[];
	locations: SiteRecord[];
};

let panelRequest: PanelRequest | null = null;
const panelListeners = new Set<() => void>();

function setPanel(request: PanelRequest | null) {
	panelRequest = request;
	for (const listener of panelListeners) {
		listener();
	}
}

export function SportCalendar(props: { categories?: string[]; keywords?: string[] }) @{
	@if (!isPatStoreConfigured()) {
		<p class="club-status">Trainingszeiten sind ohne PatStore-Konfiguration nicht verfügbar.</p>
	} @else {
		<SportCalendarData categories={props.categories ?? []} keywords={props.keywords ?? []} />
	}
}

function SportCalendarData(props: { categories: string[]; keywords: string[] }) @{
	const [search, setSearch] = useState('');
	const [age, setAge] = useState<number | null>(null);
	const [gender, setGender] = useState('all');
	const [view, setView] = useState<CalendarView>('grid');

	@try {
		const { trainingszeiten, ages, groups, locations } = useTrainingTimes({
			categories: props.categories,
			keywords: props.keywords,
			search,
			age,
			gender,
		});
		const images = useImagesFor(groupImageIds(groups));
		const people = usePersonsFor(personIds(groups));
		const openGroup = (group: SiteRecord) => {
			setPanel({ group, images, people, locations });
		};

		<div>
			<div class="club-filters">
				<label>
					Suche
					<input
						placeholder="Suche ..."
						onInput={(event: Event) => setSearch((event.currentTarget as HTMLInputElement).value)}
					/>
				</label>
				<label>
					Geschlecht
					<select onChange={(event: Event) => setGender((event.currentTarget as HTMLSelectElement).value)}>
						<option value="all" selected={gender === 'all'}>Alle</option>
						<option value="female" selected={gender === 'female'}>Weiblich</option>
						<option value="male" selected={gender === 'male'}>Männlich</option>
						<option value="mixed" selected={gender === 'mixed'}>Gemischt</option>
					</select>
				</label>
				<label>
					Alter
					<select
						onChange={(event: Event) => {
							const value = (event.currentTarget as HTMLSelectElement).value;
							setAge(value === '' ? null : Number(value));
						}}
					>
						<option value="">Alle</option>
						@for (const value of ages; key value) {
							<option value={String(value)} selected={age === value}>
								{value >= 19 ? '19+' : String(value)}
							</option>
						}
					</select>
				</label>
				<div class="club-view-toggle">
					<SwitchButton text="Kacheln" active={view === 'grid'} onClick={() => setView('grid')} />
					<SwitchButton text="Liste" active={view === 'list'} onClick={() => setView('list')} />
				</div>
			</div>
			@for (const day of WEEKDAY_ORDER; key day) {
				<>
					@if (view === 'grid') {
						<Weekday
							day={day}
							slots={trainingszeiten.filter((item) => item.weekday === day)}
							groups={groups}
							images={images}
							people={people}
							onOpen={openGroup}
						/>
					} @else {
						<DayTable
							day={day}
							slots={trainingszeiten.filter((item) => item.weekday === day)}
							groups={groups}
							images={images}
							people={people}
							onOpen={openGroup}
						/>
					}
				</>
			}
			<PanelHost />
		</div>
	} @pending {
		<Loading />
	} @catch (_error) {
		<p class="club-status">Trainingszeiten konnten nicht geladen werden.</p>
	}
}

function Weekday(props: {
	day: string;
	slots: Trainingszeit[];
	groups: SiteRecord[];
	images: SiteRecord[];
	people: SiteRecord[];
	onOpen: (group: SiteRecord) => void;
}) @{
	@if (props.slots.length > 0) {
		<section>
			<h2 class="club-section-title">{getWeekday(props.day) as string}</h2>
			<div class="club-grid">
				@for (const slot of props.slots; key (slot.id || slot.group_id + slot.start)) {
					<TrainingCard
						slot={slot}
						group={props.groups.find((group) => group.objectId === slot.group_id)}
						images={props.images}
						people={props.people}
						onOpen={props.onOpen}
					/>
				}
			</div>
		</section>
	}
}

function DayTable(props: {
	day: string;
	slots: Trainingszeit[];
	groups: SiteRecord[];
	images: SiteRecord[];
	people: SiteRecord[];
	onOpen: (group: SiteRecord) => void;
}) @{
	@if (props.slots.length > 0) {
		<table class="club-day-table">
			<caption class="club-section-title">{getWeekday(props.day) as string}</caption>
			<thead>
				<tr>
					<th>Angebot</th>
					<th>Zeit</th>
					<th>Ort</th>
					<th>Info</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				@for (const slot of props.slots; key (slot.id || slot.group_id + slot.start)) {
					<DayRow
						slot={slot}
						group={props.groups.find((group) => group.objectId === slot.group_id)}
						images={props.images}
						people={props.people}
						onOpen={props.onOpen}
					/>
				}
			</tbody>
		</table>
	}
}

function DayRow(props: {
	slot: Trainingszeit;
	group?: SiteRecord;
	images: SiteRecord[];
	people: SiteRecord[];
	onOpen: (group: SiteRecord) => void;
}) @{
	@if (props.group) {
		<tr>
			<td>
				<div>
					<img src={groupPhoto(props.group, props.images)} alt={(props.group.title || '') as string} />
					<strong>{(props.group.title || '') as string}</strong>
				</div>
			</td>
			<td>
				<div>
					<p class="club-meta">
						<Clock size={16} />
						<span>{(props.slot.start + (props.slot.end ? ' – ' + props.slot.end : '')) as string}</span>
					</p>
					@if (props.slot.text) {
						<p>{props.slot.text as string}</p>
					}
				</div>
			</td>
			<td>
				<p class="club-meta">
					<Building2 size={16} />
					<span>{(props.slot.location || '') as string}</span>
				</p>
			</td>
			<td>
				<div>
					@if (ageLabel(props.group)) {
						<p>{ageLabel(props.group) as string}</p>
					}
					@if (trainerNames(props.group, props.people)) {
						<p>{trainerNames(props.group, props.people) as string}</p>
					}
					@if (props.group.description) {
						<p>{props.group.description as string}</p>
					}
				</div>
			</td>
			<td>
				<button type="button" class="club-button" onClick={() => props.onOpen(props.group!)}>
					mehr Infos
				</button>
			</td>
		</tr>
	}
}

function TrainingCard(props: {
	slot: Trainingszeit;
	group?: SiteRecord;
	images: SiteRecord[];
	people: SiteRecord[];
	onOpen: (group: SiteRecord) => void;
}) @{
	@if (props.group) {
		<article class="club-training">
			<img src={groupPhoto(props.group, props.images)} alt={(props.group.title || '') as string} />
			<div class="club-training__body">
				<div class="club-labels">
					@for (const category of props.slot.categories; key category) {
						<Label text={category} />
					}
				</div>
				<h4>{(props.group.title || '') as string}</h4>
				<p class="club-meta">
					<Clock size={16} />
					<span>{(props.slot.start + (props.slot.end ? ' – ' + props.slot.end : '')) as string}</span>
				</p>
				@if (props.slot.text) {
					<p>{props.slot.text as string}</p>
				}
				<p class="club-meta">
					<Building2 size={16} />
					<span>{(props.slot.location || '–') as string}</span>
				</p>
				@if (ageLabel(props.group)) {
					<p>{ageLabel(props.group) as string}</p>
				}
				@if (trainerNames(props.group, props.people)) {
					<p>{trainerNames(props.group, props.people) as string}</p>
				}
				@if (props.group.description) {
					<p>{props.group.description as string}</p>
				}
				<button type="button" class="club-button" onClick={() => props.onOpen(props.group!)}>
					mehr Infos
				</button>
			</div>
		</article>
	}
}

function PanelHost() @{
	const [request, setRequest] = useState<PanelRequest | null>(null);

	useEffect(() => {
		const listener = () => setRequest(panelRequest);
		panelListeners.add(listener);
		return () => {
			panelListeners.delete(listener);
		};
	}, []);

	@if (request) {
		<GroupPanel
			group={request.group}
			images={request.images}
			people={request.people}
			locations={request.locations}
			onClose={() => setPanel(null)}
		/>
	} @else {
		<span />
	}
}

export function GroupPanel(props: {
	group: SiteRecord;
	images: SiteRecord[];
	people: SiteRecord[];
	locations: SiteRecord[];
	onClose: () => void;
}) @{
	const ref = useRef<HTMLDialogElement | null>(null);
	const slots = trainingSlots(props.group.times);
	const trainers = trainersOf(props.group, props.people);
	const photo = groupPhoto(props.group, props.images);

	useEffect(() => {
		const dialog = ref.current;
		if (!dialog) {
			return;
		}
		if (!dialog.open) {
			dialog.showModal();
		}
		lenis.stop();
		const onCancel = (event: Event) => {
			event.preventDefault();
			props.onClose();
		};
		dialog.addEventListener('cancel', onCancel);
		return () => {
			dialog.removeEventListener('cancel', onCancel);
			lenis.start();
			if (dialog.open) {
				dialog.close();
			}
		};
	}, []);

	<dialog ref={ref} class="club-slide" onClick={(event: MouseEvent) => event.stopPropagation()}>
		<div class="club-slide__bar">
			<button type="button" class="club-button club-button--dark" onClick={() => props.onClose()}>
				Schließen
			</button>
		</div>
		<div class="club-slide__body">
			<h2>{(props.group.title || '') as string}</h2>
			<img src={photo} alt={(props.group.title || '') as string} />
			@if (trainers.length > 0) {
				<div>
					<h3 class="club-section-title">Übungsleiter*innen</h3>
					@for (const person of trainers; key person.objectId) {
						<ContactPerson person={person} images={props.images} />
					}
				</div>
			}
			@if (ageLabel(props.group)) {
				<div>
					<h3 class="club-section-title">Alter</h3>
					<p>{ageLabel(props.group) as string}</p>
				</div>
			}
			@if (props.group.description) {
				<div>
					<h3 class="club-section-title">Info</h3>
					<p>{props.group.description as string}</p>
				</div>
			}
			@if (props.group.text) {
				<div>
					<h3 class="club-section-title">Beschreibung</h3>
					<Html html={props.group.text} />
				</div>
			}
			<h3 class="club-section-title">Trainingszeiten</h3>
			@for (const slot of slots; key (slot.id || slot.weekday + slot.start)) {
				<div class="club-sidebar__item">
					<h4>
						{(getWeekday(slot.weekday) +
							(slot.start && slot.end ? ' ' + slot.start + ' – ' + slot.end : '')) as string}
					</h4>
					@if (slot.text) {
						<p>{slot.text as string}</p>
					}
					@if (placeTitle(slot, props.locations)) {
						<p>{placeTitle(slot, props.locations) as string}</p>
					}
				</div>
			}
			@if (props.group.team?.description) {
				<div>
					<h3 class="club-section-title">Die Mannschaft</h3>
					<Html html={props.group.team.description} />
				</div>
			}
		</div>
	</dialog>
}

function pointerId(value: unknown): string {
	if (typeof value === 'string' && value && !value.startsWith('http') && !value.startsWith('/')) {
		return value;
	}
	if (value && typeof value === 'object' && 'objectId' in value) {
		const id = (value as { objectId?: unknown }).objectId;
		return typeof id === 'string' ? id : '';
	}
	return '';
}

function groupImageIds(groups: SiteRecord[]): string[] {
	const ids: string[] = [];
	for (const group of groups) {
		const teamId = pointerId(group.team?.image);
		const imageId = pointerId(group.image);
		if (teamId) {
			ids.push(teamId);
		}
		if (imageId) {
			ids.push(imageId);
		}
	}
	return ids;
}

function personIds(groups: SiteRecord[]): string[] {
	return groups.flatMap((group) => idList(group.persons));
}

function groupPhoto(group: SiteRecord, images: SiteRecord[]): string {
	return mediaUrl(group.team?.image, images) || mediaUrl(group.image, images) || placeholder;
}

function trainersOf(group: SiteRecord, people: SiteRecord[]): SiteRecord[] {
	return idList(group.persons)
		.map((id) => people.find((person) => person.objectId === id))
		.filter((person): person is SiteRecord => person != null);
}

function trainerNames(group: SiteRecord, people: SiteRecord[]): string {
	return trainersOf(group, people)
		.map((person) => person.title)
		.filter((name): name is string => Boolean(name))
		.join(', ');
}

function ageLabel(group: SiteRecord): string {
	const start = Number(group.data?.start_age);
	const end = group.data?.end_age;
	if (!start) {
		return '';
	}
	if (start >= 18) {
		return 'Erwachsene';
	}
	if (start > 1 && (end == null || end === '')) {
		return `Ab ${start} Jahren`;
	}
	return `Von ${start} bis ${end} Jahre`;
}

function placeTitle(slot: { place?: { location?: string; address?: string } }, locations: SiteRecord[]): string {
	if (slot.place?.address) {
		return slot.place.address;
	}
	if (slot.place?.location) {
		return locations.find((location) => location.objectId === slot.place?.location)?.title || '';
	}
	return '';
}
