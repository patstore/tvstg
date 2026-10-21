import { isPatStoreConfigured } from '@patstore/core';
import { Seo } from '@components';
import { findWebpage, useWebpages } from '@provider';
import { HeadContent, RenderContent } from '@ui';

export function Satzung(props: { language: string }) @{
	<>
		<Seo data={{ title: 'Satzung', description: 'Die Satzung des TV Freiburg St. Georgen von 1897 e.V.', language: props.language }} />
		@if (!isPatStoreConfigured()) {
			<p class="club-status">PatStore ist nicht konfiguriert.</p>
		} @else {
			<SatzungData />
		}
	</>
}

function SatzungData() @{
	@try {
		const webpage = findWebpage(useWebpages(), 'satzung');
		<div class="club-page club-page--narrow">
			<HeadContent title={webpage?.title || 'Satzung'} text={webpage?.subtitle} />
			<RenderContent path="/satzung" />
		</div>
	} @pending {
		<p class="club-status">Satzung wird geladen…</p>
	} @catch (_error) {
		<p class="club-status">Satzung konnte nicht geladen werden.</p>
	}
}
