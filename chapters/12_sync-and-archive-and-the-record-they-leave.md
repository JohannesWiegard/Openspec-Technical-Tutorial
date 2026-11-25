# 12. Sync and Archive, and the Record They Leave

The previous chapter ended with a ticked list and a well-formed delta, passed to the workflows that make the record current. This chapter discusses the last two entries of the table. Sync is the workflow that merges a delta into the main specifications and leaves the change open. Archive merges unless it is told not to, and it moves the change into the archive. The two share a chapter for two reasons. They leave the same thing: the main specifications that every later change is checked against. And archive has two answers to the first question, who does the work. For each of them the chapter asks four questions. What does the developer do? What does it read and write, and what can stop it? How does a reviewer judge what it did? What happens when its result is wrong? The examples are the vending machine's main specification and archived changes, and a scratch project in which the commands were run.

The table lists the workflows and the `validate` command again. Sync and archive are in bold.

| Workflow | Entry point | What it does |
|---|---|---|
| Explore | the skill `openspec-explore` | Think about a problem or idea with the agent before there is a change. It writes nothing unless the user confirms. |
| Propose | the skill `openspec-propose` | Create a change and all of its planning artifacts in one run. |
| Continue | the skill `openspec-continue-change` | Create the next missing artifact, one per run. Not in the core profile. |
| Update | the skill `openspec-update-change` | Revise the artifacts a change has and make them agree. |
| Apply | the skill `openspec-apply-change` | Work through the tasks and tick each box when its work is done. |
| Validate | the command `openspec validate` | Check the delta and the main specifications against the format rules. A command, not a workflow. |
| **Sync** | **the skill `openspec-sync-specs`** | **Merge a change's delta into the main specifications without archiving it.** |
| **Archive** | **the skill `openspec-archive-change` and the command `openspec archive`** | **Merge the delta unless told not to, count the tasks, and move the change into the archive.** |

## 12.1 Sync: merging without closing the change

The skill `openspec-sync-specs`, as OpenSpec 2.1.1 installs it, tells the agent to merge each delta of a change into its main specification. It also tells the agent to keep everything the delta does not mention. The agent selects the change. It asks the program where the main specifications are and which deltas exist. It reads each delta and its main specification. It applies the four operations as a merge and not as a copy. It then validates the main specifications and shows what changed. The skill calls the operation agent-driven, so that a delta can add one scenario to a requirement without a copy of the whole requirement. For a modified requirement, the closing principle of the same skill says the opposite of that last point. A MODIFIED block carries the whole requirement, and `validate` and `archive` both reject a block that drops a scenario the main specification still has. The skill stops in three cases: when the change has no delta, when the lookup of the rules fails, and when a capability is blocked. Chapter 6 says what the operations of a delta are, and this chapter does not repeat it.

The card shows the five rows for sync.

| Item | Sync |
|---|---|
| Entry point | The skill `openspec-sync-specs`, called by its name or by the words "openspec sync" or "opsx sync". No command has that name. |
| Who acts | The agent merges. The program supplies the paths and the rules, and validates the main specifications afterwards. The developer decides to sync and reads the result. |
| Writes | The main specifications that the delta names, and nothing else. The change folder is not touched. |
| What can stop it | A change with no delta, a failed lookup of the rules, a capability that is blocked, or a failed validation. |
| The developer's part | To decide whether to merge before the change is archived, and to read the merge. |

The table shows the six stages of the skill, what the tool checks at each, and the question each answers.

| Stage | What the tool checks | The question it answers |
|---|---|---|
| 1. Select the change | `list --json` returns the active changes, and the skill offers those that have a delta. | Which change is meant? |
| 2. Resolve the change context | `status --json` returns the root under which the main specifications are. | Where are the main specifications? |
| 3. Find the delta specifications | `status --json` returns the delta paths that exist. The skill uses no other source. | Which deltas does the change hold? |
| 4. Apply each delta | `instructions specs --json` returns the rules that the project configured for specifications, once, before the first write. Nothing reads the merge. | Does the main specification say what the delta says? |
| 5. Validate the main specifications | `validate --specs` checks the form of every main specification. | Is the result well formed? |
| 6. Show the summary | Nothing. | What changed, and what is left to write? |

