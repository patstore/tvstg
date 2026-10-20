import type {
	SeoAggregateRating,
	SeoArticle,
	SeoAuthor,
	SeoBreadcrumbList,
	SeoEvent,
	SeoFaqPage,
	SeoImage,
	SeoLocalBusiness,
	SeoOffer,
	SeoOrganization,
	SeoPerson,
	SeoPlace,
	SeoPostalAddress,
	SeoProduct,
	SeoReview,
	SeoStructuredData,
	SeoVideoObject,
	SeoWebPage,
	SeoWebSite,
} from '../types.d.ts';

type JsonLdObject = Record<string, unknown>;

function imageUrls(
	image: string | string[] | SeoImage | SeoImage[] | undefined,
): string[] | undefined {
	if (image == null) return undefined;

	const values = Array.isArray(image) ? image : [image];
	const urls = values.map((entry) => (typeof entry === 'string' ? entry : entry.url));
	return urls.length > 0 ? urls : undefined;
}

function authorJsonLd(author: SeoAuthor): JsonLdObject {
	return {
		'@type': 'Person',
		name: author.name,
		...(author.url ? { url: author.url } : {}),
		...(author.image ? { image: author.image } : {}),
	};
}

function authorsJsonLd(
	author: SeoAuthor | SeoAuthor[] | undefined,
): JsonLdObject | JsonLdObject[] | undefined {
	if (author == null) return undefined;
	return Array.isArray(author) ? author.map(authorJsonLd) : authorJsonLd(author);
}

function postalAddressJsonLd(address: SeoPostalAddress): JsonLdObject {
	return {
		'@type': 'PostalAddress',
		...(address.streetAddress ? { streetAddress: address.streetAddress } : {}),
		...(address.addressLocality ? { addressLocality: address.addressLocality } : {}),
		...(address.addressRegion ? { addressRegion: address.addressRegion } : {}),
		...(address.postalCode ? { postalCode: address.postalCode } : {}),
		...(address.addressCountry ? { addressCountry: address.addressCountry } : {}),
	};
}

function placeJsonLd(place: SeoPlace | string): JsonLdObject | string {
	if (typeof place === 'string') return place;

	return {
		'@type': 'Place',
		...(place.name ? { name: place.name } : {}),
		...(place.url ? { url: place.url } : {}),
		...(place.address
			? {
					address:
						typeof place.address === 'string' ? place.address : postalAddressJsonLd(place.address),
				}
			: {}),
	};
}

function offerJsonLd(offer: SeoOffer): JsonLdObject {
	return {
		'@type': 'Offer',
		price: offer.price,
		priceCurrency: offer.priceCurrency,
		...(offer.availability ? { availability: `https://schema.org/${offer.availability}` } : {}),
		...(offer.url ? { url: offer.url } : {}),
		...(offer.priceValidUntil ? { priceValidUntil: offer.priceValidUntil } : {}),
		...(offer.itemCondition ? { itemCondition: `https://schema.org/${offer.itemCondition}` } : {}),
	};
}

function offersJsonLd(
	offers: SeoOffer | SeoOffer[] | undefined,
): JsonLdObject | JsonLdObject[] | undefined {
	if (offers == null) return undefined;
	return Array.isArray(offers) ? offers.map(offerJsonLd) : offerJsonLd(offers);
}

function aggregateRatingJsonLd(rating: SeoAggregateRating): JsonLdObject {
	return {
		'@type': 'AggregateRating',
		ratingValue: rating.ratingValue,
		reviewCount: rating.reviewCount,
		...(rating.bestRating != null ? { bestRating: rating.bestRating } : {}),
		...(rating.worstRating != null ? { worstRating: rating.worstRating } : {}),
	};
}

function reviewJsonLd(review: SeoReview): JsonLdObject {
	return {
		'@type': 'Review',
		author: authorJsonLd(review.author),
		reviewRating: {
			'@type': 'Rating',
			ratingValue: review.reviewRating.ratingValue,
			...(review.reviewRating.bestRating != null
				? { bestRating: review.reviewRating.bestRating }
				: {}),
		},
		...(review.reviewBody ? { reviewBody: review.reviewBody } : {}),
		...(review.datePublished ? { datePublished: review.datePublished } : {}),
	};
}

function organizationJsonLd(data: SeoOrganization): JsonLdObject {
	return {
		'@context': 'https://schema.org',
		'@type': 'Organization',
		name: data.name,
		...(data.url ? { url: data.url } : {}),
		...(data.logo ? { logo: data.logo } : {}),
		...(data.description ? { description: data.description } : {}),
		...(data.sameAs?.length ? { sameAs: data.sameAs } : {}),
		...(data.contactPoint
			? {
					contactPoint: {
						'@type': 'ContactPoint',
						...(data.contactPoint.telephone ? { telephone: data.contactPoint.telephone } : {}),
						...(data.contactPoint.contactType
							? { contactType: data.contactPoint.contactType }
							: {}),
						...(data.contactPoint.email ? { email: data.contactPoint.email } : {}),
					},
				}
			: {}),
	};
}

