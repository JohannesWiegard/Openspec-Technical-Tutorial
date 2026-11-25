# 14. A Customized Change, from Fork to Archive

The previous chapter said what can be customized, and what the tool checks for each kind of customization. This chapter shows it in practice. It uses the vending machine's second change, `refuse-without-exact-change`, which chapter 4 quotes in full. The chapter makes this change again under a schema of its own, `with-trace`. The schema adds one artifact, a trace, between the design and the tasks. The chapter shows every file that the customization adds or changes. It also shows the console input and the main output of each step. The proposal, the delta, the design and the tasks of the change are chapter 4's. This chapter points to them and does not repeat them. The table of section 13.6 lists the four needs of the example and the place where each need is met.

The walkthrough ran on OpenSpec 2.1.1 in a scratch project on 20 November 2026. The scratch project starts from the machine's own configuration and from a main specification that holds the first change's result. This chapter is the only one in the book that shows console blocks. Its claims are what the program printed, and a reader can check them only by seeing that output. A line that begins with `$ ` is input, and the lines after it are the program's output. The project's folder is written as `.`, and the program's own install folder as `<package>`. A line of three dots marks output that is cut. No block shows the work of an agent. The files were written by hand in the scratch project.

## 14.1 Preparing the harness

The harness is prepared in four steps: a fork, a schema that differs from it, a template, and a configuration that names the fork. After each step, the program is asked what it now knows.

The scratch project holds the machine's own `config.yaml`, which names `spec-driven`. It also holds a main specification of `purchase` with the first change's result. So the project is the example's second change, waiting to be made. The first of the four steps is the fork. It copies the package's `spec-driven` into the project under a new name.

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

`openspec schema which` says where a schema comes from. With `--all`, it lists the schemas that the project can reach. The fork is a project schema, and `spec-driven` is still the package's schema.

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

The second step is to edit `schema.yaml` in the new folder. The file is the package's default of 273 lines, so the chapter shows it as the difference from the fork. The diff has four changes. The description says what the fork is. A `trace` artifact is added after the design, and it requires the specs and the design. The tasks gain `trace` in their `requires`. The apply block gains two lines. The lines of the default schema that the diff does not show are unchanged.

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

The `requires` of the trace puts it between the design and the tasks. The `requires` of the tasks makes it mandatory. The two lines of the apply block are the third of the example's four needs. The third step is the template that the trace's `template: trace.md` names. It is a new file, `templates/trace.md`, in the same folder. The block below shows the whole file.

```
## Trace

<!-- One row for every scenario in the specs. Name the decision in the design that
     satisfies the scenario. A scenario with no decision is written as "none" and is
     not satisfied. -->

| Scenario | Decision in the design | Satisfied |
|---|---|---|
| <!-- scenario name --> | <!-- decision, or none --> | <!-- yes or no --> |
```

The fourth step is `openspec/config.yaml`. The configuration needs three changes. It names the fork as the default schema. It gains a rule for the design, which is the example's second need. It also gains a line of archive guidance, which is the fourth need. The machine's own context and its rule for the tasks stay as they were.

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

Then the program is asked whether the schema is well formed. Section 13.5 says what this check covers: the syntax, the template files, the ids and the cycles.

```
$ openspec schema validate with-trace
Note: Schema commands are experimental and may change.
✓ Schema 'with-trace' is valid
```

The answer says that the schema is valid. It says nothing about the instruction of the trace, and that instruction is the new part that matters.

## 14.2 A new change uses the new default schema

A new change needs no flag, because the configuration now names the fork. The program says which schema it used. It also writes that schema into the change's own file.

```
$ openspec new change refuse-without-exact-change
- Creating change 'refuse-without-exact-change' with schema 'with-trace'...
Created change 'refuse-without-exact-change' at openspec/changes/refuse-without-exact-change/
Schema: with-trace
Next: openspec status --change refuse-without-exact-change
```

So far, the change's folder holds one file, `.openspec.yaml`. From now on, this file is the record that outranks the configuration's default (section 13.4).

```
schema: with-trace
created: 2026-11-20
```

`openspec status` lists the artifacts and what blocks each one. There are five artifacts, not four. The trace is blocked until both the specs and the design exist.

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

The order of the first three artifacts is the one that chapters 3 and 4 gave. The customization changed the end. The tasks waited for the specs and the design, and now they wait for the trace as well.

## 14.3 What the agent is told

The schema and the configuration decide what the agent is told when it asks for an artifact or an operation. The program shows this as JSON. The three commands below are the ones whose output carries the customization. The output is long, so each block is cut to the field that the customization put there.

The design's instruction is the schema's. The configuration's context, rules and template are each in a field of their own. The rule for the design is the one that the fourth step of section 14.1 wrote.

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

The archive's guidance is a field of its own. It is not a rule, as section 13.3 said.

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

The apply instruction is the schema's. It appears in the output once the change is ready, and section 14.6 reaches that point. What it says is the two lines that the diff added. What the program prints is what the agent is told. The program does not show whether an agent follows it.

## 14.4 The trace, the new file

The proposal, the delta, the design and the tasks of the change are chapter 4's. They are written as chapter 4 quotes them. Once the proposal exists, `specs` and `design` are ready, and the trace waits for both. After the design, the program says that the trace is next. It also says that the tasks wait only for the trace.

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

