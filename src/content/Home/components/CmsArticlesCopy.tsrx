import { ErrorBoundary, Suspense, use } from 'octane';

interface ArticleRecord {
	objectId: string;
	title?: { value?: string };
	label?: { value?: string };
}

interface CmsArticlesCopyProps {
	articles: Promise<ArticleRecord[]>;
}

function ArticleTitles(props: { articles: Promise<ArticleRecord[]> }) @{
	const articles = use(props.articles);

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
}

function ArticlesErrorFallback(error: unknown, reset: () => void) @{
	<div class="content-card cms-articles cms-articles--error">
		<h2>From PatStore</h2>
		<p>{(error instanceof Error ? error.message : 'Could not load CMS content.') as string}</p>
		<button type="button" class="theme-toggle" onClick={reset}>
			Retry
		</button>
	</div>
}

function ArticlesPendingFallback() @{
	<div class="content-card cms-articles cms-articles--pending">
		<h2>From PatStore</h2>
		<p>Loading CMS content…</p>
	</div>
}

export function CmsArticlesCopy(props: CmsArticlesCopyProps) @{
	<ErrorBoundary fallback={ArticlesErrorFallback}>
		<Suspense fallback={<ArticlesPendingFallback />}>
			<ArticleTitles articles={props.articles} />
		</Suspense>
	</ErrorBoundary>
}
