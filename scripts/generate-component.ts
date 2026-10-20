import * as fs from 'node:fs';
import * as path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.dirname(path.dirname(fileURLToPath(import.meta.url)));

function usage(message?: string): never {
	if (message) {
		console.error(message);
	}
	console.error(`Usage:
  node --experimental-strip-types scripts/generate-component.ts <folder>
  node --experimental-strip-types scripts/generate-component.ts --dir <parent> <name>

Examples:
  ... scripts/generate-component.ts src/content/Home/content/HomeGallery
  ... scripts/generate-component.ts --dir src/content/Home/content HomeGallery`);
	process.exit(1);
}

function toPascalCase(raw: string): string {
	const parts = raw
		.replace(/([a-z0-9])([A-Z])/g, '$1 $2')
		.replace(/[^a-zA-Z0-9]+/g, ' ')
		.trim()
		.split(/\s+/)
		.filter(Boolean);

	if (parts.length === 0) {
		usage(`Could not derive a component name from "${raw}".`);
	}

	return parts.map((part) => part.charAt(0).toUpperCase() + part.slice(1)).join('');
}

function toSnakeCase(pascal: string): string {
	return pascal.replace(/([a-z0-9])([A-Z])/g, '$1_$2').toLowerCase();
}

function displayPath(filePath: string): string {
	return path.relative(root, filePath).split(path.sep).join('/');
}

function parseArgs(argv: string[]): { parentDir: string; name: string } {
	const args = argv.filter((arg) => arg.length > 0);
	const dirFlag = args.indexOf('--dir');

	if (dirFlag !== -1) {
		const parent = args[dirFlag + 1];
		const rest = args.filter((_, index) => index !== dirFlag && index !== dirFlag + 1);
		if (!parent || rest.length !== 1) {
			usage('Expected --dir <parent> <name>.');
		}
		return { parentDir: parent, name: rest[0] };
	}

	if (args.length !== 1) {
		usage();
	}

	const target = args[0].replace(/[\\/]+$/, '');
	return { parentDir: path.dirname(target), name: path.basename(target) };
}

function assertInsideProject(resolved: string): void {
	const relative = path.relative(root, resolved);
	if (relative.startsWith('..') || path.isAbsolute(relative)) {
		usage(`Component folder must be inside the project: ${resolved}`);
	}
}

function addParentExport(parentIndex: string, name: string): boolean {
	if (!fs.existsSync(parentIndex)) {
		return false;
	}

	const source = fs.readFileSync(parentIndex, 'utf8');
	if (source.includes(`from './${name}'`) || source.includes(`from "./${name}"`)) {
		return false;
	}

	const exportLine = `export { ${name} } from './${name}';`;
	const trimmed = source.replace(/\s*$/, '');
	const next = trimmed.length > 0 ? `${trimmed}\n${exportLine}\n` : `${exportLine}\n`;
	fs.writeFileSync(parentIndex, next);
	return true;
}

function writeFile(filePath: string, contents: string): void {
	if (fs.existsSync(filePath)) {
		usage(`Refusing to overwrite existing file: ${displayPath(filePath)}`);
	}
	fs.writeFileSync(filePath, contents);
}

const { parentDir, name: rawName } = parseArgs(process.argv.slice(2));
const name = toPascalCase(rawName);

if (!/^[A-Z][A-Za-z0-9]*$/.test(name)) {
	usage(`"${name}" is not a valid component name.`);
}

const resolvedParent = path.resolve(root, parentDir);
const folder = path.join(resolvedParent, name);
assertInsideProject(folder);

const className = toSnakeCase(name);
const tsrxPath = path.join(folder, `${name}.tsrx`);
const dtsPath = path.join(folder, `${name}.d.tsrx.ts`);
const scssPath = path.join(folder, `${name}.module.scss`);
const indexPath = path.join(folder, 'index.ts');
const parentIndexPath = path.join(resolvedParent, 'index.ts');

fs.mkdirSync(folder, { recursive: true });

writeFile(
	tsrxPath,
	`import styles from './${name}.module.scss';

export function ${name}() @{
	<section class={styles.${className}}>
		
	</section>
}
`,
);

writeFile(dtsPath, `export function ${name}(): void;\n`);

writeFile(
	scssPath,
	`.${className} {
}
`,
);

writeFile(indexPath, `export { ${name} } from './${name}.tsrx';\n`);

const updatedParent = addParentExport(parentIndexPath, name);

console.log(`Created ${displayPath(folder)}/`);
console.log(`  ${name}.tsrx`);
console.log(`  ${name}.d.tsrx.ts`);
console.log(`  ${name}.module.scss`);
console.log(`  index.ts`);
if (updatedParent) {
	console.log(`Updated ${displayPath(parentIndexPath)}`);
}
