import gsap from 'gsap';

export type PageTransitionOptions = {
	element: HTMLElement;
	/** Apply the next route. Called once the outgoing snapshot is in place. */
	commit: () => void;
	/** Release the navigation lock after the timeline finishes. */
	done: () => void;
};

/** Drop Octane's comment markers so the visual clone is not adopted as live UI. */
function stripMarkerComments(root: HTMLElement) {
	const walker = document.createTreeWalker(root, NodeFilter.SHOW_COMMENT);
	const comments: Comment[] = [];
	let current = walker.nextNode();
	while (current) {
		comments.push(current as Comment);
		current = walker.nextNode();
	}
	for (const comment of comments) {
		comment.remove();
	}
}

/**
 * The clone cannot be inserted next to `.page-content`: that parent is owned
 * by Octane, and the extra nodes crash the next route update. Park it on
 * `document.body`, covering the same rectangle.
 */
function placeTransitionLayer(node: HTMLElement, rect: DOMRect) {
	Object.assign(node.style, {
		position: 'fixed',
		top: `${rect.top}px`,
		left: `${rect.left}px`,
		width: `${rect.width}px`,
		height: `${rect.height}px`,
		right: 'auto',
		bottom: 'auto',
		margin: '0',
		overflow: 'hidden',
	});
}

/**
 * `cloneNode` drops scroll offsets, so copy them over to keep the snapshot in
 * place. The clone must already be attached, detached nodes can't scroll.
 */
function copyScrollOffsets(source: HTMLElement, clone: HTMLElement) {
	const sourceNodes = [source, ...Array.from(source.querySelectorAll<HTMLElement>('*'))];
	const cloneNodes = [clone, ...Array.from(clone.querySelectorAll<HTMLElement>('*'))];
	sourceNodes.forEach((node, index) => {
		const target = cloneNodes[index];
		if (target && (node.scrollLeft || node.scrollTop)) {
			target.scrollLeft = node.scrollLeft;
			target.scrollTop = node.scrollTop;
		}
	});
}

function mountGhost(element: HTMLElement) {
	const rect = element.getBoundingClientRect();
	const ghost = element.cloneNode(true) as HTMLDivElement;
	stripMarkerComments(ghost);
	ghost.classList.add('page-content--exiting');
	ghost.setAttribute('aria-hidden', 'true');
	ghost.inert = true;
	placeTransitionLayer(ghost, rect);

	const overlay = document.createElement('div');
	placeTransitionLayer(overlay, rect);
	Object.assign(overlay.style, {
		background: 'black',
		opacity: '0',
		pointerEvents: 'none',
		zIndex: '0',
	});
	document.body.append(ghost, overlay);
	copyScrollOffsets(element, ghost);

	return { ghost, overlay };
}

function ghostTimeline(
	element: HTMLElement,
	ghost: HTMLElement,
	overlay: HTMLElement,
	done: () => void,
) {
	return gsap.timeline({
		defaults: { duration: 1.2, ease: 'power2.inOut' },
		onComplete: () => {
			ghost.remove();
			overlay.remove();
			gsap.set(element, { clearProps: 'transform,opacity' });
			done();
		},
	});
}

/**
 * Current transition. The outgoing page fades in place under a dark overlay
 * while the incoming page fades up.
 */
export function currentPageTransition({ element, commit, done }: PageTransitionOptions) {
	const { ghost, overlay } = mountGhost(element);
	commit();

	ghostTimeline(element, ghost, overlay, done)
		.to(ghost, { opacity: 0, x: 0 }, 0)
		.to(overlay, { opacity: 0.5 }, 0.2)
		.fromTo(element, { opacity: 0.8, x: 0 }, { opacity: 1, x: 0 }, 0);
}

/**
 * Former transition. The outgoing page slides left under a dark overlay
 * while the incoming page enters from the right.
 */
export function formerPageTransition({ element, commit, done }: PageTransitionOptions) {
	const { ghost, overlay } = mountGhost(element);
	commit();

	ghostTimeline(element, ghost, overlay, done)
		.to(ghost, { opacity: 0.8, x: -300 }, 0)
		.to(overlay, { opacity: 0.5 }, 0.2)
		.fromTo(element, { opacity: 0.8, x: '100vw' }, { opacity: 1, x: 0 }, 0);
}
