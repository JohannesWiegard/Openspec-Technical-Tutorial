# 8. The Tasks and the Evidence That a Check Was Made

Chapter 7 ended when the decisions and the traces were passed to the next artifact. That chapter said that this artifact says how each decision is checked. This chapter discusses that artifact and asks it the same four questions. Who writes it? Which of its parts must be right? How does a reviewer decide that it is finished? What happens when the review finds something wrong? The example is the same vending machine with the same two changes. Three things come after the tasks: the apply and archive workflows and the `validate` command. The end of this chapter gives them an outline, and chapters 11 and 12 describe them in full.

The table shows the files of a change and the paths of its specifications. The row this chapter discusses is in bold.

| Item | File | What it says | Discussed in |
|---|---|---|---|
| Change | `openspec/changes/<change>/` | The folder of one change. Archive moves it into the archive. | Chapter 4 |
| Proposal | `proposal.md` | Why the change exists and what it changes. | Chapters 4 and 5 |
| Capability | `specs/<capability>/` | The folder for one area of behaviour, such as `purchase`. | Chapters 4 and 6 |
| Specification | `specs/<capability>/spec.md` | What one change adds, modifies or removes. | Chapters 4 and 6 |
| Main specification | `openspec/specs/<capability>/spec.md` | The system as it stands. Archive writes it. | Chapters 4 and 6 |
| Design | `design.md` | How the work is done. | Chapters 4 and 7 |
| **Tasks** | **`tasks.md`** | **The checks that turn the design into work.** | **Chapters 4 and 8** |
| Schema marker | `.openspec.yaml` | The schema the change follows. It also holds `skip_specs` when the change has no deltas. | Chapter 4 |

The table lists the parts of `tasks.md`. The parts this chapter quotes or discusses are in bold.

| Tasks | Description |
|---|---|
| **Group heading** | A numbered heading that groups related tasks. |
| **Task** | A checkbox with a number and a description of the check. `[ ]` is open and `[x]` is done. |

## 8.1 Who writes the tasks

The agent drafts the first version of `tasks.md` from the delta and the design. The tool lists these two artifacts as the dependencies of the tasks. Before the agent writes, the instruction tells it to read the design's Open Questions. It must resolve with the user any question that would change what gets built, so that no unstated assumption is built into the list. The agent supplies the form of the template, a task for each decision that seems sound, and a way to verify each task. The agent cannot supply what the team can really verify. It cannot say which evidence could fail, or what size of check fits one session. The developer's part is to ask of each task what would show that it had failed. Section 5.1 describes the same division for the proposal, and sections 6.1 and 7.1 describe it for the delta and the design. Chapter 2 gives the reason why human control stays with the developer.

In the `spec-driven` schema the tasks require both the delta and the design. So `openspec status` shows the tasks as blocked until both exist. The apply workflow, in turn, requires the tasks. The instruction of the apply workflow tells the agent to work through the pending tasks and to mark each one complete as it goes. In the default schema, therefore, the agent writes the check and also ticks it, and nothing records which of the two it did. Only a person can tell the check apart from the tick. The rest of this chapter is about how.

## 8.2 The parts of the tasks

The table says what the tool checks in each part of the tasks. For this artifact, the answer is a count.

| Part | What the tool checks | The question it answers |
|---|---|---|
| Group heading | Nothing. | Which checks belong together, and in what order? |
| Task | `list`, `instructions apply` and `archive` count the checkbox lines. A box holding only `x` or `X` is done. | What has to be checked, and has it been checked? |

The tool counts the content of the tasks, and of no other artifact, and it counts nothing but checkboxes. `validate` never opens the `tasks.md` of a change that has not been archived. Only the form `--archived` opens a `tasks.md`. It reads the tasks of archived changes and reports an open box as an error, as chapter 11 shows. `status` counts the file as done if it exists, whatever it contains. A file of one character, a file of prose and an empty file all show as done. `list` shows a file with no checkbox as "No tasks". `instructions apply` calls that change blocked. `archive` continues, because there is nothing to count. A box holding `x`, `X` or ` x` is done. The markers `[~]`, `[-]` and `[]` read as unfinished and are still counted. A line with no checkbox is not counted. The "1.1" in a task is text. `instructions apply` numbers the tasks by their position in the file, and a group heading does not appear in its output. The two parts are the whole of the default template. A part that a project adds belongs in a forked schema, as chapter 3 described. The tool therefore reads a number, and the number says how many boxes are ticked. It does not say whether any check was made. That is the finding of this section.

