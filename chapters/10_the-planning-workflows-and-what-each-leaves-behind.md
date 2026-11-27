# 10. The Planning Workflows and What Each Leaves Behind

The previous chapter said who does the work in general: the agent follows a skill, the program reports facts and checks, and the developer decides and reviews. This chapter takes the four workflows that write or revise a change's plan, which are explore, propose, continue and update. For each it asks what the developer does, what the workflow writes, how a reviewer judges what it did, and what happens when its result is wrong. The chapters on the four artifacts showed what the files contain. This chapter shows what creates them and what the developer does while they are made.

The table lists the workflows and the `validate` command again. The four that this chapter takes are in bold.

| Workflow | Entry point | What it does |
|---|---|---|
| **Explore** | **the skill `openspec-explore`** | **Think about a problem or idea with the agent before there is a change. It writes nothing unless the user confirms.** |
| **Propose** | **the skill `openspec-propose`** | **Create a change and all of its planning artifacts in one run.** |
| **Continue** | **the skill `openspec-continue-change`** | **Create the next missing artifact, one per run. Not in the core profile.** |
| **Update** | **the skill `openspec-update-change`** | **Revise the artifacts a change has and make them agree.** |
| Apply | the skill `openspec-apply-change` | Work through the tasks and tick each box when its work is done. |
| Validate | the command `openspec validate` | Check the delta and the main specifications against the format rules. A command, not a workflow. |
| Sync | the skill `openspec-sync-specs` | Merge a change's delta into the main specifications without archiving it. |
| Archive | the skill `openspec-archive-change` and the command `openspec archive` | Merge the delta unless told not to, count the tasks, and move the change into the archive. |

## 10.1 Explore: thinking before there is a change

The skill `openspec-explore`, as OpenSpec installs it, calls itself "a stance, not a workflow", and it has no stages. It tells the agent to think with the developer, to read the project before asking what it can find out itself, to ask one question at a time, and never to write code. It allows writes only within a scope the developer has confirmed. Before the first write, the agent names the files and asks a yes or no in a separate message. An answer to a design question is never consent. The one exception is the developer's own request to capture the exploration as a change, which covers that change and the artifacts the request names.

The card sets out the five rows that every workflow's card has.

| Item | Explore |
|---|---|
| Entry point | The skill `openspec-explore`, called by naming it or by the words "openspec explore" or "opsx explore". |
| Who acts | The agent reads, asks and draws. The program answers read-only commands. The developer steers and confirms any write. |
| Writes | Nothing, or the change and the artifacts that the developer confirmed. |
| What can stop it | A project with no OpenSpec root, where the skill tells the agent to set nothing up, and the lack of a yes before a write. |
| The developer's part | To steer the thinking, to decide when it is enough, and to say yes or no to a write. |

Explore has no stages to list, so the table says what it may do and what allows each thing.

| What explore may do | What allows it | What the tool checks |
|---|---|---|
| Read files and run read-only commands | The skill, which needs no confirmation for a read | `list`, `list --specs` and `show` change no file. |
| Scaffold a change | The developer's request to capture the exploration, or a yes to an offer that named the change | `new change` refuses a name already in use. |
| Write the artifacts the request names | The same request or yes, for those artifacts only | Nothing at the write. `status` later counts a file as done if it exists. |
| Write anything else | Nothing allows it | Nothing. |

The program contributes read-only facts: the changes in flight with their task counts, the capabilities, and the text of one specification. None of them changes a file. Nothing in the program keeps explore read-only; the stance is the skill's, and the program cannot see whether it was kept. In a directory with no root, the program answers `no_openspec_root` and creates nothing.

Explore leaves nothing unless something is captured. It ends when the developer asks for the exploration to be captured as a change: the agent then creates that change and writes the artifacts the request names, and nothing else. The skill ends in a proposal, in updated artifacts, or in clarity and nothing more. A decision that stays in the conversation is not in the archive, which chapter 3 said and this chapter does not repeat.

## 10.2 Propose: the whole plan in one run

The skill `openspec-propose` creates a change and writes every artifact the change needs in one run, in seven numbered stages. The agent asks the developer only about an ambiguity that would change the scope, the observable behaviour, the compatibility or the acceptance criteria. It makes a reasonable assumption for a minor detail and records it in the artifacts. The request authorises planning only. The skill tells the agent to stop once the artifacts exist and not to implement what the request asked to build. Sections 5.1, 6.1, 7.1 and 8.1 say who writes each artifact and what the developer's part is in it, and this chapter does not repeat them.

