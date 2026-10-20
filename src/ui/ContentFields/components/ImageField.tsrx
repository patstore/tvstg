import { use, useContext, useMemo } from 'octane';
import { fetchPatStoreObject } from '@patstore/core';
import type { PatstoreImage } from '@data';
import { isPreviewEnabled } from '@provider';
import { Image, type ImageProps } from '../../Image/index.ts';
import { PageValuesContext, RowValuesContext, SectionPathContext } from '../context/index.ts';
import { findValueForKey, imageRecordSrc, isDirectImageSrc } from '../functions/index.ts';

export interface ImageFieldProps extends Omit<ImageProps, 'src'> {
	/** Field key, literal string — combined with the ambient section path to form the full dot-path. */
	id: string;
	/** Editor-facing label. Read directly from source by the manifest scanner. */
	label?: string;
	/** JSX default `src`, used until a CMS value resolves. */
	src?: string;
}

interface FetchedImageFieldProps extends Omit<ImageProps, 'src'> {
	imageId: string;
	fallbackSrc?: string;
}

/** Loads one `Image` record: local snapshot, or live PatStore when preview is on. */
function FetchedImageField({ imageId, fallbackSrc, ...imageProps }: FetchedImageFieldProps) @{
	const source = isPreviewEnabled() ? 'dynamic' : 'static';
	const imagePromise = useMemo(
		() => fetchPatStoreObject<PatstoreImage>('Image', imageId, { source }),
		[imageId, source],
	);
	const image = use(imagePromise);
	const resolvedSrc = imageRecordSrc(image) ?? fallbackSrc;

	@if (resolvedSrc) {
		<Image {...imageProps} src={resolvedSrc} />
	}
}

/** An image leaf — renders `@ui`'s plain `Image` component with the resolved `src`. */
export function ImageField({
	id,
	label: _label,
	src,
	imageClass,
	imageContainerClass,
	...imageProps
}: ImageFieldProps) @{
	const row = useContext(RowValuesContext);
	const sectionPath = useContext(SectionPathContext);
	const { pageData, currentLanguage } = useContext(PageValuesContext);

	const value = row
		? row[id]
		: findValueForKey({
				key: sectionPath ? `${sectionPath}.${id}` : id,
				lang: currentLanguage,
				content: pageData,
			});

	const stored = typeof value === 'string' && value ? value : undefined;
	const directSrc = stored && isDirectImageSrc(stored) ? stored : undefined;
	const imageId = stored && !directSrc ? stored : undefined;
	const fallbackSrc = directSrc ?? src;

	@if (imageId) {
		@try {
			<FetchedImageField
				imageId={imageId}
				fallbackSrc={src}
				imageClass={imageClass}
				imageContainerClass={imageContainerClass}
				{...imageProps}
			/>
		} @pending {
			@if (fallbackSrc) {
				<Image
					imageClass={imageClass}
					imageContainerClass={imageContainerClass}
					{...imageProps}
					src={fallbackSrc}
				/>
			}
		} @catch (_error) {
			@if (fallbackSrc) {
				<Image
					imageClass={imageClass}
					imageContainerClass={imageContainerClass}
					{...imageProps}
					src={fallbackSrc}
				/>
			}
		}
	} @else {
		@if (fallbackSrc) {
			<Image
				imageClass={imageClass}
				imageContainerClass={imageContainerClass}
				{...imageProps}
				src={fallbackSrc}
			/>
		}
	}
}
