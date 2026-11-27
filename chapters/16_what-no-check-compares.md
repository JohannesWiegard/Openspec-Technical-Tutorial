# 16. What No Check Compares

Chapter 15 ended two of its sections on a question it did not answer. Section 15.4 left open what a green verify report shows and what to do with a mismatch. Section 15.5 left open what a collision between two changes is and what to do before the second archive. Both questions ask about a comparison, and in both cases the tool does not make it. The first compares the specification with the code. The second compares two changes with each other. This chapter takes the two together, because both turn on the same fact about the tool's checks. It does not introduce verify or bulk-archive again. Sections 15.4 and 15.5 do that, and this chapter adds only what they leave open.

## 16.1 Three statements

Three statements about a change are easy to take for one:

- The change is well formed against the main specification.
- Two changes that are open at the same time agree with each other.
- The code does what a scenario of the specification says.

Chapters 11 and 12 showed how the first is checked. `validate` reads a change's delta and the main specifications, and archive checks the delta again before it merges. Nothing in those chapters checks the second or the third. The rest of this chapter shows why the first does not cover the other two, what the two workflows outside the table add, and what the developer does instead.

## 16.2 What every check compares

Every check the tool makes compares one change with the main specifications. A scratch project showed this on 26 November 2026. It had one main requirement with one scenario, and two changes modified the requirement's wording. One added the words "from its stock" and the other "and notes", and both carried every scenario the main specification had. Each change passed `validate --strict` on its own, and both passed `validate --changes --strict` in one run. `list` showed both as complete. No output named the overlap.

The other commands are the same. `status` takes one change by name, or all of them with `--all`, and has no option that relates two. A change's metadata file `.openspec.yaml` holds the schema, the date of creation and, in a change that declares no spec changes, `skip_specs`, and no field that names another change. So a pass says that a change is well formed against the main specification as it stands when the check runs. It says nothing about the main specification as it will stand after another change has been archived.

None of the checks reads code either. Chapter 11 says what `validate` reads and chapter 12 what archive reads, and neither is code. `instructions apply` counts the ticked boxes and, once every box is ticked, tells the agent to review or verify the change before archiving, as section 8.5 says. It leaves the comparison with the code to whoever does the verifying.

## 16.3 Between two changes, the order decides

When two open changes modify the same requirement, the change archived second decides what the main specification holds. A modified requirement replaces the requirement as a whole, as chapter 6 says. Whether the tool lets the second archive happen depends on whether the second change still carries every scenario of the main specification. The scratch project was run both ways.

| The second change | What the tool did in the runs | What the main specification held afterwards |
|---|---|---|
| Carried every scenario the main specification had | `validate` passed, and archive reported "Specs updated successfully." and nothing else | The second change's wording only. The first change's wording was gone. |
| Omitted a scenario the first change had added | `validate` failed, and archive stopped with "Aborted. No files were changed." | The first change's requirement, unchanged, and the second change still open. |

In the first run both changes were archived. The main requirement held the second change's wording and none of the first's. No output said so, and a modified block gives no reason why it should: it says what the requirement is and not what changed in it.

In the second run the first change added a scenario to the requirement, and the second change, drafted before that, did not carry it. While the first change was open, `validate` passed the second. Once the first was archived, `validate` failed with "MODIFIED … omits scenario(s) the current spec still has". Archive printed "Refresh the change spec before archiving to avoid dropping scenarios." and "Aborted. No files were changed.", exited with code 1, and left the second change open. The same change passed before an archive and was refused after it.

That refusal is the only one the runs produced. Both rows agree with chapter 12's row for MODIFIED, which says that a block must carry every scenario and that `validate` and archive reject one that drops it. What the runs add is that, because the check is made against the main specification as it stands, the order of archiving decides whether a change is refused.

## 16.4 What bulk-archive adds

Three details of bulk-archive bear on the question of this chapter.

The skill defines a conflict as two or more chosen changes with delta specs for the same capability path. The path is the unit and not the requirement, so two changes that modify different requirements of one capability count as a conflict too.

For two changes that are both implemented, the skill applies them oldest first, so that the newer overwrites. For two changes that modify the same requirement, that is the outcome of the first run in section 16.3: the main specification holds the second wording only.

The skill shows its resolution of each conflict in its table before it asks its one confirmation question. That table is where a developer can see which change will overwrite which, before anything is written.

## 16.5 What verify's evidence is

What section 15.4 leaves open about verify is what a report rests on, which is a matter of what the skill tells the agent to do.

