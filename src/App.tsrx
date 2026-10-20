import { ThemeProvider } from '@context';
import { RouterProvider } from '@provider';
import { Layout } from '@components';

export function App() @{
	<ThemeProvider>
		<RouterProvider>
			<Layout />
		</RouterProvider>
	</ThemeProvider>
}
