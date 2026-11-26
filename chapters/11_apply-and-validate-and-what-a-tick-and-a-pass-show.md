# 11. Apply and Validate, and What a Tick and a Pass Show

The previous chapter discussed the four workflows that write or revise a plan. It ended when the plan was passed to the workflow that carries it out. This chapter discusses the next two entries of the table. Apply is the workflow that does the work and ticks the boxes. `validate` is the command that checks the form of the delta and the main specifications. They share a chapter because each leaves a result that a reader can take for more than it is: a count of ticks, and a pass. For each, the chapter asks four questions. What does the developer do? What does it read and write, and what can stop it? How does a reviewer judge what it did? What happens when its result is wrong? The examples are the tasks files of the vending machine's two changes, which hold ticks and no code. A scratch project, in which the commands were run, supplies the rest.

The table lists the workflows and the `validate` command again. Apply and `validate` are in bold.

| Workflow | Entry point | What it does |
|---|---|---|
| Explore | the skill `openspec-explore` | Think about a problem or idea with the agent before there is a change. It writes nothing unless the user confirms. |
| Propose | the skill `openspec-propose` | Create a change and all of its planning artifacts in one run. |
| Continue | the skill `openspec-continue-change` | Create the next missing artifact, one per run. Not in the core profile. |
| Update | the skill `openspec-update-change` | Revise the artifacts a change has and make them agree. |
| **Apply** | **the skill `openspec-apply-change`** | **Work through the tasks and tick each box when its work is done.** |
| **Validate** | **the command `openspec validate`** | **Check the delta and the main specifications against the format rules. A command, not a workflow.** |
| Sync | the skill `openspec-sync-specs` | Merge a change's delta into the main specifications without archiving it. |
| Archive | the skill `openspec-archive-change` and the command `openspec archive` | Merge the delta unless told not to, count the tasks, and move the change into the archive. |

## 11.1 Apply: working through the tasks

The skill `openspec-apply-change`, as OpenSpec 2.2.0 installs it, tells the agent to carry out the plan one task at a time. The agent selects the change and asks the program for the apply instructions. It reads the context files that the instructions list. Then it works on each pending task in turn. For each task, it shows which task it is on, keeps the change minimal, ticks the box, and asks for the instructions again. It stops and asks in five cases: when a task is unclear, when the work shows a design issue, when a task needs work that the plan does not describe, when an error occurs, and when the developer interrupts. Section 8.1 says who ticks the boxes and what that means for the evidence. This chapter does not repeat it.

The card shows the five rows for apply.

| Item | Apply |
|---|---|
| Entry point | The skill `openspec-apply-change`, called by its name or by the words "openspec apply", "opsx apply" or "openspec implement". The command `openspec instructions apply` serves it. |
| Who acts | The agent works and ticks the boxes. The program reports the state, the progress and the line of each task. The developer decides at each pause. |
| Writes | The work that the tasks name, and a tick in the box of each finished task. |
| What can stop it | A blocked state, a pause that the skill names, an error, or an interruption. |
| The developer's part | To decide at each pause, and to judge each tick against its evidence. |

The table shows the seven stages of the skill, what the tool checks at each, and the question each answers.

| Stage | What the tool checks | The question it answers |
|---|---|---|
| 1. Select the change | `list --json` returns the active changes. | Which change is meant? |
| 2. Check the status to understand the schema | `status --json` returns the schema's name and which artifact holds the tasks. | Which schema is in use, and which file holds the tasks? |
| 3. Get the apply instructions | `instructions apply --json` returns the state, the context files, the progress, and each task with its source path and line. | Can the work begin, and what is the list? |
| 4. Read the context files | Nothing. | What does the plan say? |
| 5. Show the current progress | The count in the same output: the total, the tasks complete and the tasks remaining. | How much is done? |
| 6. Implement the tasks, in a loop | After each tick, `instructions apply` reports the count again. It does not read the work. | Did the tick register? |
| 7. Show the status on completion or pause | The same count, and the state all done when no box is open. | Where does the work stand, and why did it stop? |

The program reports a state and a count, and it checks only that a tick registers. At stage 6, the skill tells the agent to confirm that the box at the returned line still matches the task. The agent then ticks it and asks for the instructions again, to confirm that the task is done and the progress has changed. In a scratch project, ticking one of two boxes changed the count from one complete to two. It changed the state from ready to all done. Each returned line was the line of its box. A paragraph added above the tasks moved both returned lines by two. For this reason, the skill tells the agent to use the line that the program returns, and not a line it remembers. The check is that the box reads as done, not that the work is done. The instructions also return the project's `context` when the configuration has one. The skill says that this and the optional `operationGuidance` input are not evidence of task completion. Section 8.7 describes the three states, and this chapter does not repeat them.

