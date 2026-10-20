import type { TextFlipDirection, TextFlipProps } from './TextFlip.d.tsrx.ts';
import styles from './TextFlip.module.scss';
import { useState } from 'octane';

const CSS_EASE: Record<string, string> = {
	'power1.out': 'cubic-bezier(0.25, 0.46, 0.45, 0.94)',
	'power2.out': 'cubic-bezier(0.215, 0.61, 0.355, 1)',
	'power3.out': 'cubic-bezier(0.165, 0.84, 0.44, 1)',
};

function cssEase(ease: string) {
	return CSS_EASE[ease] ?? ease;
}

function directionClass(direction: TextFlipDirection) {
	if (direction === 'down') {
		return styles.down;
	}
	if (direction === 'left') {
		return styles.left;
	}
	if (direction === 'right') {
		return styles.right;
	}
	return styles.up;
}

export function TextFlip({
	text,
	nextText,
	direction = 'up',
	showText = false,
	duration = 0.6,
	ease = 'power3.out',
	className,
	useHover = true,
}: TextFlipProps) @{
	const [switchText, setSwitchText] = useState(false);
	<span
		onMouseEnter={() => setSwitchText(true)}
		onMouseLeave={() => setSwitchText(false)}
		class={[
			styles.clip,
			directionClass(direction),
			(showText || switchText) && styles.swapped,
			className,
		]}
		style={`--text-flip-duration:${duration}s;--text-flip-ease:${cssEase(ease)}`}
	>
		<span class={[styles.layer, styles.current]} aria-hidden={useHover ? switchText : showText}>
			{text as string}
		</span>
		<span class={[styles.layer, styles.next]} aria-hidden={useHover ? !switchText : !showText}>
			{nextText as string}
		</span>
	</span>
}
