# 14. A Customized Change, from Fork to Archive

The previous chapter said what can be customized and what the tool checks of each kind. This chapter shows it. It takes the vending machine's second change, `refuse-without-exact-change`, which chapter 4 quotes in full, and makes it again under a schema of its own, `with-trace`. The schema adds one artifact, a trace, between the design and the tasks. Every file that the customization adds or changes is shown, and so is the console input and the main output of each step. The proposal, the delta, the design and the tasks of the change are chapter 4's, and are pointed at and not repeated. The four needs of the example and the place where each is made are in the table of section 13.6.

The walkthrough ran in a scratch project on 26 November 2026. This chapter is the only one of the book that shows console blocks, because its claims are what the program printed and a reader can only check them by seeing it. A line that begins with `$ ` is input, and what follows is the program's output. The project's folder is written as `.`, the program's own install folder as `<package>`, and a line of three dots marks output that is cut. No block shows the work of an agent. The files were written by hand in the scratch project.

## 14.1 Preparing the harness

The harness is prepared in four steps: a fork, a schema that differs from it, a template, and a configuration that names the fork. After each the program is asked what it now knows.

The scratch project holds the machine's own `config.yaml`, which names `spec-driven`, and a main specification of `purchase` that holds the first change's result, so the project is the example's second change waiting to be made. The first of the four steps is the fork. It copies the package's `spec-driven` into the project under a new name.

```
$ openspec schema fork spec-driven with-trace
Note: Schema commands are experimental and may change.
- Forking 'spec-driven' to 'with-trace'...
✔ Forked 'spec-driven' to 'with-trace'

Source: <package>/schemas/spec-driven (package)
Destination: ./openspec/schemas/with-trace

You can now customize the schema at:
  ./openspec/schemas/with-trace/schema.yaml
```

`openspec schema which` says where a schema comes from, and with `--all` it lists what the project can reach. The fork is a project schema, and `spec-driven` is still the package's.

```
$ openspec schema which with-trace
Note: Schema commands are experimental and may change.
Schema: with-trace
Source: project
Path: ./openspec/schemas/with-trace
$ openspec schema which --all
Note: Schema commands are experimental and may change.

Project schemas:
  with-trace

Package schemas:
  spec-driven
```

The second step is the edit of `schema.yaml` in the new folder. The file is the package's default of 273 lines, so it is shown as the difference from the fork. The diff has four changes. The description says what the fork is. A `trace` artifact is added after the design, requiring the specs and the design. The tasks gain `trace` in their `requires`. The apply block gains two lines. The lines of the default schema that the diff does not show are unchanged.

```
--- a/openspec/schemas/with-trace/schema.yaml
+++ b/openspec/schemas/with-trace/schema.yaml
@@ -1,6 +1,6 @@
 name: with-trace
 version: 1
-description: Default OpenSpec workflow - proposal → specs → design → tasks
+description: spec-driven with a trace between the design and the tasks
 artifacts:
   - id: proposal
     generates: proposal.md
@@ -196,6 +196,22 @@ artifacts:
     requires:
       - proposal
 
+  - id: trace
+    generates: trace.md
+    description: Which decision in the design satisfies each scenario
+    template: trace.md
+    instruction: |
+      Create the trace that names, for every scenario in the specs, the decision in
+      the design that satisfies it.
+
+      Write one row for each scenario, using the scenario's own name. Walk the
+      scenario's inputs through the design by hand. If the design has no decision
+      that covers the scenario, write "none" and record the scenario as not
+      satisfied; do not edit the design to hide the gap.
+    requires:
+      - specs
+      - design
+
   - id: tasks
     generates: tasks.md
     description: Implementation checklist with trackable tasks
@@ -264,6 +280,7 @@ artifacts:
     requires:
       - specs
       - design
+      - trace
 
 apply:
   requires: [ tasks ]
@@ -271,3 +288,5 @@ apply:
   instruction: |
     Read context files, work through pending tasks, mark complete as you go.
     Pause if you hit blockers or need clarification.
+    Before each task, read trace.md and stop if a scenario the task touches is
+    marked not satisfied.
```

The `requires` of the trace is what puts it between the design and the tasks, and the `requires` of the tasks is what makes it mandatory. The two lines of the apply block are the third of the example's four needs. The third step is the template that the trace's `template: trace.md` names, a new file, `templates/trace.md`, in the same folder. It is the whole file.

```
## Trace

<!-- One row for every scenario in the specs. Name the decision in the design that
     satisfies the scenario. A scenario with no decision is written as "none" and is
     not satisfied. -->

| Scenario | Decision in the design | Satisfied |
|---|---|---|
| <!-- scenario name --> | <!-- decision, or none --> | <!-- yes or no --> |
```

The fourth step is `openspec/config.yaml`. The configuration needs three changes. It names the fork as the default schema. It gains a rule for the design, which is the example's second need. And it gains a line of archive guidance, the fourth. The machine's own context and its rule for the tasks stay as they were.

