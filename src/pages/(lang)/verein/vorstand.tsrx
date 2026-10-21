import { Verein } from '@content';
import type { PageProps } from '../../types.ts';

export function VorstandPage(props: PageProps) @{
	<Verein language={props.language} />
}
