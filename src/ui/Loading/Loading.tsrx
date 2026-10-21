import logo from '../../assets/logo.png';

/** Full-viewport loading state shown beneath the site header. */
export function Loading() @{
	<div class="club-loading" role="status" aria-live="polite" aria-label="Wird geladen">
		<img src={logo} alt="TV Freiburg St. Georgen" />
		<div class="club-loading__spinner" />
	</div>
}
