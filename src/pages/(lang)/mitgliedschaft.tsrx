import { Mitgliedschaft } from '@content';
import type { PageProps } from '../types.ts';

export function MitgliedschaftPage(props: PageProps) @{
	<Mitgliedschaft language={props.language} />
}
