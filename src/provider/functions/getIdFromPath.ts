export function getIdFromPath(path: string) {
	return path.split('/').pop();
}
