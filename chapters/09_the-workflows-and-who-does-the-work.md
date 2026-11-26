# 9. The Workflows and Who Does the Work

Chapters 4 to 8 followed one change from its first artifact to the archive, and they examined each of the four artifacts in detail. On the way, they met apply, validation and archive. These are not files, and the chapters gave each of them an outline. OpenSpec 2.2.0 defines twelve workflows, and this repository's profile installs seven of them. This chapter names those seven. It also names the one command that belongs to no workflow, and the one skill that is not a workflow. Chapter 15 discusses the other five. This chapter asks four questions: what a workflow is, who does the work in it, which workflows a project has, and what the three chapters that follow are based on.

## 9.1 The workflows and the order a change meets them

The table lists the seven workflows and the `validate` command, in the order a change first meets them. It gives the entry point of each and a short description.

| Workflow | Entry point | What it does |
|---|---|---|
| Explore | the skill `openspec-explore` | Think about a problem or idea with the agent before there is a change. It writes nothing unless the user confirms. |
| Propose | the skill `openspec-propose` | Create a change and all of its planning artifacts in one run. |
| Continue | the skill `openspec-continue-change` | Create the next missing artifact, one per run. Not in the core profile. |
| Update | the skill `openspec-update-change` | Revise the artifacts a change has, and make them agree. |
| Apply | the skill `openspec-apply-change` | Work through the tasks, and tick each box when its work is done. |
| Validate | the command `openspec validate` | Check the delta and the main specifications against the format rules. A command, not a workflow. |
| Sync | the skill `openspec-sync-specs` | Merge a change's delta into the main specifications without archiving the change. |
| Archive | the skill `openspec-archive-change` and the command `openspec archive` | Merge the delta unless told not to, count the tasks, and move the change into the archive. |

The order of the table is a reading order, and the tool does not enforce any of it. Continue is another way of doing what propose does. Propose creates every planning artifact in one run, and continue creates one artifact in each run. Update and validate can be run again whenever the artifacts exist. Sync is optional, because archive can make the same merge. The skill `openspec-apply-change`, as OpenSpec 2.2.0 installs it, tells the agent that apply can be invoked at any time, as long as tasks exist. This includes the time before every artifact is done. OpenSpec's documentation calls its model "actions, not phases". Chapter 3 said the same of the artifacts, when it described their dependencies as enablers and not gates.

## 9.2 What a workflow consists of, and who acts in it

A workflow is delivered as a skill, and a skill is a text that the agent reads. The skill is a Markdown file, `SKILL.md`, in an `.agents/skills/` folder. That folder is either the project's or the machine's, as chapter 3 describes. Each skill has a folder of its own. From 2.2.0, that folder may also hold a `references/` folder. Its files are instructions that the agent opens only when a task needs them. `SKILL.md` begins with front matter, and the rest of it is instructions to the agent. In the eight skills this repository installs from OpenSpec 2.2.0, the front matter gives three things. It gives the skill's name, a description of what the skill is for and which words invoke it, and the one program the skill may run in a shell, `openspec`. The front matter also holds a licence, an author and a version of the skill's own. The router's front matter also holds `references`, a short hash of its reference files. The skills of 2.0.0 also named the release that generated them, and the skills of 2.1.1 and 2.2.0 do not. The coding tool the book was checked with shows the model each skill's name and description each time it calls the model. It loads the body of a skill only when the model asks for it by name or the developer mentions it. The program does not run a skill. The agent reads the skill and does what it says.

The program contributes facts and checks. The skills installed by 2.2.0 tell the agent to ask a command, and not to assume. The skill `openspec-propose` tells the agent to run `openspec context --json` to find the project's root, and `openspec new change` to create a change. The skills tell the agent to run `openspec status` for the state of a change's artifacts. They tell it to run `openspec instructions` for the template and the instruction of an artifact. They tell it to run `openspec instructions apply` for the tasks and the count of tasks that are done. The skill `openspec-archive-change` tells the agent to run `openspec list --json` for a change's task counts. The skill `openspec-sync-specs` tells it to run `openspec validate --specs` after a merge. The skills also tell the agent not to assume names that the program knows. The skill `openspec-continue-change` says to use the schema's artifact sequence and not to assume artifact names. The skill `openspec-apply-change` says to use the files that the command returns and not to assume file names. The skill gives the order of the work, and the program gives the state that the work starts from.

The table says what each of the three parties does and what it leaves to the others.