The program supplies two things and checks one. At stage 4 it supplies the rules, and nothing reads the merge itself. The check is at stage 5. It is about the form of the main specifications, not about whether the merge says what the delta says. In a scratch project, `status` reported the root and the one delta path that existed. `instructions specs` returned a `rules` list only after the project's configuration named a rule. `openspec sync` was an unknown command, so the skill is the only definition of sync.

The skill gives a rule for each operation. The rules say what the main specification should hold afterwards and when the merge stops. The table shows them.

| Operation | What sync does | When it stops |
|---|---|---|
| ADDED | Adds the requirement. If one of that name exists, it updates it to match. | Not by itself. |
| MODIFIED | Finds the requirement and applies the change: a new scenario, a changed scenario or a changed description. It keeps the text the delta does not mention. It expects the block to carry every scenario the main specification has: `validate` and `archive` reject a block that drops one. In a scratch project on 2.1.1, the first rejected it at validation, and the second by stopping with no file changed. | When the capability has no main specification. For a capability that has one, the skill says to find the requirement and says nothing about one that is missing; the command refuses that delta. |
| REMOVED | Removes the whole requirement block. It removes the capability's `spec.md` only when six conditions hold, among them that no requirement is left, that the rest of the file is well formed, and that the change's `.openspec.yaml` declares `retire_capabilities: true`. | When the capability has no main specification: there it skips the operation and warns. When removing would leave no requirement and a condition fails, it changes nothing for that capability and names the condition. It never leaves an empty `## Requirements` section. |
| RENAMED | Finds the requirement under its old name and gives it the new one. | When the capability has no main specification. |
| Purpose | For a new capability, copies the delta's Purpose word for word, and writes a placeholder only when the delta has none. For an existing one, leaves the main specification's Purpose unchanged. | Never. |

For a capability with no main specification, only ADDED requirements can create it. MODIFIED and RENAMED have no requirement to act on there. For them, the skill tells the agent to stop for that capability and never to invent the missing requirement. REMOVED has nothing to remove, and the skill tells the agent to skip it and warn. The merge creates the file with a title, the delta's Purpose and the requirements. Section 4.6 shows the first lines of the file as the first change left them. The skill says that the merge it describes matches what `openspec archive` does for a new capability and for the Purpose. It claims no more than that.

Sync leaves the change open and the main specification ahead of it. After a sync, the main specification holds the new requirement. The change folder is where it was, and its tasks are as they were. That is why sync is optional: archive can make the same merge, and its workflow offers to. It also means that the next person can read the main specification between the sync and the archive, before the change is done.

For the developer, sync is a decision to make the record current before the change is closed. Commit the repository before the run, so that the merge shows as a diff of the main specifications and of nothing else. Name the change. When it has several deltas, say which of them are to be merged. Write a modified requirement whole, as chapter 6 teaches. Do not rely on the merge to keep a scenario that the block left out, because the program rejects such a block. After the run, read the diff of the main specifications beside the delta, operation by operation. Read a modified requirement whole in the main specification, because a diff shows only the words that moved. Read the summary for a Purpose that was left as a placeholder, because no later step asks anyone to write it.

## 12.2 Archive: merging and moving the change

Two parties can archive a change, and they do not do the same thing. The command `openspec archive` does everything in the program. The skill `openspec-archive-change` tells the agent to do several things in turn. The agent reads the status and the task count, and asks the user to confirm what is open. It compares each delta with its main specification and offers a sync. It runs the sync workflow inline. It checks the result against the delta, and it moves the folder. So the question of who does the work has two answers. The first is the program. The second is the agent, with the program's counts. The rest of this section says which of the two each sentence is about. The developer decides which to use, answers what is asked, and reads the main specification afterwards.

The card shows the five rows for archive, with an answer for each path where they differ.

| Item | Archive |
|---|---|
| Entry point | The command `openspec archive`, and the skill `openspec-archive-change`. |
| Who acts | The command: the program. The workflow: the agent, with the program's counts and the validation inside the sync. The developer chooses the path and answers what it asks. |
| Writes | The main specifications that the delta names, and the change folder, which is moved into `archive` under its date. |
| What can stop it | A delta that fails validation or cannot be merged, a question that is answered no or not answered, a mismatch after a merge, a failed lookup, or an archive of the same name. |
| The developer's part | To choose the path, to answer what it asks, and to read the record. |

