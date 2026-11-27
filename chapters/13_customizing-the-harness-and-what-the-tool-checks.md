# 13. Customizing the Harness, and What the Tool Checks

The previous four chapters took the workflows of OpenSpec and what each leaves behind. All of them rested on the default: the core profile or one workflow added to it, the schema `spec-driven`, and a configuration file with a few lines of context. This chapter is about changing that default. It names four kinds of customization, sets the possibilities that OpenSpec offers in one table, and asks of each kind where it is made, what it changes, what the tool checks, and how it is changed later. The example is the vending machine, given a schema of its own, which the next chapter builds file by file.

## 13.1 Four kinds of customization, and the possibilities in one table

A project can change four things, and they differ in how far a change reaches. The profile decides which workflows are installed, and it belongs to the machine. The project configuration holds the default schema, text that is added to what the agent is told, and advice for apply and archive, and it belongs to one project. The schema defines the artifacts of a change, what each requires and what the agent is told when it writes each, and it belongs to one project and can be shared between projects. The instruction file, `AGENTS.md`, holds rules the agent reads when a session opens. It sits beside OpenSpec and is not part of it.

The first three are OpenSpec's own, and each is a file that the machine or the project controls. The fourth is named here because it is the fourth place in which a rule can be written, and section 13.7 says why it is not set in the table below.

The question to ask of a need is which kind it belongs at. A rule about one artifact's wording belongs in the configuration. A new file that every change must have belongs in the schema. Which workflows a person can call by name belongs in the profile. A rule for every task in the project, OpenSpec or not, belongs in the instruction file. The tool will accept the same text in more than one of them, and it will not say which was the right place.

The table has one row for each file in which OpenSpec can be customized, so that a possibility is found in the row of the file it is written in. Its columns say which kind the file belongs to, how the file is made, what it holds, and what the tool checks. A cell that says "Nothing" means that no command reads or reports on it. The fields of `schema.yaml` are those of the schema reference on openspec.dev, which lists every field, the artifact's `description` and the apply block's `instruction` among them.

| File | Kind | Made with | What it holds | What the tool checks |
|---|---|---|---|---|
| The global configuration | Profile | `openspec config profile` | The profile and its workflow list | `openspec config list` reports it, and `openspec update` writes the skills to match |
| `openspec/config.yaml` | Config | `openspec init`, then by hand | `schema`; `context`; `rules` by artifact id; `operations.apply.guidance`; `operations.archive.guidance`; an opt-in for a hosted coding agent; `store` and `references`, for stores; `skillsScope` | Read when instructions are fetched, and nothing about what the text says |
| `schema.yaml` | Schema | `openspec schema fork` or `init`, or by copying a folder | The name, version and description; for each artifact its `id`, `generates`, `description`, `template`, `instruction` and `requires`, and their order; the apply block with `requires`, `tracks` and `instruction` | `openspec schema validate` reports a syntax error, a missing template, a duplicate id and a cycle; `openspec status` shows a blocked artifact; nothing about the instruction texts, the order or `apply.instruction` |
| A file in `templates/` | Schema | By hand, or copied with the schema | The headings and comments the agent starts from | `openspec schema validate` reports a missing file, and nothing about its content |
| `.openspec.yaml` of a change | Schema | `openspec new change`; `--schema` sets it | The schema that change uses | `openspec status` reports it |

A schema has one more place than the project's `openspec/schemas/<name>/` folder: the user's data directory, where every project on the machine finds it. The file is the same, and section 13.4 says how `openspec schema which` tells the two places apart. A schema written by someone else, such as one of the seven community schemas the customization page lists, is copied into either place, and is then checked like any other.

## 13.2 The profile: which workflows exist

The profile is the customization that reaches furthest and is checked least. It decides which workflows are installed as skills, and so which ones a person can ask for. Chapter 9 defines the profile and names the six workflows of the core profile. What is added here is that the profile is not a setting of the project. It is set with `openspec config profile`, and `openspec config` has only the global scope, so a person who sets it changes it for every project on the machine. The program reminds the person to run `openspec update` in each project, because the skills are only rewritten then.

