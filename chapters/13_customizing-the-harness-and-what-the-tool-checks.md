# 13. Customizing the Harness, and What the Tool Checks

The previous four chapters discussed the workflows of OpenSpec and what each one leaves behind. All of them depended on the default: the core profile or one workflow added to it, the schema `spec-driven`, and a configuration file with a few lines of context. This chapter is about changing that default. It names four kinds of customization and puts the possibilities that OpenSpec offers in one table. It asks four questions of each kind. Where is it made? What does it change? What does the tool check? How is it changed later? The example is the vending machine with a schema of its own. The next chapter builds that schema file by file.

## 13.1 Four kinds of customization, and the possibilities in one table

A project can change four things, and they differ in how far a change reaches. The profile decides which workflows are installed, and it belongs to the machine. The project configuration holds the default schema, text that is added to what the agent is told, and advice for apply and archive. It belongs to one project. The schema defines the artifacts of a change, what each one requires, and what the agent is told when it writes each one. It belongs to one project, and projects can share it. The instruction file, `AGENTS.md`, holds rules that the agent reads when a session opens. It is next to OpenSpec and is not part of it.

The first three are OpenSpec's own. Each of them is a file that the machine or the project controls. The fourth is named here because it is the fourth place where a rule can be written. Section 13.7 says why it is not in the table below.

The question to ask of a need is which kind it belongs to. A rule about the wording of one artifact belongs in the configuration. A new file that every change must have belongs in the schema. The choice of which workflows a person can call by name belongs in the profile. A rule for every task in the project, OpenSpec or not, belongs in the instruction file. The tool accepts the same text in more than one of them, and it does not say which place was right. The chapters before this one taught the default, and this chapter goes beyond it.

The table has one row for each file in which OpenSpec can be customized. So a possibility is found in the row of the file it is written in. The columns say which kind the file belongs to, how the file is made, what it holds, and what the tool checks. A cell that says "Nothing" means that no command reads it or reports on it. The fields of `schema.yaml` are those of the schema reference on openspec.dev. That reference lists every field, including the artifact's `description` and the apply block's `instruction`.

| File | Kind | Made with | What it holds | What the tool checks |
|---|---|---|---|---|
| The global configuration | Profile | `openspec config profile` | The profile and its workflow list | `openspec config list` reports it, and `openspec update` writes the skills to match |
| `openspec/config.yaml` | Config | `openspec init`, then by hand | `schema`; `context`; `rules` by artifact id; `operations.apply.guidance`; `operations.archive.guidance`; an opt-in for a hosted coding agent; `store` and `references`, for stores; `skillsScope` | Read when instructions are fetched, and nothing about what the text says |
| `schema.yaml` | Schema | `openspec schema fork` or `init`, or by copying a folder | The name, version and description; for each artifact its `id`, `generates`, `description`, `template`, `instruction` and `requires`, and their order; the apply block with `requires`, `tracks` and `instruction` | `openspec schema validate` reports a syntax error, a missing template, a duplicate id and a cycle; `openspec status` shows a blocked artifact; nothing about the instruction texts, the order or `apply.instruction` |
| A file in `templates/` | Schema | By hand, or copied with the schema | The headings and comments the agent starts from | `openspec schema validate` reports a missing file, and nothing about its content |
| `.openspec.yaml` of a change | Schema | `openspec new change`; `--schema` sets it | The schema that change uses | `openspec status` reports it |

A schema has one more place besides the project's `openspec/schemas/<name>/` folder. That place is the user's data directory, where every project on the machine finds it. The file is the same in both places. Section 13.4 says how `openspec schema which` tells the two places apart. A schema written by someone else is copied into either place, and it is then checked like any other schema. The seven community schemas that the customization page lists are examples.

## 13.2 The profile: which workflows exist

The profile is the customization that reaches furthest and is checked least. It decides which workflows are installed as skills, and so which ones a person can ask for. Chapter 9 defines the profile and names the six workflows of the core profile. This section adds one point: the profile is not a setting of the project. It is set with `openspec config profile`, and `openspec config` has only the global scope. So a person who sets it changes it for every project on the machine. The program reminds the person to run `openspec update` in each project, because the skills are rewritten only then.