The trace is written from the design's Findings, where chapter 4 quotes Traces B, C and D. No archive holds this file. So it is written for this chapter, as the previous chapter's example was, and it is not the output of an agent run. Its three rows are the three scenarios of the delta. Each row names the decision in the design that satisfies the scenario.

```
## Trace

| Scenario | Decision in the design | Satisfied |
|---|---|---|
| Change is given from stock | Work out the change before the product is released; 30 owed is 20 and 10 (Trace C) | yes |
| Exact payment gives no change | Nothing is owed, so the change is exact and no coin is returned (Trace D) | yes |
| Stock cannot make the change | If the change is not exact, refuse the purchase, release no product, and return the amount inserted (Trace B) | yes |
```

With the trace written, the tasks are ready. When the tasks are written, the program reports all five artifacts.

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

## 14.5 What the trace would have shown about the first design

The trace was added because of what the first version failed to do. Chapter 4 told that story. The design of `give-exact-change` set the stock case aside as a non-goal. The change passed validation and every task. A walkthrough written afterwards found the case undecided. The question here is where the trace would have shown the problem.

The file below is a trace of the first design, against the three scenarios of the second change. It is hypothetical, and it is written for this chapter. The machine did not write it. The first change did not have the scenario that the trace lists last. The first two rows follow the first design's own Findings, and the third row follows its Non-Goals.

```
## Trace

| Scenario | Decision in the design | Satisfied |
|---|---|---|
| Change is given from stock | Work out the change greedily from the stock; 30 owed is 20 and 10 | yes |
| Exact payment gives no change | Nothing is owed, so no coin is returned | yes |
| Stock cannot make the change | none | no |
```

The third row has no decision. The trace's instruction tells whoever writes it to say so, and not to edit the design to hide the gap. The configuration's rule would have found the same row from the other side. The first design states exactly that case as a non-goal, while a scenario now tests it.

This is a limit as well as a finding. The row exists because the scenario exists. The first change had no scenario for the stock case. So a trace of it would have had two rows, and both would have read yes. A trace finds a scenario that has no decision. It cannot find a scenario that nobody wrote. That is the coverage review of chapter 6, and the trace does not replace it. The trace does not prevent the failure either. It puts the failure where the review is cheapest: after the design and before the first task.

## 14.6 Apply, validate and archive

Apply reads the tasks. While the tasks are unticked, the program returns the schema's instruction. The boxes of chapter 4's tasks are ticked in the archive. So the scratch project's copy has them unticked, and it ticks them after this command, as an apply would. The output is cut to the fields that matter.

```
$ openspec instructions apply --change refuse-without-exact-change --json
{
...
  "state": "ready",
  "instruction": "Read context files, work through pending tasks, mark complete as you go.\nPause if you hit blockers or need clarification.\nBefore each task, read trace.md and stop if a scenario the task touches is\nmarked not satisfied.",
...
}
```

The last two lines are the diff's. The program returns them, and it counts nothing about whether they are followed. With the boxes ticked, `validate` passes the change.

```
$ openspec validate refuse-without-exact-change --strict
Change 'refuse-without-exact-change' is valid
```

The command checks the structure of the specifications. It does not open the trace, and a trace that is a row of dashes passes it. The next block is a run and not advice. The trace is replaced by a one-row placeholder, and `status` and `validate` are run again.

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

The program counts an artifact by its file. It counts the placeholder like the table of three rows, because the file is there. Then the original trace is restored, and archive is run.

```
$ openspec archive refuse-without-exact-change --yes
Task status: ✓ Complete

Specs to update:
  purchase: update
Applying changes to openspec/specs/purchase/spec.md:
  ~ 1 modified
Totals: + 0, ~ 1, - 0, → 0
Specs updated successfully.
Change 'refuse-without-exact-change' archived as '2026-11-20-refuse-without-exact-change'.
```

The command moves the whole folder, as chapter 12 said. The archived folder holds the trace beside the design.

```
$ ls openspec/changes/archive/2026-11-20-refuse-without-exact-change/
design.md
proposal.md
specs
tasks.md
trace.md
```

The guidance for the archive asked the summary to say whether the trace was read. The `archive` command writes no summary, and the output above has none. Such a summary would be written in the archive workflow, which the agent runs. Nothing checks that the summary says it.

## 14.7 What the customization costs

The customization costs a fork, and one more file for every change. The fork is a copy of `spec-driven` as it was on the day it was made. Nothing flows from the package into it. So the project keeps it up to date by hand, or does not keep it up to date. Every change carries one more artifact. That is one more file to write after the design, and to read before the first task.

What the tool counts is not what was reviewed. A design edited after the trace leaves the trace as it was. The next line is appended to the design of the scratch change. It is a decision that the trace does not mention. Then `status` and `validate` are asked what they report.

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

Five of five, and valid, after a decision that the trace never traced. The trace is as good as the review that wrote it and the review that reads it. The program knows about neither review.

A customized change is the default change with one more file. The program shows that the file exists, that the schema is well formed, and what each instruction says. It shows nothing about whether the trace is true, or whether it was read before the tasks. It also shows nothing about whether the summary at the archive said so. Those questions stay with the reviewer, as the previous chapter said of every customization.
