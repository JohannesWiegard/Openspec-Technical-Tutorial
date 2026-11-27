# 10. The Planning Workflows and What Each Leaves Behind

The previous chapter said who does the work in general: the agent writes, the commands report facts and check, and the developer decides and reviews. This chapter takes the four workflows that write or revise a change's plan, which are explore, propose, continue and update. For each it asks what the developer does, what the workflow writes, how a reviewer judges what it did, and what happens when its result is wrong. The chapters on the four artifacts showed what the files contain. This chapter shows what creates them and what the developer does while they are made.

## 10.1 Explore: thinking before there is a change

The skill `openspec-explore`, as OpenSpec installs it, calls itself "a stance, not a workflow". In explore the agent thinks with the developer, reads the project before asking what it can find out itself, asks one question at a time, and never writes code. Writes are allowed only within a scope the developer has confirmed. Before the first write, the agent names the files and asks a yes or no in a separate message. An answer to a design question is never consent.

The card sets out the five rows that every workflow's card has.

| Item | Explore |
|---|---|
| Entry point | The skill `openspec-explore`, called by naming it or by the words "openspec explore" or "opsx explore". |
| Who acts | The agent reads, asks and draws. The developer, as the last row says. |
| Writes | Nothing, except what the next table allows. |
| What can stop it | A project with no OpenSpec root, where the agent sets nothing up, and the lack of a yes before a write. |
| The developer's part | To steer the thinking, to decide when it is enough, and to say yes or no to a write. |

Explore has no stages to list, so the table says what it may do and what allows each thing.

| What explore may do | What allows it | What is checked |
|---|---|---|
| Read files and run read-only commands | Nothing is needed; a read needs no confirmation | `list`, `list --specs` and `show` change no file. |
| Scaffold a change | The developer's request to capture the exploration, or a yes to an offer that named the change | `new change` refuses a name already in use. |
| Write the artifacts the request names | The same request or yes, for those artifacts only | Nothing at the write. `status` later counts a file as done if it exists. |
| Write anything else | Nothing allows it | Nothing. |

The commands explore runs give read-only facts: the changes in flight with their task counts, the capabilities, and the text of one specification. None of them changes a file. Nothing checks that explore stays read-only. In a directory with no root, the commands answer `no_openspec_root` and create nothing.

Explore leaves nothing unless something is captured. It ends when the developer asks for the exploration to be captured as a change. That request needs no separate yes: the agent creates that change and writes the artifacts the request names, and nothing else. Explore ends in a proposal, in updated artifacts, or in clarity and nothing more.

## 10.2 Propose: the whole plan in one run

Propose creates a change and writes every artifact the change needs in one run. The agent asks the developer only about an ambiguity that would change the scope, the observable behaviour, the compatibility or the acceptance criteria. It makes a reasonable assumption for a minor detail and records it in the artifacts. The request authorizes planning only. The agent stops once the artifacts exist and does not implement what the request asked to build. Sections 5.1, 6.1, 7.1 and 8.1 say who writes each artifact and what the developer's part is in it, and this chapter does not repeat them.

| Item | Propose |
|---|---|
| Entry point | The skill `openspec-propose`, called by naming it or by the words "openspec propose" or "opsx propose". |
| Who acts | The agent writes, and runs the commands of the stages below. |
| Writes | The change's folder and its `.openspec.yaml`, and every artifact in the required set, except one whose own instruction makes it conditional and that the agent reports as skipped. |
| What can stop it | A question the agent asks about an ambiguity, the answer `no_openspec_root` at stage 2, and the refusal of a name at stage 4. |
| The developer's part | The request, the answers to the questions, the assumptions in the drafts, and the review of each draft. |

The table sets out the seven stages of the skill.

