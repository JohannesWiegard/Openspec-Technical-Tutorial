# 17. The Commands No Workflow Calls

Chapters 9 to 16 took the workflows apart, and with them the commands that their skills tell the agent to run. The program has more commands than that. Some of them a developer runs by hand, some a script runs, and some nobody needs until something goes wrong. This chapter takes the ones that no workflow skill runs and no earlier chapter explains. It asks of each group the questions that chapter 9 asks of a workflow: who acts, what is read and written, what can stop it, how a reviewer judges what it did, and what happens when its result is wrong. A command has no stages, so each group gets a table that fits it, in the form chapter 15 used for the workflows outside the table.

## 17.1 The commands outside the workflow skills

`openspec --help` lists 24 commands. The twelve workflow skills tell the agent to run twelve of them: `init`, `update`, `context`, `schemas`, `new change`, `status`, `instructions`, `list`, `show`, `validate`, `archive`, and `store list` as the one form of `store`. The workflow chapters described those. Two more are run by no workflow skill and explained in chapter 13: `config`, which holds the profile, and `schema`, with which chapter 14 forked one. The others have no chapter yet, and the table sorts them into four groups.

| Command | What it does | Group |
|---|---|---|
| `view` | Prints one dashboard of the specifications and the changes in flight. | Reading the record |
| `show --diff` | Shows a change with a diff of each modified requirement. | Reading the record |
| `spec`, `change` | Older forms of `show`, `list` and `validate`, by noun. | Reading the record |
| `templates` | Says where each artifact's template comes from. | Checking the harness |
| `doctor` | Reports the health of the root, its store and its references. | Checking the harness |
| `store` | Creates, registers and removes stores. | Working across repositories |
| `workset` | Saves named sets of folders on the machine. | Working across repositories |
| `version`, `install` | Report the program's release, and install the standalone program. | The program itself |
| `completion`, `feedback` | Add shell completion, and send feedback to the OpenSpec project. | The program itself |

The router names four of these commands, and `config profile`, in a line each. Its file of answers offers `view`, `templates` and `config profile` as answers to a developer's questions, tells the agent to run `doctor` when something seems wrong, and lets it send `feedback` only once the user has approved the message. It never says what any of their results mean, so the groups of the table still hold.

`show` is named in chapters 10 and 16 for other forms. `--diff` is the one form no chapter has used, and it belongs with the commands that read.

## 17.2 Reading the record

The first group reads. The developer runs each command, the program prints, and no file changes.

| Command | Reads | Writes | Can stop it |
|---|---|---|---|
| `view` | The main specifications and the changes in flight. | Nothing. | No root. |
| `show <change> --diff` | The change's proposal and deltas, and the main specification each delta names. | Nothing. | A name that is no change. |
| `spec show`, `spec list`, `spec validate` | The main specifications. | Nothing. | Nothing for `list`: with no root it prints "No items found" and succeeds. |
| `change show`, `change list`, `change validate` | The changes in flight. | Nothing. | The same as `spec`. |

`view` prints a dashboard: a summary of the specifications and their requirements, the changes in progress and completed, and the task progress; below it each change with a progress bar and the state of its artifacts, and each specification with its count of requirements. Without a terminal it prints once and ends. It is the shortest way to see the state of a project, and it says nothing that `list` and `status` do not.

`show <change> --diff` prints the proposal and then, under "Specifications Changed (diffs)", a unified diff of each modified requirement against the main specification. Chapter 6 said that a reader of a modified block has to set it beside the main specification to see what moved. This form does that, for the text as it stands when the command runs. It does not say that the change is right.

`spec` and `change` are the older form of the same reading, with the noun first. Each of them prints a warning that the commands are deprecated and names the verb-first command to use instead, `openspec show`, `openspec list` or `openspec validate`. The verdicts of `spec validate` and `change validate` are those of `validate`. A script that still calls them works and warns. A new one has no reason to use them.

For the developer, these commands are a way to read without opening files. The review is the reading itself, and nothing in the output is a check that the earlier chapters did not describe. A dashboard full of ticks says that files exist, as `status` does in chapter 10.

