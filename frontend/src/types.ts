export interface Cell {
  bomb: boolean;
  uncovered: boolean;
  id: number;
  value: number;
  location: { x: number; y: number };
}

export type CellIdBoard = Array<Array<number>>;

export interface CellReference {
  id: number;
  cell: Cell | null;
}

export interface Board {
  [id: number]: CellReference;
}
