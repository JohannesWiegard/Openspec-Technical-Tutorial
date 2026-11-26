# 17. The Commands No Workflow Calls

Chapters 9 to 16 examined the workflows in detail. They also examined the commands that the workflows' skills tell the agent to run. The program has more commands than that. A developer runs some of them by hand, a script runs some, and some nobody needs until something goes wrong. This chapter discusses the commands that no workflow skill runs and no earlier chapter explains. It asks each group the questions that chapter 9 asks of a workflow. Who acts? What is read and written? What can stop it? How does a reviewer judge what it did? What happens when its result is wrong? A command has no stages. So each group gets a table that fits it, in the form chapter 15 used for the workflows outside the profile. The chapter describes OpenSpec 2.2.0.

## 17.1 The commands that no workflow skill runs

`openspec --help` lists 24 commands. The twelve workflow skills of 2.2.0 tell the agent to run twelve of them: `init`, `update`, `context`, `schemas`, `new change`, `status`, `instructions`, `list`, `show`, `validate`, `archive`, and `store list` as the one form of `store`. The workflow chapters described those. No workflow skill runs two more, and chapter 13 explains them: `config`, which holds the profile, and `schema`, which chapter 14 used to fork a schema. The others have no chapter yet. The table sorts them into four groups.

| Command | What it does | Group |
|---|---|---|
| `view` | Prints one dashboard of the specifications and the active changes. | Reading the record |
| `show --diff` | Shows a change with a diff of each modified requirement. | Reading the record |
| `spec`, `change` | Older forms of `show`, `list` and `validate`, by noun. | Reading the record |
| `templates` | Says where each artifact's template comes from. | Checking the harness |
| `doctor` | Reports the health of the root, its store and its references. | Checking the harness |
| `store` | Creates, registers and removes stores. | Working across repositories |
| `workset` | Saves named sets of folders on the machine. | Working across repositories |
| `version`, `install` | Report the program's release, and install the standalone program. | The program itself |
| `completion`, `feedback` | Add shell completion, and send feedback to the OpenSpec project. | The program itself |

The router of 2.2.0 names four of the commands in the table, and `config profile`, in one line each. Its file of answers names `view`, `templates` and `config profile` as answers to a developer's question. It tells the agent to run `doctor` when something seems wrong. It tells the agent to send `feedback` only after the user approves the message. The router does not say what the result of any of them means. So the groups of the table still hold.

Chapters 10 and 16 name `show` for other forms. `--diff` is the one form that no chapter has used. It belongs with the commands that read.

## 17.2 Reading the record

The first group reads. The developer runs each command, and the program prints. No file changes.

| Command | Reads | Writes | Can stop it |
|---|---|---|---|
| `view` | The main specifications and the active changes. | Nothing. | No root. |
| `show <change> --diff` | The change's proposal and deltas, and the main specification each delta names. | Nothing. | A name that is no change. |
| `spec show`, `spec list`, `spec validate` | The main specifications. | Nothing. | Nothing for `list`: with no root it prints "No items found" and succeeds. |
| `change show`, `change list`, `change validate` | The active changes. | Nothing. | The same as `spec`. |

`view` prints a dashboard. At the top is a summary: the specifications and their requirements, the active and completed changes, and the task progress. Below it is each change, with a progress bar and the state of its artifacts. Then comes each specification, with its count of requirements. Without a terminal, `view` prints once and ends. It is the shortest way to see the state of a project. It says nothing that `list` and `status` do not.

`show <change> --diff` prints the proposal first. Then, under "Specifications Changed (diffs)", it prints a unified diff of each modified requirement against the main specification. Chapter 6 said that a reader of a modified block has to compare it with the main specification to see what changed. This form makes that comparison, for the text as it is when the command runs. It does not say that the change is right.

`spec` and `change` are the older form of the same reading, with the noun first. Each of them prints a warning that the commands are deprecated. The warning names the verb-first command to use instead: `openspec show`, `openspec list` or `openspec validate`. The verdicts of `spec validate` and `change validate` are those of `validate`. A script that still calls them works and warns. A new script has no reason to use them.

For the developer, these commands are a way to read without opening files. The review is the reading itself. Nothing in the output is a check that the earlier chapters did not describe. A dashboard full of ticks says that files exist, as `status` does in chapter 10.