| Stage | What happens |
|---|---|
| 1. Understand the request and clarify material ambiguity | The agent derives a name for the change from the request. It asks the developer about an ambiguity that would change the scope, the observable behaviour, the compatibility or the acceptance criteria, and assumes a minor detail and records the assumption. |
| 2. Load project context | `context --json` returns the project's root, and the agent reads its `openspec/config.yaml`. Where there is no root, the command answers `no_openspec_root`, and the agent stops and changes no file. |
| 3. Determine the workflow schema | The project's default schema is used. Only when the developer names another or asks which schemas exist does the agent run `schemas --json`, which lists each schema and its artifacts. |
| 4. Create the change directory | `new change` creates the folder with its `.openspec.yaml` under the name from stage 1, and refuses a name already in use. In a directory with no root it creates a root as well, which is why stage 2 checks for one. |
| 5. Get the artifact build order | `status --json` returns each artifact's status, the artifacts it requires, and `applyRequires`, the artifacts apply needs. From it the agent works out which artifacts the change needs and which can be written now. |
| 6. Create every artifact in the required set | For each artifact that is ready, `instructions <artifact> --json` returns the template and the instruction, and the agent reads the files it depends on from disk, inspects the project, and writes the file from the template. `status` then reports which artifacts are ready now, counting a file as done if the file exists, until every artifact in the required set exists. |
| 7. Show final status | `status` reports each artifact and whether planning is complete, and the agent shows its output to the developer. |

For each artifact, `instructions` returns the template, the schema's instruction, the artifacts it depends on and the path of its file. When `openspec/config.yaml` has a `context` or `rules`, the command returns them too. They are constraints for the agent and are not to be copied into the file, and nothing checks that they were not.

What propose leaves is a folder of files. In a scratch project, a new change holds `.openspec.yaml` alone, and the proposal is the only ready artifact. After the proposal, the specification and the design are ready. A specification is done as soon as one file matches its path, however many the proposal named. A file of one character also counts as done. A change that declares `skip_specs` shows the specification as skipped from the start. Chapter 4 shows the four files of each of the example's two changes in full.

For the developer, propose is one session of reading. The four drafts arrive together, so the review covers all of them at once. The minor assumptions are the part to check, because a reader who does not look for them will miss them. In the output of `status`, an artifact shown as skipped was skipped on the agent's reading of its own instruction. In the default schema the design is the artifact whose instruction makes it conditional, so decide whether you agree with the skip.

## 10.3 Continue: one artifact at a time

Continue writes one artifact per run and then stops. Which artifact comes next is not the agent's choice: it is the first one that `status` reports as ready. If an earlier run stopped part way through a specification, finishing it counts as the run's one artifact. If planning is already complete, the agent says so and writes nothing.

| Item | Continue |
|---|---|
| Entry point | The skill `openspec-continue-change`, called by naming it or by the words "openspec continue" or "opsx continue". It is installed only in a profile that adds it. |
| Who acts | The agent writes the artifact that `status` reports as ready next. |
| Writes | One artifact per run: the first that is ready, or the missing files of a specification that is partly written. |
| What can stop it | Planning that is already complete, and no artifact that is ready. |
| The developer's part | To choose the change when several are in flight, to read each draft before asking for the next, and to decide the pace. |

The skill has four stages.

| Stage | What happens |
|---|---|
| 1. Select the change | The agent uses the change the developer names, infers it from the conversation, or takes the only change in flight. Otherwise `list --json` returns the changes in flight, the latest modified first, and the developer chooses. |
| 2. Check current status | `status --json` returns each artifact as done, ready, blocked or skipped, and whether planning is complete, and the agent reads from it what is next. |
| 3. Act based on status | A specification that an earlier run left partly written is finished first. If planning is complete, the agent says so and stops. Otherwise it takes the first ready artifact, runs `instructions` for it as at stage 6 of propose, reads the files it depends on from disk, writes the file, and stops after that one artifact. |
| 4. After creating an artifact, show progress | `status` shows the artifact just written as done and the artifacts that are ready now, and the agent shows the developer what the new file unlocked. |

The order in which artifacts become ready is the one section 10.2 found: the tasks wait for the specification and the design, and a skipped artifact never becomes ready. The order of writing therefore follows the schema, and not the agent.

For the developer, continue gives a review point after each artifact, at the price of one run for each. Read each draft before you ask for the next, because the next artifact is written from it. There is one thing `status` cannot show. A run that was interrupted after one of three specification files leaves the specification looking finished, so count the files against the capabilities the proposal lists, one `spec.md` for each, as chapter 6 said.

## 10.4 Update: revising what exists