A project that wants a profile of its own has no setting for it. The way to get one is to keep a separate configuration directory and to start the session with that directory named. The program then reads the profile from there and from nowhere else. This repository does this, and its profile adds the continue workflow to the core six. The profile has one retired field, `delivery`, which 2.2.0 reads and ignores. Where the skills are installed is a second choice with the same reach. From release 2.1, `openspec init` puts them in the machine's `~/.agents/skills/` unless it is given `--scope project`. A project that keeps its own skills records that in its configuration, as this repository does.

The tool reports the result in `openspec config list`. It does not say whether the installed workflows suit the project. A person who is in the wrong directory gets the global profile without a warning.

## 13.3 The project configuration: text that is added, and none of it enforced

The project configuration is a file, `openspec/config.yaml`. `openspec init` creates it with commented examples of `context`, `rules` and `operations`. It does four things.

It names the default schema, so a new change needs no flag. It holds `context`, which is added to the instruction of every artifact. It holds `rules`, which are added to the instruction of the artifact whose id matches. So a rule about the design is read when the design is written, and at no other time. And it holds advice for apply and archive, in `operations`. This advice is kept apart from the rules, because it describes how the work is done and not what an artifact contains.

When the agent asks for the instruction of an artifact, the program returns the schema's instruction with the context, the rules and the template, each in its own field. The agent asks for the apply and archive instructions in the same way. It gets `context` and `operationGuidance` as fields of their own. The command that returns the archive instruction only reads. In the scratch project it wrote no file, and its answer held the change's name, the root, the context and the guidance. The customization page says that context is a required input to the prompt and that guidance is additive. The same page says that neither is enforceable. A workflow follows the entries that apply and reports a conflict. It copies none of the text into a file unless the person asks.

One key of the file is about files and not about the prompt. It is the opt-in for two files that let one hosted coding agent run OpenSpec: a workflow file and an agent file. When the key is true, `openspec update` writes them and keeps them current. When it is false, `openspec update` removes the ones it generated. When it is absent, the choice is undecided and `update` writes nothing. A second key is about files too. `skillsScope: project` says that the project keeps OpenSpec's skills in the repository. So `openspec update` refreshes them there and does not ask where to keep them.

The archive and sync workflows read one more thing, the `specs` rules, before they write a merge into a main specification. They stop if the lookup fails. That is the one place where the configuration is read for something that is not a prompt.

Of all this, the tool checks the file, which it reads. It checks nothing about what a rule says or whether an agent followed it. A context that is wrong is injected in the same way as one that is right.

## 13.4 Which schema a change uses

Four places decide which schema a change uses, and the tool reads them in order. The `--schema` flag on the command that creates the change comes first. Next comes the schema that the change itself recorded, in the `.openspec.yaml` of its folder. Then comes the default named in the configuration. Last comes the default of the program, `spec-driven`.

A new change writes its own schema into its `.openspec.yaml` when it is created, and that record outranks the default in the configuration. In the scratch project, a change was created under a fork, and its `.openspec.yaml` was then edited by hand. After that, the change reported `spec-driven` as its schema, though the configuration still named the fork.

When a schema is not the one a person expects, `openspec schema which` says where it comes from. It reports the schema's name, its Source and its Path. With `--all` it lists the project schemas, the user schemas and the schemas of the package. A project schema outranks a user schema of the same name. The customization page recommends project schemas, because they are kept with the code.

## 13.5 Building a schema

A schema is a folder, `openspec/schemas/<name>/`, that holds one file, `schema.yaml`, and a `templates/` folder. There are two ways to start. A fork copies an existing schema whole, so the project starts from `spec-driven` and removes or adds artifacts. A new schema starts from nothing except the artifacts that are named. In the scratch project, a schema of two artifacts was written: the proposal and the tasks, neither of them requiring anything, and an apply block that requires and tracks the tasks. The command `openspec schema init` with no option writes four artifacts, each with a template: the proposal, the specs, the design and the tasks. It writes the same kind of apply block. One option names a different list of artifacts, and another makes the new schema the project's default.

The file has five top-level keys: the name, a version, a description, the list of artifacts, and the apply block. Each artifact has an id, the file it generates, a description, the template it starts from, the instruction it gives the agent, and the artifacts it requires. The table of section 13.1 lists these fields.

