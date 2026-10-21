import { isPatStoreConfigured } from '@patstore/core';
import { Seo } from '@components';
import { findWebpage, sportKeywords, useWebpages } from '@provider';
import { HeadContent, Loading, SportCalendar } from '@ui';

export function Fachabteilung(props: { department: string; language: string }) @{
	<>
		@if (!isPatStoreConfigured()) {
			<>
				<Seo data={{ title: 'Abteilung', language: props.language }} />
				<p class="club-status">PatStore ist nicht konfiguriert.</p>
			</>
		} @else {
			<FachabteilungData department={props.department} language={props.language} />
		}
	</>
}

function FachabteilungData(props: { department: string; language: string }) @{
	@try {
		const webpage = findWebpage(useWebpages(), props.department);
		const title = webpage?.title || labelFromSlug(props.department);

		<div class="club-page">
			<Seo data={{ title, description: webpage?.description || undefined, language: props.language }} />
			<HeadContent title={title} text={webpage?.description || webpage?.subtitle} />
			<SportCalendar keywords={sportKeywords(props.department)} />
		</div>
	} @pending {
		<Loading />
	} @catch (_error) {
		<p class="club-status">Abteilung konnte nicht geladen werden.</p>
	}
}

function labelFromSlug(slug: string): string {
	return slug
		.split('-')
		.map((part) => (part ? part.charAt(0).toUpperCase() + part.slice(1) : part))
		.join(' ');
}
