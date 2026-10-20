import type { SeoData, SeoImage } from '../types.d.ts';

interface SeoTwitterProps {
	data: SeoData;
}

function primaryImageUrl(image: SeoImage | SeoImage[] | undefined): string | undefined {
	if (image == null) return undefined;
	const first = Array.isArray(image) ? image[0] : image;
	return first?.url;
}

function primaryImageAlt(image: SeoImage | SeoImage[] | undefined): string | undefined {
	if (image == null) return undefined;
	const first = Array.isArray(image) ? image[0] : image;
	return first?.alt;
}

export function SeoTwitter(props: SeoTwitterProps) @{
	const { data } = props;
	const social = data.social;
	const twitter = social?.twitter;

	@if (social != null || twitter != null) {
		const card = twitter?.card ?? 'summary_large_image';
		const title = twitter?.title ?? social?.title ?? data.title;
		const description = twitter?.description ?? social?.description ?? data.description;
		const image = twitter?.image ?? primaryImageUrl(social?.image);
		const imageAlt = twitter?.imageAlt ?? primaryImageAlt(social?.image);

		<>
			<meta name="twitter:card" content={card} />

			@if (twitter?.site) {
				<meta name="twitter:site" content={twitter.site} />
			}

			@if (twitter?.creator) {
				<meta name="twitter:creator" content={twitter.creator} />
			}

			<meta name="twitter:title" content={title} />

			@if (description) {
				<meta name="twitter:description" content={description} />
			}

			@if (image) {
				<meta name="twitter:image" content={image} />
			}

			@if (imageAlt) {
				<meta name="twitter:image:alt" content={imageAlt} />
			}
		</>
	}
}
