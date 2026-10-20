import { configurePatStoreStaticData } from '@patstore/core';
import { findByObjectId, findStaticCollection, isStaticDataReady } from '@data';
import { createRoot } from 'octane';
import { App } from './App.tsrx';
import { loadProjectSettings } from '@provider';
import { startLenisLoop } from './lenis.ts';
import './styles/main.scss';

configurePatStoreStaticData({
	findStaticCollection,
	findByObjectId,
	isStaticDataReady,
});

const container = document.getElementById('app');
if (!container) {
	throw new Error('Root element #app not found');
}

async function boot() {
	await loadProjectSettings();

	const root = createRoot(container!);
	root.render(App, {});

	startLenisLoop();
}

boot();
