// Intentionally empty of `declare module '@cms'` / `@data`.
// Those specifiers are resolved via tsconfig `paths` (and the Vite plugin aliases).
// A plugin-generated `export *` ambient module shadows the paths and exports nothing.
export {};
