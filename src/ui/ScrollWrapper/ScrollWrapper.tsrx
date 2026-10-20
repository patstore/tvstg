import { useEffect, useRef } from 'octane';
import { createHorizontalLenis, lenis, trackLenis } from '../../lenis.ts';

export type ScrollWrapperProps = {
	children?: unknown;
	isHorizontal?: boolean;
};

const HORIZONTAL_SCROLL_CLASS = 'is-horizontal-scroll';

/**
 * Layout shell for a horizontal panel row. Scroll feel comes from the shared
 * Lenis options in `src/lenis.ts`: a vertical wheel moves the row on X.
 */
export function ScrollWrapper({ children, isHorizontal = true }: ScrollWrapperProps) @{
	const wrapperRef = useRef<HTMLDivElement | null>(null);
	const trackRef = useRef<HTMLDivElement | null>(null);

	useEffect(() => {
		const wrapper = wrapperRef.current;
		const track = trackRef.current;
		if (!wrapper || !track) {
			return;
		}

		const html = document.documentElement;
		lenis.scrollTo(0, { immediate: true, force: true });
		lenis.stop();
		if (isHorizontal) {
			html.classList.add(HORIZONTAL_SCROLL_CLASS);
		}

		const horizontal = createHorizontalLenis(wrapper, track);
		const untrack = trackLenis(horizontal);

		const onKeyDown = (event: KeyboardEvent) => {
			const step = wrapper.clientWidth * 0.85;
			const current = horizontal.scroll;
			if (event.key === 'ArrowRight' || event.key === 'ArrowDown' || event.key === 'PageDown') {
				event.preventDefault();
				horizontal.scrollTo(current + step);
			} else if (event.key === 'ArrowLeft' || event.key === 'ArrowUp' || event.key === 'PageUp') {
				event.preventDefault();
				horizontal.scrollTo(current - step);
			} else if (event.key === 'Home') {
				event.preventDefault();
				horizontal.scrollTo(0);
			} else if (event.key === 'End') {
				event.preventDefault();
				horizontal.scrollTo(horizontal.limit);
			}
		};

		window.addEventListener('keydown', onKeyDown);

		return () => {
			window.removeEventListener('keydown', onKeyDown);
			untrack();
			horizontal.destroy();
			if (isHorizontal) {
				html.classList.remove(HORIZONTAL_SCROLL_CLASS);
			}
			lenis.start();
		};
	}, []);

	<>
		<style>
			.scroll-wrapper {
				position: relative;
				width: 100%;
				height: 100%;
				overflow-x: scroll;
				overflow-y: hidden;
				scrollbar-width: none;
				touch-action: pan-x;
				container-type: inline-size;
			}
			.scroll-wrapper::-webkit-scrollbar {
				display: none;
			}
			.scroll-wrapper__track {
				display: flex;
				flex-direction: row;
				flex-wrap: nowrap;
				align-items: stretch;
				height: 100%;
				width: max-content;
			}
			.scroll-wrapper__track > * {
				box-sizing: border-box;
				flex: 0 0 100cqw;
				width: 100cqw;
				height: 100%;
				min-width: 0;
				overflow: hidden;
			}
		</style>
		<div class="scroll-wrapper" ref={wrapperRef}>
			<div class="scroll-wrapper__track" ref={trackRef}>
				{children}
			</div>
		</div>
	</>
}
