import { isPatStoreConfigured } from '@patstore/core';
import { CmsArticles } from './CmsArticles.tsrx';

export function CmsSection() @{
	@if (!isPatStoreConfigured()) {
		<div class="content-card cms-placeholder">
			<h2>CMS</h2>
			<p>
				PatStore is not configured. Copy
				<code>.env.example</code>
				to
				<code>.env</code>
				{' '}
				and set the
				<code>VITE_PATSTORE_*</code>
				variables to load live content.
			</p>
		</div>
	} @else {
		<CmsArticles />
	}
}