The card sets out the five rows for propose.

| Item | Propose |
|---|---|
| Entry point | The skill `openspec-propose`, called by naming it or by the words "openspec propose" or "opsx propose". |
| Who acts | The agent writes. The program supplies the root, the build order, and the template and instruction of each artifact. |
| Writes | The change's folder and its `.openspec.yaml`, and every artifact in the required set, except one whose own instruction makes it conditional and that the agent reports as skipped. |
| What can stop it | A project with no root, a name already in use, and a question the agent asks about an ambiguity. |
| The developer's part | The request, the answers to the questions, the assumptions in the drafts, and the review of each draft. |

The table sets out the seven stages of the skill, what the tool checks at each, and the question each answers.

| Stage | What the tool checks | The question it answers |
|---|---|---|
| 1. Understand the request and clarify material ambiguity | Nothing. | What is wanted, and what would change the scope if it were guessed wrong? |
| 2. Load project context | `context --json` returns the root, or `no_openspec_root` when there is none. | Is there a project here, and what constraints does it set? |
| 3. Determine the workflow schema | `schemas --json` lists each schema and its artifacts. | Which artifacts will this change have? |
| 4. Create the change directory | `new change` creates the folder and refuses a name already in use. Where there is no root, it creates one, so stage 2 comes first. | Is there a place for the change? |
| 5. Get the artifact build order | `status --json` returns each artifact's status, what it requires and `applyRequires`. | What can be written now, and what must exist before apply? |
| 6. Create every artifact in the required set | `instructions <artifact> --json` returns the template and the instruction. `status` runs again after each write. | What goes into this file? |
| 7. Show final status | `status` reports each artifact and whether planning is complete. | Is every artifact in the required set there? |

For each artifact, `instructions` returns the template, the schema's instruction, the artifacts it depends on and the path of its file. When `openspec/config.yaml` has a `context` or `rules`, the command returns them too. The skill tells the agent that these are constraints and must not be copied into the file. The program does not check that they were not.

What propose leaves is a folder of files, and the program knows only whether each file exists. In a scratch project, a new change holds `.openspec.yaml` alone, and the proposal is the only ready artifact. After the proposal, the specification and the design are ready. A specification is done as soon as one file matches its path, however many the proposal named. A file of one character also counts as done. A change that declares `skip_specs` shows the specification as skipped from the start. Chapter 4 shows the four files of each of the example's two changes in full.

For the developer, propose is one session of reading. The four drafts arrive together, so the review covers all of them at once. Read the proposal first, because the other three are written from it. The minor assumptions are the part to check. The skill tells the agent to record them in the artifacts, and a reader who does not look for them will miss them. Then read the status. An artifact shown as skipped was skipped on the agent's reading of its own instruction. In the default schema the design is the artifact whose instruction makes it conditional, so decide whether you agree with the skip. Finally, check the working tree. A propose run should change only the new change's folder. Commit the repository before the run, so that the diff shows what the run wrote.

## 10.3 Continue: one artifact at a time

The skill `openspec-continue-change` writes one artifact per run and then stops. It takes the first artifact whose status is ready, reads the files it depends on from disk, writes the file, and shows what the file unlocked. If an earlier run stopped part way through a specification, the skill tells the agent to finish it first, and that counts as the run's one artifact. If planning is already complete, the agent says so and writes nothing. When more than one change is in flight, the skill asks the developer which one to continue.

The card sets out the five rows for continue.

| Item | Continue |
|---|---|
| Entry point | The skill `openspec-continue-change`, called by naming it or by the words "openspec continue" or "opsx continue". It is installed only in a profile that adds it. |
| Who acts | The agent writes. The program reports the status and supplies the template and instruction. |
| Writes | One artifact per run: the first that is ready, or the missing files of a specification that is partly written. |
| What can stop it | Planning that is already complete, and no artifact that is ready. |
| The developer's part | To choose the change when several are in flight, to read each draft before asking for the next, and to decide the pace. |

The table sets out the four stages of the skill, what the tool checks at each, and the question each answers.

