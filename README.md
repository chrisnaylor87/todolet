# Todolet for Linux

[Todolet](https://todolet.app), terminal style. A week-at-a-glance to-do app:
see the week ahead, add tasks to a day, tick them off. No accounts, no cloud,
no dependencies — one Python file and a JSON file on your own machine.

## Install

On Debian, Ubuntu or Mint, grab the `.deb` from the latest release and:

```sh
sudo apt install ./todolet_1.0.0_all.deb
```

Or run straight from a clone — it needs only Python 3 (already on virtually
every Linux):

```sh
mkdir -p ~/.local/bin && ln -s "$PWD/todolet" ~/.local/bin/todolet
```

## Use

```
todolet                     open the TUI
todolet add "buy milk"      quick-add to today
todolet add "gym" thu       ...or to a day (tomorrow, mon..sun, +2, 2026-07-13)
todolet list [+1|-1|...]    print a week
todolet export [FILE]       write a backup (todolet.app format)
todolet import FILE         merge a backup — nothing gets deleted
todolet ical [+1] [FILE]    export a week as iCal (.ics)
```

### TUI keys

| Key | Action |
|---|---|
| `↑ ↓` / `j k` | move |
| `← →` / `h l` | previous / next week |
| `space` / `enter` | tick a task off (on a day header: add) |
| `a` | add a task to the selected day |
| `e` | edit · `d` delete · `u` undo delete |
| `t` | jump back to today |
| `?` | help · `q` quit |

## Data

Tasks live in `~/.local/share/todolet/todolet.json`, in the exact same shape
as the web app's storage. `export` writes the web app's backup format and
`import` accepts it (merged by task id, duplicates skipped), so backups move
freely between your phone and the terminal in both directions.

## License

[MIT](LICENSE)
