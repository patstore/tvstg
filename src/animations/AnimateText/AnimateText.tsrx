import { useEffect, useRef } from 'octane';
import { gsap } from 'gsap';
import SplitType from 'split-type';
import {
	prefersReducedMotion,
	resolveTrigger,
	useViewportTrigger,
} from '../hooks/useViewportTrigger.ts';

type AnimateTextType = 'row' | 'chars';
type AnimateTextTag = 'div' | 'span' | 'p' | 'h1' | 'h2' | 'h3' | 'h4' | 'h5' | 'h6';

export interface AnimateTextProps {
	children?: unknown;
	/** Animation style: slide up as full row(s) or stagger individual chars */
	type?: AnimateTextType;
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
	as?: AnimateTextTag;
	delay?: number;
	duration?: number;
	ease?: string;
	stagger?: number;
	className?: string;
}

export function AnimateText({
	children,
	type = 'row',
	trigger,
	viewport,
	delay = 0,
	duration = 0.8,
	ease = 'power3.out',
	stagger = 0.03,
	className,
}: AnimateTextProps) @{
	const ref = useRef<HTMLSpanElement | null>(null);
	const splitRef = useRef<SplitType | null>(null);
	const hasAnimated = useRef(false);
	const viewportReached = useViewportTrigger(ref, viewport);
	const resolvedTrigger = resolveTrigger(trigger, viewport, viewportReached);

	useEffect(() => {
		const el = ref.current;
		if (!el) return;

		splitRef.current?.revert();

		if (prefersReducedMotion()) {
			return;
		}

		if (type === 'chars') {
			const split = new SplitType(el, { types: 'chars' });
			splitRef.current = split;
			gsap.set(split.chars, { y: 30, opacity: 0 });
		} else {
			const split = new SplitType(el, { types: 'lines' });
			splitRef.current = split;

			split.lines?.forEach((line) => {
				const mask = document.createElement('span');
				mask.style.cssText = 'display:block;overflow:hidden;';
				line.parentNode?.insertBefore(mask, line);
				mask.appendChild(line);
			});

			gsap.set(split.lines, { yPercent: 100, opacity: 0 });
		}

		return () => {
			splitRef.current?.revert();
			splitRef.current = null;
		};
	}, [type]);

	useEffect(() => {
		const split = splitRef.current;
		if (!split || prefersReducedMotion()) return;

		if (resolvedTrigger !== undefined && !resolvedTrigger) {
			if (hasAnimated.current) {
				if (type === 'chars') {
					gsap.to(split.chars, { y: 30, opacity: 0, duration, ease, stagger, delay });
				} else {
					gsap.to(split.lines, { yPercent: 100, opacity: 0, duration, ease, stagger, delay });
				}
				hasAnimated.current = false;
			}
			return;
		}

		if (type === 'chars') {
			gsap.to(split.chars, { y: 0, opacity: 1, duration, ease, stagger, delay });
		} else {
			gsap.to(split.lines, { yPercent: 0, opacity: 1, duration, ease, stagger, delay });
		}
		hasAnimated.current = true;
	}, [resolvedTrigger, type, delay, duration, ease, stagger]);

	<span ref={ref} class={className} style="display:block">{children}</span>
}
