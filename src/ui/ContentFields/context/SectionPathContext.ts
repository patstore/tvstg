import { createContext } from 'octane';

/** Dot-path prefix accumulated by nested `<Section>` wrappers (e.g. `page.hero`). */
export const SectionPathContext = createContext<string>('');