The skill gives the agent two kinds of rule, and the program checks neither. The first is the rule for a tick. Its guardrail in the skill of 2.2.0 reads "Only mark a task `- [x]` when its specified behavior is fully implemented, not when it is partially done or deferred". A box is ticked when the behaviour is fully done, and not before. The second kind is the rules for pausing. A task may need work beyond what the specification and the tasks describe. Or the agent may be tempted to drop, narrow or defer specified behaviour, or to accept an exception to it, to make the work fit. In both cases, the skill tells the agent to report the added scope and ask, and not to include it silently. When the work meets a design issue, the skill tells the agent to suggest updating the artifacts. Each of these is an instruction to the agent. The program has no way to see whether the agent followed it.

The schema defines apply, and apply is not a gate. The schema's `apply` block says three things: what apply requires, which file it tracks, and what instruction it gives. The `spec-driven` schema requires the tasks and tracks `tasks.md`. Its instruction is two sentences. They tell the agent to work on the pending tasks in turn, to mark each one complete, and to pause on a blocker or a need for clarification. This project's `book-change` schema is a fork, as chapter 3 described. Its apply instruction is its own, so a fork changes what apply tells the agent. The skill says that apply can be invoked at any time, as long as tasks exist. This includes the time before every artifact is done. The skill also says that apply can be mixed with updates. In a scratch change that held only a tasks file, `instructions apply` reported the state ready. It listed the proposal, the specification and the design as missing prerequisites. It warned that the change had no delta specification. The program asks for the tasks, not for a complete plan.

The example shows the ticks and no code. Both archived tasks files of the vending machine have every box ticked. The first change's file has three tasks, and the second change's file has five. The second change was made after the first change had been archived, as section 4.8 says. The example has no code, so the archive holds only the ticks and the evidence that each task names. Sections 4.5 and 4.12 show the two files in full, and chapter 8 examines them in detail.

For the developer, apply is where a plan becomes work. The review of what it did is the second review of section 8.5. Commit the repository before the run, so that the diff shows what the run changed. Name the change that the run is for. When the skill pauses, the pause is a question for you. The answers that matter are about scope. A task that needs more than the plan describes is a decision for the developer. A design issue is a reason to revise the artifacts before the work continues. After the run, read the diff beside the ticks, task by task. A box that is ticked with no change in the diff is a question to ask. So is a change that no task names. The state all done means that no box is open. The review that the skill asks for at that point is yours.

## 11.2 Validate: checking the form of the delta

`validate` is a command, and OpenSpec 2.2.0 has no skill for it. The program does the work, and something else runs it. The developer runs it, or a task names it. The skill `openspec-sync-specs` tells the agent to run `openspec validate --specs` after a merge. An agent runs it only when a task or a skill says so. The developer needs to know which form was run, because the forms check different things.

The card shows the five rows for `validate`.

| Item | Validate |
|---|---|
| Entry point | The command `openspec validate`, with a name or an option. It has no skill. |
| Who acts | The program checks. A developer, a task or another workflow runs it. |
| Writes | Nothing. In a scratch project, runs of the plain, strict, bulk and archived forms left every file unchanged. |
| What can stop it | An error, which ends the run with a failure. With `--strict`, a warning does too. A run with no name, no option and no one to ask prints what to try and fails. |
| The developer's part | To read the result, and to know what the form that was run covers. |

A command has no stages. So the table shows its forms, what each checks, and the question each answers.

| Form | What it checks | The question it answers |
|---|---|---|
| `openspec validate <change>` | The change's delta against the form rules of chapter 6, and the main specification that a MODIFIED requirement names. A MODIFIED requirement that the main specification lacks passes, with a note that the archive would refuse the delta. | Is this delta well formed? |
| `openspec validate <specification>` | One main specification against the same rules. | Is this specification well formed? |
| `--changes` | Every active change, with one result for each. Archived changes are not read. | Are all the deltas well formed? |
| `--specs` | Every main specification. | Are all the specifications well formed? |
| `--all` | The active changes and the main specifications. | Is everything well formed? |
| `--strict` | Added to any form: a warning fails as an error does. | Is it free of warnings too? |
| `--json` | Added to any form: the same checks, with the result as data. Each item has its type, whether it is valid, and its issues. Each issue has a level, a path and a message, and the totals follow. | Can a script read the result? |
| `--archived` | The archived changes only: that the `tasks.md` of each has no open box. It reads no delta. | Was every task of each archived change ticked? |

