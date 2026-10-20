import type { SeoStructuredData as SeoStructuredDataType } from '../types.d.ts';
import { toJsonLdList } from './toJsonLd.ts';

interface SeoStructuredDataProps {
	structuredData?: SeoStructuredDataType | SeoStructuredDataType[];
}

export function SeoStructuredData(props: SeoStructuredDataProps) @{
	const payloads = toJsonLdList(props.structuredData);

	@if (payloads.length > 0) {
		<>
			@for (const payload of payloads; key payload['@type']) {
				<script
					type="application/ld+json"
					dangerouslySetInnerHTML={{ __html: JSON.stringify(payload) }}
				/>
			}
		</>
	}
}
