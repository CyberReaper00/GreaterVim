# Preface
I've tried astrovim before, when i was first starting out with nvim, but when i turned it on there were so many plugins that just didnt work and always gave me errors no matter what i did and then on top of that the bindings were completely different from a normal base system that it just became static in my head and i always wondered what i'm supposed to do to get faster

There was which-key installed and that was supposed to help but what i really wanted was VimTutor but with the astro-bindings so that i can practice the bindings instead of learning them as i went along and since that didnt exist along with all the plugin bugs that i just didnt know how to solve, i just had enough and a week in i went to a stock nvim to get some actual bearings on how everything works

In doing so i have just ended up making my own distro and now i understand why all the distros exist, it is just what ends up happening when you create a PDE (Personal Development Environment)

This config is for me and my experienced hands, if you have not used never used nvim before, do not try this config for you will never understand how everything functions and if you understand nothing you will only get lost

If you still want to give it a try, i will try to write some descriptive comments in the file itself to help along if you ever wish to understand something or want to change it

But i will make this clear, i have not made this for other people, i have made this for me and my mind to make me faster - besides that i will give a brief overview of all the settings
# Overview
<img src='./nvim-screenshot.png' alt='Greatervim Splash Screen on Nvim'>
## Lazy.nvim Initializer
- I just have the boilerplate lazy package manager function that installs lazy and sets up the path for nvim from which it would manage plugins
- I have it commented out because it is unnecessary after install, but i might need it later you never know - as far as i know you can just remove it if you want
- After defining the function, the path itself is defined
## Leader Keys
- `leader` is set to be `space`, i use it all the time
- `localleader` is set to be `/`, i never use it but i have it, maybe i'll map it to something later
## Accessibility Settings
These are just some settings to make the environment a bit more condusive to live in
- `timeoutlen = 200` - some of my bindings were getting in the way, so i reduced the time of loading, it isnt perfect but it helps
- `ignorecase = true` - i hate case-sensitivity
- `different ignorecase` - just to make sure i dont get case sensitivity anywhere
- `smartcase` - if i do any searches in all small its case-insensitive, if i put any capitals in there then it becomes case-sensitive
- `spellchecking = false` - i hate the red squiggly line
- `splitright = true` - if i open a split, it will always open to the right
- `number and relativenumber` - if you dont do this, your wrong
- `tab length = 4` - this isnt the actual setting
	- `shiftwidth` - this sets the tab length on button click
	- `tabstop` - this sets the automatic tab distance when you move to the next line in a code block
- `clipboard` - set to the system clipboard
- `keywordprg` - this allows you to take the word under the cursor and then go directly to its help page
	- default behavior is to open a man page for the word
	- i set it to go to a vim help page for the word instead of looking for a man page
## Packages
These are the packages that i've installed
- Nord theme (customised)
- Telescope
- Lualine
- Vim Fugitive
## Splash Screen
I'll just tell the steps the function goes through to show the screen on startup
### Prerequisites
- Sets two variables, `scale` and `alignment`
	- These are used for the positioning of the text on screen
- Initiates a function called `command`
	- This is used to force-type commands into the command line so that i dont have to deal with failures
- Initiates a `timer` variable for adding delay when needed
- Initiates a function called `open_setup`
	- When the splash screen is removed, this allows me to open a preset layout that i have defined in the config like, two tabs and the first tab has two vertical panes and the second tab checks if a specific server is open - if not then it just opens the server in the nvim shell
	- The splash screen is removed by pressing a hotkey
		- I have designed this in a way where you can define any layout to open with any hotkey
	- My current layout is as follows
		- **First Tab**
			- Shell
		- **Second Tab**
			- New file