A project that wants a profile of its own has no setting for it. The way to get one is to keep a separate configuration directory and start the session with that directory named, so that the program reads the profile from there and from nowhere else. The profile has one retired field, `delivery`, which the program still reads and ignores. Where the skills are installed is a second choice of the same reach: by default `openspec init` puts them in the machine's `~/.agents/skills/` unless it is given `--scope project`, and a project that keeps its own records that in its configuration.

What the tool does is report the result in `openspec config list`. It does not say whether the workflows that were installed suit the project, and a person who is in the wrong directory gets the global profile without a warning.

## 13.3 The project configuration: text that is added, and none of it enforced

The project configuration is a file, `openspec/config.yaml`, and `openspec init` creates it with commented examples of `context`, `rules` and `operations`. It does four things.

It names the default schema, so that a new change needs no flag. It holds `context`, which is added to the instruction of every artifact. It holds `rules`, which are added to the instruction of the artifact whose id matches, so that a rule about the design is read when the design is written and at no other time. And it holds advice for apply and archive, in `operations`, which is kept apart from the rules because it describes how the work is done and not what an artifact contains.

When the agent asks for an artifact's instruction, the program returns the schema's instruction with the context, the rules and the template, each in its own field. The agent asks for the apply and archive instructions in the same way, and gets `context` and `operationGuidance` as fields of their own. The command that returns the archive instruction only reads: in the scratch project it wrote no file, and its answer held the change's name, the root, the context and the guidance. The customization page says that context is a required input to the prompt and that guidance is additive. The same page says that neither is enforceable: a workflow follows the entries that apply, reports a conflict, and copies none of the text into a file unless the person asks.

One key of the file is about files and not about the prompt. It is the opt-in for the files that let one hosted coding agent run OpenSpec, a workflow file and an agent file. When it is true, `openspec update` writes them and keeps them current. When it is false, `openspec update` removes the ones it generated. When it is absent, the choice is undecided and `update` writes nothing. A second key is about files too: `skillsScope: project` says that the project keeps OpenSpec's skills in the repository, so `openspec update` refreshes them there and does not ask where to keep them.

The archive and sync workflows read one more thing, the `specs` rules, before they write a merge into a main specification, and they stop if the lookup fails. That is the one place where the configuration is read for something that is not a prompt.

What the tool checks of all this is the file, which it reads. It checks nothing about what a rule says or whether an agent kept it. A context that is wrong is injected as willingly as one that is right.

## 13.4 Which schema a change uses

Four places decide which schema a change uses, and the tool reads them in order. The `--schema` flag on the command that creates the change comes first. After it comes the schema the change itself recorded, in the `.openspec.yaml` of its folder. Then comes the default named in the configuration, and last the default of the program, `spec-driven`.

A new change writes its own schema into its `.openspec.yaml` when it is created. In the scratch project, a change created under a fork reported `spec-driven` as its schema after its `.openspec.yaml` was edited by hand, though the configuration still named the fork.

When a schema is not the one a person expects, `openspec schema which` says where it comes from. It reports the schema's name, its Source and its Path, and with `--all` it lists the project schemas, the user schemas and the schemas of the package. A project schema outranks a user schema of the same name. The customization page recommends project schemas, because they are kept with the code.

## 13.5 Building a schema

A schema is a folder, `openspec/schemas/<name>/`, that holds one file, `schema.yaml`, and a `templates/` folder. There are two ways in. A fork copies an existing schema whole, so that the project starts from `spec-driven` and removes or adds. A new schema starts from nothing but the artifacts that are named: in the scratch project, a schema of two artifacts was written with the proposal and the tasks, neither requiring anything, and an apply block that requires and tracks the tasks. The command `openspec schema init` with no option writes four artifacts, the proposal, the specs, the design and the tasks, each with a template, and the same kind of apply block. An option names a different list of artifacts, and another makes the new schema the project's default.

