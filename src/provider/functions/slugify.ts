export function slugify(value: string): string {
	const from =
		'àáâäæãåāăąçćčđďèéêëēėęěğǵḧîïíīįìłḿñńǹňôöòóœøōõőṕŕřßśšşșťțûüùúūǘůűųẃẍÿýžźż·/_,:;';
	const to =
		'aaaaaaaaaacccddeeeeeeeegghiiiiiilmnnnnoooooooooprrsssssttuuuuuuuuuwxyyzzz------';
	const pattern = new RegExp(from.split('').join('|'), 'g');

	return value
		.toString()
		.toLowerCase()
		.replace(/\s+/g, '-')
		.replace(pattern, (char) => to.charAt(from.indexOf(char)))
		.replace(/&/g, '-and-')
		.replace(/[^\w-]+/g, '')
		.replace(/--+/g, '-')
		.replace(/^-+/, '')
		.replace(/-+$/, '');
}
