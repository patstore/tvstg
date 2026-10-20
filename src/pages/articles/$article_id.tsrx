import { fetchPatStoreObject } from '@patstore/core';
import { useRouter } from '@provider';
import { NotFoundPage } from '../404.tsrx';
import type { PageProps } from '../types.ts';
import { Suspense, use } from 'octane';
import { matchRoute } from '../.generated/routes.ts';

interface ArticleRecord {
	objectId: string;
	title?: { value?: string };
	label?: { value?: string };
}

function Article(props: { articlePromise: Promise<ArticleRecord | null> }) @{
	const article = use(props.articlePromise);

	@if (!article) {
		<section class="page page--not-found">
			<header class="page-header">
				<h1 class="page-title">Article not found</h1>
			</header>
		</section>
	} @else {
		const title = (article.title ?? article.label ?? article.objectId) as string;

		<div class="page">
			<header class="page-header">
				<h1 class="page-title">{title}</h1>
			</header>
		</div>
	}
}

export function ArticlePage(props: PageProps) @{
	const { path } = useRouter();
	const match = matchRoute(path);
	const articleId =
		match?.id === 'articles_article_id' ? match.params.article_id ?? '' : '';

	@if (!articleId) {
		<NotFoundPage language={props.language} />
	} @else {
		const articlePromise = fetchPatStoreObject<ArticleRecord>('Article', articleId);

		<Suspense fallback={<p class="page-lede">Loading article…</p>}>
			<Article articlePromise={articlePromise} />
		</Suspense>
	}
}