The table shows the six stages of the archive workflow, what the tool checks at each, and the question each answers.

| Stage | What the tool checks | The question it answers |
|---|---|---|
| 1. Select the change, and read the archive inputs | `list --json` returns the active changes. `instructions archive --json` is advisory: in the scratch project it returned the change's name and the root. It carries project context or guidance only when the project adds them. | Which change is meant, and what does the project add? |
| 2. Check the artifact status | `status --json` lists each artifact as done, skipped or neither. | Is the plan complete? The skill asks the user to confirm if it is not. |
| 3. Check the task count | `list --json` returns the total and the completed count; only `x` and `X` count as complete. | Is the work ticked? The skill asks the user to confirm if it is not. |
| 4. Assess the delta, and sync if chosen | Nothing: the agent checks that the archive target is free before any main specification is written. `instructions specs --json` returns the rules once before a sync, and stage 5 of the sync runs `validate --specs`. The comparison of the delta with the main specification is the agent's. | Does the main specification need the merge, and does it hold it afterwards? |
| 5. Perform the archive | Nothing: the skill checks the target once more, moves the folder with `mv`, and fails if the target exists. | Is the change in the archive under its date? |
| 6. Display the summary | Nothing. | What happened, and with what warnings? |

The sync inside stage 4 is the sync workflow of the previous section, not a command. The skill tells the agent to run it inline and to wait. The reason is that a move of the folder while a sync is still reading it would leave the change archived and the main specifications never updated. After the sync, the skill tells the agent to check the structure of each main specification. It also tells the agent to confirm that no delta heading remains, and to compare every capability with its delta again. If anything differs, the agent stops, and nothing has moved.

The two paths differ in who merges, in what is checked and in what stops them. The table shows them side by side. The column for the command is what was run in a scratch project on OpenSpec 2.1.1. The column for the workflow is what the skill tells the agent to do; no agent was run.

| What | The `archive` command | The archive workflow |
|---|---|---|
| Who merges | The program. | The agent, following the sync workflow inline. Where that skill is not installed, the agent merges itself under the same safeguards and then runs `validate --specs`. |
| Whether the change is passed through `validate` | Yes, first, when there is a delta. An error stops it before the task line is printed. | The skill names no `validate` run on the change. It runs `validate --specs` on the main specifications, inside the sync. |
| Where the task count comes from | The command reads the tasks file and prints a line, for example "Task status: 1/2 tasks". | `list --json`, with the total and the completed count. The skill stops if the lookup fails or the counts are invalid. |
| Whether artifact completion is checked | No. In the scratch project, a change with one of four artifacts complete was archived on `--yes`. The command printed no warning about the missing artifacts. | Yes. The skill reads `status --json` and asks the user to confirm if an artifact is neither done nor skipped. |
| What asks the user, and the default | "Continue?" for open tasks, with the default no, and "Proceed with spec updates?", with the default yes. With no one to answer, it fails and names `--yes`. | The same two matters, as confirmations. Also a choice of "Sync now", "Archive without syncing" or "Cancel", or of "Archive now", "Sync anyway" or "Cancel" when the delta is already merged. The skill asks again on any other answer. |
| A delta that cannot be merged | It refuses, prints "Aborted. No files were changed.", and the change stays. | A capability that cannot be merged is marked blocked, and only "Archive without syncing" and "Cancel" are offered. If the sync reports a stop, the archive stops with nothing moved. |
| What is checked after the merge | Before it writes, the command validates the rebuilt main specification, and writes nothing if that fails. | After it writes, the skill checks the structure, confirms no delta heading remains, and compares each capability with its delta again. The sync runs `validate --specs`. |
| How the folder is moved and named | In the program, under the date. It fails with "Archive ... already exists" when the name is taken, and the change stays. | With `mv`, after it makes the `archive` directory, under the date, never with a second date added. It checks that the target is free before it writes any main specification and again before the move. If the target is not free, it stops with the change in place. |
| The options that skip a check | `--yes`, `--skip-specs` and `--no-validate`. | The answer "Archive without syncing", and the answers to each confirmation. |

