import { useRouter } from '@provider';
import { PageRouter } from '@pages/.generated/PageRouter.tsrx';
import { Footer } from '../Footer/index.ts';
import { Header } from '../Header/index.ts';

export function Layout() @{
	const { contentRef } = useRouter();

	<div class="site">
		<Header />
		<main class="site-main">
			<div class="page-content" ref={contentRef}>
				<PageRouter />
			</div>
		</main>
		<Footer />
	</div>
}