## 17.3 Checking the harness

The second group checks where things come from. It reads the harness and writes nothing.

| Command | Reads | Reports | What fails it |
|---|---|---|---|
| `templates` | The schema in use and its template files. | Each artifact's template path and its source: the package, the project or the user's directory. | A schema that cannot be resolved. |
| `doctor` | The root, a declared `store`, and each entry of `references` in `openspec/config.yaml`. | Whether each is found and healthy, with a fix for each problem. | Not a missing reference: that is a warning. |
| `store doctor <id>` | One registered store. | Its location, its OpenSpec root, its metadata and its Git state. | A store that is not registered. |

`templates` answers the question that chapter 13 asked of a schema with `openspec schema which`, for the files below it. In a project that has not forked its schema, every template comes from the package. In a project with a fork, the same command names the project as the source.

`doctor` looks at relations, not at content. With nothing declared it reports the root and says that no references are declared. A reference whose store is not registered on the machine is reported as such, with the command that would register it, and the command still exits with status 0. A warning is printed and not counted. A script that runs `doctor` and checks only its exit status learns that the command ran; it has to read the `--json` output to learn what it found.

For the developer, the two commands are the answer when an agent was told something other than expected. A rule that does not appear, a template that does not match, or a reference that adds nothing to the instructions has its cause in one of the places these commands name.

## 17.4 Working across repositories

The third group writes, and it writes on the machine. Chapter 3 said that the program keeps stores and the user's own state outside the repository. These are the commands that make it. OpenSpec's guide calls stores and worksets a beta and says that their commands, flags and file formats may change between releases.

A store is a standalone OpenSpec repository registered on the machine under an id. It takes the `openspec/` folder out of a code repository and gives it a repository of its own, so that several code repositories can share one set of specifications. Any command that reads or writes specifications and changes takes `--store <id>` and then works on the store instead of the nearest `openspec/` folder, and its output begins with "Using OpenSpec root:" and the store's id.

| Command | Writes | Can stop it |
|---|---|---|
| `store setup <id> --path <folder>` | The folder, with `openspec/`, an `.openspec-store/store.yaml` file, a Git repository and a first commit; and the store's entry in the machine's registry. | No Git identity, unless told to skip Git. |
| `store register <path>` | The entry in the registry, for a store that already exists. | A folder without an `openspec/` root. |
| `store unregister <id>` | Removes the entry. The files stay. | An id that is not registered. |
| `store remove <id> --yes` | Removes the entry and deletes the folder. | No `--yes` with no one to ask. |
| `workset create <name> --member <folder>` | A named list of folders, in the user's data directory. | No member. |
| `workset remove <name> --yes` | Removes the list. The member folders are not touched. | No `--yes` with no one to ask. |

`store setup` writes in two places: the store's folder, and its entry in the machine's registry, which lives in the user's data directory beside the list of projects the program knows. `store unregister` removes only the entry and leaves the files where they are. `store remove` deletes the folder as well, and with no one to ask it does so only when `--yes` is given.

A project points at a store in two ways. A `store` key in its configuration makes the store the root when the project's own `openspec/` holds no specifications or changes; when it holds them, the key is ignored with a warning. A `references` list leaves the root alone and adds an index of each store's specifications to every instruction, in a block marked "Read-only upstream context", with each specification's Purpose and the command to fetch it in full. The agent is told the store exists. It is not told to obey it, and nothing checks whether it read it.

Where a command works is settled in a fixed order, and the first rule that applies wins: `--store` on the command; the project's own `openspec/`, when it holds specifications or changes; the `store` key; and a `defaultStore` in the global configuration, which `config` sets. When none applies, the command fails and lists the registered stores. It does not pick a store by its name, even one that matches the repository's.

In a store the workflows run as they always do, and only the place changes. A change started from a code repository that uses a store is written into the store's folder, with all its artifacts and, at the end, its archive. The code it describes stays in the code repository. The two are committed and pushed separately, and no check compares them.

