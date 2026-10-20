import type { SeoData } from '../types.d.ts';

interface SeoBasicsProps {
	data: SeoData;
}

export function SeoBasics(props: SeoBasicsProps) @{
	const { data } = props;

	<>
		<title>{data.title as string}</title>

		@if (data.description) {
			<meta name="description" content={data.description} />
		}

		@if (data.robots) {
			<meta name="robots" content={data.robots} />
		}

		@if (data.keywords?.length) {
			<meta name="keywords" content={data.keywords.join(', ')} />
		}

		@if (data.language) {
			<meta http-equiv="content-language" content={data.language} />
		}

		@if (data.canonical) {
			<link rel="canonical" href={data.canonical} />
		}

		@if (data.alternateLanguages?.length) {
			@for (const alternate of data.alternateLanguages; key alternate.hreflang) {
				<link rel="alternate" hrefLang={alternate.hreflang} href={alternate.href} />
			}
		}
	</>
}