### Startup settings
- All of the following is inside of custom command i made to show the splash screen
	- Creates a new file
	- Sets the buftype to hidden with `nocursor`, `nonumber`, `nospell` and a bunch of other settings to make the screen as clear as possible
	- Checks the current GUI
		- If its neovide, then the scale and alignment variables will be set to their neovide values to scale the text properly
		- If its a normal terminal interface or a different GUI then the variables will stay on their original values
	- Draws the banner text and places it inside of a variable
	- A bunch of calculations that happen to figure out how to align the text to the center of the screen
	- Calls the `BufUnload` command
		- Zooms out to make the text smaller
	- Move the cursor to the top
	- Sets the hotkeys to open the different presets
	
- Calls the `VimEnter` command
	- Zooms in to make the text bigger
	- Calls the splash screen command
	- Hides the status bar using `laststatus=0`
### Removing splash screen
- When pressing `i`, the `open_setup` function opens the layout with the shell in focus
	- Then it drops me in insert mode
	- From there i do what i need
- When pressing `esc`, the `open_setup` function opens the layout with the new file in focus
	- Opens telescope with the `oldfiles` option
	- Then it presses escape as well, so that when i press `j or k` it doesnt start typing but instead moves up or down in the list
	- From there i just pick the file i need and start working
- It sets the command `laststatus=3`
	- This makes the status line visible
## Plugin Settings
### Lualine
- Creates a function to get the filesize of the current file in the buffer
- Calculations happen to place the size in a human-readable format
- Returns the final value as string
- A bunch of settings to set a new custom theme for the line
- A function to apply all the new colors to the line since it wasnt doing it by default
- Change the order and placement of the items shown on the line
### Telescope
- Set `X` to delete a file buffer directly from the list of files on screen
- Set `<leader>f` to show the `find_files` menu
	- Enabled searching through hidden files
	- Set the search mechanism to be `rg --files --hidden`
- Set `<leader>g` to show the `live_grep` menu
## Keybindings
I have created a few functions to make the process of making different types of bindings easier and more bearable

**Split Function**
- I needed a function for another function that takes in a string and then seperates them into individual items based on some seperator like
	- "a b c" is the string and the seperator has been defined as space
	- The function will seperate all the letters and place all of them into a table as individual items, which will in turn give me an array to work with
- Since lua didnt have a function like this, i created my own

**Set Function**
- I didnt like the syntax of the original `vim.keymap.set()` function, so i made my own and i needed the split function for this to work
- It takes in three params, `the new key`, `execution command`, `modes to execute in`
- I use the split command to get either a single mode or multiple modes in one place and in a nice syntax
- What i did here is already possible in nvim, i just wanted it in a different syntax and thats why i made the function
- What i do is this
	- `set("<c-s-a>", "<esc>ggVG", "v i n")`
- What nvim allows is this
	- `vim.keymap.set({"v", "i", "n"}, "<c-s-a>", "<esc>ggVG")`

**Wait Function**
- This was made so that i can combine the `f` and `/` functions into one auto-executing find function that not only finds what you type but then stops finding and then executes a search automatically
- I have set the timer for this function, and of course you can update that as well, to be 500ms - this is more than enough time to type out part of the word that you need to get to at the end of the line
- But since this combines the functionality of `f` AND `/` you can now jump to a specific word at the end of the paragraph and this works for both forward and backward search
- Now of course the original `/` and `?` are still operational but i overwrote the `f` and `F` keys to take on the functionality of the `wait function`

**Retain Function**
- This takes in one input, which is a command that is to be executed, and then applies the following
    - It gets the current cursor position
    - It executes the command and then moves the cursor back to the same spot it was in, prior to command execution

### Leader Maps

