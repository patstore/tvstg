import { Satzung } from '@content';
import type { PageProps } from '../../types.ts';

export function SatzungPage(props: PageProps) @{
	<Satzung language={props.language} />
}
