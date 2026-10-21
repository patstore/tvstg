import { useEffect, useRef, useState } from 'octane';
import { motion } from '@octanejs/motion';
import { Menu } from '@octanejs/lucide';
import { lenis } from '../../lenis.ts';
import logo from '../../assets/logo.png';
import { SiteLink } from '../SiteLink/index.ts';
import { mainMenu, type MenuItem } from './constants/main_menu.ts';

const headerVariants = {
	start: {
		height: 100,
		boxShadow: '0 2px 5px rgba(0,0,0,0)',
		transition: { duration: 0.4, ease: 'easeIn', delay: 0.05 },
	},
	site: {
		height: 70,
		boxShadow: '0 2px 5px rgba(0,0,0,.2)',
		transition: { duration: 0.4, ease: 'easeIn', delay: 0.05 },
	},
};

const logoVariants = {
	start: { scale: 1, transition: { duration: 0.4 } },
	site: { scale: 0.82, transition: { duration: 0.4 } },
};

const listVariants = {
	initial: { transition: { staggerChildren: 0.04 } },
	animate: { transition: { staggerChildren: 0.04, delayChildren: 0.05 } },
};

const itemVariants = {
	initial: { opacity: 0, y: -6 },
	animate: { opacity: 1, y: 0, transition: { duration: 0.25, ease: 'easeOut' } },
};

export function Header() @{
	const [open, setOpen] = useState(false);
	const [compact, setCompact] = useState(false);
	const compactRef = useRef(false);

	useEffect(() => {
		const onScroll = (event: { scroll: number }) => {
			const next = event.scroll > 160;
			if (next === compactRef.current) {
				return;
			}
			compactRef.current = next;
			setCompact(next);
		};
		lenis.on('scroll', onScroll);
		return () => {
			lenis.off('scroll', onScroll);
		};
	}, []);

	<motion.header
		className="club-header"
		variants={headerVariants}
		initial="start"
		animate={compact ? 'site' : 'start'}
	>
		<div class="club-header__bar">
			<motion.div className="club-logo-wrap" variants={logoVariants} initial="start" animate={compact ? 'site' : 'start'}>
				<SiteLink href="/" class="club-logo">
					<img src={logo} alt="TV Freiburg St. Georgen" />
				</SiteLink>
			</motion.div>
			<button type="button" class="club-burger" aria-label="Menü" onClick={() => setOpen(!open)}>
				<Menu size={28} />
			</button>
			<motion.ul
				className={open ? 'club-nav is-open' : 'club-nav'}
				initial="initial"
				animate="animate"
				variants={listVariants}
			>
				@for (const item of mainMenu; key item.key) {
					<motion.li variants={itemVariants}>
						<SiteLink href={item.link} class={item.key === 'shop' ? 'is-shop' : undefined}>
							{item.name as string}
						</SiteLink>
						@if (item.menuItems && item.menuItems.length > 0) {
							<Submenu items={item.menuItems} />
						}
					</motion.li>
				}
			</motion.ul>
		</div>
	</motion.header>
}

function Submenu(props: { items: MenuItem[] }) @{
	<ul class="club-submenu">
		@for (const child of props.items; key child.key) {
			<li class="club-nav__item">
				<SiteLink href={child.link}>{child.name as string}</SiteLink>
				@if (child.subMenuItems && child.subMenuItems.length > 0) {
					<ul class="club-submenu">
						@for (const sub of child.subMenuItems; key sub.key) {
							<li>
								<SiteLink href={sub.link}>{sub.name as string}</SiteLink>
							</li>
						}
					</ul>
				}
			</li>
		}
	</ul>
}
