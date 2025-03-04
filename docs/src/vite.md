# Vite

Since building a website with an actual bundler is way more convenient, PlutoBoard.jl works with Vite! Check Vite's [guide](https://vite.dev/guide/) to learn more about what Vite supports.

Here is a quick overview of official Vite templates.

| JavaScript                          | TypeScript                                |
| ----------------------------------- | ----------------------------------------- |
| [vanilla](https://vite.new/vanilla) | [vanilla-ts](https://vite.new/vanilla-ts) |
| [vue](https://vite.new/vue)         | [vue-ts](https://vite.new/vue-ts)         |
| [react](https://vite.new/react)     | [react-ts](https://vite.new/react-ts)     |
| [preact](https://vite.new/preact)   | [preact-ts](https://vite.new/preact-ts)   |
| [lit](https://vite.new/lit)         | [lit-ts](https://vite.new/lit-ts)         |
| [svelte](https://vite.new/svelte)   | [svelte-ts](https://vite.new/svelte-ts)   |
| [solid](https://vite.new/solid)     | [solid-ts](https://vite.new/solid-ts)     |
| [qwik](https://vite.new/qwik)       | [qwik-ts](https://vite.new/qwik-ts)       |

## Setting up Vite

First, you need to create a vite app in your packages folder (or anywhere else):

```bash
npm create vite@latest vite-ts -- --template vanilla-ts
```

We will use the vanilla typescript template, but you can use whatever you like.

Since the fileserver PlutoBoard serves its files from runs on a different port than Pluto, we need to take this into account when building our app.
We can define this in `vite.config.js` (in our vite project folder, `vite-ts/` in this example):

```JavaScript
import { defineConfig } from "vite"

export default defineConfig({
    base: 'http://localhost:8085/',
});
```

If we build the project now, we still need to copy files in `vite-ts/dist` to `static` for PlutoBoard to load and serve them. We can do this by defining postbuild in `vite-ts/package.json`:

```json
"scripts": {
    ...,
    "postbuild": "cp -rf dist/* ../static/",
},
```

This can be replaced by other paths depending where your vite project is.

To build the project, we just need to run `npm run build`, which will build everything, set correct urls and move files into `static/`. For testing use `npm run dev`, but be aware that PlutoBoard interface functions won't be available. Still great for designing though!

## Running PlutoBoard

PlutoBoard handles everything, so just run it as usual! And don't restart it when you run `npm run build`, just refresh the website and it will update!

Although it could be useful to run it with `hide_notebook=true` for the first time. If not, you need to change the style of `<div id="app">` to use the whole screen.