The fields differ in what they decide. `requires` decides what is possible. An artifact whose required artifacts do not exist is blocked, and `openspec status` says which ones block it. An artifact counts as done when its generated file exists. In the scratch project, a change whose design file was empty was reported as complete. The order of the list decides only which artifact comes first when several are ready. A template is Markdown that is injected into the prompt. It may hold headings, comments with guidance and a sample. `generates` may be a pattern, and this is how the default schema writes one file for each capability. The apply block says which artifact must exist before apply, and which file's boxes are counted. Its `instruction` is what `openspec instructions apply` returns while the change is ready. When the change is blocked or every task is done, the program writes its own text, and the schema's instruction does not appear.

`openspec schema validate` checks that the file is well formed. In the scratch project it reported a missing template file, an artifact id that was used twice, and a cycle of requirements, which it named. The customization page lists the same four checks: the syntax, the templates, the cycles and the ids.

A schema is shared by copying its folder. A schema in the user's data directory is available to every project on the machine. The customization page lists seven schemas that others wrote and that are not part of the core. A schema copied from elsewhere is a fork of it. A fork does not receive later changes to the schema it was copied from. The project keeps it up to date by hand, or not at all. This repository's own schema is of this kind: it has no specs, and its design carries a chapter outline.

## 13.6 Where the needs of an example belong

The next chapter follows one example from the first command to the archive. This section only says where its needs belong. Chapter 4 told how the first version of the vending machine passed validation and every task, and still left a case undecided. The design had named the case as a non-goal. Chapter 7 said that a design that sets a case aside has not decided it. The review that finds this is a habit of the reviewer, and nothing in the tool knows whether it was done. The example makes the habit a file. The file is a fork of `spec-driven`, named `with-trace`. Its trace names, for every scenario, the decision in the design that satisfies it.

The example needs four things, and each one belongs in a different place. The table says where and why.

| The need | Where it is made | Why there |
|---|---|---|
| A file that every change must have before its tasks | The schema: the `trace` artifact, and `requires` on the tasks | It is a new artifact with its own place in the order, and only the schema can add one. |
| A design states a non-goal only when no scenario tests the case | The configuration: a line in `rules` for the design | It is about the wording of one artifact, and not about a file. |
| The agent checks the trace before each task | The schema: a line in `apply.instruction` | It belongs with the trace and is copied with the schema, so another project that copies the schema gets it. |
| The archive summary says whether the trace was read before the merge | The configuration: a line of archive guidance | It is advice about how the work is done, and it is for this project. |

Of such a customization, the tool checks the form. It reports the schema as valid and the trace as blocked or ready. It does not check that the trace is true, or that the line in the apply instruction is followed. It cannot find a scenario that nobody wrote. The first version failed on a case that had no scenario until the second change added it. So the trace would have made the design's non-goal visible once the scenario existed. The coverage review of chapter 6 remains the check that finds a missing scenario. The example is also a fork. It keeps nothing of later changes to `spec-driven`, so the project that keeps it maintains the copy by hand.

## 13.7 What is outside OpenSpec

The instruction file is the fourth place where a rule can be written, and OpenSpec has no mechanism for it. The agent reads `AGENTS.md` when a session opens, and the program does not read it. In 2.2.0 the program treats it as something to leave alone. The program's cleanup code treats two things as left by earlier versions: a managed `openspec/AGENTS.md`, and a block of text between two markers in the root `AGENTS.md`. In the scratch project, the project still had both. `openspec init` removed the managed file and the marked block, and it kept the rest of the root file as the person had written it. `openspec update` alone changed neither. The root file belongs to the project, and nothing in OpenSpec generates, reads or checks it.

That is why it is not a row of the table. The last column of the table says what the tool checks. A row that says "Nothing" about a file the tool does not know would suggest that the tool does something with it. It is better compared with the project configuration, which is the place nearest to it.

| | `AGENTS.md` | The configuration's `context` and `rules` |
|---|---|---|
| Read by | The agent, when a session opens | The agent, added to the instruction of an OpenSpec artifact or operation |
| Applies to | Every task in the project, OpenSpec or not | Only the artifacts and operations OpenSpec instructs |
| What the tool checks | Nothing | The file's form, and nothing about what it says |

