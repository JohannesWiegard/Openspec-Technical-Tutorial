# 4. One Change from Request to Archive

A customer pays 100 cents for a product that costs 70 cents, and the machine owes 30 cents back. Written as a request, that sentence sounds complete. It does not say which coins the machine should use, what happens when it has none left, or whether the product is handed over before the change is counted. Those questions have to become artifacts before anyone writes code. This chapter follows one change through the path from its request to its archive, on a small example: a vending machine that gives change. The example is kept in its own repository, with its own OpenSpec root, and it contains no code. What the reader sees here is what the tool produces at each stage.

## 4.1 A change is a folder

In OpenSpec a change is a folder under `openspec/changes/`, named after the change. The path from a request to an archived change has four stages, shown in the first table. The folder holds the artifacts the path produces, and the second table lists them with the other files of a change.

| Stage | What happens |
|---|---|
| Request | The starting statement of what the change should do, as in the opening paragraph. |
| Create the artifacts | The propose workflow creates the four artifacts listed in the second table. It creates them in the order the schema declares. The specification and the design each need only the proposal, and the tasks need both of them. That order decides what can be made next. It is not a set of gates that must be passed in turn; chapter 3 explains this. |
| Validation | The `validate` command checks the change's delta specifications, and it looks in the main specifications for the capabilities the change says it will modify. |
| Archive | Archiving merges the change's specification into the main specification and moves the change folder into the archive. |

The artifacts come from the default schema of the tool, `spec-driven`.

| Item | File | What it says | Discussed in |
|---|---|---|---|
| Change | `openspec/changes/<change>/` | The folder of one change. | Chapter 4 |
| Proposal | `proposal.md` | Why the change exists and what it changes. | Chapters 4 and 5 |
| Capability | `specs/<capability>/` | The folder for one area of behaviour, such as `purchase`. | Chapters 4 and 6 |
| Specification | `specs/<capability>/spec.md` | What one change adds, modifies or removes. | Chapters 4 and 6 |
| Main specification | `openspec/specs/<capability>/spec.md` | The system as it stands. | Chapters 4 and 6 |
| Design | `design.md` | How the work is done. | Chapters 4 and 7 |
| Tasks | `tasks.md` | The checks that turn the design into work. | Chapters 4 and 8 |
| Schema marker | `.openspec.yaml` | The schema the change follows, and `skip_specs` when it has no deltas. | Chapter 4 |

The two tables answer different questions, and a reader who keeps them apart will see that the tool's stages are not documents, and that the documents are not a checklist of stages. Validation and archive are the only stages that do not add a file to the change.

The example change is `give-exact-change`. It lives in `../vending-machine`, a separate repository with its own OpenSpec root, and it adds a capability called `purchase`. Its first requirement is the one this chapter follows to the end: the machine gives change in coins from its stock. A second change, `refuse-without-exact-change`, revises that requirement. Both changes are archived in the example repository, and the quotations below are taken from them as they were written.

## 4.2 The proposal

The proposal is the first artifact. It says why the change exists and what it changes. It does not say how the work is done; that belongs to the design. The default template has four parts: Why, What Changes, Capabilities and Impact.

| Proposal | Description |
|---|---|
| Why | The problem or opportunity in one or two sentences: why the change is needed. The first change gives two sentences. |
| What Changes | A list of what is added, modified or removed. The first change adds the capability `purchase` with two requirements. |
| Capabilities | The capabilities the change creates or modifies, each with the spec file it needs. The first change creates `purchase`. |
| Impact | The files, specifications or systems the change touches. The first change names the spec file that archiving will create. |

The proposal of the change `give-exact-change`, `proposal.md`, is shown in full as archived:

```markdown
## Why

A customer who pays more than the price of a product expects the difference back.
The machine holds coins, so it has to decide which coins make up the difference.

## What Changes

- Add a capability `purchase` with two requirements: the coins the machine holds,
  and the change it returns for a purchase.

## Capabilities

### New Capabilities

- `purchase`: the coins the machine holds, and the change it returns for a purchase.

## Impact

- `openspec/specs/purchase/spec.md` — created when this change is archived.
```

## 4.3 The specification

