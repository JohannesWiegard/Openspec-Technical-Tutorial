# 7. The Design and the Decisions That Can Be Traced

Chapter 6 ended with the cases that a requirement must satisfy handed to the next artifact, which it said answers how: in what order the machine works, by what method and with which coins. This chapter takes that artifact up and asks the same four questions of it: who writes it, which of its parts must be right, how a reviewer decides that it is finished, and what happens when the review finds something wrong. The example is the same vending machine and the same two changes.

The table shows the files of a change and the paths of its specifications. The row this chapter discusses is in bold.

| Item | File | What it says | Discussed in |
|---|---|---|---|
| Change | `openspec/changes/<change>/` | The folder of one change. | Chapter 4 |
| Proposal | `proposal.md` | Why the change exists and what it changes. | Chapters 4 and 5 |
| Capability | `specs/<capability>/` | The folder for one area of behaviour, such as `purchase`. | Chapters 4 and 6 |
| Specification | `specs/<capability>/spec.md` | What one change adds, modifies or removes. | Chapters 4 and 6 |
| Main specification | `openspec/specs/<capability>/spec.md` | The system as it stands. | Chapters 4 and 6 |
| **Design** | **`design.md`** | **How the work is done.** | **Chapters 4 and 7** |
| Tasks | `tasks.md` | The checks that turn the design into work. | Chapters 4 and 8 |
| Schema marker | `.openspec.yaml` | The schema the change follows, and `skip_specs` when it has no deltas. | Chapter 4 |

## 7.1 Who writes the design

The agent drafts the first version of `design.md` from the schema's instruction for the design and from the proposal. It supplies the four parts of the template, in the form the instruction asks for, and it supplies a reason for each decision that reads as sound. The instruction also says when a design is needed: a change that crosses several modules or brings a new architectural pattern, a new external dependency or a significant change to the data model, a concern about security, performance or migration, or an ambiguity that technical decisions would settle before coding. The developer decides whether one of those conditions applies, and the agent cannot decide it for them.

What the agent cannot supply is what the developer knows about the work. It cannot say which alternatives were really open, which constraints the code or the team imposes, or which cases the design may leave out. The example has no code, so its Context has no state of a codebase to describe; a design in a project with code begins there. The developer's part is to challenge the reasons, not to proofread the form. Section 5.1 describes the same division for the proposal, and chapter 2 gives the reason human control stays with the developer.

In the `spec-driven` schema the design requires only the proposal, while the tasks require both the specification and the design. The tool therefore does not wait for the delta before it offers the design. The order this book follows, in which the delta is reviewed before the design is written from it, has a reason: the design is traced against the scenarios, and a scenario that changes after the design is written means the traces have to be done again. Chapter 3 says that the dependencies between artifacts are enablers, not phase gates. This is the case where the tool shows it, because it does not enforce the order the book recommends.

## 7.2 The parts of a design

The table says what the tool checks of each part of the design. For this artifact the answer is the same in every row.

| Part | What the tool checks | The question it answers |
|---|---|---|
| Context | Nothing. | What does a reader need in order to follow the decisions? |
| Goals / Non-Goals | Nothing. | What does the design achieve, and what does it leave out at design level? |
| Decisions | Nothing. | What was chosen, for what reason, and what was given up? |
| Risks / Trade-offs | Nothing. | What can go wrong, and what is done about it? |

The tool reads nothing of the design. `validate` reads the delta and never opens `design.md`, and `archive` does not open it either. `status` counts the file as done if it exists, whatever it contains: a design of one character and an empty design both show as done. A change with no design validates and archives. That is the finding of this section, and it does not mean the design matters less than the other artifacts. It means that every check on it is a person's. The instruction asks for a design only when one of its four conditions applies, and the schema makes the tasks wait for the file; those are two rules, and the tool enforces only the second. The four parts are the whole of the default template, and a part that a project adds belongs in a forked schema, as chapter 3 described. The two parts that the instruction names beyond the template are named in section 7.7.

## 7.3 A context that points back

The file is `design.md` in the change `give-exact-change`, and its Context reads as archived:

```markdown
## Context

The purchase capability requires the machine to return the difference in coins from
its stock. This design says how the machine works out those coins and in what order
it does its steps.
```

A Context says what a reader needs in order to follow the decisions, and it points at the proposal and the delta for the rest. The instruction asks for the current state and the constraints, and it asks the design to refer to the proposal and the specifications rather than restate them. The first Context names the requirement it serves in one sentence, and then says what the design covers. A reviewer can keep that sentence or cut it. It restates the requirement, which the delta already holds, but a reader who has not opened the delta needs to know which requirement is meant.

