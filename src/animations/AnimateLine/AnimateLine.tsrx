import { useEffect, useRef } from 'octane';
import { gsap } from 'gsap';
import {
	prefersReducedMotion,
	resolveTrigger,
	useViewportTrigger,
} from '../hooks/useViewportTrigger.ts';

type AnimateLineDirection = 'top-to-bottom' | 'left-to-right' | 'right-to-left';

export interface AnimateLineProps {
	/** Pixel length of the line (height for vertical, width for horizontal) */
	length: number;
	thickness?: number | string;
	direction?: AnimateLineDirection;
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
	delay?: number;
	duration?: number;
	ease?: string;
	className?: string;
	unit?: 'px' | '%';
	id?: string;
}

export function AnimateLine({
	length,
	thickness = 0.9,
	direction = 'top-to-bottom',
	trigger,
	viewport,
	delay = 0,
	duration = 0.8,
	ease = 'power3.out',
	className,
	unit = 'px',
	id,
}: AnimateLineProps) @{
	const ref = useRef<HTMLDivElement | null>(null);
	const hasAnimated = useRef(false);
	const viewportReached = useViewportTrigger(ref, viewport);
	const resolvedTrigger = resolveTrigger(trigger, viewport, viewportReached);
	const isVertical = direction === 'top-to-bottom';
	const thicknessValue = typeof thickness === 'number' ? `${thickness}px` : thickness;
	const sizeStyle = isVertical
		? `height:${length}${unit};width:${thicknessValue};background-color:var(--text);margin:0;padding:0;`
		: `width:${length}${unit};height:${thicknessValue};background-color:var(--text);margin:0;padding:0;`;

	useEffect(() => {
		const el = ref.current;
		if (!el) return;

		if (prefersReducedMotion()) {
			gsap.set(el, { scaleX: 1, scaleY: 1 });
			return;
		}

		if (isVertical) {
			gsap.set(el, { scaleY: 0, transformOrigin: 'top center' });
		} else if (direction === 'left-to-right') {
			gsap.set(el, { scaleX: 0, transformOrigin: 'left center' });
		} else {
			gsap.set(el, { scaleX: 0, transformOrigin: 'right center' });
		}

		return () => {
			gsap.killTweensOf(el);
		};
	}, [direction, isVertical]);

	useEffect(() => {
		const el = ref.current;
		if (!el || prefersReducedMotion()) return;

		if (resolvedTrigger !== undefined && !resolvedTrigger) {
			if (hasAnimated.current) {
				if (isVertical) {
					gsap.to(el, { scaleY: 0, transformOrigin: 'top center', duration, ease, delay });
				} else if (direction === 'left-to-right') {
					gsap.to(el, { scaleX: 0, transformOrigin: 'left center', duration, ease, delay });
				} else {
					gsap.to(el, { scaleX: 0, transformOrigin: 'right center', duration, ease, delay });
				}
				hasAnimated.current = false;
			}
			return;
		}

		if (isVertical) {
			gsap.to(el, { scaleY: 1, duration, ease, delay });
		} else {
			gsap.to(el, { scaleX: 1, duration, ease, delay });
		}
		hasAnimated.current = true;
	}, [resolvedTrigger, direction, isVertical, delay, duration, ease]);

	<div id={id} ref={ref} class={className} style={sizeStyle} />
}
