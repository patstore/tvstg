import { Home } from '@content';
import type { PageProps } from '../types.ts';

export function IndexPage(props: PageProps) @{
	<Home language={props.language} />
}
