import { SportTemplate } from '@content';
import { useRouter } from '@provider';
import { matchRoute } from '../../../.generated/routes.ts';
import type { PageProps } from '../../../types.ts';

export function SportartPage(props: PageProps) @{
	const { path } = useRouter();
	const params = matchRoute(path)?.params;

	<SportTemplate
		department={params?.department ?? ''}
		sport={params?.sport ?? ''}
		language={props.language}
	/>
}
