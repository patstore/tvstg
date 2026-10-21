import { SiteLink } from '@components';
import type { PageProps } from './types.ts';

export function NotFoundPage(_props: PageProps) @{
	<section class="club-page">
		<h1>Seite nicht gefunden</h1>
		<p>Die angeforderte Seite gibt es nicht.</p>
		<SiteLink href="/" class="club-button">Zur Startseite</SiteLink>
	</section>
}
