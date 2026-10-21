import { isPatStoreConfigured } from '@patstore/core';
import { Seo, Sidebar } from '@components';
import { publishedArticles, useArticles, useCategories, useImages } from '@provider';
import { BlogElement, Sponsors, SportBanner } from '@ui';
import shopTeaser from '../../assets/shop-teaser.jpg';

export function Home(props: { language: string }) @{
	<>
		<Seo
			data={{
				title: 'TV Freiburg St. Georgen',
				description: 'Willkommen beim TV Freiburg St. Georgen von 1897 e.V.',
				language: props.language,
			}}
		/>
		@if (!isPatStoreConfigured()) {
			<p class="club-status">PatStore ist nicht konfiguriert.</p>
		} @else {
			<HomeContent />
		}
	</>
}

function HomeContent() @{
	@try {
		const articles = publishedArticles(useArticles()).slice(0, 5);
		const images = useImages();
		const categories = useCategories();

		<div>
			<div class="club-page">
				<div class="club-split">
					<div class="club-main">
						<div class="club-grid">
							@for (const article of articles; key article.objectId) {
								<BlogElement
									article={article}
									images={images}
									categories={categories}
									feature={article.objectId === articles[0]?.objectId}
								/>
							}
						</div>
						<a class="club-shop" href="https://tvstg.fan12.de" target="_blank" rel="noreferrer">
							<img src={shopTeaser} alt="TV Freiburg St. Georgen Onlineshop" />
						</a>
					</div>
					<Sidebar category="1cU4dGw1Mu" showCalendar showNews displayAllNews displayAllEvents />
				</div>
				<Sponsors />
			</div>
			<div class="club-page">
				<SportBanner />
			</div>
		</div>
	} @pending {
		<p class="club-status">Startseite wird geladen…</p>
	} @catch (_error) {
		<p class="club-status">Startseite konnte nicht geladen werden.</p>
	}
}
