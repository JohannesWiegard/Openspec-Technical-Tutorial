# 15. The Workflows Outside the Table

Chapters 9 to 12 took seven workflows apart and one command, and gave each a card and a table of its stages. They are the workflows of one profile, and OpenSpec 2.1.1 defines five more. This chapter takes all five in one place, with a short section for each in place of a card and a table. Each section answers the questions that chapter 9 asks of a workflow. A reader who wants the stages of a skill reads the skill, which is a text in the project's skills folder.

## 15.1 Five more workflows

Chapter 9 tables seven workflows. The program holds a longer list. In OpenSpec 2.1.1 it has twelve entries: propose, explore, new, continue, apply, update, ff, sync, archive, bulk-archive, verify and onboard.

A project whose profile names all twelve gets twelve skills. A scratch project showed this on 20 November 2026, on 2.1.1: `openspec init --scope project` with a global profile that listed them installed twelve skills in the project's skills folder. This repository's profile names seven, so it has seven. The table of chapter 9 is the table of that profile, and it is not wrong for being shorter than the program's list.

The table lists the five workflows outside it. Fast-forward is the name used in the text, and the program's name for it is `ff`.

| Workflow | Entry point | What it does |
|---|---|---|
| New | the skill `openspec-new-change` | Create a change and show the template of its first artifact, then stop. |
| Fast-forward | the skill `openspec-ff-change` | Create all of a change's planning artifacts in one run. |
| Verify | the skill `openspec-verify-change` | Compare the implementation with the change's artifacts and report what does not match. |
| Bulk-archive | the skill `openspec-bulk-archive-change` | Archive several changes in one run, after checking their deltas against each other. |
| Onboard | the skill `openspec-onboard` | Walk the developer through one whole change, on a real task, with narration. |

None of the five writes a kind of file that the workflows of the table do not write. New and fast-forward write the artifacts that propose and continue write. Verify writes nothing. Bulk-archive moves what archive moves. Onboard writes the artifacts, the code and the archive. What differs is how much is written or moved in one run, and how much the agent is told to ask.

## 15.2 New

The skill `openspec-new-change` starts a change and writes nothing into it. It asks what the developer wants to build if the request does not say, derives a name in lowercase with hyphens, creates the change, shows its status and the template of the first artifact, and stops. It is the first half of the path that chapter 10 describes, and continue is the second: new creates the place, and each run of continue fills one artifact.

The agent asks and runs commands, and the program creates the folder and reports the state. The skill passes no schema unless the developer names one or asks to see them, so the project's default is used. In a scratch project on the default schema, `new change` created a folder holding `.openspec.yaml`, which has the schema's name and the date of creation. `status` then showed zero of four artifacts complete, the proposal ready and the other three blocked.

The program refuses a name already in use, a name that is not in lowercase with hyphens, and a schema it does not have, each with an error and exit code 1. A request the agent cannot turn into a name, or a project with no root, stops it too.

A reviewer judges a run of new by what is missing: the folder holds `.openspec.yaml` and no artifact. The developer says what the change is for, names a schema if the default is not wanted, and decides when the first artifact is written and by which workflow.

## 15.3 Fast-forward

The skill `openspec-ff-change` creates a change and writes every artifact in its required set in one run. That is what propose does, and the two skills are close. Fast-forward has five numbered stages and propose has seven, and the loop that writes the artifacts is the same text in both, apart from a tick mark in the progress line and the word "critically" before "unclear". Section 10.2 gives propose's stages and what the program checks at each.

What fast-forward leaves out is what surrounds the loop: the clarifying of the request before anything is written, the loading of the project's context, and the choice of a schema. Three differences follow.

- Fast-forward passes no schema, so another one can be chosen only in the request.
- It asks only when the context is critically unclear and otherwise prefers reasonable decisions. Propose asks about an ambiguity that would change the scope, the observable behaviour, the compatibility or the acceptance criteria, and tells the agent to record a minor assumption in the artifacts. The skill of fast-forward has no sentence that tells the agent to record one.
- Propose opens with a paragraph that says the request authorises planning only and tells the agent to stop. Fast-forward has none. Both skills close with the same prompt, which calls the plan ready for review and offers to apply it when the developer asks.

The skill is silent on the boundary. That is a difference in text, and not a defect found in a run.

The agent writes, and the program supplies the build order and the template and instruction of each artifact. A reviewer reads a run as chapter 10 reads a run of propose: the required set exists or was reported as skipped, and nothing outside the change's folder was edited. The developer's part has two additions. Say in the request that the run is for planning and not for building, because the skill does not. And look for assumptions in the drafts, because nothing marks them and an unmarked assumption reads as a decision.

## 15.4 Verify

The skill `openspec-verify-change` compares the implementation with the change's artifacts and reports. It selects the change, asks the program for the status and for the apply instruction, which returns the artifact files, the tasks and the count of those done, and reads the artifacts. It then checks three dimensions:

- Completeness counts the tasks and looks for each requirement in the code.
- Correctness reads each requirement and each scenario of the delta and looks for an implementation and for a test.
- Coherence compares the implementation with the decisions of the design and with the patterns of the project.

Each finding is critical, a warning or a suggestion, and the skill tells the agent to prefer the lower severity when it is uncertain. A removed requirement is checked by the inverse, so that finding no implementation is the expected result. A renamed requirement is checked for the behaviour it kept.

The skill marks a check that the schema does not define as not applicable, and a check whose evidence is missing as not verified. It never scores a skipped check as a pass, and it says "ready for archive" only when nothing is critical and no check was skipped.

