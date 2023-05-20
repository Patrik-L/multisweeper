import { PUBLIC_BACKEND_LOCATION } from "$env/static/public";
import type { Cell, CellIdBoard } from "../../../types";
import type { LayoutLoad } from "../$types";

export const load = (async ({ params }) => {
  const boardId = params.room_id;
  try {
    const createRequest = await fetch(
      `${PUBLIC_BACKEND_LOCATION}/room/create/${boardId}`
    );
    const create = await createRequest.json();
  } catch (error) {
    console.warn(error);
  }

  const boardRequest = await fetch(
    `${PUBLIC_BACKEND_LOCATION}/room/get/${boardId}`
  );

  const data: { board: CellIdBoard } = await boardRequest.json();
  const { board } = data;

  return { board, boardId };
}) satisfies LayoutLoad;
