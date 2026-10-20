import { useContext } from 'octane';
import { PageValuesContext, RowValuesContext, SectionPathContext } from '../context/index.ts';
import { findValueForKey } from '../functions/index.ts';

export interface CollectionFieldProps {
	/** Field key, literal string — combined with the ambient section path to form the full dot-path. */
	id: string;
	/** Editor-facing label. Read directly from source by the manifest scanner. */
	label?: string;
	/** Exactly one JSX element — the per-item template. The scanner reads `<Field>`/`<ImageField>`/`<LinkField>` inside it as the collection's item schema. */
	children?: unknown;
}

/**
 * Repeats its JSX children once per resolved array item, providing each
 * repetition a `RowValuesContext` so nested `<Field>`/`<ImageField>`/
 * `<LinkField>` resolve against that row instead of the page-level content
 * map. `children` here is a compiler-lowered children-block render function
 * (not a plain element tree, per Octane's fine-grained reactivity model), so
 * it's simply re-rendered once per loop iteration (via `{children}`) rather
 * than extracted and `cloneElement`-ed — each render sees whichever
 * `RowValuesContext` is active at that point in the loop.
 */
export function CollectionField({ id, children }: CollectionFieldProps) @{
	const sectionPath = useContext(SectionPathContext);
	const { pageData, currentLanguage } = useContext(PageValuesContext);

	const path = sectionPath ? `${sectionPath}.${id}` : id;
	const value = findValueForKey({
		key: path,
		lang: currentLanguage,
		content: pageData,
	});
	const items = Array.isArray(value) ? (value as Array<Record<string, unknown>>) : [];
	// `@for` needs a plain identifier loop variable, not a destructuring
	// pattern (`for (const [index, item] of items.entries())` breaks the
	// compiled list's sibling tracking) — pre-pair index+item instead.
	const indexedItems = items.map((item, index) => ({ item, index }));

	@for (const row of indexedItems; key row.index) {
		<RowValuesContext value={row.item}>{children}</RowValuesContext>
	}
}
