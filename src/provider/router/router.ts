/** @jsxImportSource octane */
import { createContext, useContext } from 'octane';

export type RoutePath = string;

export interface RouterContextValue {
	path: RoutePath;
	navigate: (to: RoutePath) => void;
	contentRef: { current: HTMLDivElement | null };
}

export const RouterContext = createContext<RouterContextValue | null>(null);

export function useRouter(): RouterContextValue {
	const context = useContext(RouterContext);
	if (!context) {
		throw new Error('useRouter must be used within RouterProvider');
	}
	return context;
}