The options `--type`, `--report`, `--concurrency`, `--no-interactive` and `--store` are in the command's help. This chapter does not use them.

`validate` reads the delta and the main specifications. For an active change, the forms above do not open `proposal.md`, `design.md` or `tasks.md`. In a scratch change with no proposal, no design and an empty `tasks.md`, the command reported the change valid. The one form that opens a `tasks.md` is `--archived`, and it opens only archived ones. Chapters 4, 6 and 8 say what each file leaves to a person. Section 6.2 says what the delta is checked for. So chapter 11 adds nothing to them. An error and a warning differ in what they stop. An error fails the run in every form. A warning passes the plain form and fails the strict one. A note changes neither, such as the note for a MODIFIED requirement that is absent.

A pass is about the form of the delta, and the example's first change shows what that leaves out. Both tasks files of the example end with a task that names `openspec validate --strict` passing. That is evidence about the delta and about nothing else. The first change passed validation and every task. Still, a case that no one had written defeated its design. Section 4.5 says so, and section 4.7 goes through the case.

`validate` can be a gate. The command's help describes `--archived` as a check for pre-commit linting. `--json` lets a script read the result as data and not as text. If a form is run before archiving, that form becomes a precondition of the archive. This project's book-change schema asks every change for a review task that runs `openspec validate --all --strict`. That is a use of the command, and not advice about your use of it. The gate checks form. `--all` reads the active changes and the main specifications, so it opens no archived `tasks.md`. That check is the form `--archived`. Run against the example, `--archived` passed both archived changes, because both files have all their boxes ticked.

For the developer, `validate` is a quick check with a narrow answer. Know which form you ran. Read the whole result, not only the last line. An error, a warning and a note mean different things, and the note is the only place where the command says that the archive would refuse a delta. Run it again after any change to a delta, because a pass before the change says nothing about the delta after it. When the result is a pass, say what it covers: the delta is well formed. It says nothing about the design, the tasks or the work.

## 11.3 What apply and validate do not check

Neither apply nor `validate` checks that the work is right. Apply's result is ticks. The work is the agent's, and the program counts and reports. `validate` is structural, and it depends on neither the design nor the tasks of the change. No workflow in this chapter runs a project's tests or turns a scenario into a test. A specification defines the expected behaviour, and tests and verification still have to check it, as chapter 2 says. A pass of validation is no verdict on the requirements, as chapter 3 says. A project that has code has its own tests, and the example has none.

## 11.4 Reviewing what apply and validate did

This review asks whether apply and `validate` did what their rules say. It does not ask whether the work is right. That question is for the project's own tests and for the second review of section 8.5. The review has four passes. Evidence asks whether each tick is backed by evidence that could have failed, as section 8.5 describes. Scope asks whether anything was done that the plan does not name, or dropped that the plan does name. Form asks whether `validate` was run, in which form, and on what. Return asks whether a design issue found in the work went back to the artifacts. Evidence and Scope matter most. The program counts the ticks and checks the form, and it sees neither evidence nor scope.

The table is one checklist, in the order in which the work is done.

| Check | The workflow has done its job when | How a run can fail |
|---|---|---|
| The request is answered as meant | A reviewer can say which change and which tasks the run answers, and the work follows the plan, not an assumption | The run serves the tasks of another change, or an assumption that the developer did not make |
| Apply read the context files and worked task by task | Each task has its own change in the diff, in the order of the list | One change covers several tasks, or boxes were ticked together after the work |
| Each tick matches its task and its evidence | Each tick has its evidence where its task says to look, and the evidence could have failed | A ticked box lacks the evidence that its task names, or the evidence is the work itself |
| No behaviour was narrowed or deferred | Each behaviour that the delta names is in the work, and any added scope was put to the developer | A behaviour was dropped, narrowed or deferred under a ticked box, or work that no task names was done |
| A pause was resolved by the developer | Each question that the work raised has an answer from the developer, in the conversation or in an artifact | A question was settled without the developer, or the answer stayed in the conversation and no file holds it |
| A design issue went back to the artifacts | The artifacts say what the work now does, and the boxes that depended on the old plan were reopened | The work avoided the issue, and the design still states the old decision |
| `validate` was run in the form the project uses | The form is the one that the project names, run on the files as they are now | A form that does not read the changed files was run, or the result is older than the last change to the delta |
| The result is read as being about form | The pass is reported as covering the delta and the main specifications | A pass is read as showing that the design, the tasks or the work are right |
| Downstream | Every box is ticked with its evidence and the delta is valid, so the change is ready for archive | The count is complete and the delta is valid, and neither says that the work is right |

