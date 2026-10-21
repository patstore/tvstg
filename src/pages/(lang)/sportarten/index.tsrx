import { Sportangebot } from '@content';
import type { PageProps } from '../../types.ts';

export function SportartenPage(props: PageProps) @{
	<Sportangebot language={props.language} />
}
