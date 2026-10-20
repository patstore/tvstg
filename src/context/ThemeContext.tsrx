import { useEffect, useState } from 'octane';
import { ThemeContext, type Theme } from './theme.ts';

function readInitialTheme(): Theme {
	if (typeof window === 'undefined') {
		return 'light';
	}

	const stored = localStorage.getItem('theme');
	if (stored === 'light' || stored === 'dark') {
		return stored;
	}

	return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
}

export function ThemeProvider(props: { children: unknown }) @{
	const [theme, setTheme] = useState<Theme>(readInitialTheme);

	useEffect(() => {
		document.documentElement.dataset.theme = theme;
		localStorage.setItem('theme', theme);
	});

	const toggleTheme = () => {
		setTheme((current) => (current === 'light' ? 'dark' : 'light'));
	};

	<ThemeContext value={{ theme, toggleTheme }}>{props.children}</ThemeContext>
}