The file's top-level keys, and the fields of each artifact, are those that the table of section 13.1 lists.

The fields differ in what they decide. `requires` decides what is possible: an artifact whose requirements do not exist is blocked, and `openspec status` says by which. An artifact counts as done when its generated file exists, and in the scratch project a change whose design file was empty was reported as complete. The order of the list decides only which artifact comes first when several are ready. A template is Markdown that is injected into the prompt, and it may hold headings, comments with guidance and a sample. `generates` may be a pattern, which is how the default schema writes one file for each capability. The apply block says which artifact must exist before apply and which file's boxes are counted. Its `instruction` is what `openspec instructions apply` returns while the change is ready. When the change is blocked or every task is done the program writes its own text, and the schema's instruction does not appear.

`openspec schema validate` checks that the file is well formed. In the scratch project it reported a template file that was missing, an artifact id that was used twice, and a cycle of requirements, which it named. The customization page lists the same four checks: the syntax, the templates, the cycles and the ids.

A schema is shared by copying its folder into one of the two places that section 13.1 names. A schema copied from elsewhere is a fork of it, and a fork does not receive what is later changed in the schema it was copied from; the project keeps it up to date by hand or not at all.

## 13.6 Placing the needs of an example

The next chapter walks one example from the first command to the archive, and this section only places its needs. Chapter 4 told how the vending machine's first version passed validation and every task and still left a case undecided. The design had named the case as a non-goal, and chapter 7 said that a design that sets a case aside has not decided it. The review that finds this is a habit of the reviewer, and nothing in the tool knows whether it was done. The example turns the habit into a file: a fork of `spec-driven`, named `with-trace`, whose trace names for every scenario the decision in the design that satisfies it.

The example needs four things, and each belongs at a different place. The table says where and why.

| The need | Where it is made | Why there |
|---|---|---|
| A file that every change has to have before its tasks | The schema: the `trace` artifact, and `requires` on the tasks | It is a new artifact with its own place in the order, and only the schema can add one. |
| A design states a non-goal only when no scenario tests the case | The configuration: a line in `rules` for the design | It is about the wording of one artifact, and not about a file. |
| The agent checks the trace before each task | The schema: a line in `apply.instruction` | It belongs with the trace and travels with the schema, so another project that copies the schema gets it. |
| The archive summary says whether the trace was read before the merge | The configuration: a line of archive guidance | It is advice about how the work is done, and it is for this project. |

The tool reports the schema valid and the trace blocked or ready. It does not check that the trace is true, or that the line in the apply instruction is followed, and it cannot find a scenario that nobody wrote. The first version's failure was a case that had no scenario until the second change added it, so the trace would have made the design's non-goal visible once the scenario existed, and the coverage review of chapter 6 remains the check that finds a scenario that is missing. The example is also a fork, with the cost that section 13.5 names.

## 13.7 What is outside of OpenSpec

The instruction file is the fourth place in which a rule can be written, and OpenSpec has no mechanism for it. The program's cleanup code treats two things as left by earlier versions: a managed `openspec/AGENTS.md`, and a block of text between two markers in the root `AGENTS.md`. In the scratch project, `openspec init` removed the managed file and the marked block from a project that still had them, and kept the rest of the root file as the person had written it. `openspec update` alone changed neither. The root file belongs to the project, and nothing in OpenSpec generates, reads or checks it. It is not the only such place: chapter 18 takes a text of the project's own, kept in the skills folder beside the generated skills, that OpenSpec does not generate or check either.

That is why it is not a row of the table. The last column of the table says what the tool checks, and a row that says "Nothing" about a file the tool does not know would suggest that the tool does something with it. It is better compared with the project configuration, which is the place nearest to it.

