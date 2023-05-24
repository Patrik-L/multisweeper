import { PUBLIC_BACKEND_LOCATION } from "$env/static/public";
import type { Cell, CellIdBoard } from "../../../types";
import type { LayoutLoad } from "../$types";

export const load = (async ({ params }) => {
  const boardId = params.room_id;

  // Try creating a new room if one doesn't exist
  try {
    const createRequest = await fetch(
      `${PUBLIC_BACKEND_LOCATION}/room/create/${boardId}`
    );
    const create = await createRequest.json();
  } catch (error) {
    console.warn(error);
  }

  // Get board information
  const boardRequest = await fetch(
    `${PUBLIC_BACKEND_LOCATION}/room/get/${boardId}`
  );

  const data: { board: CellIdBoard; cells: Cell[] } = await boardRequest.json();
  const { board, cells } = data;

  // Pass board info to page.svelte
  return { board, boardId, cells };
}) satisfies LayoutLoad;
