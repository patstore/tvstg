declare module '@lucide/icons/icons/*' {
	const icon: { name: string; node: unknown };
	export default icon;
}

interface ImportMetaEnv {
	readonly DEFAULT_LANG: string;
	/** Live CMS preview — see `src/provider/content/live-content.ts` and `vite.config.ts`. */
	readonly PREVIEW_ENABLED: boolean;
}

interface ImportMeta {
	readonly env: ImportMetaEnv;
}
