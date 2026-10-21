const WEEKDAYS: Record<string, string> = {
	monday: 'Montag',
	tuesday: 'Dienstag',
	wednesday: 'Mittwoch',
	thursday: 'Donnerstag',
	friday: 'Freitag',
	saturday: 'Samstag',
	sunday: 'Sonntag',
};

export function getWeekday(weekday: string): string {
	return WEEKDAYS[weekday] ?? '';
}

export function getDateString(datum: string | Date | undefined | null): {
	date: string;
	time: string;
	dateTime: string;
} {
	if (!datum) {
		return { date: '', time: '', dateTime: '' };
	}

	const date = datum instanceof Date ? datum : new Date(datum);
	if (Number.isNaN(date.getTime())) {
		return { date: '', time: '', dateTime: '' };
	}

	const day = date.getDate();
	const month = date.getMonth() + 1;
	const year = date.getFullYear();
	const hours = date.getHours();
	const minutes = date.getMinutes() < 10 ? `0${date.getMinutes()}` : String(date.getMinutes());

	return {
		date: `${day}.${month}.${year}`,
		time: `${hours}:${minutes}`,
		dateTime: `${day}.${month}.${year} ${hours}:${minutes}`,
	};
}

/** Appointment `date` is an object with `start`; articles store a plain string. */
export function eventStart(date: unknown): string {
	if (!date) {
		return '';
	}
	if (typeof date === 'string') {
		return date;
	}
	if (typeof date === 'object' && 'start' in date) {
		const start = (date as { start?: unknown }).start;
		return typeof start === 'string' ? start : '';
	}
	return '';
}

export const MONTHS = [
	{ name: 'Januar', number: 1 },
	{ name: 'Februar', number: 2 },
	{ name: 'März', number: 3 },
	{ name: 'April', number: 4 },
	{ name: 'Mai', number: 5 },
	{ name: 'Juni', number: 6 },
	{ name: 'Juli', number: 7 },
	{ name: 'August', number: 8 },
	{ name: 'September', number: 9 },
	{ name: 'Oktober', number: 10 },
	{ name: 'November', number: 11 },
	{ name: 'Dezember', number: 12 },
] as const;