The specification, which is the delta in the change's folder, states what the system must do. Each requirement is a statement with SHALL, and each has scenarios. A change does not rewrite the whole main specification, which holds the requirements of the system as they now stand, at `openspec/specs/<capability>/spec.md`. A delta says what the change adds, modifies or removes, and the archive merges the delta later. The delta is written to `specs/<capability>/spec.md` in the change folder.

| Specification | Description |
|---|---|
| Purpose | For a new capability: one or two sentences on what the capability is for. Archiving copies it into the main specification. The first delta has one. |
| ADDED / MODIFIED Requirements | The operation the delta performs on the requirements of the main specification. |
| Requirement | One statement of what the system must do, written with SHALL. |
| Scenario | One case under a requirement, written as WHEN, the condition that can be set up, and THEN, the outcome that can be decided. |

The first change uses ADDED, because the capability did not yet exist. Its delta, `specs/purchase/spec.md` in the change `give-exact-change`, is shown in full as archived. It opens with a Purpose section, and it holds two requirements, each with its scenarios:

```markdown
## Purpose

Defines the coins the vending machine holds and the change it returns for a purchase, so that a customer who pays more than the price receives the difference in coins from the machine's stock.

## ADDED Requirements

### Requirement: The machine holds coins of four denominations

The machine SHALL hold coins of 10, 20, 50 and 100 cents only. Amounts are stated in
cents.

#### Scenario: Stock holds only the four denominations

- **WHEN** the machine is stocked
- **THEN** every coin in its stock is a coin of 10, 20, 50 or 100 cents

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

This scenario can be set up with a stock of coins, and it says exactly which coins come back. The requirement alone does not say that; the scenario does. The second change adds a third scenario of the same kind, which the first version did not have. It appears in section 4.8.

## 4.4 The design

The design is the third artifact. It records the decisions the requirement leaves open, and the reason for each. The requirement says what the machine returns. The design says in which order the machine works and how it finds the coins.

| Design | Description |
|---|---|
| Context | The current state and the constraints that shape the approach. It does not restate the motivation, which is in the proposal. The first design's Context restates the requirement and says what the design covers. |
| Goals / Non-Goals | What the design aims for and what it leaves out at design level. The first design states one goal and two non-goals. One of its non-goals is the case that section 4.7 shows the design failing. |
| Decisions | Each decision, with the reason for it and, where one was rejected, the alternative. The default template asks for "rationale and alternatives considered". |
| Risks / Trade-offs | Each risk, followed by its mitigation. The first design names one risk: the stock of coins runs down, and refilling is left outside the change. |

The layout of each decision, as a decision, a reason and, where one was rejected, an alternative, is this project's own. The tool's template asks for decisions with rationale and alternatives, and does not prescribe a layout. The design of `give-exact-change`, `design.md`, is shown in full as archived. It reads:

```markdown
## Context

The purchase capability requires the machine to return the difference in coins from
its stock. This design says how the machine works out those coins and in what order
it does its steps.

## Goals / Non-Goals

**Goals:**

- Return the difference between the amount inserted and the price, in coins from the
  stock.

**Non-Goals:**

- Deciding what happens when the stock cannot make the change. This design does not
  say.
- Choosing the coins so that the stock stays balanced, or so that the fewest coins are
  returned.

## Decisions

**Decision**: release the product first, then work out the change from the coins in
stock.

**Why**: the customer should not wait at the machine after the payment is complete.

**Decision**: work out the change greedily. Take the largest coin that does not
exceed the amount still owed, for as long as the stock of that coin lasts. Repeat
until nothing is owed.

**Why**: the method is short to state and easy to trace by hand.

## Risks / Trade-offs

- The stock of coins shrinks with each purchase, and nothing in this design refills it.
  → Refilling is outside this change; the design assumes a stocked machine.

## Findings

Each scenario is traced through the design by hand.

- **Scenario "Change is given from stock"**: 100 inserted, 70 price, 30 owed. The
  largest coin that does not exceed 30 is 20; one is returned, 10 is owed. The
  largest coin that does not exceed 10 is 10; one is returned, nothing is owed.
  Result: 20 and 10. Matches the scenario.
- **Scenario "Exact payment gives no change"**: 70 inserted, 70 price, nothing owed.
  No coin is returned. Result: none. Matches the scenario.
