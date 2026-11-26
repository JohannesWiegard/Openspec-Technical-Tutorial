# 15. The Workflows Outside the Table

Chapters 9 to 12 examined seven workflows and one command in detail, and gave each a card and a table of its stages. These are the workflows of one profile. OpenSpec 2.2.0 defines five more. This chapter discusses all five in one place. It gives each a short section in place of a card and a table. Each section answers the questions that chapter 9 asks of a workflow. A reader who wants the stages of a skill reads the skill. The skill is a text in the project's skills folder.

## 15.1 Five more workflows

The program holds a longer list of workflows than the seven that chapter 9 tables. In OpenSpec 2.2.0 the list has twelve entries: propose, explore, new, continue, apply, update, ff, sync, archive, bulk-archive, verify and onboard.

A project whose profile names all twelve gets thirteen skills: one for each workflow, and the router. A scratch project showed this on 26 November 2026, on 2.2.0. There, `openspec init --scope project` with a global profile that listed all twelve installed thirteen skills in the project's skills folder. This repository's profile names seven, so the repository has eight skills. The table of chapter 9 is the table of that profile. It is not wrong because it is shorter than the program's list.

The table lists the five workflows outside it. The text calls one of them Fast-forward. The program's name for it is `ff`.

| Workflow | Entry point | What it does |
|---|---|---|
| New | the skill `openspec-new-change` | Create a change and show the template of its first artifact, then stop. |
| Fast-forward | the skill `openspec-ff-change` | Create all of a change's planning artifacts in one run. |
| Verify | the skill `openspec-verify-change` | Compare the implementation with the change's artifacts and report what does not match. |
| Bulk-archive | the skill `openspec-bulk-archive-change` | Archive several changes in one run, after checking their deltas against each other. |
| Onboard | the skill `openspec-onboard` | Guide the developer through one whole change, on a real task, with narration. |

None of the five writes a kind of file that the workflows of the table do not write. New and fast-forward write the artifacts that propose and continue write. Verify writes nothing. Bulk-archive moves what archive moves. Onboard writes the artifacts, the code and the archive. The five differ in two things: how much is written or moved in one run, and how much the agent is told to ask.

In this repository, the five have no skill, and the router of 2.2.0 gives each a shorter path. The path is a section of the router's reference file `without-skills.md`. Each section lists the commands of the work, or says what the agent reads. It does not have the checks and the questions of the skill. For new and fast-forward, the section lists `new change`, `status` and `instructions`. It stops after one artifact, or it continues until the plan is complete. For verify, the agent reads the tasks and the specifications against the code, and it changes no file. The section names none of the dimensions or severities of section 15.4. For bulk-archive, the agent archives one change at a time. It does not check the deltas against each other, as the skill does in section 15.5. For onboard, the agent follows the sections for explore, propose, apply and archive.

## 15.2 New

The skill `openspec-new-change` starts a change and writes nothing into it. If the request does not say what the developer wants to build, the skill asks. It derives a name in lowercase with hyphens and creates the change. It shows the change's status and the template of the first artifact, and then it stops. It is the first half of the path that chapter 10 describes, and continue is the second half. New creates the place, and each run of continue fills one artifact.

The agent asks and runs commands, and the program creates the folder and reports the state. The skill passes no schema unless the developer names one or asks to see them. So the project's default schema is used. In a scratch project on the default schema, `new change` created a folder that held `.openspec.yaml`. This file has the schema's name and the date of creation. `status` then showed zero of four artifacts complete. The proposal was ready, and the other three were blocked.

The program refuses three things, each with an error and exit code 1: a name already in use, a name that is not in lowercase with hyphens, and a schema it does not have. Two other things also stop the skill: a request that the agent cannot turn into a name, and a project with no root.

A reviewer judges a run of new by what is missing: the folder holds `.openspec.yaml` and no artifact. The developer says what the change is for. The developer names a schema if the default is not wanted. The developer also decides when the first artifact is written, and by which workflow.

## 15.3 Fast-forward

