import { Fachabteilung } from '@content';
import { useRouter } from '@provider';
import { matchRoute } from '../../.generated/routes.ts';
import type { PageProps } from '../../types.ts';

export function AbteilungPage(props: PageProps) @{
	const { path } = useRouter();
	const department = matchRoute(path)?.params.department ?? '';

	<Fachabteilung department={department} language={props.language} />
}