```

The first design records no rejected alternative. Its two decisions are the ones the rest of the chapter depends on.

The file does not end with its risks. It closes with a Findings section, and the template's design has no such part: its parts are Context, Goals / Non-Goals, Decisions and Risks / Trade-offs. The example keeps the section as a stated exception. The walkthroughs have to be written down somewhere, and beside the decisions they test they are read by anyone who reads the decisions. The price of the exception is that the chapter has to keep the section true, because no part of the tool checks it.

## 4.5 The tasks

The tasks are the last artifact. They turn the design into checks, one for each part of the design that must be verified. Each task is a checkbox, and the tool counts the checkboxes to show progress.

| Tasks | Description |
|---|---|
| Group heading | A numbered heading that groups related tasks. The first change has one group, "Check the first version". |
| Task | A checkbox with a number and a description of the check. `[ ]` is open and `[x]` is done. |
| Verified by | A clause after the task that names the evidence the check passed. The example's own rules fix the clause's wording, the default instruction asks each task to state how it is verified, and the template has no part for it. |

The tasks of `give-exact-change`, `tasks.md`, are shown in full as archived:

```markdown
## 1. Check the first version

- [x] 1.1 Trace the scenario "Change is given from stock" through the design by hand. **Verified by** the trace in the design's Findings, which matches the scenario.
- [x] 1.2 Trace the scenario "Exact payment gives no change" through the design by hand. **Verified by** the trace in the design's Findings, which matches the scenario.
- [x] 1.3 Run `openspec validate --strict`. **Verified by** the command passing.
```

The first two tasks send the reader to the Findings section of the design quoted in section 4.4, and the trace each one names is there. The third task records validation. Validation passed the first version. The `validate` command reads the change's delta specifications, and the main specifications only to see what the delta modifies; it does not read the proposal, the design or the tasks of a change that has not been archived. It does not check whether the design agrees with the scenarios, and chapter 3 names that limit. Here it has a concrete consequence. The first change was complete by every check the tool runs, and the design still did not satisfy a case that had not yet been written down.

A task list is easy to read as a plan of work. The tasks in this example are checks, and ticking one records that the check was made, not only that someone intended to make it. That difference matters later, when the box is the only record of what was done.

## 4.6 Archiving the first change

Archiving closes a change. It is done in one run, but it decides what the next change is checked against, so it is shown here on its own.

The first change is ready for archiving when two things hold: its tasks are checked, and its design's Findings walk through both of its scenarios, so the design and the scenarios agree on the cases that existed when the change was written.

For a new capability, archiving does four things. It creates the main specification for the capability, `openspec/specs/purchase/spec.md`. It copies the delta's Purpose into that file, which is why the delta begins with a Purpose section: without one, the new file carries a placeholder that someone has to replace by hand. It writes the delta's requirements into the file. And it moves the change folder into the archive, under its date, so the folder is kept as a record but is no longer work in progress, and the behaviour it describes is part of the main specification. The first lines of `openspec/specs/purchase/spec.md`, as `give-exact-change` left them when it was archived, read:

```markdown
# purchase Specification

## Purpose
Defines the coins the vending machine holds and the change it returns for a purchase, so that a customer who pays more than the price receives the difference in coins from the machine's stock.

## Requirements

### Requirement: The machine holds coins of four denominations

The machine SHALL hold coins of 10, 20, 50 and 100 cents only. Amounts are stated in
cents.
```

The example was archived with an earlier release; current releases also leave a blank line after the `## Purpose` heading, and otherwise the file reads the same. The file has a title, a Purpose and the requirements of the first change, and nothing else. It does not name the change that wrote it. That record is the archived folder, which holds the proposal, the design, the tasks and the delta. The main specification says what the system is; the archive says how it came to be.

Archiving does not decide whether the change is right. That was decided earlier, by the tasks and the walkthrough of the scenarios. Archiving records a decision that has already been made, and it does so only when the change is closed. This is why the first change is archived before the second one begins: the second change modifies a requirement that exists in the main specification only after the archive.

## 4.7 The case nobody had written

The second change, `refuse-without-exact-change`, starts from the main specification that section 4.6 created. Its archive is in section 4.14. The case it starts from is one the first version lacked. The requirement says the machine returns the difference in coins from its stock, so the question is what happens when the stock cannot make that difference. The stock in the case holds one coin of 10 cents and no coin of 20 or 50 cents. Walked through the first design, the case fails. The design had named this case as a non-goal, so it never decided it. The walkthrough is recorded in the Findings of `design.md` in the change `refuse-without-exact-change`, labelled Trace A. It reads:

```markdown
**Trace A: the first design, scenario "Stock cannot make the change".** The price is
70, 100 is inserted, so 30 is owed. The stock holds one coin of 10 and none of 20.
The first design releases the product first. The largest coin that does not exceed 30
is 10, so one is returned and 20 is still owed. No coin can be returned for 20. The
customer leaves with the product and 10 of the 30 owed, and nothing says so.
```

The walkthrough shows two symptoms. The product is released before the change is worked out, and the change returned is less than the amount owed without any sign of it.

## 4.8 The correction

This section describes the second change, `refuse-without-exact-change`. It is a separate change, with its own folder and its own artifacts, and it does not edit the first change: the first change's design was not reopened. The second change starts where section 4.7 ends.

The second change does three things, and each one is in a different artifact:

- Its proposal changes the requirement. The machine must return the exact amount, and if it cannot, it refuses the purchase, releases no product and returns the amount inserted.
- Its specification adds a scenario for a stock that cannot make the change.
- Its design works out the change before the product is released.

Each of the four files of the second change has its own section below, in the order the schema declares them: the proposal, the specification, the design and the tasks. Each section follows the pattern of the matching section for the first change, so that the two can be read side by side.

## 4.9 The proposal of the second change

The proposal of the second change answers a different question from the first. The first proposal says why a customer should receive change at all. This one says why a rule that the first change wrote has to be changed, and its reason is a walkthrough rather than a situation. The four parts are the same, and each is filled from that reason.

| Second change: proposal | What this change puts there |
|---|---|
| Why | The failure the walkthrough found: two symptoms, and the fact that validation passed the first version anyway. |
| What Changes | Three changes: the requirement requires exact change, a scenario is added for a stock that cannot make the change, and the design works out the change before release. |
| Capabilities | One modified capability, `purchase`, and the requirement it changes. No capability is created. |
| Impact | The main specification that the first change created. This change modifies that file when it is archived. |

**`refuse-without-exact-change`, `proposal.md`**

```markdown
## Why

While writing the scenario for a stock that cannot make the change, the first version
has no answer. Tracing the scenario through the design of `give-exact-change` shows two
symptoms:

1. The product is released before the change is worked out. A customer who is short
   of change keeps the product.
2. With short stock the change is less than the amount owed, and nothing says so.

`openspec validate` passed the first version. It checks the structure of the
artifacts, not whether a design agrees with a scenario.

## What Changes

- The requirement "The machine gives change in coins from its stock" requires exact
  change. If the exact change cannot be made, the purchase is refused and the amount
  inserted is returned. No product is released.
- A scenario is added for a stock that cannot make the change.
- The design works out the change before the product is released.

## Capabilities

### Modified Capabilities

- `purchase`: the requirement "The machine gives change in coins from its stock" changes to require exact change.

## Impact

- `openspec/specs/purchase/spec.md` — the change requirement is modified when this
  change is archived.
```

The Why section differs most from the first proposal's Why. The first contains no reference to any file. The second cites one: the design of `give-exact-change`, the artifact that the walkthrough tested. A reader can therefore check the reason by following the trace in section 4.7. The first proposal could not have been written in this form, because the failure was not known until the walkthrough had been made.

The Capabilities section uses the Modified heading. The template asks for the exact path of an existing specification under that heading, so the delta has to match a file that is already there. The first change created its capability and used the New heading, which carried no such constraint.

Impact names the main specification and no new file. The first change's Impact named the file that archiving would create. This one names the file that archiving will change. Neither proposal has a Non-goals part, because the example removed it: the default template does not have one.

## 4.10 The specification of the second change

A delta for a modified capability has one job: it replaces a requirement in a specification that already exists. It therefore carries the requirement as a whole, and it carries no Purpose, because the specification it changes already has one. The tool ignores a Purpose in such a delta. The first delta began with a Purpose because it created a capability; this one begins with the requirement.

| Second change: specification | What this change puts there |
|---|---|
| MODIFIED Requirements | One requirement, under a MODIFIED heading. The delta replaces the existing requirement of that name. |
| Requirement | "The machine gives change in coins from its stock", written out in full. It gains the word "exactly" and a second sentence about refusal. |
| Scenario | Three scenarios. The first two keep the text they had in the first change, and the third is added here. |
| Purpose | Not present. The main specification keeps the Purpose it already has. |

