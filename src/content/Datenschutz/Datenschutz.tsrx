import { Seo } from '@components';
import { HeadContent } from '@ui';

export function Datenschutz(props: { language: string }) @{
	<div class="club-page club-prose">
		<Seo
			data={{
				title: 'Datenschutzerklärung',
				description: 'Allgemeine Informationen zum Datenschutz',
				language: props.language,
			}}
		/>
		<HeadContent title="Datenschutzerklärung" text="Allgemeine Informationen zum Datenschutz" />
		<p>Verantwortlicher im Sinne der Datenschutzgesetze, insbesondere der EU-Datenschutzgrundverordnung (DSGVO), ist:</p>
		<p>
			TV Freiburg St. Georgen von 1897 e.V.
			<br />
			Blumenstraße 9
			<br />
			79111 Freiburg
		</p>
		<h2>Ihre Betroffenenrechte</h2>
		<p>Unter den angegebenen Kontaktdaten unseres Datenschutzbeauftragten können Sie jederzeit folgende Rechte ausüben:</p>
		<ul>
			<li>Auskunft über Ihre bei uns gespeicherten Daten und deren Verarbeitung (Art. 15 DSGVO),</li>
			<li>Berichtigung unrichtiger personenbezogener Daten (Art. 16 DSGVO),</li>
			<li>Löschung Ihrer bei uns gespeicherten Daten (Art. 17 DSGVO),</li>
			<li>Einschränkung der Datenverarbeitung, sofern wir Ihre Daten aufgrund gesetzlicher Pflichten noch nicht löschen dürfen (Art. 18 DSGVO),</li>
			<li>Widerspruch gegen die Verarbeitung Ihrer Daten bei uns (Art. 21 DSGVO) und</li>
			<li>Datenübertragbarkeit, sofern Sie in die Datenverarbeitung eingewilligt haben oder einen Vertrag mit uns abgeschlossen haben (Art. 20 DSGVO).</li>
		</ul>
		<p>Sofern Sie uns eine Einwilligung erteilt haben, können Sie diese jederzeit mit Wirkung für die Zukunft widerrufen.</p>
		<p>
			Sie können sich jederzeit mit einer Beschwerde an eine Aufsichtsbehörde wenden. Eine Liste der Aufsichtsbehörden finden Sie unter{' '}
			<a href="https://www.bfdi.bund.de/DE/Service/Anschriften/Laender/Laender-node.html" target="_blank" rel="noreferrer">
				bfdi.bund.de
			</a>
			.
		</p>
		<h2>Erfassung allgemeiner Informationen beim Besuch unserer Website</h2>
		<p>
			Wenn Sie auf unsere Website zugreifen, werden automatisch Informationen allgemeiner Natur erfasst. Diese Informationen (Server-Logfiles) beinhalten anonymisierte Daten über die Art des Webbrowsers, das verwendete Betriebssystem, das Betriebsgerät, die Referrer, UTM-Parameter, Zeit auf der Seite und Scrollprozent. Hat der Besucher privates Browsing aktiviert, werden keine der zuvor genannten Daten erhoben.
		</p>
		<p>Sie werden insbesondere zur Sicherstellung des Verbindungsaufbaus, der Nutzung der Website, der Systemsicherheit und zur Optimierung der Website verarbeitet. Die Verarbeitung erfolgt gemäß Art. 6 Abs. 1 lit. f DSGVO. Es werden keine personenbezogenen Daten erhoben, deshalb ist ein Löschkonzept nicht vorgesehen.</p>
		<h2>Kontaktformular</h2>
		<p>
			Die von Ihnen eingegebenen Daten werden zum Zweck der individuellen Kommunikation mit Ihnen gespeichert. Hierfür ist die Angabe einer validen E-Mail-Adresse sowie Ihres Namens erforderlich. Die Verarbeitung erfolgt auf Grundlage eines berechtigten Interesses (Art. 6 Abs. 1 lit. f DSGVO) bzw. zur Durchführung vorvertraglicher Maßnahmen (Art. 6 Abs. 1 lit. b DSGVO). Daten werden spätestens 6 Monate nach Bearbeitung der Anfrage gelöscht, sofern keine gesetzlichen Aufbewahrungsfristen entgegenstehen.
		</p>
		<h2>Verwendung von Google Maps</h2>
		<p>
			Auf dieser Website nutzen wir das Angebot von Google Maps. Google Maps wird von Google LLC, 1600 Amphitheatre Parkway, Mountain View, CA 94043, USA betrieben. Nähere Informationen:{' '}
			<a href="https://policies.google.com/privacy" target="_blank" rel="noreferrer">
				https://policies.google.com/privacy
			</a>
			.
		</p>
		<h3>Cookies</h3>
		<p>Auf unserer Webseite verwenden wir keine Cookies.</p>
		<h2>SSL-Verschlüsselung</h2>
		<p>Um die Sicherheit Ihrer Daten bei der Übertragung zu schützen, verwenden wir dem aktuellen Stand der Technik entsprechende Verschlüsselungsverfahren (z. B. SSL) über HTTPS.</p>
		<h2>Widerspruchsrecht nach Art. 21 DSGVO</h2>
		<p>
			Sie haben das Recht, aus Gründen, die sich aus Ihrer besonderen Situation ergeben, jederzeit gegen die Verarbeitung Sie betreffender personenbezogener Daten Widerspruch einzulegen. Empfänger eines Widerspruchs: TV Freiburg St. Georgen, Martin Radtke, Blumenstr. 9, 79111 Freiburg,{' '}
			<a href="mailto:datenschutz@tvstg.de">datenschutz@tvstg.de</a>.
		</p>
		<h2>Fragen an den Datenschutzbeauftragten</h2>
		<p>
			TV Freiburg St. Georgen
			<br />
			Martin Radtke
			<br />
			Blumenstr. 9
			<br />
			79111 Freiburg
			<br />
			<a href="mailto:datenschutz@tvstg.de">datenschutz@tvstg.de</a>
		</p>
	</div>
}
