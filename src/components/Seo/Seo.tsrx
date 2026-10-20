import type { SeoProps } from './types.d.ts';
import { SeoBasics } from './components/SeoBasics.tsrx';
import { SeoOpenGraph } from './components/SeoOpenGraph.tsrx';
import { SeoStructuredData } from './components/SeoStructuredData.tsrx';
import { SeoTwitter } from './components/SeoTwitter.tsrx';

/**
 * Renders document metadata from a typed SEO object.
 * `<title>`, `<meta>`, and `<link>` tags are hoisted to `<head>` by Octane.
 */
export function Seo(props: SeoProps) @{
	const { data } = props;

	<>
		<SeoBasics data={data} />
		<SeoOpenGraph data={data} />
		<SeoTwitter data={data} />
		<SeoStructuredData structuredData={data.structuredData} />
	</>
}