**`refuse-without-exact-change`, `specs/purchase/spec.md`**

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

Set the first sentence of the requirement beside the first change's version. One word has been inserted, "exactly". The sentence after it is new. It states the outcome that the first requirement left open, and the scenario is the only place where that outcome can be decided as a case.

The two earlier scenarios keep their text, so the requirement is now checked against those two cases and the new one. The new scenario uses the same price and the same coin inserted as the first scenario, but a different stock. The first scenario needs at least one coin of 20 cents; the new one needs no coin of 20 or 50 cents. The two cases divide the stock by the 20-cent coin, although they do not cover every stock.

The schema warns that a MODIFIED delta with partial content loses detail when it is archived. The requirement is therefore quoted whole, as the replacement that archiving writes into the main specification.

## 4.11 The design of the second change

The design of the second change explains the requirement's new outcome, not only the order of steps. It is the file that replaces the first design's order, records the alternatives that were rejected, and records the walkthrough that shows the new order works for the case that failed.

| Second change: design | What this change puts there |
|---|---|
| Context | Names the first design by its change and says that this design replaces its order of steps. |
| Goals / Non-Goals | One goal: exact change, or refusal with the amount inserted returned. Two non-goals: the coin denominations and any message to the customer. |
| Decisions | Two decisions, each with a reason, and two rejected alternatives. |
| Risks / Trade-offs | One risk: refusals become more likely as the stock runs down. The design leaves the mitigation outside the change. |
| Findings | Traces B, C and D for the revised design, and Trace A for the first. Not a template part; the example keeps it as a stated exception, explained in section 4.4. |

**`refuse-without-exact-change`, `design.md`**

```markdown
## Context

The design of `give-exact-change` released the product first and then worked out the
change greedily from the stock. Its findings traced the first two scenarios correctly.
The scenario "Stock cannot make the change" was not traced then, because it did not
exist. This design replaces the order of steps and records the trace that shows why.

## Goals / Non-Goals

**Goals:**

- Return the exact difference in coins from the stock, or refuse the purchase and return
  the amount inserted.

**Non-Goals:**

- Changing the coin denominations.
- Telling the customer why a purchase was refused.

## Decisions

**Decision**: work out the change before the product is released.

**Why**: the requirement says the change is exact. A product that is released before
the change is known cannot be taken back, so the exactness of the change must be
decided first.

**Decision**: if the greedy method does not reach the exact amount, refuse the
purchase, release no product, and return the amount inserted.

**Why**: the requirement gives no near-miss outcome. Refusing is the only outcome the
requirement allows when the exact change cannot be made.

**Alternative rejected**: release the product and return the change that can be made.
Rejected because it returns less than the requirement allows, and the customer keeps a
product for money not paid back.

**Alternative rejected**: release the product and refund the rest later. Rejected
because the product is already gone when the refund is decided.

## Risks / Trade-offs

- The stock of coins shrinks with each purchase, so refusals become more likely as the
  stock runs down. → Refilling the stock is outside this change; the design does not
  mitigate it.

## Findings

[Trace A, quoted in section 4.7.]

This trace shows both symptoms. The product is released before the change is worked
out (symptom 1), and the change returned is less than owed without a signal (symptom
2). The scenario is not satisfied by the first design.

**Trace B: the revised design, scenario "Stock cannot make the change".** The same
inputs. 30 is owed; 10 is returned, 20 still owed; no coin can return 20. The change is
not exact, so the purchase is refused, no product is released, and the 100 inserted
is returned. The scenario is satisfied.

**Trace C: the revised design, scenario "Change is given from stock".** 30 is owed. The
largest coin that does not exceed 30 is 20; 10 is owed. The largest coin that does
not exceed 10 is 10; nothing is owed. The change is exact, so the product is released
and 20 and 10 are returned. The scenario is satisfied.

**Trace D: the revised design, scenario "Exact payment gives no change".** Nothing is
owed. The change is exact, so the product is released and no coin is returned. The
scenario is satisfied.
```

The first design's non-goals set aside the case that this design decides. That is the central difference in this file. This design takes the case into its decisions, and keeps only the coin denominations and the customer message out of scope.