The file is `design.md` in the change `refuse-without-exact-change`, and its Context reads as archived:

```markdown
## Context

The design of `give-exact-change` released the product first and then worked out the
change greedily from the stock. Its findings traced the first two scenarios correctly.
The scenario "Stock cannot make the change" was not traced then, because it did not
exist. This design replaces the order of steps and records the trace that shows why.
```

This Context ties the design to the one before it, so a reader of this file alone can find the thing it replaces. The full account of the first design is in section 4.11, and this chapter does not repeat it.

## 7.4 Goals and non-goals

The file is `design.md` in the change `give-exact-change`, and its Goals / Non-Goals reads as archived:

```markdown
## Goals / Non-Goals

**Goals:**

- Return the difference between the amount inserted and the price, in coins from the
  stock.

**Non-Goals:**

- Deciding what happens when the stock cannot make the change. This design does not
  say.
- Choosing the coins so that the stock stays balanced, or so that the fewest coins are
  returned.
```

The goal states what the design achieves, in the behaviour the delta already states. The two non-goals say what the design leaves out at design level, and they are the part of the template that turns an absence into a statement. The first non-goal is the case that section 4.7 shows the design failing: a stock that cannot make the change. The file says that the design does not decide it, so a reader who meets that scenario later can see that the case was set aside on purpose and was not missed. The instruction asks a design to add only design-level boundaries and not to restate the proposal's scope. Both non-goals meet that test: one concerns a case, and the other a method for choosing coins.

The file is `design.md` in the change `refuse-without-exact-change`, and its Goals / Non-Goals reads as archived:

```markdown
## Goals / Non-Goals

**Goals:**

- Return the exact difference in coins from the stock, or refuse the purchase and return
  the amount inserted.

**Non-Goals:**

- Changing the coin denominations.
- Telling the customer why a purchase was refused.
```

The goal restates the delta's outcome in the design's own words, so a reviewer can set it beside the requirement and compare them. None of the three scenarios of the requirement that this change modifies tests either of them. A non-goal that no scenario tests costs little to state, and a reviewer can confirm from the delta that it is safe to state.

A non-goal makes a case visible, but it does not decide the case, because what the system must do belongs to the delta (section 6.6). When a reviewer reads the non-goals, the question is the same for each one: does a scenario test this case? If one does, the design cannot list it as a non-goal, because the scenario says what the system must do and the design has to produce it. If none does, the reviewer asks whether the requirement's wording covers the case. If the wording covers it, the case belongs in a scenario, and the delta is where chapter 6 found the stock case, by varying what the requirement depends on (section 6.4). If the wording does not cover it, the non-goal stands. That is the answer to the question chapter 6 left open: a design records the case it sets aside, and the reviewer decides, with the delta open, whether the case was the design's to set aside.

## 7.5 Decisions and their reasons

The file is `design.md` in the change `give-exact-change`, and its Decisions reads as archived:

```markdown
## Decisions

**Decision**: release the product first, then work out the change from the coins in
stock.

**Why**: the customer should not wait at the machine after the payment is complete.

**Decision**: work out the change greedily. Take the largest coin that does not
exceed the amount still owed, for as long as the stock of that coin lasts. Repeat
until nothing is owed.

**Why**: the method is short to state and easy to trace by hand.
```

A decision is a choice with a reason, and the reason is the part a reviewer can check. The first design has two decisions, and each has a Why. The first Why says that the customer should not wait at the machine after payment, which is a preference that no scenario tests. The second says that the method is short to state and easy to trace by hand, which concerns the design's own convenience. Neither reason is wrong. A reviewer asks which kind of reason each one is, and what would contradict it. The layout, a decision followed by its reason, is the example's own. The template asks for decisions with rationale and alternatives and does not prescribe a layout, as section 4.4 says.

The file is `design.md` in the change `refuse-without-exact-change`, and its Decisions reads as archived:

```markdown
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
```

Both reasons of the second design cite the requirement: "the requirement says the change is exact" and "the requirement gives no near-miss outcome". A reviewer can set each reason beside the delta and decide whether it holds. The decision that changes between the two designs is the order of steps. The first design released the product first, and this design works out the change before the release, so the reasons support the decision that moved.

The instruction asks for alternatives that were considered for each decision. The first design records none. The second records two, both under its second decision, and none under its first. A file with no alternative does not say whether one was open, so a reviewer cannot tell a decision from a default. The reviewer's question is which alternative someone would actually have chosen. The two in the second design are the two that keep the first design's order, and those are the ones that matter. What each rejected alternative gave up is set out in section 4.11.

