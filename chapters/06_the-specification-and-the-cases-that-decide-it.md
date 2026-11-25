# 6. The Specification and the Cases That Decide It

Chapter 5 ended when the proposal passed its scope to the next artifact. That chapter called this artifact the specification. This chapter discusses that artifact and asks it the same four questions. Who writes it? Which of its parts must be right? How does a reviewer decide that it is finished? What happens when the review finds something wrong? The example is the same vending machine with the same two changes.

Before the questions, two files must be kept apart, because OpenSpec calls both of them specifications. The delta is the `spec.md` inside a change's folder, at `openspec/changes/<change>/specs/<capability>/spec.md`. It says what that one change adds, modifies or removes. The main specification is the `spec.md` at `openspec/specs/<capability>/spec.md`. It holds the system's description as it now stands, and archive writes it. Chapter 3 introduced the two files, and chapter 4 showed both in full. So this chapter defines them and does not explain them again. From here on, "the delta" means the artifact, and "the main specification" means the file it is merged into.

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
| Schema marker | `.openspec.yaml` | The schema the change follows. It also holds `skip_specs` when the change has no deltas. | Chapter 4 |

Both files are organised by capability. A capability is the area of behaviour that a folder name stands for. It is not a file, a feature or a screen. In the example, the coins a machine holds and the change it returns are one capability. Chapter 5 explains why that boundary was drawn. The name is the one thing that the proposal, the delta and the main specification must agree on. A change that modifies an existing capability writes its delta to the path that the main specification already has. Archive refuses a MODIFIED delta whose capability does not exist. Every later question in this chapter is about the contents of such a file. The path is where those contents are kept.

The table lists the parts of a delta. A delta is the file `spec.md` in the change's `specs` folder. The parts this chapter quotes or discusses are in bold.

| Specification | Description |
|---|---|
| **Purpose** | For a new capability: one or two sentences on what the capability is for. Archive copies it into the main specification. |
| **ADDED Requirements** | The operation for a capability with no main specification yet. It is also the operation for requirements that the main specification does not have. |
| **MODIFIED Requirements** | The operation that replaces a whole requirement that the main specification already has. |
| REMOVED Requirements | The operation that takes a requirement out of the main specification. Named here, not shown. |
| RENAMED Requirements | The operation that changes the name of a requirement. Named here, not shown. |
| **Requirement** | One statement of what the system must do, written with SHALL. |
| **Scenario** | One case under a requirement. WHEN states the condition, and THEN states the outcome. |

## 6.1 Who writes the delta

The agent writes one delta for each capability that the proposal lists in its Capabilities part. Each delta is a file at `specs/<capability>/spec.md` in the change folder. To write it, the agent reads the proposal, the main specifications under `openspec/specs/`, and the developer's request. Section 5.1 described the same division for the proposal. Chapter 2 gave the reason why human control stays with the developer.

The agent supplies the form that the template asks for: the headings, the SHALL sentence of each requirement, and the WHEN and THEN lines of each scenario. The agent cannot decide which behaviour the machine ought to have. It cannot decide which cases matter, or whether two requirements are really one. Those decisions belong to the developer. A delta can follow the template exactly and still describe the wrong behaviour. For this reason, the review in section 6.7 reads the delta for meaning as well as for form.

The division of work from chapter 3 holds here, as it did for the proposal. `openspec validate` reads the delta and reports the form problems it finds. `openspec archive` merges the delta into the main specification. The first delta in the example passed every check, and it still left a case undecided.

## 6.2 The four parts of a delta, and what the tool checks

A delta has four parts in the default template. The table shows what the tool checks in each part.

| Part | What the tool checks | The question it answers |
|---|---|---|
| Purpose | Only in a delta for a new capability. The tool does not check its length in a delta. For the main specification, the tool warns when the Purpose is under 50 characters. In a delta for an existing capability, the Purpose is ignored. | What is this capability for? |
| Operation: ADDED, MODIFIED, REMOVED or RENAMED | `validate` reports an error for a MODIFIED that drops a scenario the main specification has. It also reports an error for a change with no delta, unless the change declares `skip_specs`. A MODIFIED for a capability that does not exist passes `validate` with a note. `archive` refuses it. | What does the delta do to the main specification? |
| Requirement | Without SHALL or MUST: a warning, which fails under `--strict`. Without a scenario: an error. Over 500 characters, for an ADDED requirement or a MODIFIED one that grows past the limit: a warning, which fails under `--strict`. | What must the system do? |
| Scenario | A scenario header with three hashtags is ignored. Its requirement then has no scenario, and `validate` reports an error. Without a WHEN or GIVEN step, or without a THEN step: a warning, which fails under `--strict`. | In what case, and with what outcome, is the requirement tested? |

The four parts are the whole of the default delta, and the tool reads them for form only. The reviewer decides whether a requirement describes the behaviour the developer meant. Section 6.7 says how that is checked. A part that a project adds is defined in a schema that the project has forked, as chapter 3 described. The default template has no such part. The quotations below show each part as the example's archive holds it.

