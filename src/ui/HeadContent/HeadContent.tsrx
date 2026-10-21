export function HeadContent(props: { title: string; text?: string | null; center?: boolean }) @{
	<header class={props.center ? 'club-hero is-center' : 'club-hero'}>
		<h1>{props.title as string}</h1>
		@if (props.text) {
			<p>{props.text as string}</p>
		}
	</header>
}
