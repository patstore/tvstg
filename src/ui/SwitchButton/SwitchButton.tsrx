import { motion } from '@octanejs/motion';

export function SwitchButton(props: {
	text: string;
	active: boolean;
	onClick: () => void;
}) @{
	<motion.button
		type="button"
		className={props.active ? 'club-switch is-active' : 'club-switch'}
		whileTap={{ scale: 0.96 }}
		onClick={() => props.onClick()}
	>
		{props.text as string}
	</motion.button>
}