```
--- a/openspec/config.yaml
+++ b/openspec/config.yaml
@@ -1,4 +1,4 @@
-schema: spec-driven
+schema: with-trace
 
 context: |
   This OpenSpec root holds one example for the book in
@@ -15,6 +15,13 @@ context: |
   is replaced rather than defended.
 
 rules:
+  design:
+    - State a case as a non-goal only if no scenario tests it.
   tasks:
     - Each task states how it is verified, by reading the artifacts or by running
       `openspec validate`.
+
+operations:
+  archive:
+    guidance:
+      - The archive summary says whether trace.md was read before the merge.
```

Then the program is asked whether the schema is well formed. This is the check that section 13.5 says it makes: the syntax, the template files, the ids and the cycles.

```
$ openspec schema validate with-trace
Note: Schema commands are experimental and may change.
✓ Schema 'with-trace' is valid
```

The answer says the schema is valid. It says nothing about the instruction of the trace, which is the new part that matters.

## 14.2 A new change takes the new default

A new change needs no flag, because the configuration now names the fork. The program says which schema it used, and writes it into the change's own file.

```
$ openspec new change refuse-without-exact-change
- Creating change 'refuse-without-exact-change' with schema 'with-trace'...
Created change 'refuse-without-exact-change' at openspec/changes/refuse-without-exact-change/
Schema: with-trace
Next: openspec status --change refuse-without-exact-change
```

The change's folder holds one file so far, `.openspec.yaml`, and it is the record that outranks the configuration's default from now on (section 13.4).

```
schema: with-trace
created: 2026-11-26
```

`openspec status` lists the artifacts and what blocks each. There are five, not four, and the trace is blocked until the specs and the design both exist.

```
$ openspec status --change refuse-without-exact-change
- Loading change status...
Change: refuse-without-exact-change
Schema: with-trace
Change root: ./openspec/changes/refuse-without-exact-change
Progress: 0/5 artifacts complete

[ ] proposal
[-] specs (blocked by: proposal)
[-] design (blocked by: proposal)
[-] trace (blocked by: specs, design)
[-] tasks (blocked by: specs, design, trace)

Next: openspec instructions proposal --change "refuse-without-exact-change" --json
```

The order of the first three artifacts is as chapters 3 and 4 gave it. What the customization changed is the end: the tasks, which waited for the specs and the design, now wait for the trace as well.

## 14.3 What the agent is told

The schema and the configuration decide what the agent is told when it asks for an artifact or an operation. The program shows it as JSON, and the three commands below are the ones that carry the customization. The output is long, and each block is cut to the field that the customization put there.

The design's instruction is the schema's, with the configuration's context, rules and template each in a field of its own. The rule for the design is the one the fourth step of section 14.1 wrote.

```
$ openspec instructions design --change refuse-without-exact-change --json
{
...
  "rules": [
    "State a case as a non-goal only if no scenario tests it."
  ],
...
}
```

The archive's guidance is a field of its own and is not a rule, as section 13.3 said.

```
$ openspec instructions archive --change refuse-without-exact-change --json
{
...
  "operationGuidance": [
    "The archive summary says whether trace.md was read before the merge."
  ],
...
}
```

The apply instruction is the schema's. It appears in the output once the change is ready, which section 14.6 reaches, and what it says is the two lines that the diff added. What the program prints is what the agent is told. Whether an agent follows it is not something the program shows.

## 14.4 The trace is the new file

The four default artifacts are written as chapter 4 quotes them. After the design the program says that the trace is next, and that the tasks wait for it alone.

```
$ openspec status --change refuse-without-exact-change
- Loading change status...
Change: refuse-without-exact-change
Schema: with-trace
Change root: ./openspec/changes/refuse-without-exact-change
Progress: 3/5 artifacts complete

[x] proposal
[x] specs
[x] design
[ ] trace
[-] tasks (blocked by: trace)

Next: openspec instructions trace --change "refuse-without-exact-change" --json
```

The trace is written from the design's Findings, where chapter 4 quotes Traces B, C and D. No archive holds this file, so it is written for the chapter, as the previous chapter's example was. Its three rows are the three scenarios of the delta, each with the decision in the design that satisfies it.

```
## Trace

| Scenario | Decision in the design | Satisfied |
|---|---|---|
| Change is given from stock | Work out the change before the product is released; 30 owed is 20 and 10 (Trace C) | yes |
| Exact payment gives no change | Nothing is owed, so the change is exact and no coin is returned (Trace D) | yes |
| Stock cannot make the change | If the change is not exact, refuse the purchase, release no product, and return the amount inserted (Trace B) | yes |
```

With the trace written the tasks are ready, and when they are written the program reports all five artifacts.

```
$ openspec status --change refuse-without-exact-change
- Loading change status...
Change: refuse-without-exact-change
Schema: with-trace
Change root: ./openspec/changes/refuse-without-exact-change
Progress: 5/5 artifacts complete

[x] proposal
[x] specs
[x] design
[x] trace
[x] tasks

All planning artifacts complete!
Next: openspec instructions apply --change "refuse-without-exact-change" --json
```

## 14.5 What the trace would have shown the first design