The two rejected alternatives show what this design gave up. The first, releasing the product and returning what can be made, keeps the first design's behaviour in a form the new requirement forbids. The second, releasing the product and refunding the rest later, moves the failure to a later time without removing it, because the product is already gone when the refund is decided. Both alternatives keep the release-first order, which is why the order is the decision that changes.

The risk has the same subject as the first design's risk, but a different result. In the first design a stock that runs down produced a change that fell short without a signal. Here it produces refusals. The design accepts that consequence and leaves refilling outside the change.

Trace B takes the case from section 4.7 through the revised order: 30 is owed, the change is not exact, and the purchase is refused. Traces C and D repeat the first change's two cases, so the revised design is checked against all three scenarios, not only the one that failed.

## 4.12 The tasks of the second change

The tasks of the second change form two groups, and the groups follow the work. The first group reproduces the failure in the artifacts, and the second group changes the design and checks it again. Each group depends on the one before it, so the order of the groups is part of the record.

| Second change: tasks | What this change puts there |
|---|---|
| Group heading | Two groups: "Trace the first version", then "Revise and trace again". |
| Task | Five checks. Two in the first group: writing the scenario, and walking it through the first design. Three in the second: revising the design, walking all three scenarios through it, and running validation. |
| Verified by | Each task names its evidence: the scenario in the delta, Trace A, the decisions, Traces B to D, or the passing command. |

**`refuse-without-exact-change`, `tasks.md`**

```markdown
## 1. Trace the first version

- [x] 1.1 Write the scenario "Stock cannot make the change" from the requirement's word "exact". **Verified by** the scenario in the spec delta.
- [x] 1.2 Trace the scenario through the first design of `give-exact-change`. **Verified by** Trace A in the design's Findings, which records both symptoms.

## 2. Revise and trace again

- [x] 2.1 Revise the design so that the change is worked out before release, and a change that is not exact is refused. **Verified by** the decisions in the design.
- [x] 2.2 Trace all three scenarios through the revised design. **Verified by** Traces B, C and D in the design's Findings.
- [x] 2.3 Run `openspec validate --strict`. **Verified by** the command passing.
```

The task is quoted as written. The word "exact" is in the revised requirement and in the change's name, and the scenario it writes is for a case the first requirement did not mention. The first change's tasks traced scenarios that already existed. This task creates one.

Task 2.1 is verified by the decisions in the design, not by a walkthrough. That is a weaker check than the others, and it is shown here as it is written. The revision is accepted on the strength of its own text until task 2.2 tests the revised design against all three scenarios. The walkthrough, not the revision, is what closes this part of the change.

Task 2.3 runs validation again, and it passes. As in the first change, the pass says nothing about the case; the traces in task 2.2 carry that evidence.

## 4.13 How the second change differs from the first

The two changes use the same four artifacts, but they do different work on the main specification. The first creates a file, and the second changes a requirement in it. Each difference that sections 4.9 to 4.12 point out between the two comes from that job, not from the format.

## 4.14 The archive of the second change

When the second change is archived, its delta is merged into the main specification that the first change created. The delta modifies one requirement, so it replaces that requirement, adds no file and leaves the Purpose as it was. From then on the specification is the record of the requirement. The requirement as the change `refuse-without-exact-change` left it in `openspec/specs/purchase/spec.md` begins:

```markdown
The machine SHALL return to the customer the difference between the amount inserted
and the price of the product, exactly, in coins from its stock. If it cannot return
that exact amount, it SHALL refuse the purchase, release no product, and return the
amount inserted.
```

The archive keeps the change folder with its design and its findings, so the path from the first version to the corrected one can still be read, and the two commits in the history of the example repository show what was written first and what replaced it. The main specification is different: a wrong requirement that reaches it is paid for by every later change that relies on it. Archiving is therefore the point at which a change stops being a proposal and starts being the system's description.

The path from request to archive has four artifacts, taken in the order of section 4.1, and each answers a question the one before it left open. The proposal says why, the specification says what must hold, the design says how the machine gets there, and the tasks say what has to be checked for each part of the design. The example also showed that a passing validation is not the same as a design that agrees with its scenarios. The first version passed validation and every task, and it still failed a case that had not yet been written. The failure was found by writing that case down, and it was fixed in the artifacts. The next chapters take each artifact in turn; this one has shown what each looks like and where they meet.
