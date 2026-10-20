import type { SeoData, SeoImage, SeoSocialMeta } from '../types.d.ts';

interface SeoOpenGraphProps {
	data: SeoData;
}

function normalizeImages(image: SeoImage | SeoImage[] | undefined): SeoImage[] {
	if (image == null) return [];
	return Array.isArray(image) ? image : [image];
}

function articleAuthors(article: NonNullable<SeoSocialMeta['article']>): string[] {
	if (article.author == null) return [];
	return Array.isArray(article.author) ? article.author : [article.author];
}

function articleTags(article: NonNullable<SeoSocialMeta['article']>): string[] {
	if (article.tag == null) return [];
	return Array.isArray(article.tag) ? article.tag : [article.tag];
}

export function SeoOpenGraph(props: SeoOpenGraphProps) @{
	const { data } = props;
	const social = data.social;

	@if (social != null) {
		const ogTitle = social.title ?? data.title;
		const ogDescription = social.description ?? data.description;
		const ogType = social.type ?? 'website';
		const images = normalizeImages(social.image);
		const authors =
			social.article ? articleAuthors(social.article) : [];
		const tags =
			social.article ? articleTags(social.article) : [];

		<>
			<meta property="og:title" content={ogTitle} />

			@if (ogDescription) {
				<meta property="og:description" content={ogDescription} />
			}

			<meta property="og:type" content={ogType} />

			@if (social.url ?? data.canonical) {
				<meta property="og:url" content={social.url ?? data.canonical} />
			}

			@if (social.siteName) {
				<meta property="og:site_name" content={social.siteName} />
			}

			@if (social.locale) {
				<meta property="og:locale" content={social.locale} />
			}

			@for (const image of images; key image.url) {
				<>
					<meta property="og:image" content={image.url} />
					@if (image.alt) {
						<meta property="og:image:alt" content={image.alt} />
					}
					@if (image.width != null) {
						<meta property="og:image:width" content={String(image.width)} />
					}
					@if (image.height != null) {
						<meta property="og:image:height" content={String(image.height)} />
					}
					@if (image.type) {
						<meta property="og:image:type" content={image.type} />
					}
				</>
			}

			@if (social.article) {
				<>
					@if (social.article.publishedTime) {
						<meta property="article:published_time" content={social.article.publishedTime} />
					}
					@if (social.article.modifiedTime) {
						<meta property="article:modified_time" content={social.article.modifiedTime} />
					}
					@if (social.article.expirationTime) {
						<meta property="article:expiration_time" content={social.article.expirationTime} />
					}
					@if (social.article.section) {
						<meta property="article:section" content={social.article.section} />
					}

					@for (const author of authors; key author) {
						<meta property="article:author" content={author} />
					}

					@for (const tag of tags; key tag) {
						<meta property="article:tag" content={tag} />
					}
				</>
			}

			@if (social.product) {
				<>
					@if (social.product.priceAmount != null && social.product.priceCurrency) {
						<>
							<meta property="product:price:amount" content={String(social.product.priceAmount)} />
							<meta property="product:price:currency" content={social.product.priceCurrency} />
						</>
					}
					@if (social.product.availability) {
						<meta property="product:availability" content={social.product.availability} />
					}
				</>
			}
		</>
	}
}
