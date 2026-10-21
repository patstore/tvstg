import { useState } from 'octane';
import { isPatStoreConfigured } from '@patstore/core';
import { formFields, useForms } from '@provider';
import type { FormFieldDef, SiteRecord } from '@types';
import { submitContactForm } from './submitContactForm.ts';

export function RenderForm(props: { title?: string }) @{
	@if (!isPatStoreConfigured()) {
		<ContactFields fields={fallbackFields} />
	} @else {
		<FormData title={props.title} />
	}
}

const fallbackFields: FormFieldDef[] = [
	{ name: 'name', label: 'Name', required: true },
	{ name: 'email', label: 'E-Mail', type: 'email', required: true },
	{ name: 'message', label: 'Nachricht', type: 'textarea', required: true },
];

function FormData(props: { title?: string }) @{
	@try {
		const forms = useForms();
		const form = forms.find((item) => item.title === (props.title || 'Kontaktformular')) ?? forms[0];
		const fields = formFields((form as SiteRecord & { form_fields?: unknown } | undefined)?.form_fields);
		<ContactFields fields={fields.length > 0 ? fields : fallbackFields} />
	} @pending {
		<p class="club-status">Formular wird geladen…</p>
	} @catch (_error) {
		<ContactFields fields={fallbackFields} />
	}
}

function ContactFields(props: { fields: FormFieldDef[] }) @{
	const [sent, setSent] = useState(false);
	const [error, setError] = useState('');

	@if (sent) {
		<p>Formular erfolgreich gesendet.</p>
	} @else {
		<form
			class="club-form"
			onSubmit={(event: SubmitEvent) => {
				event.preventDefault();
				const message = submitContactForm(event.currentTarget as HTMLFormElement, props.fields);
				if (message) {
					setError(message);
					return;
				}
				setError('');
				setSent(true);
			}}
		>
			@for (const field of props.fields; key field.name) {
				<label class={field.type === 'textarea' ? 'is-wide' : undefined}>
					{(field.label || field.name) as string}
					@if (field.type === 'textarea') {
						<textarea name={field.name} placeholder={field.placeholder || ''} required={Boolean(field.required)} />
					} @else {
						<input
							name={field.name}
							type={field.type || 'text'}
							placeholder={field.placeholder || ''}
							required={Boolean(field.required)}
						/>
					}
				</label>
			}
			<label class="club-honeypot">
				Website
				<input name="honeypot" tabindex={-1} autocomplete="off" />
			</label>
			@if (error) {
				<p>{error as string}</p>
			}
			<button type="submit" class="club-button is-wide">
				Formular absenden
			</button>
		</form>
	}
}