The program contributes the files and the counts. The comparison is the agent's, by a search of the code for keywords and by reasoning. The skill describes a report and tells the agent not to implement tasks or archive the change while verifying. It names no file to write, and it says that the report is advisory and that archive keeps its own checks.

A reviewer judges a report by its evidence: each finding should name a file and a line, and a clean report is as good as its search. The developer reads the report as advice and decides what a finding means for the artifacts and for the code. What a green report shows, and what to do with a mismatch, is a question of its own, and this chapter does not answer it.

## 15.5 Bulk-archive

The skill `openspec-bulk-archive-change` archives several changes in one run. It lists the active changes and asks the developer to choose among them, with an option for all, and it never chooses for them. For each chosen change it gathers the status of the artifacts, the count of tasks, the delta files, and the name the archive folder would have. A change whose archive folder already exists is marked as blocked.

The skill then looks for a conflict, which is two chosen changes with deltas for the same capability. It settles a conflict by looking in the code for what each change implemented:

- If only one is implemented, it syncs that one.
- If both are, it applies them oldest first, so that the newer overwrites.
- If neither is, it skips the sync and warns.

It shows one table of all the changes with their artifacts, tasks, deltas and conflicts, and asks one question, with the options to archive all, to archive only the ready ones, or to cancel. After a yes it fetches the specifications' rules, syncs each change's included deltas inline, checks the main specifications against the deltas, and only then moves the change's folder. A target that has appeared in the meantime fails that change and not the batch, and the skill reports every outcome at the end.

The agent does the merging and the moving, and the program supplies the lists, the statuses and the counts. This is the path of chapter 12 in which the agent merges, run over several changes.

The rule that settles a conflict asks for evidence in the code, so a project whose changes are prose has nothing for it to find. A reviewer should read how each conflict was settled and not take the table's word that it was. The developer chooses the changes, reads the table and gives the one confirmation, which is the only question the skill asks before it writes. What a collision between two changes is, and what to do before the second archive, is a question of its own, and this chapter does not answer it. Chapter 16 takes up both questions, this one and the one at the end of section 15.4.

## 15.6 Onboard

The skill `openspec-onboard` is the longest of the twelve, 551 lines in the scratch project against 87 for new and 128 for fast-forward. Most of its text is not an instruction to the program. It is text for the agent to say, in a fixed order, while it does a whole change with the developer on a real task in the project.

It begins with a preflight, which runs `openspec --version` and stops if the program is missing. It goes on in eleven stages: a welcome, the choice of a task, a short exploration, the creation of the change, the proposal, the specification, the design and the tasks, then the implementation, the archive and a recap. It finds the task by scanning the code for comments that mark work to do, for errors that are swallowed, for functions without tests, for loose types, for debugging output and for user input that is not validated, and it shows the developer three or four suggestions.

The skill marks four pauses: after the exploration, after the proposal draft, after the tasks draft, and before the implementation. It shows the proposal and the tasks as drafts and saves each after approval. It marks no pause between the draft of the specification and the draft of the design. It implements in the codebase and archives with `openspec archive` and the flag `--yes`, which the skill says answers the confirmation prompts that it cannot answer from a tool call. If the developer says they need to stop, the skill tells the agent to say that the change is saved, to point at `openspec status` for where it stands, and to offer one next step from the workflows the session has.

The agent teaches and does the work, and the program answers the commands the skill calls. The skill's own words are that it does real work in the developer's codebase, and nothing in it makes the work a sandbox. The change is a change of the project, the code is its code and the archive is its archive.

A reviewer therefore judges onboard by what a project keeps: the diff of the code, the archived folder and the main specification, each one that the developer would have accepted without the tutorial. The developer chooses the task, approves the drafts at the pauses, confirms before the implementation, and says when to stop. In a repository whose rules say that a change writes the book and not the code, or the code and not the book, the tutorial's change has to fit those rules too, since the skill does not know them.

## 15.7 Judging the results, and correcting them

The program sees the same for all five: which files exist and how many tasks are counted. It does not see who asked for a write, which assumption a draft holds, whether a pause was kept, whether a conflict was settled rightly, or whether a verify report is right. The review of section 10.6 applies to each, and the evidence it adds is the table or the report the skill shows at its end.

The cost of a wrong result differs by workflow:

- A change that new started holds nothing the developer wrote, so the cheapest correction is to remove the folder and start again.
- A result of fast-forward is revised by the paths of section 10.7, and its usual defect is an unrecorded assumption.
- A verify report changes no file, so a wrong report costs a second run and a closer reading.
- A bulk-archive run that went wrong has moved folders and merged specifications, so the last row of the table of section 10.7 applies to each change it archived: the archive holds no revision, and the correction is a new change.
- The same holds for onboard, whose code is corrected by the project's own means and whose change the archive keeps as it was. A developer who stopped onboard early has a change in flight that continue and apply can take up, and nothing to correct in the archive.

The five workflows outside the table add no kind of file and no check that the program makes. They differ in how much is written or moved in one run and in how much the agent is told to ask: new writes no artifact, fast-forward writes every artifact with fewer questions and no stated boundary, verify writes nothing and reports, bulk-archive moves several changes after one question, and onboard writes a whole change and the code with it. The program sees only that files exist and tasks are counted, so what separates a good run from a bad one is the same in all five, which is the developer's reading of what was written or moved, who asked for it, and what it assumed. Of the five, only bulk-archive and onboard change the record of the project beyond a plan, and a developer chooses either by what the project will keep.
