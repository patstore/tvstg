import { Kontakt } from '@content';
import type { PageProps } from '../types.ts';

export function KontaktPage(props: PageProps) @{
	<Kontakt language={props.language} />
}
