import type { PageProps } from '../types.ts';

export function ArtikelPage(props: PageProps) @{
	console.log(props.language);
	<section class="page">
		<header class="page-header">
			<h1 class="page-title">Artikel</h1>
			<p class="page-lede">
				{'Dies ist die Artikelseite' + (props.language === 'de' ? ' auf Deutsch.' : '.')}
			</p>
		</header>
	</section>
}
