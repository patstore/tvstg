import { isPatStoreConfigured } from '@patstore/core';
import { Seo } from '@components';
import { downloadUrl, idList, mediaUrl, useCategories, useDownloads, useImages } from '@provider';
import { HeadContent } from '@ui';

export function Veroeffentlichungen(props: { language: string }) @{
	<>
		<Seo
			data={{
				title: 'Veröffentlichungen',
				description: 'Unsere Zeitschriften und Flyer hier in digitaler Form.',
				language: props.language,
			}}
		/>
		@if (!isPatStoreConfigured()) {
			<p class="club-status">PatStore ist nicht konfiguriert.</p>
		} @else {
			<Publications />
		}
	</>
}

function Publications() @{
	@try {
		const downloads = useDownloads();
		const categories = useCategories();
		const images = useImages();
		const media = categories.find((category) => category.title === 'Medien');
		const published = downloads.filter((item) => item.state !== 'draft' && downloadUrl(item));
		const items = media
			? published.filter((item) => idList(item.categories).includes(media.objectId))
			: published.filter((item) => /echo|flyer|heft|zeitschrift|jubil/i.test(item.title || '') || Boolean(item.image));

		<div class="club-page">
			<HeadContent title="Veröffentlichungen" text="Unsere Zeitschriften und Flyer hier in digitaler Form." />
			<div class="club-grid">
				@for (const item of items; key item.objectId) {
					<a class="club-publication" href={downloadUrl(item)} target="_blank" rel="noreferrer">
						@if (mediaUrl(item.image, images)) {
							<img src={mediaUrl(item.image, images)} alt={(item.title || '') as string} />
						}
						<h2>{(item.title || '') as string}</h2>
					</a>
				}
			</div>
		</div>
	} @pending {
		<p class="club-status">Veröffentlichungen werden geladen…</p>
	} @catch (_error) {
		<p class="club-status">Veröffentlichungen konnten nicht geladen werden.</p>
	}
}