## 6.3 The Purpose and the first requirement

The file is `specs/purchase/spec.md` in the change `give-exact-change`. Its Purpose reads as archived:

```markdown
## Purpose

Defines the coins the vending machine holds and the change it returns for a purchase, so that a customer who pays more than the price receives the difference in coins from the machine's stock.
```

A Purpose says what a capability is for, in one or two sentences. Section 4.6 shows where archive puts it. The second delta has no Purpose, because the capability already has one in the main specification. A Purpose written into such a delta is ignored.

The file is `specs/purchase/spec.md` in the change `give-exact-change`. Its operation and first requirement read as archived:

```markdown
## ADDED Requirements

### Requirement: The machine holds coins of four denominations

The machine SHALL hold coins of 10, 20, 50 and 100 cents only. Amounts are stated in
cents.

#### Scenario: Stock holds only the four denominations

- **WHEN** the machine is stocked
- **THEN** every coin in its stock is a coin of 10, 20, 50 or 100 cents
```

The heading says what the delta does to the main specification. ADDED is the operation for a capability with no main specification yet. Its requirements are appended. The requirement is one statement with SHALL. It carries one behaviour and one convention. The behaviour is that the stock holds four denominations. The convention is that amounts are stated in cents. The tool matches a requirement by its name. An ADDED requirement must not already exist, and a MODIFIED or REMOVED entry must name one that does. The other two operations exist as well. REMOVED takes a requirement out of the main specification. RENAMED changes a requirement's name. The example uses neither, so this chapter does not show them.

## 6.4 Scenarios, and the case that nobody wrote

The file is `specs/purchase/spec.md` in the change `give-exact-change`. Its second requirement reads as archived:

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

A scenario is one case. It is written so that a tester can set it up and read the result. WHEN names a condition that the developer can produce. THEN names an outcome that can be judged yes or no. One scenario has a price of 70 cents and 100 cents inserted. It says which coins come back, and the requirement's sentence does not say this. A reviewer uses a scenario in the way a developer uses a test. The reviewer sets up the condition and reads the outcome. Then the reviewer asks whether it is the outcome that the requirement promises.

The two scenarios cover two cases: a stock that holds the coins needed, and an exact payment. The requirement says the machine SHALL return the difference in coins from its stock. It says nothing about a stock that cannot make that difference. Both scenarios pass, and validation passes. Nothing in the delta asks what happens for that stock. The case is found by varying what the requirement depends on, and by asking what each variation should do. The requirement depends on the price, the amount inserted and the stock. Section 4.7 shows the walkthrough that found the case. The first delta is not defective. It decides the cases it lists, and it lists two.

## 6.5 A revision of one requirement

The file is `specs/purchase/spec.md` in the change `refuse-without-exact-change`. It is shown in full as archived:

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

The second delta is written out in full, because a MODIFIED requirement replaces the whole requirement in the main specification. Compared with the requirement in the first delta, the revision is small: a word, a sentence and a scenario. The earlier scenarios stay as they were. The tool reports an error when a MODIFIED drops a scenario that the main specification has. It compares scenario names, not their text. So when the wording of a scenario changes under the same name, the tool does not notice.

The new scenario is the case from the previous section, written down so that it can be decided. It fixes a stock and an outcome. The stock holds one coin of 10 cents and no coin of 20 or 50 cents. The outcome is that the purchase is refused, no product is released, and the amount inserted comes back. With this scenario in place, the requirement can be judged for that stock. The design that follows can then be traced against it. Chapter 7 discusses the design's answer.

## 6.6 What the delta leaves to the design

The delta says what the system must do. It leaves the how to the design. The schema's instruction for specifications gives a quick test: "if the implementation can change without changing externally visible behavior, it likely does not belong in the spec." Neither requirement in the example fixes an order of steps or a method for finding coins. Section 4.4 shows the first design deciding both. If a requirement contained such a decision, the requirement would change every time the method does. The how belongs to the design. Chapter 7 discusses the design, and this chapter does not analyse it.

## 6.7 Reviewing a delta

A delta is reviewed after the proposal is approved and before the design is written from it. The reason is that the design will be traced against these scenarios, and a wrong scenario is cheapest to fix now. The review has four passes. Intent asks whether this is the behaviour the developer meant. Decidability asks whether each scenario can be set up and its outcome judged. Coverage asks which price, payment and stock have no scenario. Fit asks whether there is one delta for each capability the proposal lists. It also asks whether each delta has a matching path and an operation that matches New or Modified. Decidability and coverage matter most, because the tool cannot see either of them. Also, every later artifact is checked against the scenarios.

The table is one checklist. Its rows follow the order in which the file is read. The column names use the artifact's name, the specification, which here means the delta. Like the review table in chapter 5, this table is a memory aid. No part of the tool reads it.

