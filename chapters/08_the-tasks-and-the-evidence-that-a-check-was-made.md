# 8. The Tasks and the Evidence That a Check Was Made

Chapter 7 ended with the decisions and the traces handed to the next artifact, which it said says how each decision is checked. This chapter takes that artifact up and asks the same four questions of it: who writes it, which of its parts must be right, how a reviewer decides that it is finished, and what happens when the review finds something wrong. The example is the same vending machine and the same two changes. What comes after the tasks, the apply and archive workflows and the `validate` command, is given an outline at the end of this chapter, and chapters 11 and 12 describe them in full.

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
| Schema marker | `.openspec.yaml` | The schema the change follows, and `skip_specs` when it has no deltas. | Chapter 4 |

The table lists the parts of `tasks.md`. The parts this chapter quotes or discusses are in bold.

| Tasks | Description |
|---|---|
| **Group heading** | A numbered heading that groups related tasks. |
| **Task** | A checkbox with a number and a description of the check. `[ ]` is open and `[x]` is done. |

## 8.1 Who writes the tasks

The agent drafts the first version of `tasks.md` from the delta and the design, which are the two artifacts the tool lists as the tasks' dependencies. Before it writes, the instruction tells it to read the design's Open Questions and to resolve with the user any that would change what gets built, so that no unstated assumption is built into the list. It supplies the form of the template, a task for each decision that reads as sound, and a way of verifying each one. What it cannot supply is what the team can really verify, which evidence could fail, or what size of check fits one session. The developer's part is to ask of each task what would show that it had failed. Section 5.1 describes the same division for the proposal, and sections 6.1 and 7.1 describe it for the delta and the design. Chapter 2 gives the reason human control stays with the developer.

In the `spec-driven` schema the tasks require both the delta and the design, so `openspec status` shows them as blocked until both exist, and the apply workflow requires the tasks. The instruction of the apply workflow tells the agent to work through the pending tasks and to mark each one complete as it goes. In the default schema the agent therefore writes the check and ticks it, and nothing records which of the two made it. A person is the only party who can tell the check from the tick, and the rest of this chapter is about how.

## 8.2 The parts of the tasks

The table says what the tool checks of each part of the tasks. For this artifact the answer is a count.

| Part | What the tool checks | The question it answers |
|---|---|---|
| Group heading | Nothing. | Which checks belong together, and in what order? |
| Task | `list`, `instructions apply` and `archive` count the checkbox lines. A box holding only `x` or `X` is done. | What has to be checked, and has it been? |

The tasks are the one artifact whose content the tool counts, and it counts nothing but checkboxes. `validate` never opens the `tasks.md` of a change that has not been archived. Only the form `--archived` opens a `tasks.md`: it reads the tasks of archived changes and reports an open box as an error, as chapter 11 shows. `status` counts the file as done if it exists, whatever it contains: a file of one character, a file of prose and an empty file all show as done. `list` shows a file with no checkbox as "No tasks", `instructions apply` calls that change blocked, and `archive` goes ahead, because there is nothing to count. A box holding `x`, `X` or ` x` is done. The markers `[~]`, `[-]` and `[]` read as unfinished and are still counted, and a line with no checkbox is not counted. The "1.1" in a task is text: `instructions apply` numbers the tasks by their position in the file, and a group heading appears nowhere in its output. The two parts are the whole of the default template, and a part that a project adds belongs in a forked schema, as chapter 3 described. The tool therefore reads a number, and the number says how many boxes are ticked. It does not say whether any check was made, and that is the finding of this section.

## 8.3 Groups and tasks

The file is `tasks.md` in the change `give-exact-change`, and it is shown in full as archived:

```markdown
## 1. Check the first version

- [x] 1.1 Trace the scenario "Change is given from stock" through the design by hand. **Verified by** the trace in the design's Findings, which matches the scenario.
- [x] 1.2 Trace the scenario "Exact payment gives no change" through the design by hand. **Verified by** the trace in the design's Findings, which matches the scenario.
- [x] 1.3 Run `openspec validate --strict`. **Verified by** the command passing.
```

Its single group, "Check the first version", holds three tasks: two traces and a validation run. Each is one check, and each box is ticked. The numbers 1.1 to 1.3 are the author's, as the previous section said, and the tool does not read them.

