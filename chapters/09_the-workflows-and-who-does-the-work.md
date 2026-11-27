# 9. The Workflows and Who Does the Work

Chapters 4 to 8 followed one change from its first artifact to the archive and took the four artifacts apart. Along the way they met apply, validation and archive, which are not files, and gave each of them an outline. OpenSpec defines twelve workflows. The core profile installs six of them, and this book examines continue as a seventh. This chapter names those seven, the one command that belongs to no workflow and the one skill that is not a workflow, and chapter 15 takes the other five. It asks four questions: what a workflow is, who does the work in it, which workflows a project has, and what the three chapters that follow rest on.

## 9.1 The workflows and the order they are met in

The table lists the seven workflows and the `validate` command, in the order a change first meets them, with the entry point of each and a short description.

| Workflow | Entry point | What it does |
|---|---|---|
| Explore | the skill `openspec-explore` | Think about a problem or idea with the agent before there is a change. It writes nothing unless the user confirms. |
| Propose | the skill `openspec-propose` | Create a change and all of its planning artifacts in one run. |
| Continue | the skill `openspec-continue-change` | Create the next missing artifact, one per run. Not in the core profile. |
| Update | the skill `openspec-update-change` | Revise the artifacts a change has and make them agree. |
| Apply | the skill `openspec-apply-change` | Work through the tasks and tick each box when its work is done. |
| Validate | the command `openspec validate` | Check the delta and the main specifications against the format rules. A command, not a workflow. |
| Sync | the skill `openspec-sync-specs` | Merge a change's delta into the main specifications without archiving it. |
| Archive | the skill `openspec-archive-change` and the command `openspec archive` | Merge the delta unless told not to, count the tasks, and move the change into the archive. |

The order of the table is a reading order, and the tool enforces none of it. Continue is another way of doing what propose does: propose creates every planning artifact in one run, and continue creates one artifact in each. Update and validate can be run again whenever the artifacts exist. Sync is optional, because archive can make the same merge. The skill `openspec-apply-change`, as OpenSpec installs it, tells the agent that apply can be invoked at any time, including before every artifact is done, as long as tasks exist. OpenSpec's documentation names its model "actions, not phases", and chapter 3 said the same of the artifacts when it described their dependencies as enablers and not gates.

## 9.2 What a workflow is made of, and who acts in it

A workflow is delivered as a skill, and a skill is a text that the agent reads. Its heart is a Markdown file, `SKILL.md`, in an `.agents/skills/` folder, the project's or the machine's as chapter 3 describes. Each skill has a folder of its own, and that folder may also hold a `references/` folder of further instructions, which the agent opens only when a task calls for them. `SKILL.md` begins with front matter and goes on with instructions to the agent. In the seven workflow skills of this chapter and in the router, the front matter gives the skill's name, a description of what it is for and which words invoke it, and the one program the skill may run in a shell, `openspec`. It also carries a licence, an author and a version of the skill's own, and the router's adds `references`, a short hash of its reference files. Skills of earlier releases also named the release that generated them; the current ones do not. The coding tool the book was checked with shows the model each skill's name and description each time it calls the model, and loads the body of a skill only when the model asks for it by name or the developer mentions it. The program does not run a skill. The agent reads it and does what it says.

What the program contributes is facts and checks. The skills tell the agent to ask a command and not to assume. The skill `openspec-propose` tells it to run `openspec context --json` to find the project's root and `openspec new change` to create a change. The skills tell it to run `openspec status` for the state of a change's artifacts, `openspec instructions` for the template and the instruction of an artifact, and `openspec instructions apply` for the tasks and the count of those done. The skill `openspec-archive-change` tells it to run `openspec list --json` for a change's task counts, and the skill `openspec-sync-specs` tells it to run `openspec validate --specs` after a merge. The skills also tell it not to assume names that the program knows: the skill `openspec-continue-change` says to use the schema's artifact sequence and not to assume artifact names, and the skill `openspec-apply-change` says to use the files that the command returns and not to assume file names. The skill gives the order of the work, and the program gives the state that the work starts from.

The table says what each of the three parties does and what it leaves to the others.

