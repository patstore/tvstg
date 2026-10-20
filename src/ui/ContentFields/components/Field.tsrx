import { Fragment, useContext } from 'octane';
import { PageValuesContext, RowValuesContext, SectionPathContext } from '../context/index.ts';
import { findValueForKey } from '../functions/index.ts';

export interface FieldProps {
	/** Field key, literal string — combined with the ambient section path to form the full dot-path. */
	id: string;
	/** Editor-facing label. Read directly from source by the manifest scanner. */
	label?: string;
	/** JSX default, used until a CMS value resolves. */
	children?: unknown;
}

/**
 * A text leaf. Inside a `<CollectionField>` item template, resolves `id`
 * against the current row instead of the page-level content map — collection
 * rows are flat `{ fieldKey: value }` objects, not nested under the section path.
 *
 * The two branches render `value` vs `children` from separate JSX positions
 * rather than a `{cond ? value : children} as string` ternary — the compiler
 * lowers a component's JSX children into a callable render function, not a
 * plain string, so it must see a bare `{children}` (its special-cased
 * invocation form) to invoke it; wrapping it in a ternary/cast instead
 * stringifies the function itself.
 */
export function Field({ id, children }: FieldProps) @{
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
		<Fragment>{value}</Fragment>
	} @else {
		<Fragment>{children}</Fragment>
	}
}