| \<leader> + key | Command                       | Description                                                                                                                                                   |
| --------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `s`             | `:w<cr>`                      | saves the current file                                                                                                                                        |
| `q`             | `:q<cr>`                      | quits the current tab                                                                                                                                         |
| `r`             | `:so<cr>`                     | refreshes the current file                                                                                                                                    |
| `L`             | `:Lazy<cr>`                   | opens the lazy.git menu                                                                                                                                       |
| `e`             | `"+yiw`                       | copies the word under cursor to the clipboard                                                                                                                 |
| `p`             | `viw"+p`                      | replaces the word under cursor with latest text from the clipboard                                                                                            |
| `v`             | `<C-v>`                       | starts visual block mode                                                                                                                                      |
| `j`             | `<C-^>`                       | switches to previous buffer                                                                                                                                   |
| `t`             | `:term<cr>`                   | opens the shell in the current tab                                                                                                                            |
| `n`             | `:tabnew<cr>`                 | creates a new tab to the right                                                                                                                                |
| `k`             | `J`                           | pulls the current line up to the end of the previous line                                                                                                     |
| `=`             | `$V%=`                        | selects a function and then auto-indents it                                                                                                                   |
| `<esc>`         | `<C-\\><C-n>`                 | gets out of terminal mode                                                                                                                                     |
| `f`             | `:Telescope find_files`       | opens the find_files panel in telescope                                                                                                                       |
| `b`             | `:Telescope buffers<cr><esc>` | opens the buffers panel in telescope                                                                                                                          |
| `o`             | `:Telescope oldfiles<cr>`     | opens the oldfiles panel in telescope                                                                                                                         |
| `<leader>`      | `yiw:%s/<c-r>+/rr/g`          | copies the word under the cursor, starts a substitution, pastes the word from the buffer and then sets up a global replace of all instances for the selection |

### Movement Maps

| Key      | Command   | Desciption                                                         |
| -------- | --------- | ------------------------------------------------------------------ |
| `k`      | `kzz`     | moves up and centers the screen                                    |
| `j`      | `jzz`     | moves down and centers the screen                                  |
| `K`      | `<C-u>zz` | page up and center screen                                          |
| `J`      | `<C-d>zz` | page down and center screen                                        |
| `a`      | `i`       | enter insert mode on the left                                      |
| `A`      | `I`       | move to the beginning of the line in insert mode                   |
| `i`      | `a`       | enter insert mode on the right                                     |
| `I`      | `A`       | move to the end of the line in insert mode                         |
| `H`      | `^`       | move to the beginning of the line in normal mode                   |
| `L`      | `$`       | move to the end of the line in normal mode                         |
| `L`      | `$h`      | move to the end of the line in visual mode and move back one space |
| `n`      | `nzz`     | jump to the next search result and center the screen               |
| `N`      | `Nzz`     | jump to the previous search result and center the screen           |
| `M`      | ``` ` ``` | jump to the defined mark on the page                               |
| `G`      | `Gzz`     | go to the bottom of the page and center screen                     |
| `ctrl k` | `K`       | open help section for the word under the cursor                    |
### Editing Maps

| Key            | Command        | Description                                                                                                                            |
| -------------- | -------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| `ctrl shift a` | `ggVG`         | selects the entire file                                                                                                                |
| `space a`      | `ggVG"+y`      | selects the entire file and copies it                                                                                                  |
| `y`            | `"+y`          | copies things to the system clipboard                                                                                                  |
| `d`            | `"+d`          | deletes things to the system clipboard                                                                                                 |
| `s`            | `"+s`          | deletes things to the system clipboard                                                                                                 |
| `U`            | `<C-r>`        | undo                                                                                                                                   |
| `dH`           | `d^`           | delete to the beginning of the line                                                                                                    |
| `alt B`        | `<C-w>`        | delete one word back while typing                                                                                                      |
| `alt b`        | `<BS>`         | delete one letter back while typing                                                                                                    |
| `p`            | `"+p`          | paste things from system clipboard                                                                                                     |
| `alt '`        | ``` ` ```      | type \`, because i dont want to reach all the way to the edge                                                                          |
| `tab`          | `>>`           | Moves the line forward by one tab in normal mode                                                                                       |
| `shift tab`    | `<<`           | Moves the line backward by one tab in normal mode                                                                                      |
| `tab`          | `>`            | Moves the line forward by one tab in visual mode                                                                                       |
| `shift tab`    | `<`            | Moves the line backward by one tab in visual mode                                                                                      |
| `alt n`        | `enter`        | Presses enter in normal, visual and insert mode                                                                                        |
| `alt j`        | `retain(ddp)`  | Deletes the current line and moves it up, creates the illusion of dragging a line up the page, while retaining the cursor position     |
| `alt k`        | `retain(ddkP)` | Deletes the current line and moves it down, creates the illusion of dragging a line down the page, while retaining the cursor position |
| `ctrl alt j`   | `retain(yyp)`  | Copies current line and then pastes it below, while retaining cursor position                                                          |
| `ctrl alt k`   | `retain(yyP)`  | Copies current line and then pastes it above, while retaining cursor position                                                          |

### Power Maps

| Key      | Command                  | Description                                                                                                                                                      |
| -------- | ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `;;`     | `^v$h"+y`                | copies all the text on the current line into the clipboard but no trailing whitespace                                                                            |
| `;h`     | `v^"+y`                  | copies all text from the current cursor position to the beginning of the line into the clipboard                                                                 |
| `;l`     | `v$h"+y`                 | copies all text from the current cursor position to the end of the line into the clipboard                                                                       |
| `d;`     | `$V%d`                   | deletes a block of code from the starting bracket to the ending bracket                                                                                          |
| `v;`     | `$V%y`                   | copies a block of code from the starting bracket to the ending bracket                                                                                           |
| `c;`     | `nvim_feedkeys("$v%gc")` | comments out a block of code from the starting bracket to the ending bracket, tried to make this work normally but it didnt behave properly so i had to force it |
| `alt l`  | `ctrl \, ctrl n, gt`     | escapes out into normal mode and then switches to the next tab, very nice                                                                                        |
| `ctrl ;` | `escape`                 | escapes into normal mode from insert mode                                                                                                                        |
| `ctrl ;` | `ctrl \, ctrl n`         | escapes into normal mode from terminal mode                                                                                                                      |

