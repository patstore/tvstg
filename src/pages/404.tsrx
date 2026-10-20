import type { PageProps } from './types.ts';

export function NotFoundPage(_props: PageProps) @{
	<section class="page page--not-found">
		<header class="page-header">
			<h1 class="page-title">404</h1>
			<p class="page-lede">Page not found</p>
		</header>
	</section>
}
