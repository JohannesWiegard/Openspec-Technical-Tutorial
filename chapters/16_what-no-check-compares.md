# 16. What No Check Compares

Chapter 15 ended two of its sections on a question it did not answer. Section 15.4 left open what a passing verify report shows, and what to do with a mismatch. Section 15.5 left open what a collision between two changes is, and what to do before the second archive. Both questions ask about a comparison. In both cases, the tool does not make it. The first compares the specification with the code. The second compares two changes with each other. This chapter discusses the two together, because both depend on the same fact about the tool's checks. It does not introduce verify or bulk-archive again. Sections 15.4 and 15.5 do that. This chapter adds only what they leave open.

## 16.1 Three statements that are easy to confuse

It is easy to treat three statements about a change as one:

- The change is well formed against the main specification.
- Two changes that are open at the same time agree with each other.
- The code does what a scenario of the specification says.

Chapters 11 and 12 showed how the first is checked. `validate` reads a change's delta and the main specifications. Archive checks the delta again before it merges it. Nothing in those chapters checks the second or the third. The rest of this chapter shows three things: why the first does not cover the other two, what the two workflows outside the profile add, and what the developer does instead.

## 16.2 What every check compares

Every check the tool makes compares one change with the main specifications. A scratch project on OpenSpec 2.2.0 showed this on 26 November 2026. It had one main requirement with one scenario. Two changes modified the wording of that requirement. One added the words "from its stock", and the other added "and notes". Both carried every scenario that the main specification had. Each change passed `validate --strict` on its own. Both passed `validate --changes --strict` in one run. `list` showed both as complete. No output named the overlap.

The other commands are the same. `status` takes one change by name, or all of them with `--all`. It has no option that relates two changes. A change's metadata file `.openspec.yaml` holds the schema and the date of creation. In a change that declares no spec changes, it also holds `skip_specs`. It has no field that names another change. So a pass says that a change is well formed against the main specification as it stands when the check runs. It says nothing about the main specification as it will stand after another change has been archived.

None of the checks reads code either. Chapter 11 says what `validate` reads, and chapter 12 says what archive reads. Neither is code. `instructions apply` counts the ticked boxes. Once every box is ticked, it tells the agent to review or verify the change before archiving, as section 8.5 says. It leaves the comparison with the code to whoever does the verifying.

## 16.3 Between two changes, the order of archiving decides

When two active changes modify the same requirement, the change archived second decides what the main specification holds. A modified requirement replaces the whole requirement, as chapter 6 says. Whether the tool allows the second archive depends on whether the second change still carries every scenario of the main specification. The scratch project was run both ways.

| The second change | What the tool did in the runs | What the main specification held afterwards |
|---|---|---|
| Carried every scenario the main specification had | `validate` passed. Archive reported "Specs updated successfully." and nothing else. | The second change's wording only. The first change's wording was gone. |
| Omitted a scenario the first change had added | `validate` failed. Archive stopped with "Aborted. No files were changed." | The first change's requirement, unchanged, and the second change still open. |

In the first run, both changes were archived. The main requirement held the second change's wording and none of the first change's wording. No output said so. A modified block gives no reason why it should: it says what the requirement is, not what changed in it.

In the second run, the first change added a scenario to the requirement. The second change was drafted before that, and it did not carry the scenario. While the first change was open, `validate` passed the second change. Once the first change was archived, `validate` failed with "MODIFIED … omits scenario(s) the current spec still has". Archive printed "Refresh the change spec before archiving to avoid dropping scenarios." and "Aborted. No files were changed.". It exited with code 1 and left the second change open. The same change passed before an archive and was refused after it.

That refusal is the only one the runs produced. Both rows agree with chapter 12's row for MODIFIED. That row says that a block must carry every scenario, and that `validate` and archive reject a block that drops one. The runs add one point: the check is made against the main specification as it stands on the day of the check. So the order of archiving decides whether a change is refused.

## 16.4 What bulk-archive adds

Section 15.5 describes bulk-archive and its rule for a conflict. Three details are relevant to the question of this chapter.

The skill defines a conflict as two or more chosen changes with delta specs for the same capability path. The unit is the path, not the requirement. So two changes that modify different requirements of one capability also count as a conflict.

For two changes that are both implemented, the skill applies them oldest first, so that the newer one overwrites the older one. For two changes that modify the same requirement, this gives the outcome of the first run in section 16.3: the main specification holds the second wording only.

The skill shows its resolution of each conflict in its table, before it asks its one confirmation question. In that table, a developer can see which change will overwrite which, before anything is written.

## 16.5 What verify bases its report on

Section 15.4 describes verify, its three dimensions and its severities. It leaves open what a report depends on. That is a matter of what the skill tells the agent to do.

