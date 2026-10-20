import * as fs from 'node:fs';
import * as path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import type { UserConfig, UserConfigExport, UserConfigFnPromise } from 'vite';
import { buildManifest, contentMapFromDefaults, writeContentArtifacts, writeManifest } from '@patstore/cms-content-plugin';

const root = path.dirname(path.dirname(fileURLToPath(import.meta.url)));
const pagesDir = path.join(root, 'src/pages');
const outputDir = path.join(root, 'data');

function readDefaultLang(): string {
	const envPath = path.join(root, '.env');
	if (!fs.existsSync(envPath)) {
		return 'en';
	}
	const match = fs.readFileSync(envPath, 'utf-8').match(/^DEFAULT_LANG=(.*)$/m);
	return match?.[1]?.trim() || 'en';
}

/**
 * Reads `vite.config.ts`'s resolved `resolve.alias` table (calling only the
 * plain config-factory function — no plugin hooks run) so this standalone
 * script's import-follower resolves `@content`/`@ui`/etc. the same way the
 * app's bundler does. Without this, content extracted into `src/content/`
 * (imported, not inlined, by page files) would scan to an empty manifest.
 */
async function resolveAliases(): Promise<Record<string, string>> {
	const configModule = (await import(pathToFileURL(path.join(root, 'vite.config.ts')).href)) as {
		default: UserConfigExport;
	};
	const rawConfig = configModule.default;
	const resolvedConfig: UserConfig | Promise<UserConfig> =
		typeof rawConfig === 'function'
			? await (rawConfig as UserConfigFnPromise)({
					mode: 'production',
					command: 'build',
					isSsrBuild: false,
					isPreview: false,
				})
			: rawConfig;

	const alias = (await resolvedConfig)?.resolve?.alias;
	if (!alias || Array.isArray(alias)) {
		return {};
	}

	const aliases: Record<string, string> = {};
	for (const [key, value] of Object.entries(alias)) {
		if (typeof value === 'string') {
			aliases[key] = value;
		}
	}
	return aliases;
}

const aliases = await resolveAliases();
const manifest = buildManifest(pagesDir, aliases);
writeManifest(outputDir, manifest);
writeContentArtifacts(outputDir, contentMapFromDefaults(manifest, readDefaultLang()));

console.log(
	`Generated CMS content manifest (${Object.keys(manifest.pages).length} page(s)) — run "npm run dev" or "npm run build" to sync with PatStore.`,
);