### Auto-containers

| Key       | Command           | Description                                                                                                                              |
| --------- | ----------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `"`       | `""<Esc>ha`       | places two double quotes then moves the cursor to the middle                                                                             |
| `'`       | `''<Esc>ha`       | places two single quotes then moves the cursor to the middle                                                                             |
| `oij`     | `{}<Esc>ha`       | places two braces then moves the cursor to the middle, i tried just using `{` but that didnt work for some reason so i made something up |
| `(`       | `()<Esc>ha`       | places two parens then moves the cursor to the middle                                                                                    |
| `[`       | `[]<Esc>ha`       | places two brackets then moves the cursor to the middle                                                                                  |
| ``` ` ``` | `/*  */<Esc>hhha` | places a c-style multi-line comment then moves the cursor to the middle                                                                  |
### Searching Maps

| Key           | Command | Description                                                      |
| ------------- | ------- | ---------------------------------------------------------------- |
| `alt ;`       | `%`     | moves from the closest bracket to the closest connecting bracket |
| `alt w`       | `*zz`   | search for the word under the cursor forwards                    |
| `alt shift w` | `#zz`   | search for the word under the cursor backwards                   |
<img>

| Key           | Description                                                                         |
| ------------- | ----------------------------------------------------------------------------------- |
| `wait_map(f)` | when activated, it takes input and then after 500ms searches forward for the input  |
| `wait_map(F)` | when activated, it takes input and then after 500ms searches backward for the input |
### HTML Autotags
- I write htmx and i work on alot of websites and because of that some html typing is required, so i created some bindings that reduce my html boilerplate
- I dont want to figure out how to make the tag creation automatic through a plugin or a setting or something so im just making all of the templating myself and its good enough that i dont need to care
- I do the bulk of the programming in go and js anyway, so it doesnt really matter