## 17.3 Checking the harness

The second group checks where things come from. It reads the harness and writes nothing.

| Command | Reads | Reports | What fails it |
|---|---|---|---|
| `templates` | The schema in use and its template files. | Each artifact's template path and its source: the package, the project or the user's directory. | A schema that cannot be resolved. |
| `doctor` | The root, a declared `store`, and each entry of `references` in `openspec/config.yaml`. | Whether each is found and healthy, with a fix for each problem. | Not a missing reference: that is a warning. |
| `store doctor <id>` | One registered store. | Its location, its OpenSpec root, its metadata and its Git state. | A store that is not registered. |

Chapter 13 asked of a schema where it comes from, with `openspec schema which`. `templates` answers the same question for the files below the schema. In a project that has not forked its schema, every template comes from the package. In a project with a fork, the same command names the project as the source.

`doctor` looks at relations, not at content. With nothing declared, it reports the root and says that no references are declared. A reference may have a store that is not registered on the machine. `doctor` reports it as unregistered, with the command that would register it, and still exits with status 0. A warning is printed and not counted. A script may run `doctor` and check only its exit status; it learns only that the command ran. To learn what the command found, it has to read the `--json` output.

For the developer, the two commands are the answer when an agent was told something other than expected. A rule may not appear, a template may not match, or a reference may add nothing to the instructions. The cause is in one of the places these commands name.

## 17.4 Working across repositories

The third group writes, and it writes on the machine. Chapter 3 said that the program keeps stores and the user's own state outside the repository. These are the commands that create that state. OpenSpec's guide calls stores and worksets a beta. It says that their commands, flags and file formats may change between releases.

A store is a standalone OpenSpec repository, registered on the machine under an id. It moves the `openspec/` folder out of a code repository into a repository of its own. Several code repositories can then share one set of specifications. Any command that reads or writes specifications and changes takes `--store <id>`. With it, the command works on the store instead of the nearest `openspec/` folder. Its output then begins with "Using OpenSpec root:" and the store's id.

| Command | Writes | Can stop it |
|---|---|---|
| `store setup <id> --path <folder>` | The folder, with `openspec/`, an `.openspec-store/store.yaml` file, a Git repository and a first commit; and the store's entry in the machine's registry. | No Git identity, unless told to skip Git. |
| `store register <path>` | The entry in the registry, for a store that already exists. | A folder without an `openspec/` root. |
| `store unregister <id>` | Removes the entry. The files stay. | An id that is not registered. |
| `store remove <id> --yes` | Removes the entry and deletes the folder. | No `--yes` with no one to ask. |
| `workset create <name> --member <folder>` | A named list of folders, in the user's data directory. | No member. |
| `workset remove <name> --yes` | Removes the list. The member folders are not touched. | No `--yes` with no one to ask. |

`store setup` writes in two places. The first is the store's folder. The second is its entry in the machine's registry, which is in the user's data directory, next to the list of projects the program knows. `store unregister` removes only the entry and leaves the files where they are. `store remove` deletes the folder as well. With no one to ask, it does so only when `--yes` is given.

A project points at a store in two ways. The first is a `store` key in its configuration. It makes the store the root when the project's own `openspec/` holds no specifications or changes. When `openspec/` holds them, the program ignores the key with a warning. The second is a `references` list. It does not change the root. It adds an index of each store's specifications to every instruction, in a block marked "Read-only upstream context". The index gives each specification's Purpose and the command to fetch it in full. The agent is told that the store exists. It is not told to obey it, and nothing checks whether it read it.

The program decides where a command works in a fixed order, and the first rule that applies wins. First is `--store` on the command. Second is the project's own `openspec/`, when it holds specifications or changes. Third is the `store` key. Fourth is a `defaultStore` in the global configuration, which `config` sets. When none applies, the command fails and lists the registered stores. It does not choose a store by its name, even one that matches the repository's name.

In a store, the workflows run as they always do; only the place changes. A developer may start a change from a code repository that uses a store. The change is then written into the store's folder, with all its artifacts and, at the end, its archive. The code it describes stays in the code repository. The two are committed and pushed separately, and no check compares them.

