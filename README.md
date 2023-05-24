# Multisweeper

## Description

This is a simple minesweeper project built for the purpose of learning elixir. The project is built using two different technologies,

1. Elixir backend, doing board and game management
2. Static sveltekit frontend, only dong simple rendering of data recieved from the back end

As the goal was to learn elixir, the application focuses on moving as much work as possible to the elixir backend.
This has resulted in some odd architectural decitions, such as the server sending the board state incrementally to
the client.

## Installation

### Back end

For the back end, ensure you have Elixir installed, after this, run the following command in the root directory of the project. This will install all neccessary dependencies for the back end:

```
mix deps.get
```

After this, you can start the back end with the following command:

```
mix run --no-halt
```

### Front end

For the front end, you will need to first move into the frontend directory:

```
cd frontend
```

After this, ensure you have npm installed and install all dependencies with:

```
npm i
```

Now you're ready to start the frontend:

```
npm run dev
```

## To play

To play, navigate to the frontend with your browser (usually at [http://127.0.0.1:5173/](http://127.0.0.1:5173/))

You will notice that you are taken to /room/myFirstRoom, feel free to start playing. All progress is stored on the server. If you want to start a new game, simply change the room name in the address bar

You can also use right click to place flags, they won't however be stored on the server

If you want to edit the board size or bomb amount, you can edit the variables near the bottom of the
room.ex file, found in `lib/multisweeper/routes/room.ex`