The file is `tasks.md` in the change `refuse-without-exact-change`, and it is shown in full as archived:

```markdown
## 1. Trace the first version

- [x] 1.1 Write the scenario "Stock cannot make the change" from the requirement's word "exact". **Verified by** the scenario in the spec delta.
- [x] 1.2 Trace the scenario through the first design of `give-exact-change`. **Verified by** Trace A in the design's Findings, which records both symptoms.

## 2. Revise and trace again

- [x] 2.1 Revise the design so that the change is worked out before release, and a change that is not exact is refused. **Verified by** the decisions in the design.
- [x] 2.2 Trace all three scenarios through the revised design. **Verified by** Traces B, C and D in the design's Findings.
- [x] 2.3 Run `openspec validate --strict`. **Verified by** the command passing.
```

The second change has five tasks in two groups. In the first the failure is written down and traced, and in the second the design is revised and checked again, so the second group cannot begin before the first has given an answer. The instruction asks for the tasks to be ordered by dependency and to be small enough to finish in one session, and both files meet that: each task is one check. Section 4.12 says what the groups do.

Every box in both files is ticked, and the archive keeps them. A tick does not hold its evidence. Each task points at the delta, at a trace in the design's Findings, at the decisions, or at a command, so the box is a pointer, and the file it names holds what it points at. A reader of the tasks alone learns that someone ticked, and has to open the file the task names to learn why. Section 4.5 says what a tick records. This chapter asks what a reader can do with one.

## 8.4 What the template leaves out

The instruction for the tasks asks for two things that the template does not have. The first is a statement in each task of how it is verified. The instruction says that each task must state how to verify completion, with a test, a command, an observable behaviour or a delivered artifact, and that the statement goes in the task's own description. The template has two checkbox placeholders and no part for it. The example fixes its wording through a rule in its project configuration, which asks each task to state how it is verified, and `Verified by` is the example's wording of what the instruction already asks.

The file is `tasks.md` in the change `give-exact-change`, and its task 1.1 reads as archived:

```markdown
- [x] 1.1 Trace the scenario "Change is given from stock" through the design by hand. **Verified by** the trace in the design's Findings, which matches the scenario.
```

The evidence is a trace in the design's Findings, which matches the scenario. A reviewer opens the design, reads the trace and compares it with the scenario. The trace could have disagreed with the scenario, and the reviewer can see whether it did. Section 4.7 shows a trace of this kind.

The file is `tasks.md` in the change `refuse-without-exact-change`, and its task 2.1 reads as archived:

```markdown
- [x] 2.1 Revise the design so that the change is worked out before release, and a change that is not exact is refused. **Verified by** the decisions in the design.
```

The evidence is the decisions in the design. The decision is both what was done and the proof that it was done, so this evidence cannot show a failure of its own. The question a reviewer asks of any task is whether its evidence could have come out the other way. Task 2.2 of the same file, which traces all three scenarios through the revised design, is the task whose evidence can fail. The example shows both kinds side by side, as written.

The example has three kinds of evidence. A reading, such as a trace in the design or a scenario in the delta, can be opened by someone who was not there. The work itself, such as the decisions of task 2.1, is the claim again. A command's result, as in the last task of each file, which runs `openspec validate --strict` and names the command passing, is recorded by the box and by the clause, and nowhere else unless the task says where. `validate`, run on a change that has not been archived, reads the delta and never the design or the tasks, as sections 7.2 and 4.5 say, so those two tasks are evidence about the delta and no more. Section 4.5 says what followed for the first change.

The instruction's second addition is for steps that need the archive. It asks that the tracked tasks be work that can be completed before the archive, and that any step which waits for the archive be a plain bullet under an optional `## Workflow follow-up` section, where the tool does not count it. The reason shows in what `archive` does with an open box: it asks whether to continue. A box for the archive itself could not be ticked before the archive ran, so it would be an open box at the moment the archive counts. The instruction names the section for use when it applies, and neither example file has one.

## 8.5 Reviewing the tasks

