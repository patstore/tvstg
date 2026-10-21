import { isPatStoreConfigured } from '@patstore/core';
import { Seo } from '@components';
import { downloadUrl, findWebpage, useDownloads, useWebpages } from '@provider';
import { HeadContent, RenderContent } from '@ui';

export function Mitgliedschaft(props: { language: string }) @{
	<>
		<Seo data={{ title: 'Mitgliedschaft', description: 'Mitglied werden beim TV Freiburg St. Georgen', language: props.language }} />
		@if (!isPatStoreConfigured()) {
			<p class="club-status">PatStore ist nicht konfiguriert.</p>
		} @else {
			<MitgliedschaftData />
		}
	</>
}

function MitgliedschaftData() @{
	@try {
		const webpage = findWebpage(useWebpages(), 'mitgliedschaft');
		const form = useDownloads().find((item) => item.title === 'Mitgliedsantrag');

		<div class="club-page">
			<HeadContent title={webpage?.title || 'Mitgliedschaft'} text={webpage?.subtitle} />
			<div class="club-split">
				<div>
					<h2>Online-Anmeldung</h2>
					<p>Melden Sie sich einfach über unser Online-Portal an.</p>
					<a class="club-button" href="https://tvstg.pw-ng.de/Frontend/Home/NewMember" target="_blank" rel="noreferrer">
						Online anmelden
					</a>
				</div>
				<div>
					<h2>Mitgliedsantrag</h2>
					@if (form) {
						<a class="club-button club-button--dark" href={downloadUrl(form)} target="_blank" rel="noreferrer">
							Mitgliedsantrag herunterladen
						</a>
					}
				</div>
			</div>
			<RenderContent path="/mitgliedschaft" />
			<div class="club-prose">
				<p>Die Beiträge werden jeweils jährlich im Voraus abgebucht.</p>
				<p>
					* Ab dem Kalenderjahr nach Vollendung des 18. Lebensjahres gilt der Beitragssatz für Erwachsene. Bei Vorlage einer aktuellen Schul- oder Hochschulbescheinigung wird bis einschließlich 25 Jahre ein ermäßigter Beitrag gewährt.
				</p>
				<p>** Der Familienbeitrag setzt voraus, dass bereits eine Person aus der Familie Mitglied im Turnverein Freiburg-St. Georgen ist.</p>
				<p>*** Eventuelle Zusatzbeiträge einzelner Abteilungen erhöhen den Familienbeitrag.</p>
				<p>**** Hier entfällt die Aufnahmegebühr.</p>
				<p>
					Weitere Informationen: Tel. 0761 46732, E-Mail <a href="mailto:info@tvstg.de">info@tvstg.de</a>
				</p>
			</div>
		</div>
	} @pending {
		<p class="club-status">Mitgliedschaft wird geladen…</p>
	} @catch (_error) {
		<p class="club-status">Mitgliedschaft konnte nicht geladen werden.</p>
	}
}