## 8.3 Groups and tasks

The file is `tasks.md` in the change `give-exact-change`. It is shown in full as archived:

```markdown
## 1. Check the first version

- [x] 1.1 Trace the scenario "Change is given from stock" through the design by hand. **Verified by** the trace in the design's Findings, which matches the scenario.
- [x] 1.2 Trace the scenario "Exact payment gives no change" through the design by hand. **Verified by** the trace in the design's Findings, which matches the scenario.
- [x] 1.3 Run `openspec validate --strict`. **Verified by** the command passing.
```

Its single group, "Check the first version", holds three tasks: two traces and a validation run. Each task is one check, and each box is ticked. The numbers 1.1 to 1.3 are the author's, as the previous section said. The tool does not read them.

The file is `tasks.md` in the change `refuse-without-exact-change`. It is shown in full as archived:

```markdown
## 1. Trace the first version

- [x] 1.1 Write the scenario "Stock cannot make the change" from the requirement's word "exact". **Verified by** the scenario in the spec delta.
- [x] 1.2 Trace the scenario through the first design of `give-exact-change`. **Verified by** Trace A in the design's Findings, which records both symptoms.

## 2. Revise and trace again

- [x] 2.1 Revise the design so that the change is worked out before release, and a change that is not exact is refused. **Verified by** the decisions in the design.
- [x] 2.2 Trace all three scenarios through the revised design. **Verified by** Traces B, C and D in the design's Findings.
- [x] 2.3 Run `openspec validate --strict`. **Verified by** the command passing.
```

The second change has five tasks in two groups. In the first group, the failure is written down and traced. In the second group, the design is revised and checked again. So the second group cannot begin before the first group has given an answer. The instruction asks that the tasks be ordered by dependency and be small enough to finish in one session. Both files meet that: each task is one check. Section 4.12 says what the groups do.

Every box in both files is ticked, and the archive keeps them. A tick does not hold its evidence. Each task points at the delta, at a trace in the design's Findings, at the decisions or at a command. So the box is a pointer, and the file it names holds what it points at. A reader of the tasks alone learns that someone ticked. To learn why, the reader has to open the file that the task names. Section 4.5 says what a tick records. This chapter asks what a reader can do with one.

## 8.4 What the template leaves out

The instruction for the tasks asks for two things that the template does not have. The first is a statement in each task of how the task is verified. The instruction says that each task must state how to verify completion: with a test, a command, an observable behaviour or a delivered artifact. It says that this statement goes in the task's own description. The template has two checkbox placeholders and no part for the statement. The example fixes its wording through a rule in its project configuration, which asks each task to state how it is verified. `Verified by` is the example's wording of what the instruction already asks.

The file is `tasks.md` in the change `give-exact-change`. Its task 1.1 reads as archived:

```markdown
- [x] 1.1 Trace the scenario "Change is given from stock" through the design by hand. **Verified by** the trace in the design's Findings, which matches the scenario.
```

The evidence is a trace in the design's Findings, which matches the scenario. A reviewer opens the design, reads the trace and compares it with the scenario. The trace could have disagreed with the scenario, and the reviewer can see whether it did. Section 4.7 shows a trace of this kind.

The file is `tasks.md` in the change `refuse-without-exact-change`. Its task 2.1 reads as archived:

```markdown
- [x] 2.1 Revise the design so that the change is worked out before release, and a change that is not exact is refused. **Verified by** the decisions in the design.
```

The evidence is the decisions in the design. The decision is both what was done and the proof that it was done. So this evidence cannot show a failure of its own. The question a reviewer asks of any task is whether its evidence could have come out the other way. Task 2.2 of the same file traces all three scenarios through the revised design. It is the task whose evidence can fail. The example shows both kinds next to each other, as written.

The example has three kinds of evidence. A reading, such as a trace in the design or a scenario in the delta, can be opened by someone who was not there. The work itself, such as the decisions of task 2.1, is the claim again. A command's result is the third kind. The last task of each file runs `openspec validate --strict` and names the command passing. That result is recorded by the box and by the clause, and nowhere else unless the task says where. `validate`, run on a change that has not been archived, reads the delta and never the design or the tasks, as sections 7.2 and 4.5 say. So those two tasks are evidence about the delta and no more. Section 4.5 says what followed for the first change.

The instruction's second addition is for steps that need the archive. It asks that the tracked tasks be work that can be completed before the archive. Any step that waits for the archive must be a plain bullet under an optional `## Workflow follow-up` section, where the tool does not count it. The reason is in what `archive` does with an open box: it asks whether to continue. A box for the archive itself could not be ticked before the archive ran. So it would be an open box at the moment the archive counts. The instruction names the section for use when it applies, and neither example file has one.

