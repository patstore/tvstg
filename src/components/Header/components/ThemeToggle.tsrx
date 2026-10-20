import { Moon, Sun } from '@octanejs/lucide';
import { useToggle } from '@octanejs/usehooks-ts';
import { useEffect } from 'octane';
import { useTheme } from '@context';

export function ThemeToggle() @{
	const { theme, toggleTheme } = useTheme();
	const [pressed, , setPressed] = useToggle(theme === 'dark');

	useEffect(() => {
		setPressed(theme === 'dark');
	});

	<button
		type="button"
		class="theme-toggle"
		onClick={toggleTheme}
		aria-pressed={pressed}
		aria-label={theme === 'dark' ? 'Switch to light mode' : 'Switch to dark mode'}
	>
		@if (theme === 'dark') {
			<Sun size={18} strokeWidth={2.25} />
		} @else {
			<Moon size={18} strokeWidth={2.25} />
		}
	</button>
}
