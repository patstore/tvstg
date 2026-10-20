import { getProjectLanguages } from '@provider';
import { isRoutablePath, localizePath, resolveDocumentLang, useRouter } from '@provider';

function languageLabel(lang: string): string {
	return lang.toUpperCase();
}

export function LanguageToggle() @{
	const { path, navigate } = useRouter();
	const languages = getProjectLanguages();
	const currentLanguage = resolveDocumentLang(path);

	if (languages.length <= 1) {
		return null;
	}

	const switchLanguage = (lang: string) => {
		if (lang === currentLanguage) {
			return;
		}

		let nextPath = localizePath(path, lang);
		if (!isRoutablePath(nextPath)) {
			nextPath = localizePath('/', lang);
		}

		navigate(nextPath);
	};

	<div class="language-toggle" role="group" aria-label="Language">
		@for (const lang of languages; key lang) {
			<button
				type="button"
				class={'language-toggle__button' + (lang === currentLanguage ? ' is-active' : '')}
				onClick={() => switchLanguage(lang)}
				aria-pressed={lang === currentLanguage}
				aria-label={'Switch to ' + languageLabel(lang) as string}
			>{languageLabel(lang) as string}</button>
		}
	</div>
}
