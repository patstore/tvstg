import { Impressum } from '@content';
import type { PageProps } from '../types.ts';

export function ImpressumPage(props: PageProps) @{
	<Impressum language={props.language} />
}