The skills follow the same rule. Each skill that the book's profile installs has a paragraph on store selection. The developer may name a store, or the work may be in one. Then the agent runs `store list --json` for the registered ids. It adds `--store <id>` to every command that reads or writes specifications and changes, for the rest of the workflow. The project may declare a store that this machine cannot resolve. Then the agent stops before writing and shows the error and its fix. It does not treat the project as one without OpenSpec. That is why `store list` is the one form of `store` that a skill runs.

A workset is a name for several folders, kept on the machine. `workset open` writes a workspace file and opens the folders in one editor window. The guide says that the openers for two editors are built in. It says that the openers for terminal agents are disabled for now. `workset remove` removes the list and does not touch the member folders. A workset does not change which `openspec/` folder a command uses.

For the developer, the review of this group is a review of the machine. The registry and the worksets are files outside every repository. OpenSpec never clones, pulls or pushes a store. A teammate clones it with Git and registers it on each machine. A checkout that was not pulled shows old specifications until it is pulled. A teammate who clones only the project does not have the store. That is why `doctor` reports a reference as unregistered on a new machine. Only two commands touch a folder: `store setup` creates one, and `store remove --yes` deletes one.

## 17.5 The program itself

The fourth group is about the program, and its effects go furthest: most of its forms change the machine or send something off it.

| Command | Reaches |
|---|---|
| `version` | Nothing outside the program. |
| `version --check` | The package registry, for a newer release. |
| `install [version]` | The project's GitHub releases, for the standalone program. |
| `completion generate <shell>` | Nothing; it prints a script. |
| `completion install <shell>` | The shell's own setup files. |
| `feedback <message>` | GitHub, as a public issue on the OpenSpec project. |

`version` prints the release, the package manager and the scope of the install. Its `--json` form adds the folder of the install. Chapter 3 says that the README names the release, and this is the line it points at. `version --check` asks the registry whether a newer release exists. `update` does the same when it offers an upgrade.

`install` fetches the standalone program from the project's GitHub release, together with its checksums. The standalone program runs without Node.js. `install` puts it in `~/.local/bin` unless told otherwise. It then says which copy comes first on the path. It also prints the command that removes the package-manager copy. Until one of the two is removed, the machine has two programs, and `version` says which one ran.

`completion generate <shell>` prints a completion script for the shell. `completion install` writes such a script into the shell's setup, and `completion uninstall` removes it.

`feedback` sends a message to the OpenSpec project. When the `gh` program is installed and signed in, `feedback` uses it to file an issue on the project's GitHub repository. It adds the release, the platform and the time below the message. Without `gh`, it prints a prefilled address for the issue form instead. An issue on a public repository is public.

For the developer, this group is the one whose effect is outside the project. Before a run, the question is where the command reaches: the shell, the install, or a public tracker.

## 17.6 Judging the result, and correcting it

The program checks none of the effects of these commands. It reads, it reports, and it writes what it is told. The checks of form in the earlier chapters are the only checks there are. What a wrong run costs depends on what it wrote:

- A reading or checking command changes no file, so a wrong run costs a second run with the right name or form.
- A warning from `doctor` is read and not counted, so a gate that depends on its exit status passes a missing reference.
- `store unregister` and `workset remove` are undone by registering the store or creating the workset again, because their files were left in place.
- `store remove --yes` deletes the folder. Only a copy elsewhere, such as a pushed remote, brings it back.
- A store checkout that was not pulled shows old specifications, and the agent works against them. OpenSpec never pulls a store, so only pulling it with Git brings it up to date.
- `install` leaves two copies of the program until one is removed, and the path decides which runs.
- A `feedback` issue is public once it is filed. Correcting it is a matter for the tracker, not for the program.

Before a command of the third or fourth group, the developer can say in one sentence what it will write and where. Afterwards, the developer can run `git status` and the matching `list`: `store list`, `workset list` or `version`.

The commands that no workflow calls read the record, check the harness, connect repositories and maintain the program. None of them judges a change. Reading and checking leave the project as it was, and say nothing that `validate`, `list` and `status` do not. Connecting writes the machine's state, which no clone carries and which `doctor` can find missing. Maintaining reaches the shell, the install and a public tracker. So the developer's review of these commands is not a review of a change. It is a review of the machine they wrote to, and of what left it.
