# 6. The Specification and the Cases That Decide It

Chapter 5 ended with the proposal's scope handed to the next artifact, which that chapter called the specification. This chapter takes that artifact up and asks the same four questions of it: who writes it, which of its parts must be right, how a reviewer decides that it is finished, and what happens when the review finds something wrong. The example is the same vending machine and the same two changes.

Before the questions, two files have to be kept apart, because OpenSpec calls both of them specifications. The delta is the `spec.md` inside a change's folder, at `openspec/changes/<change>/specs/<capability>/spec.md`, and it says what that one change adds, modifies or removes. The main specification is the `spec.md` at `openspec/specs/<capability>/spec.md`, which holds the system's description as it now stands, and which archiving writes. Chapter 3 introduced the two files and chapter 4 showed both in full, so this chapter defines them and does not explain them again. From here, "the delta" is the artifact, and "the main specification" is the file it is merged into.

The table shows the files of a change and the paths of its specifications. The rows this chapter discusses are in bold.

| Item | File | What it says | Discussed in |
|---|---|---|---|
| Change | `openspec/changes/<change>/` | The folder of one change. Archive moves it into the archive. | Chapter 4 |
| Proposal | `proposal.md` | Why the change exists and what it changes. | Chapters 4 and 5 |
| **Capability** | **`specs/<capability>/`** | **The folder for one area of behaviour, such as `purchase`.** | **Chapters 4 and 6** |
| **Specification** | **`specs/<capability>/spec.md`** | **What one change adds, modifies or removes.** | **Chapters 4 and 6** |
| **Main specification** | **`openspec/specs/<capability>/spec.md`** | **The system as it stands. Archive writes it.** | **Chapters 4 and 6** |
| Design | `design.md` | How the work is done. | Chapters 4 and 7 |
| Tasks | `tasks.md` | The checks that turn the design into work. | Chapters 4 and 8 |
| Schema marker | `.openspec.yaml` | The schema the change follows, and `skip_specs` when it has no deltas. | Chapter 4 |

Both files are organised by capability, the area of behaviour that a folder name stands for, and a capability is not a file, a feature or a screen. The coins a machine holds and the change it returns are one capability in the example, and chapter 5 explains why that boundary was drawn. The name is the one thing that the proposal, the delta and the main specification must agree on. A change that modifies an existing capability writes its delta to the path the main specification already has, and archive refuses a MODIFIED delta whose capability does not exist. Every later question in this chapter is about the contents of such a file, and the path is where those contents are kept.

The table lists the parts of a delta, the file `spec.md` in the change's `specs` folder. The parts this chapter quotes or discusses are in bold.

| Specification | Description |
|---|---|
| **Purpose** | For a new capability: one or two sentences on what the capability is for. Archive copies it into the main specification. |
| **ADDED Requirements** | The operation for a capability with no main specification yet, or for requirements the main specification does not have. |
| **MODIFIED Requirements** | The operation that replaces a whole requirement the main specification already has. |
| REMOVED Requirements | The operation that takes a requirement out of the main specification. Named here, not shown. |
| RENAMED Requirements | The operation that changes the name of a requirement. Named here, not shown. |
| **Requirement** | One statement of what the system must do, written with SHALL. |
| **Scenario** | One case under a requirement, written as WHEN, the condition, and THEN, the outcome. |

## 6.1 Who writes the delta

The agent writes one delta for each capability that the proposal lists in its Capabilities part, as a file at `specs/<capability>/spec.md` in the change folder. To do that it reads the proposal, the main specifications under `openspec/specs/`, and the developer's request. Section 5.1 described the same division for the proposal, and chapter 2 gave the reason human control stays with the developer.

The agent supplies the form that the template asks for: the headings, the SHALL sentence of each requirement, and the WHEN and THEN lines of each scenario. It cannot supply which behaviour the machine ought to have, which cases matter, or whether two requirements are really one. Those decisions belong to the developer, and a delta that follows the template exactly can still describe the wrong behaviour. That is why the review in section 6.7 reads for meaning as well as for form.

Chapter 3's division of work holds here as it did for the proposal. `openspec validate` reads the delta and reports the form problems it finds, and `openspec archive` merges the delta into the main specification. The first delta in the example passed every check and still left a case undecided.

