<script lang="ts">
  import { goto } from "$app/navigation";
  import { onMount } from "svelte";

  onMount(() => {
    //Quick and dirty re-route
    goto("/room/myFirstRoom");
  });
</script>
