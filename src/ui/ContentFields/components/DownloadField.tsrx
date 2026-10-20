import { useContext } from 'octane';
import { PageValuesContext, RowValuesContext, SectionPathContext } from '../context/index.ts';
import { resolveFile, findValueForKey } from '../functions/index.ts';

export interface DownloadFieldProps {
	/** Field key, literal string — combined with the ambient section path to form the full dot-path. */
	id: string;
	/** Editor-facing label. Read directly from source by the manifest scanner. */
	label?: string;
	/** JSX default `href`, used until a CMS value resolves. */
	href?: string;
	class?: string;
	/** Suggested filename for the browser's save dialog, used until a CMS value resolves (falls back to the resolved file's own uploaded filename, then to the browser default). */
	filename?: string;
	/** Link text — always JSX-authored, mirrors `<ImageField>` in that only the file itself (not its caption) is resolved from the CMS value. Ignored when `displayFileName` is set. */
	children?: unknown;
	/** Shows the resolved file's own filename as the link text instead of `children`. */
	displayFileName?: boolean;
}

/**
 * A downloadable-file leaf — resolves `href` to the CMS-picked file's URL.
 * PatStore stores the picked file as a `Download` record (its dedicated
 * class for downloadable files, mirroring `Image`), so the CMS value is that
 * record's `objectId`; `resolveFile` looks it up and reads `file.url` (same
 * `/asset/...` resolution `<ImageField>` gets from the `Image` class — see
 * `resolve-file.ts`). Sets `download` so the browser saves it instead of
 * navigating to it.
 *
 * The two branches render `resolvedDownload` vs `children` from separate JSX
 * positions rather than a `displayFileName ? resolvedDownload : children`
 * ternary — the compiler lowers a component's JSX children into a callable
 * render function, not a plain string, so it must see a bare `{children}`
 * (its special-cased invocation form) to invoke it; wrapping it in a ternary
 * instead stringifies the function itself.
 */
export function DownloadField({
	id,
	href,
	class: className,
	filename,
	children,
	displayFileName = false,
}: DownloadFieldProps) @{
	const row = useContext(RowValuesContext);
	const sectionPath = useContext(SectionPathContext);
	const { pageData, currentLanguage } = useContext(PageValuesContext);

	const value = row
		? row[id]
		: findValueForKey({
				key: sectionPath ? `${sectionPath}.${id}` : id,
				lang: currentLanguage,
				content: pageData,
			});
	const resolved = typeof value === 'string' && value ? resolveFile(value) : null;
	const resolvedHref = resolved?.url ?? href;
	const resolvedDownload = resolved?.filename ?? filename ?? '';

	@if (displayFileName) {
		<a class={className} href={resolvedHref} download={resolvedDownload}>
			{resolvedDownload}
		</a>
	} @else {
		<a class={className} href={resolvedHref} download={resolvedDownload}>
			{children}
		</a>
	}
}
