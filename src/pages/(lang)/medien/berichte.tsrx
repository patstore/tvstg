import { Berichte } from '@content';
import type { PageProps } from '../../types.ts';

export function BerichtePage(props: PageProps) @{
	<Berichte language={props.language} />
}
