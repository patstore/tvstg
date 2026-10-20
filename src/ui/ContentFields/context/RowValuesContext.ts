import { createContext } from 'octane';

/** The current `<CollectionField>` row, if any — `<Field>`/`<ImageField>`/`<LinkField>` inside a collection's item template resolve against this instead of `PageValuesContext`. */
export const RowValuesContext = createContext<Record<string, unknown> | null>(null);
