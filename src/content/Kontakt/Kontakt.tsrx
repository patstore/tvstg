import { Seo, RenderForm } from '@components';
import { findWebpage, useWebpages } from '@provider';
import { isPatStoreConfigured } from '@patstore/core';
import { HeadContent, Loading, RenderContent } from '@ui';

export function Kontakt(props: { language: string }) @{
	<>
		<Seo
			data={{
				title: 'Kontakt',
				description: 'Hast Du Fragen zum Sportangebot, unseren Veranstaltungen oder dem Verein?',
				language: props.language,
			}}
		/>
		@if (!isPatStoreConfigured()) {
			<div class="club-page">
				<HeadContent title="Kontakt" />
				<RenderForm />
			</div>
		} @else {
			<KontaktData />
		}
	</>
}

function KontaktData() @{
	@try {
		const webpage = findWebpage(useWebpages(), 'kontakt');

		<div class="club-page">
			<HeadContent title={webpage?.title || 'Kontakt'} text={webpage?.subtitle} />
			<div class="club-split">
				<div class="club-main">
					<h2 class="club-section-title">Kontaktformular</h2>
					<RenderForm title="Kontaktformular" />
				</div>
				<aside class="club-side">
					<h3 class="club-section-title">Kontakt</h3>
					<RenderContent contentId="contact_page" />
				</aside>
			</div>
		</div>
	} @pending {
		<Loading />
	} @catch (_error) {
		<p class="club-status">Kontaktseite konnte nicht geladen werden.</p>
	}
}
