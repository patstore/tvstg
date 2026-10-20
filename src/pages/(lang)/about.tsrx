import type { PageProps } from '@types';
import { AboutPage as AboutPageView } from '../about.tsrx';

export function AboutPageLang(props: PageProps) @{
	<AboutPageView language={props.language} />
}