## 6.2 The parts of a delta

A delta has four parts in the default template, and the table shows what the tool checks of each one.

| Part | What the tool checks | The question it answers |
|---|---|---|
| Purpose | Only in a delta for a new capability. The tool does not check its length in a delta; the main specification warns when its Purpose is under 50 characters. In a delta for an existing capability the Purpose is ignored. | What is this capability for? |
| Operation: ADDED, MODIFIED, REMOVED or RENAMED | `validate` reports an error for a MODIFIED that drops a scenario the main specification has, and for a change with no delta unless it declares `skip_specs`. A MODIFIED for a capability that does not exist passes `validate` with a note, and `archive` refuses it. | What does the delta do to the main specification? |
| Requirement | Without SHALL or MUST, a warning that `--strict` fails. Without a scenario, an error. Over 500 characters, a warning that `--strict` fails, for an ADDED requirement and for a MODIFIED one that grows past the limit. | What must the system do? |
| Scenario | A scenario header with three hashtags is ignored, so its requirement has none and `validate` reports an error. Without a WHEN or GIVEN step, or without a THEN step, a warning that `--strict` fails. | In what case, and with what outcome, is the requirement tested? |

The four parts are the whole of the default delta, and the tool reads them for form only. Whether a requirement describes the behaviour the developer meant is for the reviewer, and section 6.7 says how that is checked. A part that a project adds lives in a schema the project has forked, as chapter 3 described, and the default template has no such part. The quotations below show each part as the example's archive holds it.

## 6.3 A purpose, and the requirement it introduces

The file is `specs/purchase/spec.md` in the change `give-exact-change`, and its Purpose reads as archived:

```markdown
## Purpose

Defines the coins the vending machine holds and the change it returns for a purchase, so that a customer who pays more than the price receives the difference in coins from the machine's stock.
```

A Purpose says what a capability is for, in one or two sentences. Section 4.6 shows where archive puts it. The second delta has none, since the capability already has a Purpose in the main specification, and a Purpose written into such a delta is ignored.

The file is `specs/purchase/spec.md` in the change `give-exact-change`, and its operation and first requirement read as archived:

```markdown
## ADDED Requirements

### Requirement: The machine holds coins of four denominations

The machine SHALL hold coins of 10, 20, 50 and 100 cents only. Amounts are stated in
cents.

#### Scenario: Stock holds only the four denominations

- **WHEN** the machine is stocked
- **THEN** every coin in its stock is a coin of 10, 20, 50 or 100 cents
```

The heading says what the delta does to the main specification. ADDED is the operation for a capability with no main specification yet, and its requirements are appended. The requirement is one statement with SHALL, carrying one behaviour, that the stock holds four denominations, and one convention, that amounts are stated in cents. Its name is what the tool matches on: an ADDED requirement must not already exist, and a MODIFIED or REMOVED entry must name one that does. The other two operations exist as well. REMOVED takes a requirement out of the main specification, and RENAMED changes a requirement's name. The example uses neither, so this chapter does not show them.

## 6.4 Scenarios, and the case nobody wrote

The file is `specs/purchase/spec.md` in the change `give-exact-change`, and its second requirement reads as archived:

```markdown
### Requirement: The machine gives change in coins from its stock

The machine SHALL return to the customer the difference between the amount inserted
and the price of the product, in coins from its stock.

#### Scenario: Change is given from stock

- **WHEN** the price is 70 cents, 100 cents is inserted, and the stock holds at least
  one coin of 10 cents and at least one coin of 20 cents
- **THEN** the machine returns 30 cents as one coin of 20 cents and one coin of 10
  cents

#### Scenario: Exact payment gives no change

- **WHEN** the price is 70 cents and 70 cents is inserted
- **THEN** the machine returns no change
```

A scenario is one case, written so that a tester can set it up and read the result. WHEN names a condition the developer can produce, and THEN names an outcome that can be judged yes or no. The scenario with a price of 70 cents and 100 cents inserted says which coins come back, which the requirement's sentence does not. A reviewer uses a scenario as a developer uses a test: set up the condition, read the outcome, and ask whether it is the one the requirement promises.

