import { useState } from 'octane';
import { isPatStoreConfigured } from '@patstore/core';
import { Seo } from '@components';
import { idList, publishedArticles, useArticles, useCategories, useImages } from '@provider';
import { BlogElement, HeadContent, SwitchButton } from '@ui';

const PAGE_SIZE = 18;

export function Berichte(props: { language: string }) @{
	<>
		<Seo
			data={{
				title: 'Berichte',
				description: 'Aktuelle und vergangene Berichte aus dem Vereinsgeschehen',
				language: props.language,
			}}
		/>
		@if (!isPatStoreConfigured()) {
			<p class="club-status">PatStore ist nicht konfiguriert.</p>
		} @else {
			<BerichteData />
		}
	</>
}

function BerichteData() @{
	const [filter, setFilter] = useState('alle');
	const [page, setPage] = useState(0);

	@try {
		const articles = publishedArticles(useArticles());
		const allCategories = useCategories();
		const categories = allCategories.filter((category) => category.type === 'sportarten');
		const images = useImages();
		const filtered =
			filter === 'alle' ? articles : articles.filter((article) => idList(article.categories).includes(filter));
		const pageCount = Math.max(1, Math.ceil(filtered.length / PAGE_SIZE));
		const current = filtered.slice(page * PAGE_SIZE, page * PAGE_SIZE + PAGE_SIZE);

		<div class="club-page">
			<HeadContent title="Beiträge" text="Aktuelle und vergangene Berichte aus dem Vereinsgeschehen" />
			<div class="club-switches">
				<SwitchButton text="Alle" active={filter === 'alle'} onClick={() => { setFilter('alle'); setPage(0); }} />
				@for (const category of categories; key category.objectId) {
					<SwitchButton
						text={category.title || ''}
						active={filter === category.objectId}
						onClick={() => { setFilter(category.objectId); setPage(0); }}
					/>
				}
			</div>
			<div class="club-grid">
				@if (current.length === 0) {
					<p>Keine Artikel gefunden</p>
				}
				@for (const article of current; key article.objectId) {
					<BlogElement article={article} images={images} categories={allCategories} />
				}
			</div>
			<Pager page={page} pageCount={pageCount} onPage={setPage} />
		</div>
	} @pending {
		<p class="club-status">Berichte werden geladen…</p>
	} @catch (_error) {
		<p class="club-status">Berichte konnten nicht geladen werden.</p>
	}
}

function Pager(props: { page: number; pageCount: number; onPage: (page: number) => void }) @{
	@if (props.pageCount > 1) {
		<div class="club-pagination">
			<button type="button" onClick={() => props.onPage(Math.max(0, props.page - 1))}>zurück</button>
			@for (const index of pageIndexes(props.pageCount); key index) {
				<button
					type="button"
					class={index === props.page ? 'is-active' : undefined}
					onClick={() => props.onPage(index)}
				>
					{String(index + 1)}
				</button>
			}
			<button type="button" onClick={() => props.onPage(Math.min(props.pageCount - 1, props.page + 1))}>weiter</button>
		</div>
	}
}

function pageIndexes(count: number): number[] {
	return Array.from({ length: count }, (_, index) => index);
}