Both paths can skip a check, and the developer decides which one. The command's help describes `--yes` as skipping the confirmation prompts and `--skip-specs` as skipping the spec update operations. It describes `--no-validate` as skipping validation, calls that not recommended, and says it requires confirmation. In the scratch project, `--skip-specs` moved a change whose delta was never merged. `--no-validate` merged a requirement that had no scenario. The main specification then failed `validate --specs`. The next archive of a change that touched it was refused until the requirement was removed. The program reports what it was told to skip, and does not say whether the skip was right.

For the developer, archive is where the change stops being work and the record changes, and the review is of what the merge left. Choose the path before the run, and know what each path checks. The command validates the delta and the rebuilt specification before it writes anything. The workflow compares the result with the delta after it writes. Answer each question as a decision. Read the question that defaults to yes, the merge, as carefully as the one that defaults to no, the open tasks. Commit the repository before the run, so that the merge and the move show as one diff.

The example shows what an archive leaves, and nothing of the path. After the first change, the main specification `purchase` holds the first change's requirements and nothing about the change that wrote them. The folder with the proposal, the delta, the design and the tasks is in the archive under its date. Section 4.6 shows both. After the second change, the modified requirement is replaced and the file has no new section, as section 4.14 says. The archived folders hold the artifacts and a metadata file. That file records the schema and the date the change was created. None of the files says which path made the record, or whether a check was skipped.

An archive is a record, and nothing in it is edited. A change that has been moved into the archive is not changed again. An archived design that was wrong stays as it was, and a new change corrects it. Chapter 5 says so for the proposal, and section 4.8 shows it: the first change's requirement was found incomplete, and the correction was a second change. The only form of `validate` that reads the archive is `--archived`. It checks that each archived `tasks.md` has no open box.

## 12.3 What sync and archive do not check

Neither path checks whether the record is right. The program checks the form of the delta and of the main specifications. The agent compares its own merge with the delta. Neither path asks whether the requirement that reached the main specification is the right one. Section 4.14 says why that matters: every later change relies on what the record holds, so an error in it is carried forward. Also, the two paths need not give the same result. Sync has no command, so the sync workflow has the skill's rules and nothing that checks them. The skill's statement that it matches the command is the skill's own claim.

## 12.4 Reviewing the record

This review asks whether sync and archive did what their rules say. It does not ask whether the requirement is right; that is for the review of the delta in chapter 6. The review has four passes. Merge asks whether the main specification says what the delta says and no more, with everything else kept. Form asks four things: that no delta heading remains, that the Purpose is not a placeholder, that the file has the format of a main specification, and that `validate` passes. Folder asks whether the change is in the archive under its date with all its artifacts. Path asks which path was used and which checks were skipped. Merge and Path matter most. The reason is that the program checks the form and not the content, and a skipped check leaves no record in the archive.

The table is one checklist, in the order in which the record is read.

| Check | The workflow has done its job when | How a run can fail |
|---|---|---|
| The request is answered as meant | A reviewer can say which change and which deltas the run answers, and the record follows them | The run merges the delta of another change, or only some of the deltas the change holds |
| The delta merged is the delta of the change | The main specification changed only where the change's delta names a requirement | A requirement outside the delta changed, or one the delta names did not |
| Each operation did what the merge rules say | Added requirements are present, a modified one carries the change and every scenario it had before, removed ones are gone, and a renamed one has the new name only | A modified requirement lost a scenario, a removed one is still there, or a rename left both names |
| Nothing the delta did not mention changed | The rest of the main specification is as it was, in its order | A requirement was reworded or moved as a side effect |
| No delta heading remains | The main specification has one `## Requirements` section and no `## ADDED` or other delta heading | The delta file was copied in unchanged |
| The Purpose is not a placeholder | A new capability carries the delta's own Purpose, and an existing one is unchanged | A new specification carries the placeholder, or an existing Purpose was rewritten |
| `validate` passes on the main specifications | The form of the run is the one the project uses, run on the files as they are now | The result is from before the merge, or the run used a form that does not read the main specifications |
| The folder is in the archive under its date with every artifact | The folder, with the proposal, the delta, the design and the tasks, is under `archive` | The change was archived without its merge, or the folder lacks an artifact |
| The path and the skips are known | Someone can say which path was used and what it skipped | The record was made by a path nobody wrote down, with a check skipped |
| Downstream | The next change starts from a record that a person has read | The folder moved and no one read the main specification |

