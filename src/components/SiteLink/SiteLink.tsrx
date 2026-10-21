import { useRouter, type RoutePath } from '@provider';

export function SiteLink(props: { href: string; class?: string; children?: unknown }) @{
	const { navigate } = useRouter();
	const external = props.href.startsWith('http');

	<a
		href={props.href}
		class={props.class}
		target={external ? '_blank' : undefined}
		rel={external ? 'noreferrer' : undefined}
		onClick={(event: MouseEvent) => {
			if (external || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey || event.button !== 0) {
				return;
			}
			event.preventDefault();
			navigate(props.href as RoutePath);
		}}
	>
		{props.children}
	</a>
}
