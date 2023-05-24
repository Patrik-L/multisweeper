<script lang="ts">
  import { PUBLIC_BACKEND_LOCATION } from "$env/static/public";
  import CellButton from "../../../components/cell-button.svelte";
  import type { Board, Cell, CellReference } from "../../../types";
  import type { LayoutData } from "../$types";
  import { onMount } from "svelte";

  export let data: LayoutData;

  // Fetched from layout.ts
  const board = data.board;
  const cells: Cell[] = data.cells;
  const timeLoaded = new Date().valueOf();
  let gameover = false;
  let gameoverText = "Game Over";
  let elapsedSeconds = "000";

  const gameBoard: Board = {};

  // Populate the board with cell references
  for (const row of board) {
    for (const cellId of row) {
      gameBoard[cellId] = { id: cellId, cell: null, flag: false };
    }
  }

  // Add known cells to board
  for (const cell of cells as Cell[]) {
    gameBoard[cell.id].cell = cell;
  }

  // Timer
  let padToFour = (number: number) =>
    number <= 999 ? `00${number}`.slice(-3) : number.toString();
  onMount(() => {
    // Updates timer 1 time per second
    setInterval(() => {
      if (gameover) {
        return;
      }
      elapsedSeconds = padToFour(
        Math.floor((new Date().valueOf() - timeLoaded.valueOf()) / 1000)
      );
    }, 1000);
  });

  // When cell is clicked
  let onClick = async (cellReference: CellReference) => {
    // Trigger post request to back end
    const digRequest = await fetch(`${PUBLIC_BACKEND_LOCATION}/game/dig`, {
      method: "POST",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        roomId: data.boardId,
        cellId: cellReference.id,
      }),
    });

    const dig = await digRequest.json();

    // Update all cell references with new cells we recieved
    for (const cell of dig.cellUpdates as Cell[]) {
      gameBoard[cell.id].cell = cell;
      // If any of the dug up cells were bombs, we end the game
      if (cell.bomb) {
        gameover = true;
      }
    }

    // if dig request resulted in the game ending, we declare a victory
    if (dig.gameOver) {
      gameoverText = "You Win!";
      gameover = true;
    }
  };
</script>

<div class="main-div">
  <!-- Game over text -->
  {#if gameover}
    <div class="game-over-screen">
      <h1>{gameoverText}</h1>
    </div>
  {/if}
  <div>
    <!-- Header above board -->
    <div class="header"><p class="seconds">{elapsedSeconds}</p></div>
    <!-- Game board itself -->
    <div class="game-board">
      {#each board as row}
        <div class="row">
          {#each row as cellId}
            <CellButton
              {gameover}
              cellReference={gameBoard[cellId]}
              bind:onClick
            />
          {/each}
        </div>
      {/each}
    </div>
  </div>
</div>

<style lang="scss">
  .row {
    display: flex;
  }

  .header {
    background-color: #bdbdbd;
    display: flex;
    border: 6px #ebebeb outset;
    flex-direction: row;
    justify-content: end;
    align-items: center;
  }

  .seconds {
    padding: 0.2em;
    margin: 0.5em;
    font-size: 2em;
    width: fit-content;
    color: red;
    background-color: black;
    border: 4px #ebebeb inset;
  }

  .game-over-screen {
    display: flex;
    justify-content: center;
    align-items: center;
    text-align: center;
    font-size: 1.2em;
    text-align: center;
  }

  .main-div {
    display: flex;
    flex-direction: column;
    width: 100%;
    height: 100vh;
    justify-content: center;
    align-items: center;
  }
</style>