Update revises the artifacts that exist and keeps them coherent. The agent drafts every revision in the conversation first, writes a file only after the developer confirms its revision, one artifact at a time, and never edits code. When the request changes the intent of the change rather than its detail, the agent recommends a new change under a new name.

| Item | Update |
|---|---|
| Entry point | The skill `openspec-update-change`, called by naming it or by the words "openspec update change" or "opsx update". It is not the command `openspec update`. |
| Who acts | The agent drafts and reconciles. The developer, as the last row says. |
| Writes | The artifact files that exist, and never code. After a confirmation, a missing file under a specification that already has one. |
| What can stop it | A revision the developer rejects, and a request that changes the intent. |
| The developer's part | The revision, the confirmation of each write, and the call on whether the intent has changed. |

The skill has six stages.

| Stage | What happens |
|---|---|
| 1. Select the change | As at stage 1 of continue. |
| 2. Get the change's artifacts | `status --json` returns each artifact's status and the files that exist, and the agent takes the files to revise from its output and not from assumed names. |
| 3. Understand the request | The agent decides whether the developer asked for a specific revision or only for the artifacts to be made to agree. |
| 4. Read and reconcile | The agent reads the artifacts, drafts the requested edit in the conversation and not in a file, and checks every other existing artifact against it, in either direction. It notes what is now inconsistent or missing. |
| 5. Confirm and apply, one artifact at a time | The agent shows each proposed revision with its reason, writes it only after the developer confirms, and leaves a rejected one unwritten. Before a substantial rewrite it runs `instructions`, which returns the template and the rules. Nothing checks the confirmation. |
| 6. Point to what comes next | The agent names the workflow that follows and does not start it. If tasks are already ticked, it tells the developer which may need revisiting. |

The decisions in update are the agent's reading and the developer's confirmation, and nothing checks either.

In a scratch change whose tasks exist, an edit to the design changes no status, because every file still exists and every artifact is still done.

For the developer, update is where the reading happens, and no tool does it for you. Name the file and say what must not move. Chapter 5 shows what happens when a request leaves that out. Read every proposed revision, including those to files you did not name, because a revision to one of them may be one you did not ask for. Reject any revision that goes beyond the request. If your request changes what the change is for, do not push it through update. Take the recommendation of a new change, so that the archive keeps the old change as it was.

## 10.5 What the planning workflows leave out

No planning workflow decides that the plan is right. What is reported is that files exist. `status` reads no artifact for its content, and `validate` reads the delta and the main specifications and never the other three artifacts of a change in flight, as chapter 5 showed. The agent asks about an ambiguity and, in explore and update, asks for a write to be confirmed. That is the agent asking, not a check. Chapter 8 said that the tool counts the boxes in the tasks and nothing more. The review of the content is the developer's.

Continue is not in the core profile, so a project on that profile has propose and update and no continue. The choice between propose and continue is a choice about review points, which sections 10.2 and 10.3 set out. Neither is better in itself. The difference is where the developer reads.

## 10.6 Reviewing what a planning workflow did

This review asks whether the workflow did what its skill describes. It does not ask whether the file is right, which the checklists of the four artifact chapters do. It has four passes. Authority asks whether each write was asked for or confirmed. Coverage asks whether every artifact the plan needs exists and whether each was written from the one it depends on. Record asks whether every decision made in the conversation reached a file. Order asks whether each artifact was written after the ones it depends on. Record and Authority matter most, because no check sees who asked for a write or a decision that stayed in the conversation, and a decision that stays there is not in the archive.

The table is one checklist, ordered the way a change is made.

