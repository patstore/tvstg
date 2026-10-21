import { Bericht } from '@content';
import { useRouter } from '@provider';
import { matchRoute } from '../../.generated/routes.ts';
import type { PageProps } from '../../types.ts';

export function AktuellesPage(props: PageProps) @{
	const { path } = useRouter();
	const slug = matchRoute(path)?.params.slug ?? '';

	<Bericht slug={slug} language={props.language} />
}
