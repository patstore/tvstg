import js from '@eslint/js';
import eslintPluginPrettierRecommended from 'eslint-plugin-prettier/recommended';
import tsrx from '@tsrx/eslint-plugin';
import globals from 'globals';
import tseslint from 'typescript-eslint';

export default tseslint.config(
	{
		ignores: [
			'dist',
			'node_modules',
			'octane-temp',
			'src/pages/.generated/**',
			'**/*.d.tsrx.ts',
			'data/*',
		],
	},
	{
		extends: [js.configs.recommended, ...tseslint.configs.recommended],
		files: ['**/*.{ts,tsx}'],
		languageOptions: {
			ecmaVersion: 2023,
			globals: globals.browser,
		},
		rules: {
			'@typescript-eslint/no-unused-vars': [
				'error',
				{ argsIgnorePattern: '^_', varsIgnorePattern: '^_' },
			],
		},
	},
	...tsrx.configs.recommended,
	{
		files: ['**/*.tsrx'],
		languageOptions: {
			globals: globals.browser,
		},
	},
	eslintPluginPrettierRecommended,
);