- For each added or modified requirement, the skill tells the agent to search the code for keywords related to it and to "assess if implementation likely exists".
- For each scenario, it tells the agent to check whether the conditions are handled in the code and whether tests exist that cover it.
- Its heuristics name the method for correctness as "keyword search, file path analysis, reasonable inference" and say not to require perfect certainty.

The skill does not tell the agent to run the code or to run a test. It asks whether a test exists, and not whether the test fails when the scenario is broken.

The skill also says what a report is not. A check marked "Not verified" describes a limit of the report, in the skill's words, and is not a new condition for archive, which keeps its own checks. Two things can stop the skill. Before the first step that writes anything, a shared project-root guard checks that the project has an OpenSpec root, and stops and asks when it has none. When the change to verify is vague or ambiguous, the skill asks the user to choose one.

Verify is not one of the seven workflows of chapter 9. In a project whose profile names only those seven, a request for verify reaches the router's shorter path of section 15.1, not this skill. This chapter rests on the skill text and says nothing about how well an agent carries it out.

## 16.6 The scenario as the unit of a check

A scenario is the unit that can be carried from the specification into a check. Chapter 6 writes it with a WHEN and a THEN that can be observed, and an observable THEN is something a test, a command or a procedure can confirm or refute. Section 8.5 asks the same of a task's evidence, that it could have come out the other way.

The tool holds no link between a scenario and a check. A specification has requirements and scenarios and no field for the check that covers a scenario, and a change's metadata has none either. Where the link exists, it exists in the project's tests and in the tasks that name them.

## 16.7 Making the two comparisons

Before an archive, the developer makes the two comparisons that the tool does not. Each has a routine, in the manner of chapters 11 and 12.

### Before a second archive

1. Before archiving any change, list the open changes and find those whose deltas name the same capability. `openspec show <change> --json --deltas-only` prints each delta's spec, operation, requirement name, text and scenarios.
2. Decide which change archives first, and write the reason down in the second change's design. The order decides whose wording the main specification holds.
3. Archive the first change, or sync it as chapter 12 describes, so that the main specification is current.
4. For each change still open that modifies the same requirement, copy the requirement from the main specification as it now stands, with its scenarios and with the first change's wording, and apply that change's edit to the copy.
5. Run `validate` on the second change.
6. After the second archive, read the requirement in the main specification whole, and not only the diff.

Step 4 is more than the refusal asks for. In a third run of the scratch project, the second change from section 16.3 was given only the scenario it had omitted. It then validated and archived, and the main requirement held its wording: the first change's words "from its stock" were gone, although the first change's scenario was kept. The refusal protects a scenario and not a wording, so the wording is kept only when the first change's text is carried over as well.

### Before archiving a change with code

1. Take the delta's scenarios one at a time.
2. For each, name the check that would fail if the scenario were broken: a test, a command or a procedure.
3. If there is no such check, write a note that says so.
4. Run the checks.
5. Record each result in the task that names the check, as chapter 8 describes.

## 16.8 Changing the result

When a comparison finds that something is wrong, the correction depends on where the error is and how far the change has gone.

After a wrong second archive, the main specification holds a requirement that has lost the first change's wording. The archive is not edited. The lost wording is restored by a new change that modifies the requirement, by the path of chapter 12.

After a mismatch between the code and the specification, the skill's recommendations name the ways out, worded as follows:

- for a requirement with no implementation: "Implement requirement X: `<description>`";
- for a scenario that is not covered: "Add test or implementation for scenario: `<description>`";
- for a design decision the code does not follow: "Update implementation or revise design.md to match reality".

The recommendations name the code first, and only the design decision has the artifact as a way out. Which side was wrong is the developer's decision. A requirement the code does not meet may be a missing implementation, or a requirement that was not right. When the artifact is at fault and the change is open, it is revised in the change, as section 11.5 says. When the requirement is archived, it is corrected by a new change, as after a wrong second archive.

## 16.9 What the example shows

The example shows a correction and neither of the two cases. The vending machine has two archived changes, `give-exact-change` and `refuse-without-exact-change`. They were never open together. The second modified a requirement of the first after the first had been archived, so no order decided anything and nothing was refused. The example holds no code, so it shows no mismatch between code and specification and no verify report.

The tool checks one change's text against the main specification as it stands on the day of the check. It refuses a modified requirement that has lost a scenario, it passes one that has lost another change's wording, and it reads no code. Two changes can each pass and still leave a main specification that says what only one of them meant, and a change can pass with code that does something else. Whether two changes agree, and whether the code does what a scenario says, is therefore the developer's reading: of the requirement in the main specification after the second archive, and of each scenario against the check that would fail if it were broken.