| Check | The workflow has done its job when | How a run can fail |
|---|---|---|
| The request is answered as meant | A reviewer can say which request the run answers, and nothing in the files answers an assumption made instead | The run serves an assumption the developer did not make, and every artifact after it follows the assumption |
| Explore kept to what it may write | Every file explore wrote is one that the table in section 10.1 allows | A file was written on the strength of an answer to a design question, or beyond what the confirmation named |
| Propose wrote what its card names | Nothing is missing that the card names, and nothing outside the change's folder was edited | An artifact is missing though no skip was reported, or code was edited because the request asked for something to be built |
| Continue wrote what its card names | The run wrote what the card names and nothing more | Two artifacts were written in one run, or one was written before the ones it depends on |
| Update wrote what was confirmed | Each changed file is one whose revision the developer confirmed | A file changed that was not shown, or a rejected revision was written anyway |
| No context or rules text was copied into an artifact | The artifacts say what the change is and do not repeat the project's constraints | A constraint from the configuration was copied into a file as if it were content |
| A decision made in the conversation is in a file | Each decision the developer remembers making is written in the artifact that owns it | The decision was settled in the conversation and no file records it, so the archive will not hold it |
| Downstream | The artifacts are ready for the reviews of the four artifact chapters | Every file exists, and the plan has still not been reviewed |

The table is a memory aid, and no part of the tool reads it.

Across the four workflows the developer can follow one routine:

1. Commit the repository before a run, so that the run's changes show as one diff.
2. Say in one sentence what the run is for.
3. After the run, read `status` and the list of changed files. A changed file outside the change's folder, or any change under code, is a reason to stop and ask.
4. Read the drafts in dependency order: the proposal first, then the artifacts written from it.
5. Confirm, or revise. Revise by hand when the fix is one phrase. Ask for a revision when several files have to agree.
6. Commit again once the drafts are read, so that the next run starts from a state that has been reviewed.

## 10.7 Changing the result

When the review finds that a planning workflow went wrong, two decisions follow: what the revision covers, and who makes it. The first depends on what already exists.

| What exists | What the revision covers |
|---|---|
| Only an exploration, with nothing written | Nothing to revise. The conversation continues, or propose writes the plan. This is a new run and not an edit. |
| Drafts written and not yet reviewed | An edit to the draft at its own part, by the paths of the chapter on that artifact. |
| Drafts reviewed, and later artifacts written from them | An update that reconciles forwards: the artifacts written from the changed one are revised too, by the paths of the chapters on those artifacts. |
| Tasks ticked, and apply begun | The update, and then a check of what apply has done. The skill says that the code may no longer match the revised plan. |
| The change archived | Nothing in the archive. The correction is a new change. |

The example's archive holds no revision of a draft, so of these rows it shows only the last: section 4.8 of chapter 4 says that the correction of the first change was made in a second change, because the first had been archived.

The second decision is about the means. The developer can revise the artifact by hand, or can ask the agent to run the workflow again. They differ in cost and in how they go wrong.

| | The developer revises by hand | The agent is asked to run the workflow again |
|---|---|---|
| Right when | The edit is one phrase that the developer can write without help | Several artifacts have to agree, or the right text has to be worked out from the others |
| What it costs | The developer's reading of every artifact that depends on the one changed | A confirmation for each write, and a request that says what is not to move |
| How it goes wrong | A dependent artifact is left as it was, so the files disagree | The agent's reconciling misses a file, or a confirmation is given without reading what it confirms |
| What to check afterwards | The diff, and each artifact written from the one that changed | Each confirmed diff, and the artifacts that were not named |

Suppose the developer changes one decision in the design of a vending machine change, so that the machine works out the change before it releases the product, and edits nothing else. By hand, the tasks are left as they were. `status` still shows every artifact done, and the tasks still check the order the design had before. The diff of the design shows the new decision and does not show the task that checks the old one.

Suppose the developer, instead, asks the update workflow to make the tasks agree with the changed decision. The tasks that checked the old decision are among the revisions the agent proposes, and the developer decides which to confirm. They are reopened or rewritten, and a ticked box is the part that the diff shows least.

Both means are checked in the same way: by the diff, and by reading what depends on the file that changed, because the diff shows words and not whether the artifacts agree. A revision is read as a new draft, with the passes of the review above.

## 10.8 What the planning workflows hand on

The planning workflows hand the plan to apply. The artifacts are its input, and apply requires the tasks. What it reads is the proposal, the specification, the design and the tasks. A plan that the developer has not reviewed is passed on as it is.

The next chapter takes the workflow that does the work and the command that checks the plan: apply and `validate`.

The planning workflows write a plan, and what is checked is only which files of it exist, so the plan is the developer's to judge. A change whose artifacts all exist is not a change whose plan is right.
