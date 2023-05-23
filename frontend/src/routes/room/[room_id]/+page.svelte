<script lang="ts">
  import { PUBLIC_BACKEND_LOCATION } from '$env/static/public';
    import CellButton from '../../../components/cell-button.svelte';
    import type { Board, Cell, CellReference } from '../../../types';
  import type { LayoutData } from '../$types';

    export let data: LayoutData

    const board = data.board
    const cells: Cell[] = data.cells
    let gameover = false;
    let gameoverText = "Game Over!";

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
            if(cell.bomb){
                gameover = true
            }
        }

        if(dig.gameOver) {
            gameoverText = "You Win!"
            gameover = true
        }
    }
</script>
<div class="main-div">
{#if !gameover}
    <div class="game-board">
        {#each board as row}
            <div class="row">
                {#each row as cellId}
                    <CellButton cellReference={gameBoard[cellId]} bind:onClick></CellButton>
                {/each}
            </div>
        {/each}
    </div>
{:else}
    <div class="game-over-screen">
        <h1>{gameoverText}</h1>
    </div>
{/if}
</div>

<style lang="scss">
    .row {
        display: flex;
    }

    .game-over-screen {
        background-color: rgb(212, 247, 176);
        width: 100%;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        text-align: center;
        font-size: 4em;
    }

    .main-div {
        display: flex;
        width: 100%;
        height: 100vh;
        justify-content: center;
        align-items: center;
    }
</style>