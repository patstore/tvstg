import { Info, Newspaper, Home } from '@octanejs/lucide';
import { isSamePagePath, resolveLocalizedPath, useRouter, type RoutePath } from '@provider';
import type { HeaderNavItem } from '../constants/nav.ts';
import styles from '../Header.module.scss';

function navIcon(item: HeaderNavItem) {
	if (item.path === '/about') {
		return <Info size={16} strokeWidth={2.25} aria-hidden="true" />;
	}
	if (item.path === '/artikel') {
		return <Newspaper size={16} strokeWidth={2.25} aria-hidden="true" />;
	}
	return <Home size={16} strokeWidth={2.25} aria-hidden="true" />;
}

export function HeaderNavLink(props: {
	item: HeaderNavItem;
	language: string;
	currentPath: RoutePath;
}) @{
	const { navigate } = useRouter();
	const itemPath = resolveLocalizedPath(props.item.path, props.language) as RoutePath;
	const isActive = isSamePagePath(props.currentPath, props.item.path);

	<li>
		<a
			class={styles.nav_link + (isActive ? ' ' + styles['is-active'] : '')}
			href={itemPath}
			aria-current={isActive ? 'page' : undefined}
			onClick={(event) => {
				event.preventDefault();
				navigate(itemPath);
			}}
		>
			{navIcon(props.item)}
			<span>{props.item.label as string}</span>
		</a>
	</li>
}
