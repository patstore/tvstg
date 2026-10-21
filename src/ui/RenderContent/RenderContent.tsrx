import { isPatStoreConfigured } from '@patstore/core';
import {
	asTable,
	contentElements,
	findWebpage,
	htmlString,
	mediaUrl,
	useImages,
	useWebpages,
} from '@provider';
import type { ContentElement, SiteRecord } from '@types';
import { Html } from '../Html/index.ts';

function elementValue(element: ContentElement): unknown {
	return element.value;
}

export function RenderContent(props: { path?: string; contentId?: string }) @{
	@if (!isPatStoreConfigured()) {
		<span />
	} @else {
		<RenderContentData path={props.path} contentId={props.contentId} />
	}
}

function RenderContentData(props: { path?: string; contentId?: string }) @{
	@try {
		const webpages = useWebpages();
		const images = useImages();
		const webpage = props.path || props.contentId ? findWebpage(webpages, props.path || props.contentId || '') : undefined;
		const elements = contentElements(webpage?.content);

		<div class="club-richtext">
			@if (elements.length === 0 && webpage?.text) {
				<Html html={htmlString(webpage.text)} />
			} @else if (elements.length === 0 && webpage?.description) {
				<p>{webpage.description as string}</p>
			}
			@for (const element of elements; key element.id) {
				<ContentBlock element={element} images={images} />
			}
		</div>
	} @pending {
		<p class="club-status">Inhalt wird geladen…</p>
	} @catch (_error) {
		<p class="club-status">Inhalt konnte nicht geladen werden.</p>
	}
}

function ContentBlock(props: { element: ContentElement; images: SiteRecord[] }) @{
	@if (!props.element.active) {
		<span />
	} @else if (props.element.type === 'image') {
		<img class="club-media" src={mediaUrl(props.element.value, props.images)} alt={(props.element.name || '') as string} />
	} @else if (props.element.type === 'video') {
		<div class="club-richtext" dangerouslySetInnerHTML={{ __html: htmlString(props.element.value) }} />
	} @else if (props.element.type === 'table') {
		<ContentTable data={elementValue(props.element)} />
	} @else if (props.element.type === 'divider') {
		<hr />
	} @else {
		<Html html={htmlString(props.element.value)} />
	}
}

function ContentTable(props: { data: unknown }) @{
	const table = asTable(props.data);

	@if (table) {
		<div>
			@if (table.settings?.title) {
				<h3>{table.settings.title as string}</h3>
			}
			@if (table.settings?.description) {
				<p>{table.settings.description as string}</p>
			}
			<table class="club-table">
				<thead>
					<tr>
						@for (const column of table.columns; key column.id) {
							<th>{column.name as string}</th>
						}
					</tr>
				</thead>
				<tbody>
					@for (const row of table.rows; key row.id) {
						<tr>
							@for (const column of table.columns; key row.id + column.id) {
								<td>{(row.data[table.columns.indexOf(column)] || '') as string}</td>
							}
						</tr>
					}
				</tbody>
			</table>
			@if (table.settings?.footer) {
				<p>{table.settings.footer as string}</p>
			}
		</div>
	}
}
