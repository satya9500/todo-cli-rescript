/*
Sample JS implementation of Todo CLI that you can attempt to port:
https://gist.github.com/jasim/99c7b54431c64c0502cfe6f677512a87
*/

/* Returns date with the format: 2021-02-04 */
let getToday: unit => string = %raw(`
function() {
  let date = new Date();
  return new Date(date.getTime() - (date.getTimezoneOffset() * 60000))
    .toISOString()
    .split("T")[0];
}
  `)

type fsConfig = {encoding: string, flag: string}

/* https://nodejs.org/api/fs.html#fs_fs_existssync_path */
@bs.module("fs") external existsSync: string => bool = "existsSync"

/* https://nodejs.org/api/fs.html#fs_fs_readfilesync_path_options */
@bs.module("fs")
external readFileSync: (string, fsConfig) => string = "readFileSync"

/* https://nodejs.org/api/fs.html#fs_fs_writefilesync_file_data_options */
@bs.module("fs")
external appendFileSync: (string, string, fsConfig) => unit = "appendFileSync"

@bs.module("fs")
external writeFileSync: (string, string, fsConfig) => unit = "writeFileSync"

/* https://nodejs.org/api/os.html#os_os_eol */
@bs.module("os") external eol: string = "EOL"

let encoding = "utf8"

/*
NOTE: The code below is provided just to show you how to use the
date and file functions defined above. Remove it to begin your implementation.
*/

let pending_todos_file = "todo.txt"
let completed_todos_file = "done.txt"

let help_string = `Usage :-
$ ./todo add "todo item"  # Add a new todo
$ ./todo ls               # Show remaining todos
$ ./todo del NUMBER       # Delete a todo
$ ./todo done NUMBER      # Complete a todo
$ ./todo help             # Show usage
$ ./todo report           # Statistics`

let cmdHelp: unit => unit = () => {
  Js.log(help_string)
}

let cmdLs: unit => unit = () => {
  Js.log("List todos")
}

let cmdAddTodo: string => unit = (todo) => {
  Js.log(`Add todo: ${todo}`)
}

let cmdDelTodo: string => unit = (id) => {
  Js.log(`Del todo: ${id}`)
}

let cmdMarkDone: string => unit = (id) => {
  Js.log(`Mark Done: ${id}`)
}

let cmdReport: unit => unit = () => {
  Js.log(`Report`)
}

let argv = Sys.argv
let isValid = if Js.Array.length(argv) == 3 || Js.Array.length(argv) == 4 {
  true
} else {
  false
}

let cases = if !isValid {
  cmdHelp()
} else {
  let command = argv[2]
  let arg:ref<string> = ref("")
  if Js.Array.length(argv) == 4 {
    arg.contents = argv[3]
  }
  switch command {
  | "help" => cmdHelp()
  | "ls" => cmdLs()
  | "add" => cmdAddTodo(arg.contents)
  | "del" => cmdDelTodo(arg.contents)
  | "done" => cmdMarkDone(arg.contents)
  | "report" => cmdReport()
  | _ => cmdHelp()
  }
}