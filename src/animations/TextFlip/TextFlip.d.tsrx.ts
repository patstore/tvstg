export type TextFlipDirection = 'up' | 'down' | 'left' | 'right';

export type TextFlipProps = {
	/** Text shown while `showText` is false. */
	text: string;
	/** Text shown while `showText` is true. */
	nextText: string;
	/**
	 * Direction the text that is currently in the container leaves.
	 * The replacement enters from the opposite side.
	 */
	direction?: TextFlipDirection;
	/**
	 * Which string is in the container.
	 * `false` shows `text`. `true` shows `nextText`.
	 * Returning to the previous value reverses the swap:
	 * `text` comes back from the direction it left, and `nextText` leaves the other way.
	 */
	showText?: boolean;
	duration?: number;
	/** CSS timing function. `power1.out`, `power2.out`, and `power3.out` are accepted. */
	ease?: string;
	className?: string;
	/**
	 * Whether to use hover to switch the text.
	 */
	useHover?: boolean;
};

export function TextFlip(props: TextFlipProps): void;