The skills follow the same rule. Each workflow skill of chapters 9 to 12 carries a paragraph on store selection. When the developer names a store, or the work lives in one, the agent runs `store list --json` for the registered ids and adds `--store <id>` to every command that reads or writes specifications and changes, for the rest of the workflow. When the project declares a store that this machine cannot resolve, the agent stops before writing and shows the error and its fix, instead of treating the project as one without OpenSpec. That is why `store list` is the one form of `store` a skill runs.

A workset is a name for several folders, kept on the machine. `workset open` writes a workspace file and opens the folders in one editor window; the guide says that the openers for two editors are built in and that those for terminal agents are disabled for now. `workset remove` removes the list and leaves the member folders untouched. A workset does not change which `openspec/` folder a command uses.

For the developer, the review of this group is of the machine. The registry and the worksets are files outside every repository. OpenSpec never clones, pulls or pushes a store: a teammate clones it with Git and registers it on each machine, and a checkout that was not pulled shows old specifications until it is pulled. A teammate who clones only the project does not have the store, which is why `doctor` reports a reference as unregistered on a new machine. Only two commands touch a folder: `store setup` creates one, and `store remove --yes` deletes one.

## 17.5 The program itself

The fourth group is about the program and reaches furthest: most of its forms change the machine or send something off it.

| Command | Reaches |
|---|---|
| `version` | Nothing outside the program. |
| `version --check` | The package registry, for a newer release. |
| `install [version]` | The project's GitHub releases, for the standalone program. |
| `completion generate <shell>` | Nothing; it prints a script. |
| `completion install <shell>` | The shell's own setup files. |
| `feedback <message>` | GitHub, as a public issue on the OpenSpec project. |

`version` prints the release, the package manager and the scope of the install, and its `--json` form adds the folder of the install. That is the line chapter 3 points at when it says the release is named in the README. `version --check` asks the registry whether a newer release exists, and so does `update` when it offers an upgrade.

`install` fetches the standalone program, which runs without Node.js, from the project's GitHub release, together with its checksums, and puts it in `~/.local/bin` unless told otherwise. It then says which copy comes first on the path, and prints the command that removes the package-manager copy. Until one of the two is removed, the machine has two programs, and `version` says which one ran.

`completion generate <shell>` prints a completion script for the shell. `completion install` writes such a script into the shell's setup, and `completion uninstall` takes it out.

`feedback` sends a message to the OpenSpec project. It files an issue on the project's GitHub repository through the `gh` program when that is installed and signed in, with the release, the platform and the time added below the message. Without `gh` it prints a prefilled address for the issue form instead. An issue on a public repository is public.

For the developer, this group is the one whose effect is outside the project. Before a run, the question is where it reaches: the shell, the install, or a public tracker.

## 17.6 Judging the result, and correcting it

The program checks none of these commands' effects. It reads, it reports and it writes what it is told, and the earlier chapters' checks of form are the only checks there are. What a wrong run costs depends on what it wrote:

- A reading or checking command changes no file, so a wrong run costs a second run with the right name or form.
- A warning from `doctor` is read and not counted, so a gate that relies on its exit status passes a missing reference.
- `store unregister` and `workset remove` are undone by registering the store or creating the workset again, because their files were left in place.
- `store remove --yes` deletes the folder. Only a copy elsewhere, such as a pushed remote, brings it back.
- A store checkout that was not pulled shows old specifications, and the agent works against them. OpenSpec never pulls a store, so only pulling it with Git brings it up to date.
- `install` leaves two copies of the program until one is removed, and the path decides which runs.
- A `feedback` issue is public once it is filed, and correcting it is a matter for the tracker, not for the program.

Before a command of the third or fourth group, the developer can say in one sentence what it will write and where, and run `git status` and the matching `list` afterwards: `store list`, `workset list` or `version`.

The commands that no workflow calls read the record, check the harness, connect repositories and maintain the program, and none of them judges a change. Reading and checking leave the project as it was, and say nothing that `validate`, `list` and `status` do not. Connecting writes the machine's state, which no clone carries and which `doctor` can find missing. Maintaining reaches the shell, the install and a public tracker. So the developer's review of these commands is not of a change, but of the machine they wrote to and of what left it.
