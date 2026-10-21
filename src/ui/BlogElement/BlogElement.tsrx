import { motion } from '@octanejs/motion';
import { SiteLink } from '../../components/SiteLink/index.ts';
import { categoryTitles, getDateString, mediaUrl, slugify } from '@provider';
import type { SiteRecord } from '@types';
import { Label } from '../Label/index.ts';

export function BlogElement(props: {
	article: SiteRecord;
	images: SiteRecord[];
	categories: SiteRecord[];
	feature?: boolean;
}) @{
	const href = `/aktuelles/${slugify(props.article.title || props.article.objectId)}`;
	const image = mediaUrl(props.article.image, props.images);
	const labels = categoryTitles(props.article.categories, props.categories);
	const date = getDateString(typeof props.article.date === 'string' ? props.article.date : undefined).date;

	<motion.article
		className={props.feature ? 'club-card club-card--feature' : 'club-card'}
		initial={{ opacity: 0, y: 16 }}
		animate={{ opacity: 1, y: 0 }}
		transition={{ duration: 0.45, ease: 'easeOut' }}
		whileHover={{ y: -4 }}
	>
		<SiteLink href={href} class="club-card__link">
			{(props.article.title || 'Beitrag') as string}
		</SiteLink>
		@if (image) {
			<img src={image} alt={(props.article.title || 'Beitrag') as string} />
		}
		<div class="club-card__body">
			<div class="club-labels">
				@for (const label of labels; key label) {
					<Label text={label} />
				}
			</div>
			@if (props.feature) {
				<h2>{(props.article.title || '') as string}</h2>
			} @else {
				<h3>{(props.article.title || '') as string}</h3>
			}
			@if (date) {
				<time>{date as string}</time>
			}
		</div>
	</motion.article>
}