The two scenarios cover a stock that holds the coins needed, and an exact payment. The requirement says the machine SHALL return the difference in coins from its stock, and says nothing about a stock that cannot make that difference. Both scenarios pass, validation passes, and nothing in the delta asks what happens for that stock. The case is found by varying what the requirement depends on, the price, the amount inserted and the stock, and asking what each variation should do. Section 4.7 shows the walkthrough that found it. The first delta is not defective: it decides the cases it lists, and it lists two.

## 6.5 A revision of one requirement

The file is `specs/purchase/spec.md` in the change `refuse-without-exact-change`, and it is shown in full as archived:

```markdown
## MODIFIED Requirements

### Requirement: The machine gives change in coins from its stock

The machine SHALL return to the customer the difference between the amount inserted
and the price of the product, exactly, in coins from its stock. If it cannot return
that exact amount, it SHALL refuse the purchase, release no product, and return the
amount inserted.

#### Scenario: Change is given from stock

- **WHEN** the price is 70 cents, 100 cents is inserted, and the stock holds at least
  one coin of 10 cents and at least one coin of 20 cents
- **THEN** the machine returns 30 cents as one coin of 20 cents and one coin of 10
  cents

#### Scenario: Exact payment gives no change

- **WHEN** the price is 70 cents and 70 cents is inserted
- **THEN** the machine returns no change

#### Scenario: Stock cannot make the change

- **WHEN** the price is 70 cents, 100 cents is inserted, and the stock holds one coin
  of 10 cents and no coin of 20 or 50 cents
- **THEN** the machine refuses the purchase, releases no product, and returns the 100
  cents inserted
```

The second delta is written out whole, because a MODIFIED requirement replaces the whole requirement in the main specification. Set against the first delta's requirement, the revision is small: a word, a sentence and a scenario. The earlier scenarios stand as they were. The tool reports a MODIFIED that drops a scenario the main specification has, as an error, and it compares scenario names and not their text. A scenario whose wording changes under the same name is therefore not noticed.

The new scenario is the case from the previous section, written down so that it can be decided. It fixes a stock of one coin of 10 cents and none of 20 or 50 cents, and an outcome: the purchase is refused, no product is released, and the amount inserted comes back. With the scenario in place the requirement can be judged for that stock, and the design that follows can be traced against it. Chapter 7 takes up the design's answer.

## 6.6 What the delta leaves to the design

The delta says what the system must do, and it leaves how to the design. The schema's instruction for specifications gives a quick test: "if the implementation can change without changing externally visible behavior, it likely does not belong in the spec." Neither requirement in the example fixes an order of steps or a method for finding coins; section 4.4 shows the first design deciding both. A decision written into a requirement would make the requirement change every time the method does. The how belongs to the design, which chapter 7 takes up, and this chapter does not analyse it.

## 6.7 Reviewing a delta

A delta is reviewed after the proposal is approved and before the design is written from it, because the design will be traced against these scenarios and a scenario that is wrong is cheapest to fix now. The review has four passes. Intent asks whether this is the behaviour the developer meant. Decidability asks whether each scenario can be set up and its outcome judged. Coverage asks which price, payment and stock have no scenario. Fit asks whether there is one delta for each capability the proposal lists, at a path that matches, with an operation that matches New or Modified. Decidability and coverage matter most, because the tool cannot see either of them, and every later artifact is checked against the scenarios.

The table is one checklist, in the order the file is read, and the column names use the artifact's name, the specification, which here means the delta. Like the review table in chapter 5, it is a memory aid, and no part of the tool reads it.