| Party | Does | Leaves to others |
|---|---|---|
| The agent | Follows the skill: reads the files, calls the commands and writes the files. In the archive workflow, it can make the merge of a delta itself. | The facts about the state of a change, which the program reports. Every decision, which the developer makes. |
| The program | Reports the state and the counts, and checks the format. As the commands `validate` and `archive`, it checks a delta, can merge it, and moves a change into the archive. | Reading the project and writing its files, which the agent does. Saying what is wanted, which the developer does. |
| The developer | Decides what is wanted, confirms what a skill asks to have confirmed, and reviews the result. | Writing the files, which the agent does. Checking the format, which the program does. |

The same division holds in every workflow, but with a different weight. It is the pattern of chapter 3, and each workflow gives its three parties a different weight. In explore, the agent writes nothing until the developer confirms that it may. So the developer decides what is written, if anything is written. In propose, the agent writes every planning artifact. In validate, there is no skill, and the program does the work. In archive, the work can be done by the program or by the agent. The chapters that follow ask, for each workflow, who does what.

## 9.3 Which workflows are installed, and their names

No project has all twelve workflows unless its profile asks for them. OpenSpec installs the workflows that a setting called the profile asks for. The core profile installs six workflows:

- propose: for when the developer can already say what is wanted.
- explore: for when something has to be thought about carefully, before a change or during one.
- apply: for when the plan is ready and the work starts, or when the work has to be resumed.
- update: for when the plan has changed, or when an artifact was edited by hand and the others no longer agree with it.
- sync: for when the main specifications should show a change before the change is archived.
- archive: for when the work is finished and the change is to be closed.

Continue is not one of them, and this repository's profile adds it. The profile is a setting of the machine, not of one project. The command `openspec update` rewrites the installed skills so that they match the profile. Every profile also installs one skill that is not a workflow. From 2.2.0, this is `openspec`, the router. `openspec config list` does not show it, because a profile does not choose it. A workflow whose skill is not installed cannot be called by its name.

The router changes who chooses the workflow. Its description tells the agent to use it when the developer asks for OpenSpec work without naming a skill. Its text then tells the agent to do one of three things. The agent answers a question, hands the request to one skill, or runs several skills in order. A table in the skill maps a request to one of the twelve workflow skills. When a request fits more than one row, the agent asks which is meant. When the agent runs several skills, it finishes each one before the next. The stops of each skill still hold. So the agent picks the workflow from the table, and the program checks nothing about that choice. The developer can still name a skill. The router's description is written for a request that names none. The table also names the workflows whose skill is not installed. For such a workflow, the router tells the agent to say so, and to name `openspec config profile` and `openspec update`. It then gives the agent a shorter path from a reference file. Chapter 15 describes that path.

Some of the names are easy to confuse:

1. `openspec update` is a command that rewrites the installed skills. It is not the update workflow, which revises a change's artifacts.
2. Archive is both a command and a workflow. The command is `archive`, and the workflow is archive. The table lists both as its entry points.
3. Explore, apply and sync have no command of their own name. On 2.2.0, `openspec apply`, `openspec sync` and `openspec explore` each give an error, "unknown command".

For this reason, a workflow is written in plain text, and a command or a skill is written in code font.

## 9.4 What the next chapters do

What the next chapters say about a skill comes from reading it. What they say about a command comes from running it. Both the reading and the running were done on OpenSpec 2.2.0. The runs were first made on 2.1.1, and they were repeated on 2.2.0 on 26 November 2026. Both releases gave the same results, except for the number of skills that a profile installs. Section 9.3 gives the reason, which is the router. A skill is a text, and one agent can follow the same text differently from another agent. The developer's review therefore covers that difference.

The next three chapters discuss the workflows in the order of the table, in three groups. The groups are the workflows that write the plan, the workflows that do the work and check it, and the workflows that make the project's record current. Each chapter begins with the table of section 9.1, with its own rows in bold. Each chapter asks the same four questions of every workflow:

1. Who does the work?
2. What does it read and write, and what can stop it?
3. How does a reviewer judge what it did?
4. What happens when its result is wrong?

Each workflow gets a card with the same five rows, so that the reader can compare one workflow with another.

| Item | What it says |
|---|---|
| Entry point | The skill or the command that starts the workflow, and the words that call it. |
| Who acts | Which of the agent, the program and the developer does each part of the work. |
| Writes | The files that the workflow creates or changes, or the fact that it changes none. |
| What can stop it | The check, the missing input or the question to the developer that stops it before it is done. |
| The developer's part | What the developer decides, confirms or reviews, and what the workflow leaves to the developer. |

The workflows that write the plan come first, because the reader already knows them by their results.

A workflow is a skill that the agent reads, together with the commands that the skill calls. The order of the table is not an order that the tool enforces. The question for the next chapters is who does the work in a workflow, because the answer differs. The agent writes in propose, the program checks in validate, and in archive the work can be done by the program or by the agent.
