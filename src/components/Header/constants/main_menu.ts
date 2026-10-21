export interface MenuLink {
	name: string;
	key: string;
	link: string;
	color?: string;
	menuItems?: MenuItem[];
}

export interface MenuItem {
	name: string;
	key: string;
	link: string;
	hasSubmenu?: boolean;
	subMenuItems?: { name: string; key: string; link: string }[];
}

export const mainMenu: MenuLink[] = [
	{
		name: 'Unser Sportangebot',
		key: 'sportangebot',
		link: '/sportarten',
		menuItems: [
			{
				name: 'Ballsport',
				key: 'ballsport',
				hasSubmenu: true,
				link: '/sportarten/ballsport',
				subMenuItems: [
					{ name: 'Prellball', key: 'prellball', link: '/sportarten/ballsport/prellball' },
					{ name: 'Volleyball', key: 'volleyball', link: '/sportarten/ballsport/volleyball' },
					{ name: 'Tischtennis', key: 'tischtennis', link: '/sportarten/ballsport/tischtennis' },
				],
			},
			{ name: 'Tanz und Rope Skipping', key: 'tanzundshow', link: '/sportarten/tanz-und-rope-skipping' },
			{ name: 'Turnen', key: 'turnen', link: '/sportarten/turnen' },
			{ name: 'Gesund und Fit', key: 'gesundheitssport', link: '/sportarten/gesundheitssport' },
			{ name: 'Leichtathletik', key: 'leichtathletik', link: '/sportarten/leichtathletik' },
		],
	},
	{
		name: 'Über den Verein',
		key: 'verein',
		link: '/verein/vorstand',
		menuItems: [
			{ name: 'Vorstand', key: 'vorstand', link: '/verein/vorstand' },
			{ name: 'Prävention', key: 'praevention', link: '/verein/praevention' },
			{ name: 'Satzung', key: 'satzung', link: '/verein/satzung' },
			{ name: 'Jugendordnung', key: 'jugendordnung', link: '/verein/jugendordnung' },
		],
	},
	{
		name: 'Medien',
		key: 'medien',
		link: '/medien/berichte',
		menuItems: [
			{ name: 'Berichte', key: 'berichte', link: '/medien/berichte' },
			{ name: 'Downloads', key: 'downloads', link: '/medien/downloads' },
			{ name: 'Veröffentlichungen', key: 'veroeffentlichungen', link: '/medien/veroeffentlichungen' },
		],
	},
	{ name: 'Termine', key: 'termine', link: '/termine', menuItems: [] },
	{ name: 'Mitglied werden', key: 'mitglied', link: '/mitgliedschaft', menuItems: [] },
	{ name: 'Kontakt', key: 'kontakt', link: '/kontakt', menuItems: [] },
	{ name: 'Unser Shop', key: 'shop', link: 'https://tvstg.fan12.de/', color: '#BE0027', menuItems: [] },
];