function webSiteJsonLd(data: SeoWebSite): JsonLdObject {
	return {
		'@context': 'https://schema.org',
		'@type': 'WebSite',
		name: data.name,
		url: data.url,
		...(data.description ? { description: data.description } : {}),
		...(data.publisher
			? {
					publisher: {
						'@type': 'Organization',
						name: data.publisher.name,
						...(data.publisher.url ? { url: data.publisher.url } : {}),
						...(data.publisher.logo ? { logo: data.publisher.logo } : {}),
					},
				}
			: {}),
		...(data.potentialAction
			? {
					potentialAction: {
						'@type': 'SearchAction',
						target: data.potentialAction.target,
						...(data.potentialAction.queryInput
							? { 'query-input': data.potentialAction.queryInput }
							: {}),
					},
				}
			: {}),
	};
}

function webPageJsonLd(data: SeoWebPage): JsonLdObject {
	return {
		'@context': 'https://schema.org',
		'@type': 'WebPage',
		name: data.name,
		...(data.description ? { description: data.description } : {}),
		...(data.url ? { url: data.url } : {}),
		...(data.datePublished ? { datePublished: data.datePublished } : {}),
		...(data.dateModified ? { dateModified: data.dateModified } : {}),
		...(data.isPartOf ? { isPartOf: data.isPartOf } : {}),
	};
}

function articleJsonLd(data: SeoArticle): JsonLdObject {
	return {
		'@context': 'https://schema.org',
		'@type': data.type,
		headline: data.headline,
		...(data.description ? { description: data.description } : {}),
		...(data.url ? { url: data.url } : {}),
		...(imageUrls(data.image) ? { image: imageUrls(data.image) } : {}),
		...(data.datePublished ? { datePublished: data.datePublished } : {}),
		...(data.dateModified ? { dateModified: data.dateModified } : {}),
		...(authorsJsonLd(data.author) ? { author: authorsJsonLd(data.author) } : {}),
		...(data.publisher
			? {
					publisher: {
						'@type': 'Organization',
						name: data.publisher.name,
						...(data.publisher.logo ? { logo: data.publisher.logo } : {}),
						...(data.publisher.url ? { url: data.publisher.url } : {}),
					},
				}
			: {}),
		...(data.articleSection ? { articleSection: data.articleSection } : {}),
		...(data.keywords ? { keywords: data.keywords } : {}),
		...(data.wordCount != null ? { wordCount: data.wordCount } : {}),
	};
}

function productJsonLd(data: SeoProduct): JsonLdObject {
	const brand =
		data.brand == null
			? undefined
			: typeof data.brand === 'string'
				? data.brand
				: { '@type': 'Brand', name: data.brand.name };

	return {
		'@context': 'https://schema.org',
		'@type': 'Product',
		name: data.name,
		...(data.description ? { description: data.description } : {}),
		...(data.url ? { url: data.url } : {}),
		...(imageUrls(data.image) ? { image: imageUrls(data.image) } : {}),
		...(data.sku ? { sku: data.sku } : {}),
		...(data.gtin ? { gtin: data.gtin } : {}),
		...(brand ? { brand } : {}),
		...(offersJsonLd(data.offers) ? { offers: offersJsonLd(data.offers) } : {}),
		...(data.aggregateRating
			? { aggregateRating: aggregateRatingJsonLd(data.aggregateRating) }
			: {}),
		...(data.review
			? {
					review: Array.isArray(data.review)
						? data.review.map(reviewJsonLd)
						: reviewJsonLd(data.review),
				}
			: {}),
	};
}

function eventJsonLd(data: SeoEvent): JsonLdObject {
	const organizer =
		data.organizer == null
			? undefined
			: 'type' in data.organizer && data.organizer.type === 'Organization'
				? organizationJsonLd(data.organizer)
				: authorJsonLd(data.organizer);

	return {
		'@context': 'https://schema.org',
		'@type': 'Event',
		name: data.name,
		startDate: data.startDate,
		...(data.description ? { description: data.description } : {}),
		...(data.url ? { url: data.url } : {}),
		...(imageUrls(data.image) ? { image: imageUrls(data.image) } : {}),
		...(data.endDate ? { endDate: data.endDate } : {}),
		...(data.eventStatus ? { eventStatus: `https://schema.org/${data.eventStatus}` } : {}),
		...(data.eventAttendanceMode
			? { eventAttendanceMode: `https://schema.org/${data.eventAttendanceMode}` }
			: {}),
		...(data.location ? { location: placeJsonLd(data.location) } : {}),
		...(organizer ? { organizer } : {}),
		...(offersJsonLd(data.offers) ? { offers: offersJsonLd(data.offers) } : {}),
		...(data.performer
			? {
					performer: Array.isArray(data.performer)
						? data.performer.map(authorJsonLd)
						: authorJsonLd(data.performer),
				}
			: {}),
	};
}