A rule that every task must follow belongs in the instruction file. The language of the project's files is such a rule. A rule about what one artifact contains belongs in the configuration, where it is read when the artifact is written. A rule written in both places can disagree with itself, and nothing warns of it. So the person who writes both has to read them together. Section 3.5 gave the reason why the rules are kept with the code. This chapter adds only that they are in two places, and that the tool knows one of them.

## 13.8 What the tool checks, and what it does not check

The tool checks the form of a customization and never its effect. `openspec config list` reports the profile. The configuration is read as a file. The schema is checked for its syntax, its templates, its cycles and its ids. The instruction file is not checked at all.

The effect is left to the reviewer, and it can fail in ways that the checks do not see. A schema that validates can tell the agent something that does not produce the artifact that the template holds. The default schema already does this once: section 7.7 shows that its instruction for the design names two parts that the template lacks. A rule can be ignored, because it is advice that the agent reads. A context can be wrong, and it is injected as it is. The guidance for apply and archive is advisory, and no command reports whether it was followed. The order of the artifact list and the wording of a fork's instruction change what an agent does. Nothing checks them.

Each of these can happen to a change that passes every command. So a customization that is reported as well-formed has shown that it is well-formed, and no more.

## 13.9 Reviewing a customization

A customization is reviewed first in the file and then in what it produces. The review has four passes. Placement asks whether the need is at the kind that reaches as far as it should. Form asks whether the tool accepts the customization. Instruction asks whether each instruction produces the part that the template holds. Effect asks whether a change run through the schema produces what was meant. Placement and Effect matter most. The tool can check Form and nothing else, and a customization at the wrong kind or with the wrong effect passes that check.

The table is a memory aid, and no part of the tool reads it.

| Check | The customization has done its job when | How it can fail |
|---|---|---|
| Placement | The need is at the kind that reaches as far as the need, and no further | A rule for one artifact is in the instruction file, or a rule for every task is in the rules of one artifact |
| The profile | `openspec config list` shows the workflows the project needs | The wrong configuration directory was used, and the global profile was read |
| The configuration | `openspec instructions` returns the context and the rules for the artifact they were written for | A rule is under an id that no artifact has |
| The schema's form | `openspec schema validate` passes and `openspec schema which` names the intended source | A project schema shadows a user schema of the same name, or the reverse |
| The selection | A new change records the schema that was meant | A flag or a default is set that overrides it |
| The instruction | Each instruction produces the part the template holds | An instruction names a part the template does not have |
| The effect | A change run through the schema produces the artifacts that were meant, and they are good | The schema validates and the artifacts are wrong |

## 13.10 Changing a customization

The cost of changing a customization depends on what has already been made with it. The table says what the revision covers in each case.

| What exists | What the revision covers |
|---|---|
| Nothing has been made with it yet | The file only. The next command that reads it sees the change. |
| Active changes | A configuration edit is read the next time the instructions are fetched. A schema edited in place changes the active changes that use it at once: in the scratch project, a change created with four artifacts reported five after the schema gained one, and the new one was blocked. A change keeps the schema name it recorded, so a new default does not move it. A profile change reaches the skills only after `openspec update`. |
| Changes archived | Nothing. The archive is a record and is not rewritten, as chapters 5 and 12 say. A change made under the old schema stays as it was made, and the next change uses the new one. |

The row for active changes is the one to read most carefully. Every change that names a schema shares it, so an edit to the schema moves them all. A change that was half-written under one set of artifacts then finds another set. A person who wants a change to keep the old schema copies the schema under a new name before editing it. That person then starts the new changes with the copy.

## 13.11 What customization passes on

Customization passes to the project a harness of its own. The profile says which workflows can be called. The configuration says what is added to what the agent is told. The schema says what a change is made of. Each is a file that is kept with the project or the machine, and each can be read, reviewed and revised like any other file. The tool accepts all of it when it is well formed, and it says nothing about whether it was wise.

A customization is a choice of the kind that reaches as far as the need and no further, and the tool confirms only that it was made well-formed. The question to ask of any customization is where it was made and what is checked there.
