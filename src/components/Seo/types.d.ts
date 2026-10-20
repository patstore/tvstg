/** Image reference for Open Graph, Twitter, and structured data. */
export interface SeoImage {
	url: string;
	alt?: string;
	width?: number;
	height?: number;
	type?: string;
}

/** Author or person reference used across article and review schemas. */
export interface SeoAuthor {
	name: string;
	url?: string;
	image?: string;
}

export type SeoOpenGraphType =
	| 'website'
	| 'article'
	| 'book'
	| 'profile'
	| 'music.song'
	| 'music.album'
	| 'music.playlist'
	| 'music.radio_station'
	| 'video.movie'
	| 'video.episode'
	| 'video.tv_show'
	| 'video.other'
	| 'product';

export type TwitterCardType = 'summary' | 'summary_large_image' | 'app' | 'player';

export interface SeoTwitterMeta {
	card?: TwitterCardType;
	site?: string;
	creator?: string;
	title?: string;
	description?: string;
	image?: string;
	imageAlt?: string;
}

/** Open Graph and article/product-specific social metadata. */
export interface SeoSocialMeta {
	type?: SeoOpenGraphType;
	url?: string;
	siteName?: string;
	locale?: string;
	title?: string;
	description?: string;
	image?: SeoImage | SeoImage[];
	article?: {
		publishedTime?: string;
		modifiedTime?: string;
		expirationTime?: string;
		author?: string | string[];
		section?: string;
		tag?: string | string[];
	};
	product?: {
		priceAmount?: number;
		priceCurrency?: string;
		availability?: 'instock' | 'outofstock' | 'preorder';
	};
	twitter?: SeoTwitterMeta;
}

export type SeoRobotsDirective =
	'index, follow' | 'noindex, follow' | 'index, nofollow' | 'noindex, nofollow' | string;

export interface SeoAlternateLanguage {
	hreflang: string;
	href: string;
}

export interface SeoPostalAddress {
	streetAddress?: string;
	addressLocality?: string;
	addressRegion?: string;
	postalCode?: string;
	addressCountry?: string;
}

export interface SeoPlace {
	name?: string;
	address?: string | SeoPostalAddress;
	url?: string;
}

export interface SeoOffer {
	price: number;
	priceCurrency: string;
	availability?: 'InStock' | 'OutOfStock' | 'PreOrder' | 'Discontinued' | string;
	url?: string;
	priceValidUntil?: string;
	itemCondition?: 'NewCondition' | 'UsedCondition' | 'RefurbishedCondition' | string;
}

export interface SeoAggregateRating {
	ratingValue: number;
	reviewCount: number;
	bestRating?: number;
	worstRating?: number;
}

export interface SeoReview {
	author: SeoAuthor;
	reviewRating: { ratingValue: number; bestRating?: number };
	reviewBody?: string;
	datePublished?: string;
}

/** Schema.org Organization structured data. */
export interface SeoOrganization {
	type: 'Organization';
	name: string;
	url?: string;
	logo?: string;
	description?: string;
	sameAs?: string[];
	contactPoint?: {
		telephone?: string;
		contactType?: string;
		email?: string;
	};
}

/** Schema.org WebSite structured data. */
export interface SeoWebSite {
	type: 'WebSite';
	name: string;
	url: string;
	description?: string;
	publisher?: Pick<SeoOrganization, 'name' | 'url' | 'logo'>;
	potentialAction?: {
		target: string;
		queryInput?: string;
	};
}

/** Schema.org WebPage structured data. */
export interface SeoWebPage {
	type: 'WebPage';
	name: string;
	description?: string;
	url?: string;
	datePublished?: string;
	dateModified?: string;
	isPartOf?: string;
}

