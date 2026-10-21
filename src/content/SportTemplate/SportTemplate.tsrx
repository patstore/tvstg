import { useState } from 'octane';
import { AnimatePresence } from '@octanejs/motion';
import { isPatStoreConfigured } from '@patstore/core';
import { Seo, Sidebar } from '@components';
import {
	idList,
	matchesSport,
	mediaUrl,
	publishedArticles,
	slugify,
	useArticles,
	useCategories,
	useGroups,
	useImages,
} from '@provider';
import type { SiteRecord } from '@types';
import { BlogElement, GroupPanel, HeadContent, Loading } from '@ui';

export function SportTemplate(props: { department: string; sport: string; language: string }) @{
	<>
		@if (!isPatStoreConfigured()) {
			<>
				<Seo data={{ title: 'Sportart', language: props.language }} />
				<p class="club-status">PatStore ist nicht konfiguriert.</p>
			</>
		} @else {
			<SportData department={props.department} sport={props.sport} language={props.language} />
		}
	</>
}

function SportData(props: { department: string; sport: string; language: string }) @{
	@try {
		const categories = useCategories();
		const sport = categories.find((item) => slugify(item.title || '') === props.sport);
		const images = useImages();
		const articles = publishedArticles(useArticles())
			.filter((article) =>
				sport
					? idList(article.categories).includes(sport.objectId)
					: matchesSport(article, props.sport, categories),
			)
			.slice(0, 4);
		const groups = useGroups().filter((group) =>
			sport ? idList(group.categories).includes(sport.objectId) : matchesSport(group, props.sport, categories),
		);
		const title = sport?.title || labelFromSlug(props.sport);

		<div class="club-page">
			<Seo
				data={{
					title,
					description: sport?.description || undefined,
					language: props.language,
				}}
			/>
			<HeadContent title={title} text={sport?.description || labelFromSlug(props.department)} />
			<div class="club-split">
				<div class="club-main">
					<h2 class="club-section-title">Unsere neuesten Beiträge</h2>
					<div class="club-grid">
						@for (const article of articles; key article.objectId) {
							<BlogElement article={article} images={images} categories={categories} />
						}
					</div>
					<h2 class="club-section-title">Unsere Mannschaften</h2>
					<div class="club-grid">
						@for (const group of groups; key group.objectId) {
							<TeamCard group={group} images={images} />
						}
					</div>
				</div>
				<Sidebar
					category={sport?.objectId}
					showCalendar
					showNews
					displayAllNews={!sport}
					displayAllEvents={!sport}
				/>
			</div>
		</div>
	} @pending {
		<Loading />
	} @catch (_error) {
		<p class="club-status">Sportart konnte nicht geladen werden.</p>
	}
}

function TeamCard(props: { group: SiteRecord; images: SiteRecord[] }) @{
	const [open, setOpen] = useState(false);
	const image = mediaUrl(props.group.team?.image || props.group.image, props.images);

	<article class="club-card">
		@if (image) {
			<img src={image} alt={(props.group.team?.name || props.group.title || '') as string} />
		}
		<div class="club-card__body">
			<h3>{(props.group.team?.name || props.group.title || '') as string}</h3>
			<button type="button" class="club-button" onClick={() => setOpen(true)}>
				mehr erfahren
			</button>
		</div>
		<AnimatePresence>
			@if (open) {
				<GroupPanel
					group={props.group}
					images={props.images}
					people={[]}
					locations={[]}
					onClose={() => setOpen(false)}
				/>
			}
		</AnimatePresence>
	</article>
}

function labelFromSlug(slug: string): string {
	return slug
		.split('-')
		.map((part) => (part ? part.charAt(0).toUpperCase() + part.slice(1) : part))
		.join(' ');
}
