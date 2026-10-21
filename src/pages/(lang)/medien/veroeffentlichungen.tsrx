import { Veroeffentlichungen } from '@content';
import type { PageProps } from '../../types.ts';

export function VeroeffentlichungenPage(props: PageProps) @{
	<Veroeffentlichungen language={props.language} />
}