| Party | Does | Leaves to others |
|---|---|---|
| The agent | Follows the skill: reads the files, calls the commands and writes the files, and in the archive workflow can make the merge of a delta itself. | The facts about the state of a change, which the program reports, and every decision, which the developer makes. |
| The program | Reports the state and the counts, checks the format, and, as the commands `validate` and `archive`, checks a delta, can merge it and moves a change into the archive. | The reading of the project and the writing of its files, which the agent does, and what is wanted, which the developer says. |
| The developer | Decides what is wanted, confirms what a skill asks to have confirmed, and reviews the result. | The writing of the files, which the agent does, and the checks of format, which the program does. |

The same division holds in every workflow, with a different weight. It is chapter 3's pattern, and each workflow weighs its three parties differently. In explore the agent writes nothing until the developer confirms that it may, so the developer decides what is written, if anything. In propose the agent writes every planning artifact. In validate there is no skill, and the program does the work. In archive the work can be the program's or the agent's. The chapters that follow ask, for each workflow, who does what.

## 9.3 Which workflows are installed, and what they are called

No project has all twelve workflows unless its profile asks for them. OpenSpec installs the workflows that a setting called the profile asks for. The core profile installs six workflows:

- propose: for when the developer can already say what is wanted.
- explore: for when something has to be thought through, before a change or during one.
- apply: for when the plan is ready and the work starts, or has to be picked up again.
- update: for when the plan has changed, or an artifact was edited by hand and the others no longer agree with it.
- sync: for when the main specifications should show a change before it is archived.
- archive: for when the work is finished and the change is to be closed.

Continue is not one of them; a profile that names it installs it, and the book examines it alongside the six. The profile is a setting of the machine, not of one project. The command `openspec update` rewrites the installed skills so that they match it. Every profile also installs one skill that is not a workflow: `openspec`, the router. `openspec config list` does not show it, because no profile chooses it. A workflow whose skill is not installed cannot be called by its name.

The router changes who picks the workflow. Its description tells the agent to reach for it when the developer asks for OpenSpec work without naming a skill, and its text then leaves the agent three moves: answer a question, hand the request to one skill, or run several skills in order. A table in the skill maps requests to the twelve workflow skills. When a request fits more than one row, the agent asks which is meant; when it runs several skills, it finishes each before starting the next, and every skill's own stops still hold. The agent picks the workflow from the table, and the program checks nothing about that choice. The developer can still name a skill directly; the router is written for the request that names none. Its table also covers the workflows whose skill is not installed. For those, the router tells the agent to say so, to point to `openspec config profile` and `openspec update`, and then to follow a shorter path from one of its reference files, which chapter 15 describes.

Some of the names are easy to mix up:

1. `openspec update` is a command that rewrites the installed skills. It is not the update workflow, which revises a change's artifacts.
2. Archive is both a command and a workflow. The command is `archive`, and the workflow is archive. The table lists both as its entry points.
3. Explore, apply and sync have no command of their own name. `openspec apply`, `openspec sync` and `openspec explore` each give an error, "unknown command".

A workflow is therefore written in plain text, and a command or a skill in code font.

## 9.4 What comes next

What the next chapters say about a skill comes from reading it, and what they say about a command comes from running it. Each time the book moved to a newer release, every run was repeated, and the results stayed the same except for the number of skills a profile installs, for the reason section 9.3 gives: the router. A skill is a text, and one agent can follow the same text differently from another, so the developer's review covers that difference.

The next three chapters take the workflows in the order of the table, in three groups: those that write the plan, those that do the work and check it, and those that bring the project's record up to date. Each begins with the table of section 9.1, with its own rows in bold, and asks the same four questions of every workflow:

1. Who does the work?
2. What does it read and write, and what can stop it?
3. How does a reviewer judge what it did?
4. What happens when its result is wrong?

Each workflow gets a card with the same five rows, so that one can be compared with another.

| Item | What it says |
|---|---|
| Entry point | The skill or the command that starts the workflow, and the words that call it. |
| Who acts | Which of the agent, the program and the developer does each part of the work. |
| Writes | The files that the workflow creates or changes, or that it changes none. |
| What can stop it | The check, the missing input or the question to the developer that halts it before it is done. |
| The developer's part | What the developer decides, confirms or reviews, and what the workflow leaves to them. |

The workflows that write the plan come first, because the reader already knows them by their results.

A workflow is a skill that the agent reads and the commands that skill calls, and the order of the table is not an order that the tool enforces. The question to carry into the next chapters is who does the work in a workflow, because the answer differs: the agent writes in propose, the program checks in validate, and in archive the work can be the program's or the agent's.
