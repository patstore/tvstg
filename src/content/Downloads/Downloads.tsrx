import { isPatStoreConfigured } from '@patstore/core';
import { Seo } from '@components';
import { downloadUrl, idList, useCategories, useDownloads } from '@provider';
import { HeadContent, Loading } from '@ui';

export function Downloads(props: { language: string }) @{
	<>
		<Seo data={{ title: 'Downloads', description: 'Dokumente und Downloads', language: props.language }} />
		@if (!isPatStoreConfigured()) {
			<p class="club-status">PatStore ist nicht konfiguriert.</p>
		} @else {
			<DownloadsData />
		}
	</>
}

function DownloadsData() @{
	@try {
		const downloads = useDownloads().filter((item) => item.state !== 'draft' && downloadUrl(item));
		const categories = useCategories().filter((category) => category.title);

		<div class="club-page">
			<HeadContent title="Alle Downloads und Dokumente" />
			@if (categories.length === 0) {
				<ul class="club-download-list">
					@for (const download of downloads; key download.objectId) {
						<li>
							<a href={downloadUrl(download)} target="_blank" rel="noreferrer">
								{(download.title || 'Download') as string}
							</a>
						</li>
					}
				</ul>
			} @else {
				@for (const category of categories; key category.objectId) {
					<section>
						<h3>{(category.title || '') as string}</h3>
						@for (const download of downloads; key category.objectId + download.objectId) {
							@if (idList(download.categories).includes(category.objectId)) {
								<a href={downloadUrl(download)} target="_blank" rel="noreferrer">
									{(download.title || 'Download') as string}
								</a>
							}
						}
					</section>
				}
			}
		</div>
	} @pending {
		<Loading />
	} @catch (_error) {
		<p class="club-status">Downloads konnten nicht geladen werden.</p>
	}
}
