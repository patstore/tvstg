import { useEffect, useRef } from 'octane';
import { gsap } from 'gsap';
import {
	prefersReducedMotion,
	resolveTrigger,
	useViewportTrigger,
} from '../hooks/useViewportTrigger.ts';

type AnimateContentTag = 'div' | 'span' | 'section' | 'article' | 'p';

export interface AnimateContentProps {
	children?: unknown;
	/**
	 * Controls when the animation plays.
	 * - Omit entirely → plays immediately on mount.
	 * - Pass `false` → element starts hidden and waits.
	 * - Pass `true`  → plays the animation (set to true to trigger).
	 */
	trigger?: boolean;
	/**
	 * Lenis-driven viewport progress at which the animation plays.
	 * `0` = element just enters the viewport, `1` = element just leaves.
	 * Omit to play on mount (or via `trigger`).
	 */
	viewport?: number;
	as?: AnimateContentTag;
	delay?: number;
	duration?: number;
	ease?: string;
	className?: string;
}

export function AnimateContent({
	children,
	trigger,
	viewport,
	delay = 0,
	duration = 0.6,
	ease = 'power3.inOut',
	className,
}: AnimateContentProps) @{
	const ref = useRef<HTMLDivElement | null>(null);
	const hasAnimated = useRef(false);
	const viewportReached = useViewportTrigger(ref, viewport);
	const resolvedTrigger = resolveTrigger(trigger, viewport, viewportReached);

	useEffect(() => {
		const el = ref.current;
		if (!el) return;

		if (!prefersReducedMotion()) {
			gsap.set(el, { autoAlpha: 0 });
		}

		return () => {
			gsap.killTweensOf(el);
			gsap.set(el, { clearProps: 'opacity,visibility' });
		};
	}, []);

	useEffect(() => {
		const el = ref.current;
		if (!el || prefersReducedMotion()) return;

		if (resolvedTrigger !== undefined && !resolvedTrigger) {
			if (hasAnimated.current) {
				gsap.to(el, { autoAlpha: 0, duration, ease, delay });
				hasAnimated.current = false;
			}
			return;
		}

		gsap.to(el, { autoAlpha: 1, duration, ease, delay });
		hasAnimated.current = true;
	}, [resolvedTrigger, delay, duration, ease]);

	<div ref={ref} class={className}>{children}</div>
}