## 7.6 Risks and what they cost

The file is `design.md` in the change `give-exact-change`, and its Risks / Trade-offs reads as archived:

```markdown
## Risks / Trade-offs

- The stock of coins shrinks with each purchase, and nothing in this design refills it.
  → Refilling is outside this change; the design assumes a stocked machine.
```

A risk names what could go wrong and what is done about it. The instruction gives that as an arrow from the risk to its mitigation, and the first design follows the form. The risk names its cause, but it does not name what the machine does once the stock has run down, which is the case the first design set aside in its Goals / Non-Goals. A reviewer reads the arrow for whether the mitigation is a decision or a deferral, and here it is a deferral that the design states.

The file is `design.md` in the change `refuse-without-exact-change`, and its Risks / Trade-offs reads as archived:

```markdown
## Risks / Trade-offs

- The stock of coins shrinks with each purchase, so refusals become more likely as the
  stock runs down. → Refilling the stock is outside this change; the design does not
  mitigate it.
```

The second design has the same cause and names a consequence, and it says that it does not mitigate the risk. A risk left unmitigated is a decision once it is stated, and a reviewer can judge whether the consequence is acceptable. Section 4.11 says what changed between the two risks.

## 7.7 What the template leaves out

The instruction for the design asks for two parts that the template does not have. Migration Plan asks for the steps to deploy and the rollback strategy, if one applies. Open Questions asks for unknowns that can be answered later without changing the specifications, the approach or the task breakdown, and it says that a question which would change any of them is resolved now. The instruction for the tasks adds a step: the agent reads the design's Open Questions and resolves with the user any that would change what gets built. Neither example design has either part, so this chapter names them and shows neither. The Findings section that the example adds to its designs is not in the template either, and section 4.4 explains why the example keeps it. Section 5.7 already says where an unknown that can wait is recorded, and this chapter does not repeat it.

## 7.8 Reviewing a design

A design is reviewed after the delta is reviewed and before the tasks are written from it. The tasks are written from the design, so a decision that nobody traced becomes a task that nobody can check. The review has four passes. Intent asks whether the design serves the behaviour the delta states. Reasons asks whether each decision's reason can be checked, and, where the delta leaves a choice open, whether an alternative was recorded. Trace asks whether each scenario can be walked through the decisions to the outcome it states, as section 4.7 walks one. Boundaries asks whether each non-goal is a case that no scenario tests, and whether each risk says what happens when it occurs. Trace and boundaries matter most, because the tool cannot see either of them, and chapter 6 handed the design the cases it must meet.

A trace tests the design against the cases that exist, and it cannot supply a case. A trace walks one scenario through the decisions by hand: the WHEN gives the inputs, the decisions are applied in order, and the result is compared with the THEN. The example's designs record their traces, and its tasks cite them, in sections 4.5 and 4.12. The second design traces all three of its scenarios, including the two that the first design had passed, as section 4.11 shows.

The table is one checklist, in the order the file is read. The column names use the artifact's name, which here is the design.

| Check | The design passes when | How a draft can fail |
|---|---|---|
| The request is answered as meant | The design serves the behaviour the delta states, and nothing in it answers an assumption the agent made instead | The design decides a behaviour the delta does not state, and the tasks are written from it |
| Context | It says what a reader needs to follow the decisions, and points at the proposal and the delta for the rest | It restates the proposal or the requirement at length, or it describes what the design will do rather than the state it starts from |
| Goals | Each goal is a behaviour the delta states, in the design's words | A goal restates the proposal's scope, or it states a method the delta leaves open as if the delta required it |
| Non-Goals | Each non-goal is a case that no scenario tests, or the scenario that tests it is named and the non-goal is removed | A non-goal is a case that a scenario tests, or a case the requirement's wording covers, and no one has decided it |
| Decisions: reason | Each reason can be checked against the delta, a constraint or a stated preference | A reason is only the design's convenience, and nothing could contradict it |
| Decisions: alternative | Where the delta leaves a choice open, the rejected alternatives are recorded, and each is one someone would choose | No alternative is recorded for a decision that could have gone another way, so a reviewer cannot tell a decision from a default |
| Risks / Trade-offs | Each risk names its cause, its consequence and what is done about it | A risk names a cause and no consequence, or its mitigation is one the design cannot keep |
| Trace | Each scenario of the delta can be walked through the decisions to the outcome it states | A trace covers only the scenarios that existed when the design was written, and a scenario added later is never traced |
| Downstream | The tasks can be written from the design, and each decision has a check that can mark it done | A decision is one that no task can check, or a task asks for something the design does not decide |

