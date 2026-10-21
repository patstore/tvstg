import { isPatStoreConfigured } from '@patstore/core';
import { Seo } from '@components';
import { downloadUrl, findWebpage, idList, useDownloads, useImages, usePersons, useWebpages } from '@provider';
import { ContactPerson, HeadContent, Loading, RenderContent } from '@ui';

export function Praevention(props: { language: string }) @{
	<>
		<Seo
			data={{
				title: 'Prävention',
				description: 'Kinder und Jugendschutz im TV Freiburg St. Georgen.',
				language: props.language,
			}}
		/>
		@if (!isPatStoreConfigured()) {
			<p class="club-status">PatStore ist nicht konfiguriert.</p>
		} @else {
			<PraeventionData />
		}
	</>
}

function PraeventionData() @{
	@try {
		const webpage = findWebpage(useWebpages(), 'praevention');
		const images = useImages();
		const persons = usePersons().filter((person) => idList(person.categories).includes('7wjIlSmQ8x'));
		const downloads = useDownloads().filter((item) => idList(item.categories).includes('3zUkKuH1v8'));

		<div class="club-page">
			<HeadContent title={webpage?.title || 'Prävention'} text={webpage?.subtitle} />
			<div class="club-split">
				<div class="club-main">
					<RenderContent path="/verein/praevention" />
				</div>
				<aside class="club-side">
					<h3 class="club-section-title">Ansprechpartner:Innen</h3>
					@for (const person of persons; key person.objectId) {
						<ContactPerson person={person} images={images} />
					}
					<h3 class="club-section-title">Dokumente</h3>
					@for (const download of downloads; key download.objectId) {
						<a href={downloadUrl(download)} target="_blank" rel="noreferrer">
							{(download.title || 'Dokument') as string}
						</a>
					}
				</aside>
			</div>
		</div>
	} @pending {
		<Loading />
	} @catch (_error) {
		<p class="club-status">Prävention konnte nicht geladen werden.</p>
	}
}