The skill `openspec-ff-change` creates a change and writes every artifact in its required set in one run. Propose does the same, and the two skills are close. Fast-forward has five numbered stages and propose has seven. The loop that writes the artifacts is the same text in both skills, with two exceptions: a tick mark in the progress line, and the word "critically" before "unclear". Section 10.2 gives the stages of propose and what the program checks at each.

Fast-forward leaves out what surrounds the loop. It does not clarify the request before anything is written, it does not load the project's context, and it does not choose a schema. Three differences follow.

- Fast-forward passes no schema, so the developer can choose another schema only in the request.
- It asks only when the context is critically unclear, and otherwise it prefers reasonable decisions. Propose asks about an ambiguity that would change the scope, the observable behaviour, the compatibility or the acceptance criteria. Propose also tells the agent to record a minor assumption in the artifacts. The skill of fast-forward has no sentence that tells the agent to record one.
- Propose opens with a paragraph that says the request authorises planning only, and that tells the agent to stop. Fast-forward has no such paragraph. Both skills close with the same prompt. The prompt calls the plan ready for review and offers to apply it when the developer asks.

The skill says nothing about the boundary. That is a difference in the text, and not a defect found in a run.

The agent writes. The program supplies the build order, and the template and instruction of each artifact. A reviewer reads a run in the way chapter 10 reads a run of propose. The required set exists or was reported as skipped, and nothing outside the change's folder was edited. The developer's part has two additions. First, say in the request that the run is for planning and not for building, because the skill does not say it. Second, look for assumptions in the drafts, because nothing marks them, and an unmarked assumption reads as a decision.

## 15.4 Verify

The skill `openspec-verify-change` compares the implementation with the change's artifacts and reports the result. It selects the change. It asks the program for the status and for the apply instruction. The apply instruction returns the artifact files, the tasks and the count of tasks that are done. The skill then reads the artifacts and checks three dimensions:

- Completeness counts the tasks and looks for each requirement in the code.
- Correctness reads each requirement and each scenario of the delta and looks for an implementation and for a test.
- Coherence compares the implementation with the decisions of the design and with the patterns of the project.

Each finding is critical, a warning or a suggestion. When the agent is uncertain, the skill tells it to prefer the lower severity. A removed requirement is checked in the inverse way, so the expected result is that no implementation is found. A renamed requirement is checked for the behaviour it kept.

The skill marks a check that the schema does not define as not applicable. It marks a check whose evidence is missing as not verified. It never scores a skipped check as a pass. It says "ready for archive" only when nothing is critical and no check was skipped.

The program contributes the files and the counts. The agent makes the comparison, by searching the code for keywords and by reasoning. The skill describes a report. It tells the agent not to implement tasks or archive the change while it verifies. It names no file to write. It says that the report is advisory and that archive keeps its own checks.

A reviewer judges a report by its evidence. Each finding should name a file and a line, and a clean report is as good as its search. The developer reads the report as advice, and decides what a finding means for the artifacts and for the code. Two further questions are separate: what a passing report shows, and what to do with a mismatch. This chapter does not answer them.

## 15.5 Bulk-archive

The skill `openspec-bulk-archive-change` archives several changes in one run. It lists the active changes and asks the developer to choose among them, with an option for all. It never chooses for the developer. For each chosen change, it collects the status of the artifacts, the count of tasks, the delta files, and the name that the archive folder would have. It marks a change as blocked if the change's archive folder already exists.

The skill then looks for a conflict. A conflict is two chosen changes with deltas for the same capability. The skill settles a conflict by looking in the code for what each change implemented:

- If only one is implemented, it syncs that one.
- If both are, it applies them oldest first, so that the newer overwrites.
- If neither is, it skips the sync and warns.

It shows one table of all the changes with their artifacts, tasks, deltas and conflicts. It asks one question, with three options: archive all, archive only the ready ones, or cancel. After a yes, it fetches the rules of the specifications and syncs the included deltas of each change inline. It checks the main specifications against the deltas, and only then moves the change's folder. If a target folder has appeared in the meantime, that change fails and the batch does not. At the end, the skill reports every outcome.

The agent does the merging and the moving, and the program supplies the lists, the statuses and the counts. This is the path of chapter 12 in which the agent merges, run over several changes.

