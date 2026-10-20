import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { defineConfig, loadEnv } from 'vite';
import { octane } from '@octanejs/vite-plugin';

// import { octane } from 'octane/compiler/vite';
import { patStorePlugin } from '@patstore/vite-plugin';
import { octanePagesPlugin } from '@patstore/octane-pages-plugin';
import { cmsContentPlugin } from '@patstore/cms-content-plugin';

const root = path.dirname(fileURLToPath(import.meta.url));

export default defineConfig(({ mode }) => {
	const env = loadEnv(mode, root, '');

	return {
		define: {
			'import.meta.env.DEFAULT_LANG': JSON.stringify(env.DEFAULT_LANG ?? 'en'),
			'import.meta.env.PREVIEW_ENABLED': JSON.stringify(env.PREVIEW_ENABLED === 'true'),
		},
		plugins: [
			octanePagesPlugin(),
			patStorePlugin({ strict: false, env }),
			cmsContentPlugin({ env, outputDir: 'data' }),
			octane(),
		],
		resolve: {
			alias: {
				'@data': path.resolve(root, 'data/index.ts'),
				'@animations': path.resolve(root, 'src/animations/index.ts'),
				'@cms-content': path.resolve(root, 'data/cms-content-data.ts'),
				'@provider': path.resolve(root, 'src/provider/index.ts'),
				'@context': path.resolve(root, 'src/context/index.ts'),
				'@ui': path.resolve(root, 'src/ui/index.ts'),
				'@content': path.resolve(root, 'src/content/index.ts'),
				'@types': path.resolve(root, 'src/types/index.ts'),
				'@components': path.resolve(root, 'src/components/index.ts'),
				'@pages': path.resolve(root, 'src/pages'),
			},
		},
		build: { target: 'esnext' },
		optimizeDeps: {
			include: ['lodash.debounce'],
			needsInterop: ['lodash.debounce'],
		},
	};
});
