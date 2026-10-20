import { useContext } from 'octane';
import { PageValuesContext, RowValuesContext, SectionPathContext } from '../context/index.ts';
import { findValueForKey } from '../functions/index.ts';

type CmsLinkValue = { text?: string; href?: string };

function isLinkValue(value: unknown): value is CmsLinkValue {
	if (!value || typeof value !== 'object') return false;
	return 'href' in value || 'text' in value;
}

export interface LinkFieldProps {
	/** Field key, literal string — combined with the ambient section path to form the full dot-path. */
	id: string;
	/** Editor-facing label. Read directly from source by the manifest scanner. */
	label?: string;
	/** JSX default `href`, used until a CMS value resolves. */
	href?: string;
	class?: string;
	/** JSX default link text, used until a CMS value resolves. */
	children?: unknown;
}

/**
 * A link leaf — resolved value is `{ text, href }`; either half falls back to
 * the JSX defaults independently.
 *
 * The two branches render `resolved.text` vs `children` from separate JSX
 * positions rather than a `{resolved?.text ?? children} as string`
 * expression — the compiler lowers a component's JSX children into a
 * callable render function, not a plain string, so it must see a bare
 * `{children}` (its special-cased invocation form) to invoke it; wrapping it
 * in `??`/a cast instead stringifies the function itself.
 */
export function LinkField({ id, href, class: className, label, children }: LinkFieldProps) @{
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
	const resolved = isLinkValue(value) ? value : { href: href, text: label || '' };
	const resolvedTarget = resolved.href.includes('http') ? '_blank' : '_self';
	const resolvedHref = resolved?.href ?? href;
	const rel = resolvedHref === '_blank' ? 'noopener noreferrer' : undefined;

	@if (typeof resolved?.text === 'string') {
		<a class={className} href={resolvedHref} target={resolvedTarget} rel={rel}>
			{resolved.text ? resolved.text : children}
		</a>
	} @else {
		children;
	}
}
