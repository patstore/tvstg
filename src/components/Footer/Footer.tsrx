import { motion } from '@octanejs/motion';
import { ArrowUp } from '@octanejs/lucide';
import { lenis } from '../../lenis.ts';
import logo from '../../assets/logo.png';
import { SiteLink } from '../SiteLink/index.ts';

export function Footer() @{
	<footer class="club-footer">
		<div class="club-footer__top">
			<div>
				<h6>Anschrift</h6>
				<p>
					TV Freiburg St. Georgen von 1897 e.V.
					<br />
					Blumenstraße 9
					<br />
					79111 Freiburg
				</p>
			</div>
			<div>
				<h6>Kontakt</h6>
				<p>
					Tel.: 0761 46732
					<br />
					<a href="mailto:info@tvstg.de">info@tvstg.de</a>
				</p>
			</div>
			<div>
				<SiteLink href="/kontakt" class="club-button">zum Kontaktformular</SiteLink>
			</div>
		</div>
		<div class="club-footer__bar">
			<div class="club-footer__bar-inner">
				<div class="club-footer__links">
					<p>TV Freiburg St. Georgen © {String(new Date().getFullYear())}</p>
					<SiteLink href="/datenschutzerklaerung">Datenschutzerklärung</SiteLink>
					<SiteLink href="/impressum">Impressum</SiteLink>
					<SiteLink href="/kontakt">Kontakt</SiteLink>
				</div>
				<img src={logo} alt="TV Freiburg St. Georgen" height="28" />
			</div>
		</div>
		<motion.button
			type="button"
			className="club-top"
			aria-label="Nach oben"
			initial={{ opacity: 0, y: 16 }}
			animate={{ opacity: 1, y: 0 }}
			whileHover={{ scale: 1.08 }}
			whileTap={{ scale: 0.94 }}
			onClick={() => lenis.scrollTo(0)}
		>
			<ArrowUp size={18} />
		</motion.button>
	</footer>
}