The table is a memory aid, and no part of the tool reads it. A change in the archive is a change that was moved. The main specification is what the next change relies on. So the record is accepted when someone has read the main specification, not when the folder has moved.

For both sync and archive, the developer can follow one routine:

1. Commit the repository before the run, so that the merge and the move show as one diff.
2. Read the delta first and say which requirements it changes, and decide the path and whether to sync before the archive.
3. Answer each question the path asks as a decision, and note each check that was skipped.
4. After the run, read the diff of `openspec/specs/` beside the delta, operation by operation, and read each changed requirement whole.
5. Run `validate` in the form the project uses, and read the whole result.
6. Commit once the record is read, and name the path and the skipped checks in the message, because the archive does not keep them.

## 12.5 Changing the result

When the review finds that the record is wrong, two decisions follow: what the revision covers, and who makes it. The first depends on whether the merge has happened.

| What exists | What the revision covers |
|---|---|
| The delta only, nothing merged | An edit of the delta, by the ways of chapter 6, and then either path. |
| The sync run and the change open | The same edit, and the sync again. The skill tells the agent to make the operation idempotent, so that a second run gives the result of one. |
| The change archived with a wrong requirement | Nothing in the archive. The correction is a new change. |

The example shows the last row and none of the others. The first change was archived with a requirement that did not cover a case. The correction was a new change that modified it. Section 4.8 tells this story. Section 4.14 shows the main specification afterwards, with the first change's folder as it was. The example holds no other case. It runs no sync, so no change reached the main specification before it was archived, and no change is still open.

The second decision is about the means. The developer can revise the main specification by hand, or can ask the agent to run the workflow again. The two differ in cost and in how they go wrong.

| | The developer revises by hand | The agent is asked to run the workflow again |
|---|---|---|
| Right when | One word or one block of the main specification is wrong and the developer knows the replacement. An example is a Purpose, which a delta cannot change for an existing capability | The delta changed, or several requirements have to change together |
| What it costs | The change records nothing of the edit, and a delta that modifies the block does not know about it | Another merge, and a request that names the change and the deltas |
| How it goes wrong | A later MODIFIED copies the old block, and the correction is lost | An operation is not idempotent, or the run changes a requirement the delta does not name |
| What to check afterwards | The diff of the main specification, and the delta of any active change that names the block | The diff of the main specification against the new delta, and `validate --specs` |

Suppose the developer corrects a word in the requirement of `purchase` by hand, in the main specification. A change that was drafted before the correction then modifies that requirement, and it copies the block from its own earlier draft. The merge replaces the block with the delta's block, and the correction is lost. The diff shows the old word coming back. Nothing in the program says that the word was ever corrected.

Suppose a delta is edited after a sync, and the sync is run again. The skill tells the agent to make the operation idempotent, so that two runs give the same result as one. No run was observed. The check that the main specification says what the new delta says is the developer's.

Both means are checked by reading the main specification, not only the diff. The diff shows words, and the main specification is what the next change relies on. A revision is read as a new draft, with the passes of the review above.

## 12.6 What sync and archive pass on

Sync and archive pass a record to the next change. The main specification is the living description that chapter 3 spoke of. Section 4.14 says that archiving turns a change from a proposal into part of that description. The workflows of the last four chapters end here. The plan is written, carried out, checked and made current. The next change starts from the record, and its requirements are read against what the record holds.

Sync merges a delta without moving the change, and it exists only as a skill. Archive merges and moves the change. It exists as a command that does this in the program, and as a workflow that has the agent do it. The two paths differ in who merges and what is checked, and both can skip a check. The merge rules say what the main specification should hold. The review is of the main specification that the merge left, not of the folder that moved. Where the skill says two things about one operation, a delta can rely on the stricter one, which the program checks, and a modified requirement is written whole. The archive is a record, and a new change corrects a mistake in it. The question to ask of any archive is which path made the record and what it checked.
