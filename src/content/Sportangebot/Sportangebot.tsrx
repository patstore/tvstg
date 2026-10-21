import { Seo } from '@components';
import { HeadContent, SportCalendar } from '@ui';

export function Sportangebot(props: { language: string }) @{
	<div class="club-page">
		<Seo data={{ title: 'Sportangebot', description: 'Trainingszeiten des TV Freiburg St. Georgen', language: props.language }} />
		<HeadContent title="Unser Sportangebot" />
		<SportCalendar categories={[]} />
	</div>
}