| Check | The specification passes when | How a draft can fail |
|---|---|---|
| The request is answered as meant | There is one delta for each capability the proposal lists. The delta states the behaviour the developer meant | The agent wrote the behaviour it thought the request implied. The scenarios test that behaviour instead |
| One file per capability | Each capability has one `spec.md`, at the path that the Capabilities part names | Two capabilities share one file, or a path is spelled differently from the proposal |
| Operation matches the proposal | ADDED for a capability that does not exist, MODIFIED for one that does | A new capability is filed under MODIFIED, which `archive` refuses, or an existing requirement under ADDED: `archive` refuses it if the name is the same, and adds it beside the old one if the name differs |
| Purpose | A new capability has one or two sentences of Purpose. An existing one has none | The Purpose is missing for a new capability, or it is written for an existing one, where the tool ignores it |
| Requirement | Each requirement states one behaviour with SHALL or MUST | A requirement says "should" or "may", which validation only warns about, or it holds several behaviours in one block |
| Scenario | Each requirement has at least one scenario at four hashtags, with a WHEN and a THEN | A scenario is written at three hashtags and is ignored, so its requirement has none, or the scenario restates the requirement and names no case |
| Coverage | Each price, payment and stock that the requirement depends on has a scenario, or the gap is named | The requirement depends on the stock, and no scenario varies it |
| Modified requirement | The MODIFIED block carries the whole requirement, every scenario the main specification has, and the new ones | A partial MODIFIED drops a scenario, which `validate` refuses, or it changes a scenario's text under its old name, which the tool does not notice |
| Downstream | The design can be traced against every scenario | A scenario is written that the design cannot be traced against, or the design sets aside a case that a scenario tests. The disagreement is found only later |

## 6.8 Changing a delta after review

Once a review has found a fault, two questions follow. What does the revision cover, and who makes it? The table answers the first question.

| What exists | What the revision covers |
|---|---|
| Only the delta | The part, and the parts coupled to it. For example, a new scenario can change the wording of its requirement. |
| The delta, with the design and the tasks written from it | Those too. They were traced against the old text. A trace that was true of the old text says nothing about the new text. |
| An archived change | Nothing in the archive. A later gap goes into a new change. |

Of the three rows, the example shows only the bottom one. Chapter 5 gives the reason why the archive has no case of the middle row.

The second decision is which way to use, and there are two. The developer can edit the delta, or the developer can ask the agent to revise it. The choice depends on whether the corrected text is already known. The table compares the two ways on four points.

| | The developer edits the file | The agent is asked to revise it |
|---|---|---|
| Right when | The replacement is known, and the fault is in one scenario or one sentence | The text must be derived from the main specification or the other scenarios |
| What it costs | A minute with the file open, and a diff that shows one change | A request with three parts, a whole file to read again, and a diff so large that it hides what actually changed |
| How it goes wrong | An edit to one scenario leaves the requirement's wording, or the other scenarios, no longer consistent with it | A request for a clearer scenario returns a rewrite that changes more than was asked. A MODIFIED block can lose a scenario |
| What to check afterwards | The requirement and every scenario it has | The whole file, including the scenarios that nobody meant to change |

Suppose that the first delta's Change scenario had said the machine returns "an appropriate set of coins". The developer knows the sentence that the archive holds: 30 cents as one coin of 20 cents and one coin of 10 cents. Here the edit is right, because the replacement was known before the file was opened. One sentence changes. Nothing else changes, and the diff shows nothing else.

Suppose instead that the developer sees that no scenario covers a stock without a 10-cent coin. The developer cannot yet say what the machine should do in that case. A request to the agent then has three parts:

1. which part to revise: the one requirement and its scenarios;
2. what is wrong with it: no scenario covers a stock with no coin of 10 cents;
3. what must not change: the requirement's text, its header and the scenarios that already exist.

The request asks the agent to propose the outcome from the main specification and the other scenarios. The developer reviews that proposal before accepting it. Without the third part, the agent may rewrite the whole block.

Both ways end in the same reading. An edit is judged by its diff, and a change outside the scenario is an error. A revision made by asking the agent rewrites the file. So the reader checks the whole delta again, using the passes of section 6.7. The tool catches a scenario dropped from a MODIFIED block. It does not catch a scenario whose text changed, so the reader has to catch it.

## 6.9 What the delta passes on

The delta passes to the design a set of cases that the design must satisfy. Each scenario is a case that the design will be traced against. The first design left the stock case undecided. Chapter 7 discusses what a design should do with a case it has set aside. The delta passes nothing directly to the tasks, because the tasks are written from the design, as section 4.5 shows.

The next artifact answers how: in what order the machine works, by what method, and with which coins. The delta leaves those questions open on purpose.

A delta is a requirement and the cases that decide it. The agent writes it and supplies the form. A person reviews it and decides what the behaviour should be. A program checks the form. It cannot check whether the cases are enough, so a delta can pass every check and still leave a case undecided. The cases that nobody wrote are found by writing them. This means varying what the requirement depends on, and asking what each variation should do. The design is then traced against those cases, and the design decides how the behaviour is produced.