| Check | The specification passes when | How a draft can fail |
|---|---|---|
| The request is answered as meant | There is one delta for each capability the proposal lists, and it states the behaviour the developer meant | The agent wrote the behaviour it thought the request implied, and the scenarios test that instead |
| One file per capability | Each capability has one `spec.md`, at the path the Capabilities part names | Two capabilities share one file, or a path is spelled differently from the proposal |
| Operation matches the proposal | ADDED for a capability that does not exist, MODIFIED for one that does | A new capability is filed under MODIFIED, which `archive` refuses, or an existing requirement under ADDED, which `archive` refuses when the name is the same and adds beside the old one when the name differs |
| Purpose | A new capability has one or two sentences of Purpose, and an existing one has none | The Purpose is missing for a new capability, or it is written for an existing one, where the tool ignores it |
| Requirement | Each requirement states one behaviour with SHALL or MUST | A requirement says "should" or "may", which validation only warns about, or it holds several behaviours in one block |
| Scenario | Each requirement has at least one scenario at four hashtags, with a WHEN and a THEN | A scenario is written at three hashtags and is ignored, which leaves its requirement with none, or it restates the requirement and names no case |
| Coverage | Each price, payment and stock the requirement depends on has a scenario, or the gap is named | The requirement depends on the stock, and no scenario varies it |
| Modified requirement | The MODIFIED block carries the whole requirement, every scenario the main specification has, and the new ones | A partial MODIFIED drops a scenario, which `validate` refuses, or it changes a scenario's text under its old name, which the tool does not notice |
| Downstream | The design can be traced against every scenario | A scenario is written that the design cannot be traced against, or the design sets aside a case that a scenario tests, and the disagreement is found only later |

## 6.8 Changing a delta after review

Once a review has found a fault, two questions follow: what the revision covers, and who makes it. The table answers the first.

| What exists | What the revision covers |
|---|---|
| Only the delta | The part, and the parts coupled to it: a new scenario can change the wording of its requirement. |
| The delta, with the design and the tasks written from it | Those too. They were traced against the old text, and a trace that was true of the old text says nothing about the new. |
| An archived change | Nothing in the archive. A later gap goes into a new change. |

Of the three rows, the example shows only the bottom one, and chapter 5 gives the reason the archive has no case of the middle row.

The second decision is which means to use, and there are two. The developer can edit the delta, or ask the agent to revise it. The choice turns on whether the corrected text is already known, and the table compares the two on four points.

| | The developer edits the file | The agent is asked to revise it |
|---|---|---|
| Right when | The replacement is known, and the fault sits in one scenario or one sentence | The text must be worked out from the main specification or the other scenarios |
| What it costs | A minute with the file open, and a diff that shows one change | A request with three parts, a whole file to read back, and a diff whose size hides what actually changed |
| How it goes wrong | An edit to one scenario leaves the requirement's wording, or the other scenarios, out of step with it | A request for a clearer scenario returns a rewrite that changes more than was asked, and a MODIFIED block can lose a scenario |
| What to check afterwards | The requirement and every scenario it has | The whole file, including the scenarios nobody meant to change |

Suppose the first delta's Change scenario had said that the machine returns "an appropriate set of coins", and the developer knows the sentence the archive holds: 30 cents as one coin of 20 cents and one coin of 10 cents. The edit is right because the replacement was known before the file was opened. One sentence changes, nothing else moves, and the diff shows nothing else.

Suppose instead that the developer sees that no scenario covers a stock without a 10-cent coin, but cannot yet say what the machine should do in that case. A request to the agent has three parts:

1. which part to revise: the one requirement and its scenarios;
2. what is wrong with it: no scenario covers a stock with no coin of 10 cents;
3. what must not move: the requirement's text, its header and the scenarios that already exist.

The request asks the agent to propose the outcome from the main specification and the other scenarios, and the developer reviews that proposal before it is accepted. Without the third part, the agent may rewrite the whole block.

The two means meet at the same reading. An edit is judged by its diff, and a change outside the scenario is an error. A revision made by asking rewrites the file, so the reader checks the whole delta again, using the passes of section 6.7. The tool catches a scenario dropped from a MODIFIED block. It does not catch a scenario whose text moved, so the reader has to.

## 6.9 What the delta hands on

The delta hands the design a set of cases that the design must satisfy, and each scenario is a case the design will be traced against. The first design left the stock case undecided, and chapter 7 takes up what a design should do with a case it has set aside. The delta hands the tasks nothing directly, because the tasks are written from the design, as section 4.5 shows.

The next artifact answers how: in what order the machine works, by what method and with which coins. The delta leaves those open by design.

A delta is a requirement and the cases that decide it. An agent writes it and supplies the form, and a person reviews it and owns what the behaviour should be. A program checks the form, and it cannot check whether the cases are enough, so a delta can pass every check and still leave a case undecided. The cases nobody wrote are found by writing them, by varying what the requirement depends on and asking what each variation should do. The design is then traced against those cases, and it decides how the behaviour is produced.
