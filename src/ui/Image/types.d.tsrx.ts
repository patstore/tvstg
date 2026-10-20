export type ImageProps = {
	imageClass?: string;
	imageContainerClass?: string;
	alt?: string;
	/** Skip lazy loading (LCP / above-the-fold). Default: false. */
	eager?: boolean;
	src?: string;
};
