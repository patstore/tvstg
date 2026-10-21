import { SiteLink } from '../../components/SiteLink/index.ts';

const sports = [
	{ label: 'Ballsport', href: '/sportarten/ballsport' },
	{ label: 'Gesundheitssport', href: '/sportarten/gesundheitssport' },
	{ label: 'Tanz und Rope Skipping', href: '/sportarten/tanz-und-rope-skipping' },
	{ label: 'Turnen', href: '/sportarten/turnen' },
	{ label: 'Leichtathletik', href: '/sportarten/leichtathletik' },
];

export function SportBanner() @{
	<section class="club-banner">
		<div>
			<h2>Finde jetzt Deine nächste Sportart!</h2>
		</div>
		<div class="club-banner__actions">
			@for (const sport of sports; key sport.href) {
				<SiteLink href={sport.href} class="club-button club-button--white">
					{sport.label as string}
				</SiteLink>
			}
		</div>
	</section>
}
