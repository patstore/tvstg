import ganter from '../../assets/ganter.png';
import sparkasse from '../../assets/sparkasse.jpg';

export function Sponsors() @{
	<section class="club-sponsors">
		<h2>Unsere Sponsoren</h2>
		<div class="club-sponsors__logos">
			<img src={ganter} alt="Ganter Brauerei" />
			<img src={sparkasse} alt="Sparkasse" />
		</div>
	</section>
}
