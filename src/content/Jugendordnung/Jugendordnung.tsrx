import { isPatStoreConfigured } from '@patstore/core';
import { Seo } from '@components';
import { findWebpage, useWebpages } from '@provider';
import { HeadContent, Loading, RenderContent } from '@ui';

export function Jugendordnung(props: { language: string }) @{
	<>
		<Seo
			data={{
				title: 'Jugendordnung',
				description: 'Die Jugendordnung des TV Freiburg St. Georgen von 1897 e.V.',
				language: props.language,
			}}
		/>
		@if (!isPatStoreConfigured()) {
			<p class="club-status">PatStore ist nicht konfiguriert.</p>
		} @else {
			<JugendordnungData />
		}
	</>
}

function JugendordnungData() @{
	@try {
		const webpage = findWebpage(useWebpages(), 'jugendordnung');
		<div class="club-page club-page--narrow">
			<HeadContent title={webpage?.title || 'Jugendordnung'} text={webpage?.subtitle} />
			<RenderContent path="/jugendordnung" />
		</div>
	} @pending {
		<Loading />
	} @catch (_error) {
		<p class="club-status">Jugendordnung konnte nicht geladen werden.</p>
	}
}
