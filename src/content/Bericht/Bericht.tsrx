import { isPatStoreConfigured } from '@patstore/core';
import { Seo } from '@components';
import {
	categoryTitles,
	findBySlug,
	htmlString,
	mediaUrl,
	publishedArticles,
	slugify,
	useArticles,
	useCategories,
	useImages,
} from '@provider';
import { Html, Label, Loading, SportBanner } from '@ui';

export function Bericht(props: { slug: string; language: string }) @{
	@if (!props.slug || !isPatStoreConfigured()) {
		<p class="club-status">Beitrag nicht gefunden.</p>
	} @else {
		<BerichtData slug={props.slug} language={props.language} />
	}
}

function BerichtData(props: { slug: string; language: string }) @{
	@try {
		const article = findBySlug(publishedArticles(useArticles()), props.slug);
		const images = useImages();
		const categories = useCategories();
		const label = categoryTitles(article?.categories, categories)[0] || '';
		const image = article ? mediaUrl(article.image, images) : '';
		const gallery = Array.isArray(article?.gallery) ? article.gallery : [];

		@if (!article) {
			<p class="club-status">Beitrag nicht gefunden.</p>
		} @else {
			<div>
				<Seo
					data={{
						title: article.title || 'Beitrag',
						description: article.description || undefined,
						language: props.language,
					}}
				/>
				<article class="club-page">
					@if (label) {
						<Label text={label} />
					}
					<h1>{(article.title || '') as string}</h1>
					@if (image) {
						<img class="club-media" src={image} alt={(article.title || '') as string} />
					}
					<Html html={htmlString(article.text)} />
					@if (gallery.length > 0) {
						<div class="club-grid">
							@for (const item of gallery; key String(item)) {
								<img src={mediaUrl(item, images)} alt={(article.title || '') as string} />
							}
						</div>
					}
				</article>
				<div class="club-page">
					<SportBanner />
				</div>
			</div>
		}
	} @pending {
		<Loading />
	} @catch (_error) {
		<p class="club-status">Beitrag konnte nicht geladen werden.</p>
	}
}

export function articlePath(title: string): string {
	return `/aktuelles/${slugify(title)}`;
}
