import { Home } from '@octanejs/lucide';
import { resolveDocumentLang, resolveLocalizedPath, useRouter, type RoutePath } from '@provider';
import { LanguageToggle, ThemeToggle, HeaderNavLink } from './components';
import { getHeaderNavItems } from './constants/nav.ts';
import styles from './Header.module.scss';

export function Header() @{
	const { path, navigate } = useRouter();
	const language = resolveDocumentLang(path);
	const navItems = getHeaderNavItems(language);
	const homePath = resolveLocalizedPath('/', language) as RoutePath;

	<header class={styles.site_header}>
		<div class={styles.inner}>
			<a
				class={styles.logo}
				href={homePath}
				onClick={(event) => {
					event.preventDefault();
					navigate(homePath);
				}}
			>
				<span aria-hidden="true">
					<Home size={18} strokeWidth={2.25} />
				</span>
				<span class="site-logo__text">Octane Starter</span>
			</a>

			<nav class={styles.nav} aria-label="Main">
				<ul class={styles.nav_list}>
					@for (const item of navItems; key item.path) {
						<HeaderNavLink item={item} language={language} currentPath={path} />
					}
				</ul>
			</nav>

			<div class={styles.actions}>
				<LanguageToggle />
				<ThemeToggle />
			</div>
		</div>
	</header>
}
