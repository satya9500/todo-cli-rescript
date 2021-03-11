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

let help_string = `Usage :-
$ ./todo add "todo item"  # Add a new todo
$ ./todo ls               # Show remaining todos
$ ./todo del NUMBER       # Delete a todo
$ ./todo done NUMBER      # Complete a todo
$ ./todo help             # Show usage
$ ./todo report           # Statistics`

/*
NOTE: The code below is provided just to show you how to use the
date and file functions defined above. Remove it to begin your implementation.
*/

let pending_todos_file = "todo.txt"
let completed_todos_file = "done.txt"

let formatOutputToArray: string => array<string> = (content) => {
let refined = Js.String.split("\n",content)
  let _ = Js.Array.pop(refined)
  refined
  // Js.Array.reverseInPlace(refined)
}

let readFile: string => array<string> = (fileName) => {
  let content = readFileSync(fileName, {encoding: "utf8", flag: "r"})
  formatOutputToArray(content)
}

let appendFile: (string, string) => unit = (fileName, text) => {
  appendFileSync(fileName, text++"\n", { encoding: "utf8", flag: "a"})
}

let writeFile: (string, string) => unit = (fileName, text) => {
  writeFileSync(fileName, text++"\n", { encoding: "utf8", flag: "w"})
}

let cmdHelp: unit => unit = () => {
  Js.log(help_string)
}

let cmdLs: unit => unit = () => {
  let final = readFile(pending_todos_file)
  let size = Js.Array.length(final)
  if(size == 0) {
    Js.log("There are no pending todos!")
  } 
  else {
    for i in size downto 1 {
      Js.log(`[${Belt.Int.toString(i)}] ${final[i-1]}`)
    }
  }
}

let cmdAddTodo: string => unit = (todo) => {
  if todo==""{
    Js.log("Error: Missing todo string. Nothing added!");
  } else {
    appendFile(pending_todos_file, todo)
    Js.log(`Added todo: "${todo}"`)
  }
}

let returnInt = (x) => {
  switch (x) {
  | Some (y) => y
  | None => -1 // invalid condition
  }
}

let cmdDelTodo: string => unit = (id) => {
  if id == "" {
    Js.log(`Error: Missing NUMBER for deleting todo.`)
  } else {
    let temp = Belt.Int.fromString(id)
    let idInt = returnInt(temp)
    let final = readFile(pending_todos_file)
    let size = Js.Array.length(final)
    if idInt < 1 || idInt > size {
      Js.log(`Error: todo #${id} does not exist. Nothing deleted.`)
    } else {
      let _ = Js.Array.spliceInPlace(~pos=idInt-1, ~remove=1, ~add=[],final)
      let final2 = Js.Array.joinWith("\n",final)
      writeFile(pending_todos_file, final2)
      Js.log(`Deleted todo #${id}`)
  } 
  }
}

let cmdMarkDone: string => unit = (id) => {
  if id == "" {
    Js.log(`Error: Missing NUMBER for marking todo as done.`)
  } 
  else {
    let final = readFile(pending_todos_file)
    let size = Js.Array.length(final)
    let idInt = returnInt(Belt.Int.fromString(id))
    if idInt < 1 || idInt > size {
      Js.log(`Error: todo #${id} does not exist.`)
    } 
    else {
      let completedTodo = final[idInt - 1]
      appendFile(completed_todos_file, completedTodo)
      let _ = Js.Array.spliceInPlace(~pos=idInt-1, ~remove=1, ~add=[],final)
      let final2 = Js.Array.joinWith("\n",final)
      writeFile(pending_todos_file, final2)
      Js.log(`Marked todo #${id} as done.`)
    }
  }
}

let cmdReport: unit => unit = () => {
  let pendingTodos = readFile(pending_todos_file)
  let pendingTodosLength = Js.Array.length(pendingTodos)
  let completedTodos = readFile(completed_todos_file)
  let completedTodosLength = Js.Array.length(completedTodos)
  Js.log(`${getToday()} Pending : ${Belt.Int.toString(pendingTodosLength)} Completed : ${Belt.Int.toString(completedTodosLength)}`)
}

let argv = Sys.argv

if !existsSync(pending_todos_file) {
  writeFileSync(pending_todos_file, "", { encoding: "utf8", flag: "w"})
}
if !existsSync(completed_todos_file) {
  writeFileSync(completed_todos_file, "", { encoding: "utf8", flag: "w"})
}


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