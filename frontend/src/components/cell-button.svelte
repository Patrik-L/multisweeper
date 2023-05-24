<script lang="ts">
  import type { Cell, CellReference } from "../types";
  import bomb from "$lib/assets/bomb.png";
  import flag from "$lib/assets/flag.png";
  import { prevent_default } from "svelte/internal";
  export let cellReference: CellReference;
  export let onClick = (cellReference: CellReference) => {};
  export let gameover: boolean;

  const mouseDown = (e: any) => {
    // Check if we right click
    if (e.buttons === 2) {
      // Toggle flag
      cellReference.flag = !cellReference.flag;
    }
  };
</script>

<button
  on:mousedown={mouseDown}
  on:click={() => onClick(cellReference)}
  disabled={gameover}
  class="cell {cellReference.cell ? '' : 'covered'}"
>
  {#if cellReference.cell}
    {#if !cellReference.cell.bomb}
      <span
        class={cellReference.cell.value
          ? "value-" + cellReference.cell.value.toString()
          : ""}>{cellReference.cell.value ? cellReference.cell.value : ""}</span
      >
    {:else}
      <img class="icon" src={bomb} />
    {/if}
  {:else if cellReference.flag}
    <img class="icon" src={flag} />
  {/if}
</button>

<style lang="scss">
  .cell {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 32px;
    height: 32px;
    background-color: #bdbdbd;
    border: #656565 1px solid;
  }

  .icon {
    width: 24px;
    height: 24px;
  }

  .covered {
    border: 4px #ebebeb outset;
  }

  .value-1 {
    color: #0007fe;
  }

  .value-2 {
    color: #007e01;
  }

  .value-3 {
    color: #fe0000;
  }

  .value-4 {
    color: #00027f;
  }

  .value-5 {
    color: #800103;
  }

  .value-6 {
    color: #800103;
  }

  .value-7 {
    color: #000000;
  }

  .value-8 {
    color: #7f7f7f;
  }
</style>