- For each added or modified requirement, the skill tells the agent to search the code for keywords related to it, and to "assess if implementation likely exists".
- For each scenario, it tells the agent to check two things: whether the code handles the conditions, and whether tests exist that cover the scenario.
- Its heuristics name the method for correctness as "keyword search, file path analysis, reasonable inference". They say not to require perfect certainty.

The skill does not tell the agent to run the code or to run a test. It asks whether a test exists. It does not ask whether the test fails when the scenario is broken.

The skill also says what a report is not. In the skill's words, a check marked "Not verified" describes a limit of the report. It is not a new condition for archive, which keeps its own checks. Two things can stop the skill. First, before the first step that writes anything, a shared project-root guard checks that the project has an OpenSpec root. When the project has none, the guard stops and asks. Second, when the change to verify is vague or ambiguous, the skill asks the user to choose one.

Verify is outside this repository's profile, which lists seven workflows. So in this repository, a request for verify reaches the router's shorter path of section 15.1, not this skill. This chapter depends on the skill text of 2.2.0. It says nothing about how well an agent carries out that text.

## 16.6 The scenario as the unit of a check

A scenario is the unit that can be carried from the specification into a check. Chapter 6 writes it with a WHEN and a THEN that can be observed. An observable THEN is something that a test, a command or a procedure can confirm or refute. Section 8.5 asks the same of a task's evidence: that it could have come out the other way.

The tool holds no link between a scenario and a check. A specification has requirements and scenarios. It has no field for the check that covers a scenario, and a change's metadata has none either. Where the link exists, it is in the project's tests and in the tasks that name them.

## 16.7 Making the two comparisons

Before an archive, the developer makes the two comparisons that the tool does not make. Each comparison has a routine, like the routines of chapters 11 and 12.

### Before a second archive

1. Before archiving any change, list the active changes. Find those whose deltas name the same capability. `openspec show <change> --json --deltas-only` prints each delta's spec, operation, requirement name, text and scenarios.
2. Decide which change archives first. Write the reason down in the second change's design. The order decides whose wording the main specification holds.
3. Archive the first change, or sync it as chapter 12 describes, so that the main specification is current.
4. For each change still open that modifies the same requirement, copy the requirement from the main specification as it now stands. The copy includes its scenarios and the first change's wording. Then apply that change's edit to the copy.
5. Run `validate` on the second change.
6. After the second archive, read the whole requirement in the main specification, not only the diff.

Step 4 does more than the refusal asks for. In a third run of the scratch project, the second change from section 16.3 was given only the scenario it had omitted. It then validated and archived. The main requirement held its wording: the first change's words "from its stock" were gone, although the first change's scenario was kept. The refusal protects a scenario, not a wording. So the wording is kept only when the first change's text is carried over as well.

### Before archiving a change with code

1. Take the delta's scenarios one at a time.
2. For each scenario, name the check that would fail if the scenario were broken: a test, a command or a procedure.
3. If there is no such check, write a note that says so.
4. Run the checks.
5. Record each result in the task that names the check, as chapter 8 describes.

## 16.8 Correcting the result

When a comparison finds that something is wrong, the correction depends on two things: where the error is, and how far the change has gone.

After a wrong second archive, the main specification holds a requirement that has lost the first change's wording. The archive is not edited. A new change restores the lost wording. It modifies the requirement, by the path that chapter 12 describes.

After a mismatch between the code and the specification, the skill's recommendations name the possible corrections, in these words:

- for a requirement with no implementation: "Implement requirement X: `<description>`";
- for a scenario that is not covered: "Add test or implementation for scenario: `<description>`";
- for a design decision the code does not follow: "Update implementation or revise design.md to match reality".

The recommendations name the code first. Only the recommendation for a design decision offers a change to the artifact as a correction. The developer decides which side was wrong. A requirement that the code does not meet may be a missing implementation. It may also be a requirement that was not right. When the artifact is at fault and the change is open, the artifact is revised in the change, as section 11.5 says. When the requirement is archived, a new change corrects it, as chapter 12 says, and the archive is not edited.

## 16.9 What the example shows

The example shows a correction, and it shows neither of the two cases. The vending machine has two archived changes, `give-exact-change` and `refuse-without-exact-change`. They were never open at the same time. The second modified a requirement of the first after the first had been archived. So no order decided anything, and nothing was refused. The example holds no code. So it shows no mismatch between code and specification, and no verify report.

The tool checks the text of one change against the main specification as it stands on the day of the check. It refuses a modified requirement that has lost a scenario. It passes one that has lost another change's wording. It reads no code. Two changes can each pass and still leave a main specification that says what only one of them meant. A change can also pass with code that does something else. So whether two changes agree, and whether the code does what a scenario says, is the developer's reading. The developer reads the requirement in the main specification after the second archive. The developer also reads each scenario against the check that would fail if it were broken.