The rule that settles a conflict asks for evidence in the code. So in a project whose changes are prose, the rule has nothing to find. A reviewer should read how each conflict was settled, and not trust the table's statement that it was settled. The developer chooses the changes, reads the table and gives the one confirmation. This confirmation is the only question the skill asks before it writes. Two further questions are separate: what a collision between two changes is, and what to do before the second archive. This chapter does not answer them. Chapter 16 discusses both questions, this one and the one at the end of section 15.4.

## 15.6 Onboard

The skill `openspec-onboard` is the longest of the twelve. In the scratch project it has 551 lines, against 87 for new and 128 for fast-forward. Most of its text is not an instruction to the program. It is text for the agent to say, in a fixed order, while the agent does a whole change with the developer on a real task in the project.

It begins with a preflight, which runs `openspec --version` and stops if the program is missing. It then continues in eleven stages: a welcome, the choice of a task, a short exploration, the creation of the change, the proposal, the specification, the design and the tasks, then the implementation, the archive and a recap. To find the task, it scans the code for six things: comments that mark work to do, errors that are swallowed, functions without tests, loose types, debugging output, and user input that is not validated. It shows the developer three or four suggestions.

The skill marks four pauses: after the exploration, after the proposal draft, after the tasks draft, and before the implementation. It shows the proposal and the tasks as drafts, and saves each after approval. It marks no pause between the draft of the specification and the draft of the design. It implements in the codebase. It archives with `openspec archive` and the flag `--yes`. The skill says that this flag answers the confirmation prompts, which the skill cannot answer from a tool call. The developer may say that they need to stop. Then the skill tells the agent to say that the change is saved, and to point at `openspec status` for the state of the change. It also tells the agent to offer one next step from the workflows that the session has.

The agent teaches and does the work, and the program answers the commands that the skill calls. The skill itself says that it does real work in the developer's codebase. Nothing in it makes the work a sandbox. The change is a change of the project, the code is the project's code, and the archive is the project's archive.

A reviewer therefore judges onboard by what a project keeps: the diff of the code, the archived folder and the main specification. The reviewer asks of each one whether the developer would have accepted it without the tutorial. The developer chooses the task, approves the drafts at the pauses, confirms before the implementation, and says when to stop. Some repositories have rules that a change writes the book and not the code, or the code and not the book. In such a repository, the tutorial's change has to follow those rules too, because the skill does not know them.

## 15.7 Judging the results, and correcting them

The program sees the same things for all five workflows: which files exist and how many tasks are counted. It does not see who asked for a write or which assumption a draft holds. It does not see whether a pause was kept, whether a conflict was settled correctly, or whether a verify report is correct. The review of section 10.6 applies to each workflow. The evidence it adds is the table or the report that the skill shows at its end.

The cost of a wrong result differs by workflow:

- A change that new started holds nothing the developer wrote. So the cheapest correction is to remove the folder and start again.
- A result of fast-forward is revised by the paths of section 10.7. Its usual defect is an unrecorded assumption.
- A verify report changes no file. So a wrong report costs a second run and a closer reading.
- A bulk-archive run that went wrong has moved folders and merged specifications. So the last row of the table of section 10.7 applies to each change it archived: the archive holds no revision, and the correction is a new change.
- The same holds for onboard. Its code is corrected by the project's own means, and the archive keeps its change as it was. A developer who stopped onboard early has an active change that continue and apply can work on further, and nothing to correct in the archive.

The five workflows outside the table add no kind of file and no check that the program makes. They differ in how much is written or moved in one run, and in how much the agent is told to ask. New writes no artifact. Fast-forward writes every artifact with fewer questions and no stated boundary. Verify writes nothing and reports. Bulk-archive moves several changes after one question. Onboard writes a whole change and the code with it. The program sees only that files exist and that tasks are counted. So the same thing separates a good run from a bad one in all five: the developer's reading of what was written or moved, who asked for it, and what it assumed. Of the five, only bulk-archive and onboard change the record of the project beyond a plan. A developer chooses either of them by what the project will keep.
