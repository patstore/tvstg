import { Seo } from '@components';
import { HeadContent, RenderContent } from '@ui';

export function Impressum(props: { language: string }) @{
	<div class="club-page">
		<Seo data={{ title: 'Impressum', description: 'Impressum des TV Freiburg St. Georgen', language: props.language }} />
		<HeadContent title="Impressum" />
		<RenderContent path="impressum" />
		<div class="club-prose">
			<p>
				TV Freiburg St. Georgen von 1897 e.V.
				<br />
				Blumenstraße 9
				<br />
				79111 Freiburg
			</p>
			<p>
				Tel.: 0761 46732
				<br />
				<a href="mailto:info@tvstg.de">info@tvstg.de</a>
			</p>
		</div>
	</div>
}
