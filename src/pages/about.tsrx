import type { PageProps } from './types.ts';

export function AboutPage(_props: PageProps) @{
	<section class="page">
		<header class="page-header">
			<p class="page-eyebrow">About</p>
			<h1 class="page-title">About this starter</h1>
			<p class="page-lede">
				Built with Octane, Vite, GSAP, Lenis, and SCSS — ready for your content.
			</p>
		</header>

		<div class="page-body">
			<div class="content-card">
				<h2>Stack</h2>
				<p>
					<a href="https://octanejs.dev/" target="_blank" rel="noreferrer">
						Octane
					</a>
					{' compiles React-style components ahead of time. '}
					<a href="https://vite.dev/" target="_blank" rel="noreferrer">
						Vite
					</a>
					{' handles dev server and bundling.'}
				</p>
			</div>

			<div class="content-card">
				<h2>Next steps</h2>
				<p>
					Add your pages, components, and styles. Run
					<code>npm run doctor</code>
					to verify the Octane setup.
				</p>
			</div>
		</div>
	</section>
}
