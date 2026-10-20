import { useRouter } from '@provider';
import { PageRouter } from '@pages/.generated/PageRouter.tsrx';
import { Header } from '@components';

export function Layout() @{
	const { contentRef } = useRouter();

	<div class="site">
		<Header />
		<main class="site-main">
			<div class="page-content" ref={contentRef}>
				<PageRouter />
			</div>
		</main>
	</div>
}
