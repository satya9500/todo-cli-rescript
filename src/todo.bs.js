// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Fs = require("fs");
var Sys = require("bs-platform/lib/js/sys.js");
var Curry = require("bs-platform/lib/js/curry.js");
var Belt_Int = require("bs-platform/lib/js/belt_Int.js");
var Caml_array = require("bs-platform/lib/js/caml_array.js");

var getToday = (function() {
  let date = new Date();
  return new Date(date.getTime() - (date.getTimezoneOffset() * 60000))
    .toISOString()
    .split("T")[0];
});

var help_string = "Usage :-\n$ ./todo add \"todo item\"  # Add a new todo\n$ ./todo ls               # Show remaining todos\n$ ./todo del NUMBER       # Delete a todo\n$ ./todo done NUMBER      # Complete a todo\n$ ./todo help             # Show usage\n$ ./todo report           # Statistics";

var pending_todos_file = "todo.txt";

var completed_todos_file = "done.txt";

function formatOutputToArray(content) {
  var refined = content.split("\n");
  refined.pop();
  return refined;
}

function readFile(fileName) {
  return formatOutputToArray(Fs.readFileSync(fileName, {
                  encoding: "utf8",
                  flag: "r"
                }));
}

function appendFile(fileName, text) {
  Fs.appendFileSync(fileName, text + "\n", {
        encoding: "utf8",
        flag: "a"
      });
  
}

function writeFile(fileName, text) {
  Fs.writeFileSync(fileName, text + "\n", {
        encoding: "utf8",
        flag: "w"
      });
  
}

function cmdHelp(param) {
  console.log(help_string);
  
}

function cmdLs(param) {
  var $$final = readFile(pending_todos_file);
  var size = $$final.length;
  if (size === 0) {
    console.log("There are no pending todos!");
    return ;
  }
  for(var i = size; i >= 1; --i){
    console.log("[" + String(i) + "] " + Caml_array.get($$final, i - 1 | 0));
  }
  
}

function cmdAddTodo(todo) {
  if (todo === "") {
    console.log("Error: Missing todo string. Nothing added!");
  } else {
    appendFile(pending_todos_file, todo);
    console.log("Added todo: \"" + todo + "\"");
  }
  
}

function returnInt(x) {
  if (x !== undefined) {
    return x;
  } else {
    return -1;
  }
}

function cmdDelTodo(id) {
  if (id === "") {
    console.log("Error: Missing NUMBER for deleting todo.");
    return ;
  }
  var temp = Belt_Int.fromString(id);
  var idInt = temp !== undefined ? temp : -1;
  var $$final = readFile(pending_todos_file);
  var size = $$final.length;
  if (idInt < 1 || idInt > size) {
    console.log("Error: todo #" + id + " does not exist. Nothing deleted.");
    return ;
  }
  $$final.splice(idInt - 1 | 0, 1);
  var final2 = $$final.join("\n");
  writeFile(pending_todos_file, final2);
  console.log("Deleted todo #" + id);
  
}

function cmdMarkDone(id) {
  if (id === "") {
    console.log("Error: Missing NUMBER for marking todo as done.");
    return ;
  }
  var $$final = readFile(pending_todos_file);
  var size = $$final.length;
  var x = Belt_Int.fromString(id);
  var idInt = x !== undefined ? x : -1;
  if (idInt < 1 || idInt > size) {
    console.log("Error: todo #" + id + " does not exist.");
    return ;
  }
  var completedTodo = Caml_array.get($$final, idInt - 1 | 0);
  appendFile(completed_todos_file, completedTodo);
  $$final.splice(idInt - 1 | 0, 1);
  var final2 = $$final.join("\n");
  writeFile(pending_todos_file, final2);
  console.log("Marked todo #" + id + " as done.");
  
}

function cmdReport(param) {
  var pendingTodos = readFile(pending_todos_file);
  var pendingTodosLength = pendingTodos.length;
  var completedTodos = readFile(completed_todos_file);
  var completedTodosLength = completedTodos.length;
  console.log(Curry._1(getToday, undefined) + " Pending : " + String(pendingTodosLength) + " Completed : " + String(completedTodosLength));
  
}

if (!Fs.existsSync(pending_todos_file)) {
  Fs.writeFileSync(pending_todos_file, "", {
        encoding: "utf8",
        flag: "w"
      });
}

if (!Fs.existsSync(completed_todos_file)) {
  Fs.writeFileSync(completed_todos_file, "", {
        encoding: "utf8",
        flag: "w"
      });
}

var isValid = Sys.argv.length === 3 || Sys.argv.length === 4;

var cases;

if (isValid) {
  var command = Caml_array.get(Sys.argv, 2);
  var arg = "";
  if (Sys.argv.length === 4) {
    arg = Caml_array.get(Sys.argv, 3);
  }
  switch (command) {
    case "add" :
        cases = cmdAddTodo(arg);
        break;
    case "del" :
        cases = cmdDelTodo(arg);
        break;
    case "done" :
        cases = cmdMarkDone(arg);
        break;
    case "help" :
        console.log(help_string);
        cases = undefined;
        break;
    case "ls" :
        cases = cmdLs(undefined);
        break;
    case "report" :
        cases = cmdReport(undefined);
        break;
    default:
      console.log(help_string);
      cases = undefined;
  }
} else {
  console.log(help_string);
  cases = undefined;
}

var encoding = "utf8";

var argv = Sys.argv;

exports.getToday = getToday;
exports.encoding = encoding;
exports.help_string = help_string;
exports.pending_todos_file = pending_todos_file;
exports.completed_todos_file = completed_todos_file;
exports.formatOutputToArray = formatOutputToArray;
exports.readFile = readFile;
exports.appendFile = appendFile;
exports.writeFile = writeFile;
exports.cmdHelp = cmdHelp;
exports.cmdLs = cmdLs;
exports.cmdAddTodo = cmdAddTodo;
exports.returnInt = returnInt;
exports.cmdDelTodo = cmdDelTodo;
exports.cmdMarkDone = cmdMarkDone;
exports.cmdReport = cmdReport;
exports.argv = argv;
exports.isValid = isValid;
exports.cases = cases;
/*  Not a pure module */