The tasks are reviewed twice. The first review is made after the design is reviewed and before apply begins, and it asks whether the checks are the right ones. The second is made when the boxes are ticked, and it reads each ticked box against the evidence its task names. The tool shows the count at both moments and checks neither review. The review has four passes. Intent asks whether the tasks check this change and not another. Coverage asks whether each decision of the design, and each trace it hands on, has a task that checks it, and whether each task checks something the design holds. Evidence asks whether each task's evidence could have come out the other way, and whether someone who was not there can open it. Order asks whether the tasks are small, ordered by dependency and grouped so that each group lands its own tests and documentation. Coverage and evidence matter most, because the tool counts boxes and sees neither.

When every box is ticked, `instructions apply` reports the change as all done, and it tells the agent to review or verify the change as appropriate before archiving. The tool leaves the verification to a person. The count says how many boxes are ticked and does not say how many checks were made. The second review is the one the count cannot do: it reads each ticked box in the file its task names, and it finds the box whose evidence is absent.

The table is one checklist, in the order the file is read. The column names use the artifact's name, which here is the tasks.

| Check | The tasks pass when | How a draft can fail |
|---|---|---|
| The request is answered as meant | The tasks check the change that the design describes, and nothing in them answers an assumption the agent made | The list checks another change, or adds work that the design does not hold |
| Group heading | Each group names one stretch of work, and the groups follow the order that the work depends on | A group collects unlike checks, or a final group holds tests or documentation that an earlier group owed |
| Task: size | Each task is one check that can be finished in one session | One task holds several checks under one box, so one tick stands for several claims |
| Task: coverage | Each decision of the design, and each trace it hands on, has a task that checks it, and each task checks something the design holds | A decision has no task, so nothing checks it, or a task checks something that no decision states |
| Verification: statement | Each task says how it is verified, in the form the instruction asks for | A task names no evidence, or names only the work itself as evidence |
| Verification: evidence | The evidence could have come out the other way, and someone who was not there can open it | The evidence is the claim itself, or it sits where no one can find it |
| Box | Each ticked box has its evidence in the place the task names, and each open box has none yet | A box is ticked and its evidence is absent, or the task was reworded after the tick |
| Workflow follow-up | A step that waits for the archive is a plain bullet and not a box | An archive step is written as a box, so the list cannot be finished before the archive it waits for |
| Downstream | The count is complete because each task is ticked with its evidence, and the change can go to archive | The list reads complete because an open task was removed or reworded, or an open box is left for the archive to ask about |

The table is a memory aid, and no part of the tool reads it. A row that passes records a person's judgement, not a machine's check. The rows on evidence, on the box and on what is downstream look beyond the file to the files its tasks name, and they are the ones that cannot be read from the tasks alone. A list whose count is complete and whose evidence cannot be opened is not finished. A task list is finished when each tick can be traced to its evidence, not when the count is complete.

## 8.6 Changing the tasks after review

When the review finds a fault, two decisions follow: what the revision covers, and who makes it. The first depends on how many boxes are ticked and whether the change is archived.

| What exists | What the revision covers |
|---|---|
| Only the tasks, and no box ticked | The task, its order and the tasks that depend on it. |
| The tasks, with boxes ticked | Those too. A tick belongs to the task as it was, so a task whose wording changes is reopened until its check is made again. |
| An archived change | Nothing in the archive. A later gap goes into a new change, whose tasks name the change they check. |

The archive keeps the tasks as they were, as section 5.9 says of the proposal, and the same reason applies here. The example shows the bottom row and not the middle one. The second change's tasks are a new list in a new change. Its task 1.2 traces the design of the first change, and the first change's list is untouched, with every box still ticked. The middle row, a list revised while boxes are ticked, has no case in the archive, for the reason chapter 5 gives: the second change was written after the first was archived, from a finding.

A revision is made by editing the file or by asking the agent to change it, and the choice turns on whether the replacement is known. The developer edits when the sentence is already known. The developer asks the agent when the check has to be worked out from the design, or when several tasks have to move together. The table compares the two means on four points.

| | The developer edits the file | The agent is asked to revise it |
|---|---|---|
| Right when | The replacement is known, and the fault sits in one task | The check has to be worked out from the design, or several tasks have to move together |
| What it costs | A minute with the file open, and a diff that shows one line | A request with three parts, a whole file to read back, and a diff whose size hides what changed |
| How it goes wrong | An edit changes what a task checks while its box stays ticked | A request for a clearer list returns a renumbered one, in which boxes have turned over and the count has changed |
| What to check afterwards | The task's box against its new wording, and the tasks that depend on it | Each box against its evidence, and the whole list with its count |