/** Schema.org Article / BlogPosting / NewsArticle structured data. */
export interface SeoArticle {
	type: 'Article' | 'BlogPosting' | 'NewsArticle';
	headline: string;
	description?: string;
	url?: string;
	image?: string | string[] | SeoImage | SeoImage[];
	datePublished?: string;
	dateModified?: string;
	author?: SeoAuthor | SeoAuthor[];
	publisher?: { name: string; logo?: string; url?: string };
	articleSection?: string;
	keywords?: string | string[];
	wordCount?: number;
}

/** Schema.org Product structured data. */
export interface SeoProduct {
	type: 'Product';
	name: string;
	description?: string;
	url?: string;
	image?: string | string[] | SeoImage | SeoImage[];
	sku?: string;
	gtin?: string;
	brand?: string | { name: string };
	offers?: SeoOffer | SeoOffer[];
	aggregateRating?: SeoAggregateRating;
	review?: SeoReview | SeoReview[];
}

/** Schema.org Event structured data. */
export interface SeoEvent {
	type: 'Event';
	name: string;
	description?: string;
	url?: string;
	image?: string | string[] | SeoImage | SeoImage[];
	startDate: string;
	endDate?: string;
	eventStatus?: 'EventScheduled' | 'EventCancelled' | 'EventPostponed' | 'EventMovedOnline';
	eventAttendanceMode?:
		'OfflineEventAttendanceMode' | 'OnlineEventAttendanceMode' | 'MixedEventAttendanceMode';
	location?: SeoPlace | string;
	organizer?: SeoAuthor | SeoOrganization;
	offers?: SeoOffer | SeoOffer[];
	performer?: SeoAuthor | SeoAuthor[];
}

/** Schema.org BreadcrumbList structured data. */
export interface SeoBreadcrumbList {
	type: 'BreadcrumbList';
	items: SeoBreadcrumbItem[];
}

export interface SeoBreadcrumbItem {
	name: string;
	url?: string;
	position?: number;
}

/** Schema.org FAQPage structured data. */
export interface SeoFaqPage {
	type: 'FAQPage';
	questions: SeoFaqItem[];
}

export interface SeoFaqItem {
	question: string;
	answer: string;
}

/** Schema.org LocalBusiness structured data. */
export interface SeoLocalBusiness {
	type: 'LocalBusiness' | 'Restaurant' | 'Store' | 'MedicalBusiness';
	name: string;
	description?: string;
	url?: string;
	image?: string | string[];
	telephone?: string;
	email?: string;
	address?: SeoPostalAddress;
	geo?: { latitude: number; longitude: number };
	openingHours?: string[];
	priceRange?: string;
}

/** Schema.org Person structured data. */
export interface SeoPerson {
	type: 'Person';
	name: string;
	url?: string;
	image?: string;
	jobTitle?: string;
	worksFor?: Pick<SeoOrganization, 'name' | 'url'>;
	sameAs?: string[];
}

/** Schema.org VideoObject structured data. */
export interface SeoVideoObject {
	type: 'VideoObject';
	name: string;
	description?: string;
	thumbnailUrl?: string | string[];
	uploadDate?: string;
	duration?: string;
	contentUrl?: string;
	embedUrl?: string;
}

/** Discriminated union of all supported Schema.org payloads. */
export type SeoStructuredData =
	| SeoOrganization
	| SeoWebSite
	| SeoWebPage
	| SeoArticle
	| SeoProduct
	| SeoEvent
	| SeoBreadcrumbList
	| SeoFaqPage
	| SeoLocalBusiness
	| SeoPerson
	| SeoVideoObject;

/**
 * Primary SEO payload passed to the Seo component.
 * Combines document metadata, social tags, and optional JSON-LD blocks.
 */
export interface SeoData {
	title: string;
	description?: string;
	canonical?: string;
	robots?: SeoRobotsDirective;
	keywords?: string[];
	language?: string;
	alternateLanguages?: SeoAlternateLanguage[];
	social?: SeoSocialMeta;
	structuredData?: SeoStructuredData | SeoStructuredData[];
}

export interface SeoProps {
	data: SeoData;
}
