import { useMemo } from 'octane';
import { fetchPatStoreCollection, isPatStoreConfigured } from '@patstore/core';
import {
	CollectionField,
	Field,
	ImageField,
	LinkField,
	Section,
	RichTextField,
	DownloadField,
} from '@ui';
import { AnimateContent, AnimateLine, AnimateText } from '@animations';
import { CmsArticlesCopy, CmsArticles, CmsSection } from './components/index.ts';

interface ArticleRecord {
	objectId: string;
	title?: { value?: string };
	label?: { value?: string };
}

export function Home(_props: { language: string }) @{
	const articlesPromise = useMemo(
		() => fetchPatStoreCollection<ArticleRecord>('Article', { limit: 6 }),
		[],
	);

	<Section id="page" label="Seite">
		<section class="page">
			<Section id="hero" label="Hero">
				<header class="page-header">
					<p class="page-eyebrow">
						<AnimateText delay={0.1} duration={0.6}>
							<Field id="eyebrow" label="Hero Eyebrow">Welcome</Field>
						</AnimateText>
					</p>
					<h1 class="page-title">
						<AnimateText delay={0.2} duration={0.7}>
							<Field id="title" label="Hero Title">Home (default)</Field>
						</AnimateText>
					</h1>
					<p class="page-lede">
						<AnimateText delay={0.35} duration={0.7}>
							<Field id="lede" label="Hero Description">
								A minimal Octane + Vite starter with routing, theming, and page transitions.
							</Field>
						</AnimateText>
					</p>
					<AnimateLine
						length={48}
						direction="left-to-right"
						delay={0.5}
						duration={0.6}
					/>
					<LinkField id="cta-1" label="Hero Call To Action" href="/about" class="btn">
						Learn more
					</LinkField>
				</header>
			</Section>

			<Section id="body" label="Body">
				<article class="page-body">
					@if (isPatStoreConfigured()) {
						<CmsArticlesCopy articles={articlesPromise} />
					} @else {
						<CmsSection />
					}

					<CmsArticles />

					<Section id="content-card" label="Content Card">
						<AnimateContent viewport={0.2} duration={0.7}>
							<div class="content-card">
								<h2>
									<Field id="title" label="Content Card Title">Included</Field>
								</h2>
								<ul>
									<CollectionField id="collection" label="Content Card List">
										<li>
											<Field id="item" label="Content Card Item">Octane components in TSRX</Field>
										</li>
									</CollectionField>
								</ul>
							</div>
						</AnimateContent>
					</Section>

					<Section id="article">
						<article>
							<h2>
								<Field id="title" label="Article Title">Article Title</Field>
							</h2>
							<ImageField
								id="image"
								label="Article Image"
								src="https://via.placeholder.com/150"
								alt="Article Image"
							/>
							<RichTextField id="content" label="Article Content">
								<p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quos.</p>
							</RichTextField>
							<DownloadField
								id="download"
								label="Article Download"
								href="https://via.placeholder.co/150"
								displayFileName
							>Lade das PDF herunter</DownloadField>
						</article>
						<LinkField id="link" href="https://react.dev">Learn more</LinkField>
					</Section>
				</article>
			</Section>
		</section>
	</Section>
}