Suppose the first change's task 1.2 had named the first scenario, "Change is given from stock", and the developer knows the name the archive holds: "Exact payment gives no change". One name changes. The box was ticked against the trace of the first scenario, so the developer reads the trace the task now names before the box stays ticked. The diff shows one name, and the tick is the part the diff does not show.

Suppose a task list, not one of the example's, holds a task whose evidence is "the design", and the developer cannot yet say what would fail. The request to the agent has three parts:

1. which task to revise: the one whose evidence is the design;
2. what is wrong with it: the evidence cannot fail, because it is the work itself;
3. what must not move: the other tasks, their order and the boxes already ticked.

The agent proposes evidence from the delta's scenarios and the design's traces, and the developer decides which of them would catch a wrong design. Without the third part, the agent may renumber the list and turn boxes over.

Both means end in the same reading. An edit is checked by its diff, which includes the state of each box. A revision made by asking is a rewrite, so the whole list is read again as a new draft, with the passes of section 8.5 and each box against its evidence. Chapter 6 said that the tool reports a scenario dropped from a MODIFIED block, and chapter 7 said that it notices nothing of a design. The tasks fall between. The count moves, and a box turned over and an open task removed both make the list read complete, in the same words. The tool is not wrong to count. It counts what it can see.

## 8.7 What the tasks hand on

The tasks are the one artifact that the next workflow reads, and the schema names them as the file that apply tracks. Three things follow them: the apply workflow, the `validate` command and the archive workflow. This section gives each one a paragraph, saying what it does with the tasks and one fact that a reader would not guess. Chapter 11 describes apply and the `validate` command and chapter 12 describes archive, each with its own review and update guidance.

Apply is the workflow in which the boxes change. The agent works through the pending tasks and marks each one complete. `instructions apply` reports one of three states: blocked when there is no task to work on, ready when some are open, and all done when none is, which is the state in which it tells the agent to review or verify. The developer's part is the second review of section 8.5: to read the evidence and not the ticks.

The `validate` command, run on a change that has not been archived, reads the delta and never the tasks, as section 8.2 says, and the example's tasks run it as a check. `openspec validate --strict` fails on a warning, such as a requirement that says should where SHALL or MUST belongs, and `archive` does not: it blocks on errors, and a warning passes it without being shown. The main specification then fails the strict check for the same warning. A task that names "the command passing" is therefore evidence about whichever form the task names.

The `archive` command reads the tasks to count them. It prints the count, and when some boxes are open it asks whether to continue. The default answer is no, and a run with no one to answer is refused unless it is told to continue. The archive workflow reads the same count from `list` and asks the user to confirm before it goes on. A change with no `tasks.md`, or with no checkbox in it, raises no question about the tasks. The `archive` command refuses a delta it cannot merge and changes no file, and when it succeeds it moves the change into the archive under the date; the workflow stops before it moves the change if its merge fails. Sections 4.6 and 4.14 describe what that leaves in the main specification.

The tasks said how each decision is checked, and what is described above uses them. Chapters 9 to 12 describe what the tool does in each, who decides, and what to review. The frame of this chapter fits a file with parts, and it bends for a workflow: those chapters give each workflow a card, and a table of its stages or forms, in place of a file's parts.

The tasks are the checks of the design. An agent drafts them, a program counts them without being able to read them, and a person judges them by opening the evidence behind each box. The agent supplies the form of the template, and the developer decides what counts as evidence and whether each task could have failed. The tool reads a number, so a tick is a claim, and a claim whose evidence is the work itself, or cannot be found, is one that no one can check. A reading that someone who was not there can open is evidence, and so is a result that could have come out the other way. The review is made twice, before the work and when the boxes are ticked, because the tasks are the one artifact that changes after it is reviewed, and the update paths turn on whether a box is already ticked. The workflows and the command that follow count and move what the tasks record, and none of them verifies it. The reader should carry away that a list of ticked boxes shows that someone ticked, and that a task is done when its evidence can be opened and could have failed.
