export function Html(props: { html: string; class?: string }) @{
	<div class={props.class ?? 'club-richtext'} dangerouslySetInnerHTML={{ __html: props.html }} />
}