function breadcrumbJsonLd(data: SeoBreadcrumbList): JsonLdObject {
	return {
		'@context': 'https://schema.org',
		'@type': 'BreadcrumbList',
		itemListElement: data.items.map((item, index) => ({
			'@type': 'ListItem',
			position: item.position ?? index + 1,
			name: item.name,
			...(item.url ? { item: item.url } : {}),
		})),
	};
}

function faqJsonLd(data: SeoFaqPage): JsonLdObject {
	return {
		'@context': 'https://schema.org',
		'@type': 'FAQPage',
		mainEntity: data.questions.map((entry) => ({
			'@type': 'Question',
			name: entry.question,
			acceptedAnswer: {
				'@type': 'Answer',
				text: entry.answer,
			},
		})),
	};
}

function localBusinessJsonLd(data: SeoLocalBusiness): JsonLdObject {
	return {
		'@context': 'https://schema.org',
		'@type': data.type,
		name: data.name,
		...(data.description ? { description: data.description } : {}),
		...(data.url ? { url: data.url } : {}),
		...(imageUrls(data.image) ? { image: imageUrls(data.image) } : {}),
		...(data.telephone ? { telephone: data.telephone } : {}),
		...(data.email ? { email: data.email } : {}),
		...(data.address ? { address: postalAddressJsonLd(data.address) } : {}),
		...(data.geo
			? {
					geo: {
						'@type': 'GeoCoordinates',
						latitude: data.geo.latitude,
						longitude: data.geo.longitude,
					},
				}
			: {}),
		...(data.openingHours?.length ? { openingHours: data.openingHours } : {}),
		...(data.priceRange ? { priceRange: data.priceRange } : {}),
	};
}

function personJsonLd(data: SeoPerson): JsonLdObject {
	return {
		'@context': 'https://schema.org',
		'@type': 'Person',
		name: data.name,
		...(data.url ? { url: data.url } : {}),
		...(data.image ? { image: data.image } : {}),
		...(data.jobTitle ? { jobTitle: data.jobTitle } : {}),
		...(data.worksFor
			? {
					worksFor: {
						'@type': 'Organization',
						name: data.worksFor.name,
						...(data.worksFor.url ? { url: data.worksFor.url } : {}),
					},
				}
			: {}),
		...(data.sameAs?.length ? { sameAs: data.sameAs } : {}),
	};
}

function videoJsonLd(data: SeoVideoObject): JsonLdObject {
	return {
		'@context': 'https://schema.org',
		'@type': 'VideoObject',
		name: data.name,
		...(data.description ? { description: data.description } : {}),
		...(data.thumbnailUrl ? { thumbnailUrl: data.thumbnailUrl } : {}),
		...(data.uploadDate ? { uploadDate: data.uploadDate } : {}),
		...(data.duration ? { duration: data.duration } : {}),
		...(data.contentUrl ? { contentUrl: data.contentUrl } : {}),
		...(data.embedUrl ? { embedUrl: data.embedUrl } : {}),
	};
}

/** Converts a typed SEO structured-data object into a Schema.org JSON-LD payload. */
export function toJsonLd(data: SeoStructuredData): JsonLdObject {
	switch (data.type) {
		case 'Organization':
			return organizationJsonLd(data);
		case 'WebSite':
			return webSiteJsonLd(data);
		case 'WebPage':
			return webPageJsonLd(data);
		case 'Article':
		case 'BlogPosting':
		case 'NewsArticle':
			return articleJsonLd(data);
		case 'Product':
			return productJsonLd(data);
		case 'Event':
			return eventJsonLd(data);
		case 'BreadcrumbList':
			return breadcrumbJsonLd(data);
		case 'FAQPage':
			return faqJsonLd(data);
		case 'LocalBusiness':
		case 'Restaurant':
		case 'Store':
		case 'MedicalBusiness':
			return localBusinessJsonLd(data);
		case 'Person':
			return personJsonLd(data);
		case 'VideoObject':
			return videoJsonLd(data);
	}
}

/** Normalizes a single object or array into JSON-LD objects. */
export function toJsonLdList(
	data: SeoStructuredData | SeoStructuredData[] | undefined,
): JsonLdObject[] {
	if (data == null) return [];
	return (Array.isArray(data) ? data : [data]).map(toJsonLd);
}
