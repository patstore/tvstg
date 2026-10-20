import * as path from 'node:path';
import { fileURLToPath } from 'node:url';
import { generateRoutes } from '@patstore/octane-pages-plugin';

const root = path.dirname(path.dirname(fileURLToPath(import.meta.url)));

generateRoutes({
	pagesDir: path.join(root, 'src/pages'),
	outputDir: path.join(root, 'src/pages/.generated'),
});

console.log('Generated page routes');
