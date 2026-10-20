import { useState } from 'octane';
import type { ImageProps } from './types.tsrx';

export function Image({
	alt = 'Image',
	eager = false,
	src = 'https://placehold.co/600x400',
	imageClass,
	imageContainerClass,
}: ImageProps) @{
	const [loaded, setLoaded] = useState(false);

	<>
		<style>
			.image {
				width: var(--image-frame-width, 100%);
				height: var(--image-frame-height, auto);
				aspect-ratio: var(--image-aspect-ratio, 3 / 2);
				background-color: #f0f0f0;
				overflow: hidden;
			}
			.image__img {
				width: var(--image-width, 100%);
				height: var(--image-height, 100%);
				position: var(--image-position, static);
				object-fit: cover;
				transition: opacity 0.3s ease;
			}
			.image.is-loaded .image__img {
				opacity: 1;
			}
		</style>
		<div class={['image', imageContainerClass, loaded ? 'is-loaded' : '']}>
			<img
				class={['image__img', imageClass]}
				src={src}
				alt={alt}
				loading={eager ? 'eager' : 'lazy'}
				decoding="async"
				onLoad={() => setLoaded(true)}
			/>
		</div>
	</>
}
