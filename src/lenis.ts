import Lenis from 'lenis';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

/**
 * Shared by the document scroller and by `ScrollWrapper`'s horizontal instance.
 * `gestureOrientation: 'both'` on the horizontal instance maps vertical wheel
 * and horizontal trackpad input onto the same X axis.
 */
export const lenisOptions = {
	duration: 1.8,
	wheelMultiplier: 0.65,
	touchMultiplier: 0.85,
	easing: (t: number) => Math.min(1, 1.001 - Math.pow(2, -10 * t)),
	smoothWheel: true,
	allowNestedScroll: true,
} as const;

const active = new Set<Lenis>();

export function trackLenis(instance: Lenis) {
	active.add(instance);
	return () => {
		active.delete(instance);
	};
}

/** Vertical document scroller. Stopped while a horizontal `ScrollWrapper` is mounted. */
export const lenis = new Lenis({
	...lenisOptions,
	prevent: (node) => node.closest('.scroll-wrapper') != null,
});

trackLenis(lenis);
lenis.on('scroll', ScrollTrigger.update);

export function createHorizontalLenis(wrapper: HTMLElement, content: HTMLElement) {
	const horizontal = new Lenis({
		...lenisOptions,
		wrapper,
		content,
		orientation: 'horizontal',
		gestureOrientation: 'both',
		overscroll: false,
	});
	horizontal.on('scroll', ScrollTrigger.update);
	return horizontal;
}

export function startLenisLoop() {
	function onFrame(time: number) {
		for (const instance of active) {
			instance.raf(time);
		}
		requestAnimationFrame(onFrame);
	}

	requestAnimationFrame(onFrame);
}
