import { useContext } from 'octane';
import { SectionPathContext } from '../context/index.ts';

export interface SectionProps {
	/** Segment appended to the ambient section path — must be a literal string (the manifest scanner reads it statically). */
	id: string;
	/** Editor-facing label for this section. Purely descriptive here; the scanner reads it directly from source. */
	label?: string;
	children?: unknown;
}

/**
 * Pure context provider — renders no DOM of its own. Nests the ambient
 * `SectionPathContext` one level deeper so descendant `<Field>`/`<ImageField>`/
 * `<LinkField>`/`<CollectionField>` resolve their full dot-path (`page.hero.title`)
 * without needing to know their own ancestry.
 */
export function Section({ id, children }: SectionProps) @{
	const parent = useContext(SectionPathContext);
	const path = parent ? `${parent}.${id}` : id;

	<SectionPathContext value={path}>{children}</SectionPathContext>
}