| | `AGENTS.md` | The configuration's `context` and `rules` |
|---|---|---|
| Read by | The agent, when a session opens | The agent, added to the instruction of an OpenSpec artifact or operation |
| Applies to | Every task in the project, OpenSpec or not | Only the artifacts and operations OpenSpec instructs |
| What the tool checks | Nothing | The file's form, and nothing about what it says |

A rule that every task must follow, such as the language of the project's files, belongs in the instruction file, as section 13.1 said. A rule written in both the instruction file and the configuration can disagree with itself, and nothing warns of it, so the person who writes both has to read them together. Section 3.5 gave the reason the rules live with the code. This chapter adds only that they live in two places, and that the tool knows one of them.

## 13.8 What the tool checks, and what it leaves out

The tool checks the form of a customization and never its effect, as the last column of the table in section 13.1 shows.

The effect is left to the reviewer, and it can fail in ways the checks do not see. A schema that validates can tell the agent something that does not produce the artifact the template holds. The default schema does this once already: section 7.7 shows that its instruction for the design names two parts the template lacks. The rules, the context and the guidance of section 13.3 are advice, and none of them is enforced. The order of the artifact list, and the wording of a fork's instruction, change what an agent does and are checked by nothing.

Each of these can happen to a change that passes every command, so a customization that reports well formed has shown that it is well formed, and no more.

## 13.9 Reviewing a customization

A customization is reviewed in the file first and then in what it produces, and the review has four passes. Placement asks whether the need is at the kind that reaches as far as it should. Form asks whether the tool accepts the customization. Instruction asks whether each instruction produces the part the template holds. Effect asks whether a change run through the schema produces what was meant. Placement and Effect matter most, because the tool can check Form and nothing else, and a customization at the wrong kind or with the wrong effect passes it.

The table is a memory aid, and no part of the tool reads it.

| Check | The customization has done its job when | How it can fail |
|---|---|---|
| Placement | The need is at the kind that reaches as far as it, and no further | A rule for one artifact is in the instruction file, or a rule for every task is in one artifact's rules |
| The profile | `openspec config list` shows the workflows the project needs | The wrong configuration directory was used, and the global profile was read |
| The configuration | `openspec instructions` returns the context and the rules for the artifact they were written for | A rule is under an id that no artifact has |
| The schema's form | `openspec schema validate` passes and `openspec schema which` names the intended source | A user schema of the same name is shadowed by a project schema, or the reverse |
| The selection | A new change records the schema that was meant | A flag or a default is set that overrides it |
| The instruction | Each instruction produces the part the template holds | An instruction names a part the template does not have |
| The effect | A change run through the schema produces the artifacts that were meant, and they are good | The schema validates and the artifacts are wrong |

## 13.10 Changing a customization

The cost of changing a customization depends on what has already been made with it. The table says what the revision covers at each stage.

| What exists | What the revision covers |
|---|---|
| Nothing has been made with it yet | The file only. The next command that reads it sees the change. |
| Changes in progress | A configuration edit is read the next time the instructions are fetched. A schema edited in place changes the open changes that use it at once: in the scratch project a change created with four artifacts reported five after the schema gained one, with the new one blocked. A change keeps the schema name it recorded, so a new default does not move it. A profile change reaches the skills only after `openspec update`. |
| Changes archived | Nothing. The archive is a record and is not rewritten, as chapters 5 and 12 say. A change made under the old schema stays as it was made, and the next change uses the new one. |

The row for changes in progress is the one to read twice. A schema is shared by every change that names it, so editing it moves them all, and a change that was half-written under one set of artifacts finds another. A person who wants a change to keep the old schema copies the schema under a new name before editing, and starts the new changes with the copy.

## 13.11 What customization hands on

Customization hands the project a harness that is its own. Each of its files is kept with the project or the machine, and each can be read, reviewed and revised like any other.

A customization is a choice of the kind that reaches as far as the need and no further, and the tool will confirm only that it was made well formed. The question to ask of any customization is where it was made and what is checked there.
