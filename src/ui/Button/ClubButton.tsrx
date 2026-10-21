export function ClubButton(props: {
	text: string;
	onClick?: () => void;
	href?: string;
	tone?: 'primary' | 'dark' | 'white';
}) @{
	const tone = props.tone === 'dark' ? ' club-button--dark' : props.tone === 'white' ? ' club-button--white' : '';

	@if (props.href) {
		<a class={'club-button' + tone} href={props.href}>
			{props.text as string}
		</a>
	} @else {
		<button type="button" class={'club-button' + tone} onClick={() => props.onClick?.()}>
			{props.text as string}
		</button>
	}
}
