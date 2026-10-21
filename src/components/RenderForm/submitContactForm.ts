import type { FormFieldDef } from '@types';

export function submitContactForm(form: HTMLFormElement, fields: FormFieldDef[]): string {
	const data = new FormData(form);
	if (String(data.get('honeypot') || '').trim()) {
		return '';
	}
	const missing = fields.some((field) => field.required && !String(data.get(field.name) || '').trim());
	if (missing) {
		return 'Bitte fülle die Pflichtfelder aus.';
	}
	const body = fields
		.map((field) => `${field.label || field.name}: ${String(data.get(field.name) || '')}`)
		.join('\n');
	window.location.href = `mailto:info@tvstg.de?subject=${encodeURIComponent('Kontaktformular')}&body=${encodeURIComponent(body)}`;
	return '';
}