The table is a memory aid, and no part of the tool reads it. A row that passes records a person's judgment, not a machine's check. The last two rows are the only ones that are not about the file on its own. A design is finished when it can be traced, not when its parts are filled, and a design that passes every other row but leaves a scenario untraced is not finished.

## 7.9 Changing a design after review

When the review finds a fault, two decisions follow: what the revision covers, and who makes it. The first depends on how much of the change exists.

| What exists | What the revision covers |
|---|---|
| Only the design | The part and the parts coupled to it. A changed decision can move the goal it served, the risk it created and the traces, so every scenario is walked again, not only the one that prompted the change. |
| The design, with the tasks written from it | Those too, because the tasks were written from the decisions that changed. |
| An archived change | Nothing in the archive. A later gap goes into a new change, whose design names the design it replaces in its Context. |

The archive keeps the decisions as they were made, as section 5.9 says of the proposal, and the same reason applies here. The example shows the bottom row and not the middle one. The second change's design is a new design in a new change, as section 4.11 shows, and the first design is not touched. The middle row, a design revised while its tasks exist, has no case in the archive, for the reason chapter 5 gives: the second change was written after the first was archived, from a finding.

A revision is made by editing the file or by asking the agent to change it, and the choice turns on whether the replacement is known. The table compares the two means on four points.

| | The developer edits the file | The agent is asked to revise it |
|---|---|---|
| Right when | The replacement is known, and the fault sits in one decision or one reason | The decision has to be worked out from the delta, the other decisions or the traces |
| What it costs | A minute with the file open, and a diff that shows one change | A request with three parts, a whole file to read back, and a diff whose size hides what changed |
| How it goes wrong | An edit to one decision leaves its goal, its risk or its trace out of step with it | A request for a clearer decision returns a rewrite that changes what was decided |
| What to check afterwards | The goals, risks and traces that the decision touches | The whole file, including the decisions nobody meant to change |

Suppose the second reason of the first design had said that the method is the usual one, and the developer knows the sentence the archive holds: that it is short to state and easy to trace by hand. One sentence changes, and nothing else needs to move, because a reason's wording is not an input to any trace. The diff shows that sentence and nothing else.

Suppose a design, not one of the example's, records one decision with no alternative, and the developer cannot yet say what was open. The request to the agent names that decision, says that no alternative is recorded for it, and says that the decision's text, its reason, the other decisions and the traces must not move. The agent proposes alternatives from the delta and the design's other decisions, and the developer decides which of them anyone would have chosen. Without the third part, the agent may rewrite the whole Decisions part, and the rewrite may change decisions that nobody asked about.

Both means end in the same reading. An edit is checked by its diff, and a revision made by asking is a rewrite, so the whole design is read again as a new draft, with the four passes of section 7.8. Chapter 6 said that the tool catches a scenario dropped from a MODIFIED block and does not catch one whose text moved. A design has no such check. A decision can be dropped, or its reason changed, and `validate` still passes. The trace is what notices, and it notices only for the scenarios that exist.

## 7.10 What the design hands on

The design hands the tasks the decisions to check and the traces that have been done. Section 4.5 shows the first two tasks of the example, which are traces of its two scenarios. The design also hands over any open question, which the instruction for the tasks asks to be resolved before the tasks are written. What the delta handed to the design, the design now holds as decisions, each with its reason and, where one was open, its alternative.

The tasks do not say what the system must do, and they do not decide how it works. They say how each decision is checked, and they turn those checks into items that can be marked done. A command and a workflow that are not files, `validate` and archive, close the change. Chapter 8 takes up the tasks and outlines what follows them, and chapters 11 and 12 describe them in full.

A design is the decisions that meet the cases. An agent drafts it, a program reads none of it, and a person judges it by tracing the cases through it. The agent supplies the four parts and the form the instruction asks for, and the developer decides whether a design is needed and whether each reason holds. A reason that can be set beside a requirement can be checked, and a reason that is only convenience cannot. A non-goal is a statement that the review reads against the scenarios, and a trace is the pass that finds a decision in conflict with a case. The reader should carry away that a design is judged by whether its scenarios can be traced through it and whether what it leaves out is honest. A design that the tool accepts can still leave a scenario untraced, and finding that scenario is the reviewer's work.
