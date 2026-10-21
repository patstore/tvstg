import { Seo } from '@components';
import { HeadContent, RenderContent, SportBanner } from '@ui';

export function Verein(props: { language: string }) @{
	<div>
		<Seo data={{ title: 'Über den Verein', description: 'Das Wesentliche über den TV Freiburg St. Georgen.', language: props.language }} />
		<div class="club-page club-page--narrow">
			<HeadContent title="Über den Verein" text="In aller Kürze das Wesentliche über den Verein." />
			<RenderContent path="vorstand" />
		</div>
		<div class="club-page">
			<SportBanner />
		</div>
	</div>
}