## 8.5 Reviewing the tasks

The tasks are reviewed twice. The first review is made after the design is reviewed and before apply begins. It asks whether the checks are the right ones. The second review is made when the boxes are ticked. It reads each ticked box against the evidence that its task names. The tool shows the count at both moments and checks neither review. The review has four passes. Intent asks whether the tasks check this change and not another. Coverage asks whether each decision of the design, and each trace that the design passes on, has a task that checks it. It also asks whether each task checks something the design holds. Evidence asks whether each task's evidence could have come out the other way, and whether someone who was not there can open it. Order asks whether the tasks are small and ordered by dependency. It also asks whether they are grouped so that each group delivers its own tests and documentation. Coverage and evidence matter most, because the tool counts boxes and sees neither.

When every box is ticked, `instructions apply` reports the change as all done. It tells the agent to review or verify the change as appropriate before archiving. The tool leaves the verification to a person. The count says how many boxes are ticked. It does not say how many checks were made. The second review is the one that the count cannot do. It reads each ticked box in the file that its task names, and it finds the box whose evidence is absent.

The table is one checklist, in the order the file is read. The column names use the artifact's name, which here is the tasks.

| Check | The tasks pass when | How a draft can fail |
|---|---|---|
| The request is answered as meant | The tasks check the change that the design describes, and nothing in them answers an assumption the agent made | The list checks another change, or adds work that the design does not hold |
| Group heading | Each group names one part of the work, and the groups follow the order of the dependencies in the work | A group collects checks of different kinds, or a final group holds tests or documentation that an earlier group owed |
| Task: size | Each task is one check that can be finished in one session | One task holds several checks under one box, so one tick stands for several claims |
| Task: coverage | Each decision of the design, and each trace the design passes on, has a task that checks it. Each task checks something the design holds | A decision has no task, so nothing checks it, or a task checks something that no decision states |
| Verification: statement | Each task says how it is verified, in the form the instruction asks for | A task names no evidence, or names only the work itself as evidence |
| Verification: evidence | The evidence could have come out the other way, and someone who was not there can open it | The evidence is the claim itself, or it is where no one can find it |
| Box | Each ticked box has its evidence in the place the task names, and each open box has none yet | A box is ticked and its evidence is absent, or the task was reworded after the tick |
| Workflow follow-up | A step that waits for the archive is a plain bullet and not a box | An archive step is written as a box, so the list cannot be finished before the archive it waits for |
| Downstream | The count is complete because each task is ticked with its evidence, and the change can go to archive | The list reads complete because an open task was removed or reworded, or an open box is left for the archive to ask about |

The table is a memory aid, and no part of the tool reads it. A row that passes records a person's judgement, not a machine's check. Three rows look beyond the file to the files its tasks name: the rows on evidence, on the box and on what is downstream. They are the rows that cannot be read from the tasks alone. A list whose count is complete and whose evidence cannot be opened is not finished. A task list is finished when each tick can be traced to its evidence, not when the count is complete.

## 8.6 Changing the tasks after review

When the review finds a fault, two decisions follow: what the revision covers, and who makes it. The first decision depends on how many boxes are ticked and on whether the change is archived.

| What exists | What the revision covers |
|---|---|
| Only the tasks, and no box ticked | The task, its order and the tasks that depend on it. |
| The tasks, with boxes ticked | Those too. A tick belongs to the task as it was, so a task whose wording changes is reopened until its check is made again. |
| An archived change | Nothing in the archive. A later gap goes into a new change, whose tasks name the change they check. |

The archive keeps the tasks as they were, as section 5.9 says of the proposal, and the same reason applies here. The example shows the bottom row and not the middle one. The second change's tasks are a new list in a new change. Its task 1.2 traces the design of the first change. The first change's list is untouched, and every box in it is still ticked. The middle row, a list revised while boxes are ticked, has no case in the archive. The reason is the one chapter 5 gives: the second change was written after the first was archived, from a finding.

A revision is made by editing the file or by asking the agent to change it. The choice depends on whether the replacement is known. The developer edits when the sentence is already known. The developer asks the agent when the check has to be worked out from the design, or when several tasks have to move together. The table compares the two ways on four points.

