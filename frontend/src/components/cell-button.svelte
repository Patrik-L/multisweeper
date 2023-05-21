<script lang="ts">
  import type { Cell, CellReference } from "../types";
    export let cellReference: CellReference
    export let onClick = (cellReference: CellReference) => {} 
</script>

<button on:click={() => onClick(cellReference)} class="cell {cellReference.cell ? "": "covered"}">

{#if cellReference.cell}
    <span>{cellReference.cell.bomb ? '💣' : (cellReference.cell.value ? cellReference.cell.value : '')}</span>
{/if}

</button>

<style lang="scss">
    .cell {
        display: flex;
        justify-content: center;
        align-items: center;
        width: 24px;
        height: 24px;
        padding: 16px;
    }

    .covered {
        background-color: brown;
    }
</style>