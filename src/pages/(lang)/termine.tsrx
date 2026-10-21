import { Termine } from '@content';
import type { PageProps } from '../types.ts';

export function TerminePage(props: PageProps) @{
	<Termine language={props.language} />
}