The table is a memory aid, and no part of the tool reads it. A reader can take a complete count and a pass as the whole of the review, and neither is. A result is accepted when a person has read what is behind it.

For both apply and `validate`, the developer can follow one routine:

1. Commit the repository before apply runs, so that the run's changes show as one diff.
2. Name the change that the run is for, and read its tasks first, so that you know what evidence each tick should have.
3. Answer each pause as a decision. If the work shows a design issue, revise the artifacts before apply continues.
4. After the run, read the diff beside the ticks, task by task, and open the evidence that each task names.
5. Run `validate` in the form the project uses, and read the whole result, including any note.
6. Commit once you have read the result, so that the next run starts from a state that has been reviewed.

## 11.5 Changing the result

When the review finds that apply or `validate` went wrong, two decisions follow. The first is what the revision covers. The second is who makes it. The first depends on how far the work has gone.

| What exists | What the revision covers |
|---|---|
| No box ticked | An edit of the plan, by the paths of the chapter on that artifact, and then apply from the start. |
| Some boxes ticked | The same edit, and the ticked tasks that depend on it are reopened, as section 8.6 says. |
| Every box ticked | The same, and apply is run again. In a scratch change, one reopened box changed the state from all done back to ready. |
| A failing validation | A fix in the delta, by the path of chapter 6, and validation run again. |
| The change archived | Nothing in the archive. The correction is a new change. |

The example shows the last row and none of the others. Section 4.8 says that the first change was corrected in a second change, because the first had been archived. Section 8.6 says that the first change's list was left unchanged, with all its boxes still ticked. The other rows are absent from the archive. Section 8.6 gives the reason for its own middle row. A failing validation writes no file for an archive to keep.

The second decision is about the means. The developer can revise the files by hand, or can ask the agent to run the workflow again. The two means differ in cost and in how they fail.

| | The developer revises by hand | The agent is asked to run the workflow again |
|---|---|---|
| Right when | One box or one word is wrong and the developer knows the replacement | A task has to be done again, or several tasks and the work have to change together |
| What it costs | The developer's reading of each task that depends on the one changed | A run, and a request that says which tasks to redo and what must not change |
| How it goes wrong | A dependent box is left ticked on evidence that no longer fits | The box is ticked again over the same evidence, or the run does more than the request named |
| What to check afterwards | The diff, and each box that depends on the one changed | Each reopened box against its new evidence, and the files outside the tasks that the run named |

Suppose the developer revises the design of a vending machine change, so that the machine checks the coins it holds before it accepts the payment. The developer then finds that the ticked task that traces a scenario through the design no longer fits. By hand, the developer reopens the box and rewrites the task so that it names the revised design. The diff shows the box and the words. It does not show that a later box was ticked based on the trace that has changed.

Suppose apply stops over a design issue, as the skill's rule for a pause allows. The developer revises the plan with the update workflow, as the previous chapter described, and then asks for apply again. The boxes that were ticked against the old plan are the ones to reopen before the work continues.

Both means are checked in the same way: by the diff, and by running `validate` again for the delta. For an active change, the program reads neither the tasks nor the design, so a pass is about the delta's form alone. A revision to a tick is read as a new draft, with the passes of the review above.

## 11.6 What apply and validate pass on

Apply and `validate` pass two things to archive: a ticked list and a delta that is well formed. Neither is a statement about the work or about the evidence behind it. A reviewer who takes the two results as the whole review passes archive a change that has not been checked.

The next chapter discusses the workflows that merge the delta and close the change: sync and archive.

Apply is an agent that works to a skill's rules while the program counts the boxes. `validate` is the program checking the form of the delta and the main specifications. Neither reads whether the work is right. A change whose boxes are all ticked and whose delta passes has a count and a pass. The evidence and the scope behind them are for the developer to review.
