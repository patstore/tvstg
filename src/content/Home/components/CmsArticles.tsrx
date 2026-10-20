import { usePatStoreCollection } from '@patstore/core';

interface ArticleRecord {
	objectId: string;
	title?: { value?: string };
	label?: { value?: string };
}

export function CmsArticles() @{
	@try {
		const articles = usePatStoreCollection<ArticleRecord>('Article', { limit: 6 });

		<div class="content-card cms-articles">
			<h2>From PatStore</h2>
			@if (articles.length === 0) {
				<p>No articles returned for this project.</p>
			} @else {
				<ul class="cms-articles__list">
					@for (const article of articles; key article.objectId) {
						<li>{(article.title?.value ?? article.label?.value ?? article.objectId) as string}</li>
					}
				</ul>
			}
		</div>
	} @pending {
		<div class="content-card cms-articles cms-articles--pending">
			<h2>From PatStore</h2>
			<p>Loading CMS content…</p>
		</div>
	} @catch (_error) {
		<div class="content-card cms-articles cms-articles--error">
			<h2>From PatStore</h2>
			<p>Could not load CMS content. Check your PatStore credentials and Module setup.</p>
		</div>
	}
}