The trace was added because of what the first version failed to do. Chapter 4 told it: the design of `give-exact-change` set the stock case aside as a non-goal, the change passed validation and every task, and a walkthrough written afterwards found the case undecided. The question here is where the trace would have shown it.

A trace of the first design, against the three scenarios of the second change, is the file below. It is hypothetical, and it is written for this chapter. The machine did not write it, and the first change did not have the scenario it lists last. The first two rows follow the first design's own Findings, and the third follows its Non-Goals.

```
## Trace

| Scenario | Decision in the design | Satisfied |
|---|---|---|
| Change is given from stock | Work out the change greedily from the stock; 30 owed is 20 and 10 | yes |
| Exact payment gives no change | Nothing is owed, so no coin is returned | yes |
| Stock cannot make the change | none | no |
```

The third row has no decision, and the trace's instruction tells whoever writes it to say so and not to edit the design to hide the gap. The configuration's rule would have met the same row from the other side: the first design states exactly that case as a non-goal, while a scenario now tests it.

This is a limit as well as a finding. The row exists because the scenario exists. The first change had no scenario for the stock case, so a trace of it would have had two rows and both would have read yes. A trace finds a scenario that has no decision, and cannot find a scenario that nobody wrote. That is the coverage review of chapter 6, and the trace does not replace it. The trace does not prevent the failure either. It puts the failure where the review is cheapest, after the design and before the first task.

## 14.6 Apply, validate and archive

Apply reads the tasks, and with them unticked the program returns the schema's instruction. The boxes of chapter 4's tasks are ticked in the archive, so the scratch project's copy has them unticked, and ticks them after this command, as an apply would. The output is cut to the fields that matter.

```
$ openspec instructions apply --change refuse-without-exact-change --json
{
...
  "state": "ready",
  "instruction": "Read context files, work through pending tasks, mark complete as you go.\nPause if you hit blockers or need clarification.\nBefore each task, read trace.md and stop if a scenario the task touches is\nmarked not satisfied.",
...
}
```

With the boxes ticked, `validate` passes the change.

```
$ openspec validate refuse-without-exact-change --strict
Change 'refuse-without-exact-change' is valid
```

The command checks the structure of the specifications. It does not open the trace, and a trace that is a row of dashes passes it. The next block is a run and not advice: the trace is replaced by a one-row placeholder, and `status` and `validate` are run again.

```
## Trace

| Scenario | Decision in the design | Satisfied |
|---|---|---|
| - | - | - |
```

```
$ openspec status --change refuse-without-exact-change
- Loading change status...
Change: refuse-without-exact-change
Schema: with-trace
Change root: ./openspec/changes/refuse-without-exact-change
Progress: 5/5 artifacts complete
...
$ openspec validate refuse-without-exact-change --strict
Change 'refuse-without-exact-change' is valid
```

The program counts an artifact by its file. The placeholder is counted like the table of three rows, because the file is there. The original trace is restored and archive is run.

```
$ openspec archive refuse-without-exact-change --yes
Task status: ✓ Complete

Specs to update:
  purchase: update
Applying changes to openspec/specs/purchase/spec.md:
  ~ 1 modified
Totals: + 0, ~ 1, - 0, → 0
Specs updated successfully.
Change 'refuse-without-exact-change' archived as '2026-11-26-refuse-without-exact-change'.
```

The command moves the whole folder, as chapter 12 said, and the archived folder holds the trace beside the design.

```
$ ls openspec/changes/archive/2026-11-26-refuse-without-exact-change/
design.md
proposal.md
specs
tasks.md
trace.md
```

The guidance for the archive asked the summary to say whether the trace was read. The `archive` command writes no summary, and the output above has none. The archive workflow, which the agent runs, is where such a summary would be written, and nothing checks that it says it.

## 14.7 What the customization costs

The customization costs a fork and a file for every change. The fork is a copy of `spec-driven` as it was on the day it was made, and the project keeps it up to date by hand, or does not, because nothing flows from the package into it. Every change carries one more artifact, which is one more file to write after the design and to read before the first task.

What the tool counts is not what was reviewed. A design edited after the trace leaves the trace as it was. The next line is appended to the design of the scratch change, a decision that the trace does not mention, and `status` and `validate` are asked what they think.

```
**Decision**: refuse every purchase for which the stock holds fewer than three coins.
```

```
$ openspec status --change refuse-without-exact-change
- Loading change status...
Change: refuse-without-exact-change
Schema: with-trace
Change root: ./openspec/changes/refuse-without-exact-change
Progress: 5/5 artifacts complete
...
$ openspec validate refuse-without-exact-change --strict
Change 'refuse-without-exact-change' is valid
```

Five of five, and valid, after a decision the trace never traced. The trace is as good as the review that wrote it and the review that reads it, and the program does not know either.

A customized change is the default change with one more file. The program shows that the file exists, that the schema is well formed, and what each instruction says. It shows nothing about whether the trace is true, whether it was read before the tasks, or whether the summary at the archive said so, and those stay with the reviewer, as the previous chapter said of every customization.
