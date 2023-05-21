<script lang="ts">
  import { PUBLIC_BACKEND_LOCATION } from '$env/static/public';
    import CellButton from '../../../components/cell-button.svelte';
    import type { Board, Cell, CellReference } from '../../../types';
  import type { LayoutData } from '../$types';

    export let data: LayoutData

    let selectedCell: CellReference

    let updateNum: number;

    const board = data.board
    const cells: Cell[] = data.cells

    const gameBoard: Board = {}
    for(const row of board) {
        for (const cellId of row){
            gameBoard[cellId] = {id: cellId, cell: null}
        }
    }
    
    for (const cell of cells as Cell[]) {
            gameBoard[cell.id].cell = cell
       }

       
    let onClick = async (cellReference: CellReference) => {
        const digRequest = await fetch(`${PUBLIC_BACKEND_LOCATION}/game/dig`, {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(
                {
                    roomId: data.boardId,
                    cellId: cellReference.id
                }
            )
        });

        const dig = await digRequest.json()


       for (const cell of dig.cellUpdates as Cell[]) {
            gameBoard[cell.id].cell = cell
       }

    }

</script>

<div class="game-board">
    {#each board as row}
        <div class="row">
            {#each row as cellId}
                <CellButton cellReference={gameBoard[cellId]} bind:onClick></CellButton>
            {/each}
        </div>
    {/each}
</div>
<p>{JSON.stringify(selectedCell)}</p>

<style lang="scss">
    .row {
        display: flex;
    }
</style>