| Stage | What the tool checks | The question it answers |
|---|---|---|
| 1. Select the change | `list --json` returns the changes in flight, the latest modified first. | Which change is meant? |
| 2. Check current status | `status --json` returns each artifact as done, ready, blocked or skipped, and whether planning is complete. | What is next, and is anything left to write? |
| 3. Act based on status | `instructions <artifact> --json` returns the template and the instruction. | What goes into this file? |
| 4. After creating an artifact, show progress | `status` runs again and shows the artifact just written as done, and what it unlocked. | What does the new file unlock? |

The program decides what is next. The proposal is ready first. The specification and the design become ready after it, and the tasks wait for both. A skipped artifact never becomes ready. The order of writing therefore follows the schema, and not the agent.

For the developer, continue gives a review point after each artifact, at the price of one run for each. Read each draft before you ask for the next, because the next artifact is written from it. There is one thing `status` cannot show. A specification reads done after one file, so after a run that was interrupted, count the files against the capabilities the proposal lists. The rule is one `spec.md` for each capability, as chapter 6 said. A run that wrote one of three files leaves the specification looking finished. Ask for the next artifact only when the draft you have is one you accept.

## 10.4 Update: revising what exists

The skill `openspec-update-change` revises the artifacts that exist and keeps them coherent. It drafts the requested edit in the conversation, checks every other existing artifact against it in either direction, and shows each proposed revision with its reason. It writes only after the developer confirms, one artifact at a time, and it never edits code. When the request changes the intent of the change rather than its detail, the skill tells the agent to recommend a new change under a new name.

The card sets out the five rows for update.

| Item | Update |
|---|---|
| Entry point | The skill `openspec-update-change`, called by naming it or by the words "openspec update change" or "opsx update". It is not the command `openspec update`. |
| Who acts | The agent drafts and reconciles. The developer confirms each write. The program reports which files exist. |
| Writes | The artifact files that exist, and never code. After a confirmation, a missing file under a specification that already has one. |
| What can stop it | A revision the developer rejects, and a request that changes the intent. |
| The developer's part | The revision, the confirmation of each write, and the call on whether the intent has changed. |

The table sets out the six stages of the skill, what the tool checks at each, and the question each answers.

| Stage | What the tool checks | The question it answers |
|---|---|---|
| 1. Select the change | `list --json` returns the changes in flight, the latest modified first. | Which change is meant? |
| 2. Get the change's artifacts | `status --json` returns each artifact's status and the files that exist. | Which files can be revised? |
| 3. Understand the request | Nothing. | Is this a specific revision, or a check that the artifacts agree? |
| 4. Read and reconcile | Nothing. The reading is the agent's. | What else does the revision make wrong? |
| 5. Confirm and apply, one artifact at a time | Nothing. The confirmation is the developer's. `instructions` is called only for a substantial rewrite. | Is each proposed revision accepted? |
| 6. Point to what comes next | Nothing. | Which workflow follows? |

Four of the six stages say "Nothing", and that is the point of the table. The decisions are the agent's reading and the developer's confirmation.

The program tracks files and not agreement. In a scratch change whose tasks exist, an edit to the design changes no status, because every file still exists and every artifact is still done.

For the developer, update is where the reading happens, and no tool does it for you. Name the file and say what must not move. Chapter 5 shows what happens when a request leaves that out. Read every proposed revision, including those to files you did not name, because the skill checks the other artifacts in either direction and a revision to one of them may be one you did not ask for. Reject any revision that goes beyond the request. If your request changes what the change is for, do not push it through update. Take the skill's recommendation and start a new change, so that the archive keeps the old one as it was.

## 10.5 What the planning workflows leave out

No planning workflow decides that the plan is right. The program reports that files exist. `status` reads no artifact for its content, and `validate` reads the delta and the main specifications and never the other three artifacts of a change in flight, as chapter 5 showed. The skills tell the agent to ask about an ambiguity and, in explore and update, to confirm a write. That is the agent asking, not the program checking. Chapter 8 said that the tool counts the boxes in the tasks and nothing more. The review of the content is the developer's, with the checklists of the four artifact chapters.

Continue is not in the core profile, and the choice between propose and continue is a choice about review points. A project on the core profile has propose and update and no continue. Propose writes every artifact in one run, so the first review is of all of them together. Continue gives a review between artifacts, at the price of one run for each. Neither is better in itself. The difference is where the developer reads.

## 10.6 Reviewing what a planning workflow did