| | The developer edits the file | The agent is asked to revise it |
|---|---|---|
| Right when | The replacement is known, and the fault is in one task | The check has to be worked out from the design, or several tasks have to move together |
| What it costs | A minute with the file open, and a diff that shows one line | A request with three parts, a whole file to read back, and a diff whose size hides what changed |
| How it goes wrong | An edit changes what a task checks while its box stays ticked | A request for a clearer list returns a renumbered one, in which boxes have changed state and the count has changed |
| What to check afterwards | The task's box against its new wording, and the tasks that depend on it | Each box against its evidence, and the whole list with its count |

Suppose the first change's task 1.2 had named the first scenario, "Change is given from stock". The developer knows the name that the archive holds: "Exact payment gives no change". One name changes. The box was ticked against the trace of the first scenario. So the developer reads the trace that the task now names before the box stays ticked. The diff shows one name. The tick is the part that the diff does not show.

Suppose a task list, not one of the example's, holds a task whose evidence is "the design". The developer cannot yet say what would fail. The request to the agent has three parts:

1. which task to revise: the one whose evidence is the design;
2. what is wrong with it: the evidence cannot fail, because it is the work itself;
3. what must not move: the other tasks, their order and the boxes already ticked.

The agent proposes evidence from the delta's scenarios and the design's traces. The developer decides which of them would catch a wrong design. Without the third part, the agent may renumber the list and change the state of boxes.

Both ways end in the same reading. An edit is checked by its diff, which includes the state of each box. A revision made by asking is a rewrite. So the whole list is read again as a new draft, with the passes of section 8.5 and with each box read against its evidence. Chapter 6 said that the tool reports a scenario dropped from a MODIFIED block. Chapter 7 said that the tool notices nothing in a design. The tasks are between these two cases. The count changes. A box that changed state and an open task that was removed both make the list read complete, in the same words. The tool is not wrong to count. It counts what it can see.

## 8.7 What the tasks pass on

The tasks are the one artifact that the next workflow reads, and the schema names them as the file that apply tracks. Three things follow the tasks: the apply workflow, the `validate` command and the archive workflow. This section gives each of them a paragraph. Each paragraph says what one of them does with the tasks, and gives one fact that a reader would not guess. Chapter 11 describes apply and the `validate` command, and chapter 12 describes archive, each with its own review and update guidance.

Apply is the workflow in which the boxes change. The agent works through the pending tasks and marks each one complete. `instructions apply` reports one of three states. It reports blocked when there is no task to work on, and ready when some tasks are open. It reports all done when no task is open, and in that state it tells the agent to review or verify. The developer's part is the second review of section 8.5: to read the evidence and not the ticks.

The `validate` command, run on a change that has not been archived, reads the delta and never the tasks, as section 8.2 says. The example's tasks run it as a check. `openspec validate --strict` fails on a warning, such as a requirement that says should where SHALL or MUST belongs. `archive` does not fail on it: it blocks on errors, and a warning passes it without being shown. The main specification then fails the strict check for the same warning. So a task that names "the command passing" is evidence about whichever form the task names.

The `archive` command reads the tasks to count them. It prints the count, and when some boxes are open it asks whether to continue. The default answer is no. A run with no one to answer is refused unless it is told to continue. The archive workflow reads the same count from `list` and asks the user to confirm before it continues. A change with no `tasks.md`, or with no checkbox in it, raises no question about the tasks. The `archive` command refuses a delta that it cannot merge, and it changes no file. When it succeeds, it moves the change into the archive under the date. The workflow stops before it moves the change if its merge fails. Sections 4.6 and 4.14 describe what that leaves in the main specification.

The tasks said how each decision is checked, and the workflows and the command described above use them. Chapters 9 to 12 describe what the tool does in each, who decides, and what to review. The frame of this chapter fits a file with parts, and it must be adapted for a workflow. Those chapters give each workflow a card, and a table of its stages or forms, in place of a file's parts.

The tasks are the checks of the design. An agent drafts them, a program counts them without being able to read them, and a person judges them by opening the evidence behind each box. The agent supplies the form of the template. The developer decides what counts as evidence and whether each task could have failed. The tool reads a number, so a tick is a claim. A claim whose evidence is the work itself, or cannot be found, is one that no one can check. A reading that someone who was not there can open is evidence, and so is a result that could have come out the other way. The review is made twice, before the work and when the boxes are ticked. The reason is that the tasks are the one artifact that changes after it is reviewed, and the ways to update them depend on whether a box is already ticked. The workflows and the command that follow count and move what the tasks record, and none of them verifies it. The reader should carry away two things. A list of ticked boxes shows that someone ticked. A task is done when its evidence can be opened and could have failed.
