import placeholder from '../../assets/person-placeholder.png';
import { mediaUrl } from '@provider';
import type { SiteRecord } from '@types';

export function ContactPerson(props: { person: SiteRecord; images: SiteRecord[] }) @{
	const photo = mediaUrl(props.person.image, props.images) || placeholder;
	const email = props.person.email || props.person.data?.email || '';

	<div class="club-person">
		<img src={photo} alt={(props.person.title || 'Ansprechpartner') as string} />
		<div>
			<h4>{(props.person.title || '') as string}</h4>
			@if (email) {
				<a href={'mailto:' + email}>E-Mail schreiben</a>
			}
		</div>
	</div>
}
