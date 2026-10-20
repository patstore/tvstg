import { useContext } from 'octane';
import { PageValuesContext, RowValuesContext, SectionPathContext } from '../context/index.ts';
import { findValueForKey } from '../functions/index.ts';

export interface RichTextFieldProps {
	/** Field key, literal string — combined with the ambient section path to form the full dot-path. */
	id: string;
	/** Editor-facing label. Read directly from source by the manifest scanner. */
	label?: string;
	class?: string;
	/** JSX default, used until a CMS value resolves — rendered as normal JSX, not as HTML. */
	children?: unknown;
}

/**
 * A rich-text leaf. PatStore's editor stores rich text as an HTML string, so
 * once a CMS value resolves it's injected via `dangerouslySetInnerHTML`
 * rather than treated as plain text (unlike `<Field>`). Until then, the JSX
 * default renders normally as ordinary nested elements/text.
 */
export function RichTextField({ id, class: className, children }: RichTextFieldProps) @{
	const row = useContext(RowValuesContext);
	const sectionPath = useContext(SectionPathContext);
	const { pageData, currentLanguage } = useContext(PageValuesContext);

	const value = row
		? row[id]
		: findValueForKey({
				key: sectionPath ? `${sectionPath}.${id}` : id,
				lang: currentLanguage,
				content: pageData,
			});

	@if (typeof value === 'string') {
		<div class={className} dangerouslySetInnerHTML={{ __html: value }} />
	} @else {
		<div class={className}>{children}</div>
	}
}