This review asks whether the workflow did what its skill told the agent to do. It does not ask whether the file is right, which the checklists of the four artifact chapters do. It has four passes. Authority asks whether each write was asked for or confirmed. Coverage asks whether every artifact the plan needs exists and whether each was written from the one it depends on. Record asks whether every decision made in the conversation reached a file. Order asks whether each artifact was written after the ones it depends on, with the project's context and rules kept out of it. Record and Authority matter most, because the program sees neither. It sees which files exist and which artifacts are blocked. It does not see who asked for a write, or a decision that stayed in the conversation.

The table is one checklist, ordered the way a change is made.

| Check | The workflow has done its job when | How a run can fail |
|---|---|---|
| The request is answered as meant | A reviewer can say which request the run answers, and nothing in the files answers an assumption made instead | The run serves an assumption the developer did not make, and every artifact after it follows the assumption |
| Explore wrote nothing without a yes | Every file explore wrote is one the developer asked for or confirmed | A file was written on the strength of an answer to a design question, or beyond what the confirmation named |
| Propose wrote the required set and implemented nothing | Each artifact of the required set exists or was reported as skipped, and nothing outside the change's folder was edited | An artifact is missing though no skip was reported, or code was edited because the request asked for something to be built |
| Continue wrote one artifact | One new artifact exists since the last run, and it is the first that was ready | Two artifacts were written in one run, or one was written before the ones it depends on |
| Update changed only what was confirmed, and no code | Each changed file is one whose revision the developer confirmed, and no code changed | A file changed that was not shown, or a rejected revision was written anyway |
| No context or rules text was copied into an artifact | The artifacts say what the change is and do not repeat the project's constraints | A constraint from the configuration was copied into a file as if it were content |
| A decision made in the conversation is in a file | Each decision the developer remembers making is written in the artifact that owns it | The decision was settled in the conversation and no file records it, so the archive will not hold it |
| Downstream | The artifacts are ready for the reviews of the four artifact chapters | Every file exists, and the plan has still not been reviewed |

The table is a memory aid, and no part of the tool reads it. A change whose status shows every artifact done has its files, and not necessarily a reviewed plan.

Across the four workflows the developer can follow one routine:

1. Commit the repository before a run, so that the run's changes show as one diff.
2. Say in one sentence what the run is for, and what must not change.
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

The example shows the last row and none of the others. Section 4.8 of chapter 4 says that the correction of the first change was made in a second change, because the first had been archived. The archive holds no revision of a draft, so the other rows are described and not shown.

The second decision is about the means. The developer can revise the artifact by hand, or can ask the agent to run the workflow again. They differ in cost and in how they go wrong.

| | The developer revises by hand | The agent is asked to run the workflow again |
|---|---|---|
| Right when | The edit is one phrase that the developer can write without help | Several artifacts have to agree, or the right text has to be worked out from the others |
| What it costs | The developer's reading of every artifact that depends on the one changed | A confirmation for each write, and a request that says what is not to move |
| How it goes wrong | A dependent artifact is left as it was, so the files disagree | The agent's reconciling misses a file, or a confirmation is given without reading what it confirms |
| What to check afterwards | The diff, and each artifact written from the one that changed | Each confirmed diff, and the artifacts that were not named |

Suppose the developer changes one decision in the design of a vending machine change, so that the machine works out the change before it releases the product, and edits nothing else. By hand, the tasks are left as they were. `status` still shows every artifact done, because every file exists, and the tasks still check the order the design had before. The diff of the design shows the new decision and does not show the task that checks the old one.

Suppose the developer, instead, asks the update workflow to make the tasks agree with the changed decision. The skill tells the agent to draft the edit, to check the other artifacts against it, and to show each proposed revision, and the developer decides which to confirm. The tasks that checked the old decision are reopened or rewritten, and a ticked box is the part that the diff shows least.

Both means are checked in the same way: by the diff, and by reading what depends on the file that changed. The status shows that files exist and the diff shows words, and neither shows that the artifacts agree. A revision is read as a new draft, with the passes of the review above.

## 10.8 What the planning workflows hand on

The planning workflows hand the plan to apply. The artifacts are its input, and apply requires the tasks. What it reads is the proposal, the specification, the design and the tasks. A plan that the developer has not reviewed is passed on as it is, because nothing in the program stops it.

The next chapter takes the workflow that does the work and the command that checks the plan: apply and `validate`.

The planning workflows write a plan, and the program can see only which files of it exist, so the plan is the developer's to judge. A change whose artifacts all exist is not a change whose plan is right.
