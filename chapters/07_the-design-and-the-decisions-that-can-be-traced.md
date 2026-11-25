# 7. The Design and the Decisions That Can Be Traced

Chapter 6 ended when the cases that a requirement must satisfy were passed to the next artifact. That chapter said that this artifact answers how: in what order the machine works, by what method, and with which coins. This chapter discusses that artifact and asks it the same four questions. Who writes it? Which of its parts must be right? How does a reviewer decide that it is finished? What happens when the review finds something wrong? The example is the same vending machine with the same two changes.

The table shows the files of a change and the paths of its specifications. The row this chapter discusses is in bold.

| Item | File | What it says | Discussed in |
|---|---|---|---|
| Change | `openspec/changes/<change>/` | The folder of one change. Archive moves it into the archive. | Chapter 4 |
| Proposal | `proposal.md` | Why the change exists and what it changes. | Chapters 4 and 5 |
| Capability | `specs/<capability>/` | The folder for one area of behaviour, such as `purchase`. | Chapters 4 and 6 |
| Specification | `specs/<capability>/spec.md` | What one change adds, modifies or removes. | Chapters 4 and 6 |
| Main specification | `openspec/specs/<capability>/spec.md` | The system as it stands. Archive writes it. | Chapters 4 and 6 |
| **Design** | **`design.md`** | **How the work is done.** | **Chapters 4 and 7** |
| Tasks | `tasks.md` | The checks that turn the design into work. | Chapters 4 and 8 |
| Schema marker | `.openspec.yaml` | The schema the change follows. It also holds `skip_specs` when the change has no deltas. | Chapter 4 |

The table lists the parts of `design.md`. The parts this chapter quotes or discusses are in bold.

| Design | Description |
|---|---|
| **Context** | The current state, and the constraints that shape the approach. |
| **Goals / Non-Goals** | What the design aims for, and what it leaves out at design level. |
| **Decisions** | Each decision with its reason. Where an alternative was rejected, also that alternative. |
| **Risks / Trade-offs** | Each risk, followed by what is done about it. |

## 7.1 Who writes the design

The agent drafts the first version of `design.md`. It drafts it from the schema's instruction for the design and from the proposal. The proposal is the one artifact that the tool lists as the design's dependency. The agent supplies the four parts of the template, in the form that the instruction asks for. It also supplies a reason for each decision, and each reason reads as sound. The instruction also says when a design is needed. A design is needed when a change crosses several modules, or brings a new architectural pattern, a new external dependency or a significant change to the data model. It is also needed for a concern about security, performance or migration, or for an ambiguity that technical decisions would settle before coding. The developer decides whether one of those conditions applies. The agent cannot decide it for them.

The agent cannot supply what the developer knows about the work. It cannot say which alternatives were really open. It cannot say which constraints the code or the team imposes, or which cases the design may leave out. The example has no code, so its Context has no state of a codebase to describe. A design in a project with code begins there. The developer's part is to challenge the reasons, not to proofread the form. Section 5.1 describes the same division for the proposal. Chapter 2 gives the reason why human control stays with the developer.

In the `spec-driven` schema, the design requires only the proposal. The tasks require both the specification and the design. So the tool does not wait for the delta before it offers the design, and `openspec instructions design` lists the proposal as the design's only dependency. This book follows an order in which the delta is reviewed before the design is written from it. That order has a reason. The design is traced against the scenarios. If a scenario changes after the design is written, the traces have to be done again. Chapter 3 says that the dependencies between artifacts are enablers, not phase gates. This is the case where the tool shows it, because the tool does not enforce the order that the book recommends.

## 7.2 The parts of a design

The table shows what the tool checks in each part of the design. For this artifact, the answer is the same in every row.

| Part | What the tool checks | The question it answers |
|---|---|---|
| Context | Nothing. | What does a reader need in order to follow the decisions? |
| Goals / Non-Goals | Nothing. | What does the design achieve, and what does it leave out at design level? |
| Decisions | Nothing. | What was chosen, for what reason, and what was given up? |
| Risks / Trade-offs | Nothing. | What can go wrong, and what is done about it? |

The tool reads nothing of the design. `validate` reads the delta and never opens `design.md`. `archive` does not open it either. `status` counts the file as done if it exists, whatever it contains. A design of one character and an empty design both show as done. A change with no design validates and archives. At the same time, `status` shows the tasks as blocked until the file exists. That is the finding of this section. It does not mean that the design matters less than the other artifacts. It means that every check on it is made by a person. The instruction asks for a design only when one of its four conditions applies. The schema makes the tasks wait for the file. Those are two rules, and the tool enforces only the second. The four parts are the whole of the default template. A part that a project adds belongs in a forked schema, as chapter 3 described. Section 7.7 names the two parts that the instruction names beyond the template.

## 7.3 The Context, and what it points to

The file is `design.md` in the change `give-exact-change`. Its Context reads as archived:

```markdown
## Context

The purchase capability requires the machine to return the difference in coins from
its stock. This design says how the machine works out those coins and in what order
it does its steps.
```

A Context says what a reader needs in order to follow the decisions. For the rest, it points to the proposal and the delta. The instruction asks for the current state and the constraints. It also asks the design to refer to the proposal and the specifications rather than restate them. The first Context names the requirement it serves, in one sentence. Then it says what the design covers: how the machine works out the coins, and in what order it does its steps. A reviewer can keep that sentence or cut it. The sentence restates the requirement, which the delta already holds. But a reader who has not opened the delta needs to know which requirement is meant.

The file is `design.md` in the change `refuse-without-exact-change`. Its Context reads as archived:

```markdown
## Context

The design of `give-exact-change` released the product first and then worked out the
change greedily from the stock. Its findings traced the first two scenarios correctly.
The scenario "Stock cannot make the change" was not traced then, because it did not
exist. This design replaces the order of steps and records the trace that shows why.
```

This Context links the design to the one before it. It names the first design by its change. It says what that design traced and what it did not trace. It also says that this design replaces the order of steps. A reader of this file alone can find the thing that it replaces. Section 4.11 gives the full account of the first design, and this chapter does not repeat it.

## 7.4 Goals and non-goals

The file is `design.md` in the change `give-exact-change`. Its Goals / Non-Goals reads as archived:

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

The goal states what the design achieves, in the behaviour that the delta already states. The two non-goals say what the design leaves out at design level. They are the part of the template that changes an absence into a statement. The first non-goal is the case that section 4.7 shows the design failing: a stock that cannot make the change. The file says that the design does not decide it. So a reader who meets that scenario later can see that the case was set aside on purpose and was not missed. The instruction asks a design to add only design-level boundaries, and not to restate the proposal's scope. Both non-goals meet that test. One concerns a case, and the other concerns a method for choosing coins.

The file is `design.md` in the change `refuse-without-exact-change`. Its Goals / Non-Goals reads as archived:

```markdown
## Goals / Non-Goals

**Goals:**

- Return the exact difference in coins from the stock, or refuse the purchase and return
  the amount inserted.

**Non-Goals:**

- Changing the coin denominations.
- Telling the customer why a purchase was refused.
```

The goal restates the delta's outcome in the design's own words. So a reviewer can put it beside the requirement and compare the two. The two non-goals are the coin denominations and any message to the customer. The requirement that this change modifies has three scenarios, and none of them tests either non-goal. A non-goal that no scenario tests costs little to state. A reviewer can confirm from the delta that it is safe to state.

A non-goal makes a case visible, but it does not decide the case. What the system must do belongs to the delta (section 6.6). So a design that sets a case aside has not decided it. It has said that it does not decide it. When a reviewer reads the non-goals, the question is the same for each one: does a scenario test this case? If one does, the design cannot list the case as a non-goal. The scenario says what the system must do, and the design has to produce it. If no scenario tests it, the reviewer asks whether the requirement's wording covers the case. If the wording covers it, the case belongs in a scenario. The delta is where chapter 6 found the stock case, by varying what the requirement depends on (section 6.4). If the wording does not cover it, the non-goal stands. That is the answer to the question that chapter 6 left open. A design records the case it sets aside. The reviewer decides, with the delta open, whether the case was the design's to set aside.

## 7.5 Decisions and their reasons

The file is `design.md` in the change `give-exact-change`. Its Decisions reads as archived:

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

A decision is a choice with a reason, and the reason is the part that a reviewer can check. The first design has two decisions, and each has a Why. The first Why says that the customer should not wait at the machine after payment. That is a preference, and no scenario tests it. The second Why says that the method is short to state and easy to trace by hand. That reason concerns the design's own convenience. Neither reason is wrong. A reviewer asks which kind of reason each one is, and what would contradict it. The layout, a decision followed by its reason, is the example's own. The template asks for decisions with rationale and alternatives. It does not prescribe a layout, as section 4.4 says.

The file is `design.md` in the change `refuse-without-exact-change`. Its Decisions reads as archived:

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

Both reasons of the second design cite the requirement: "the requirement says the change is exact" and "the requirement gives no near-miss outcome". A reviewer can compare each reason with the delta and decide whether it holds. The decision that changes between the two designs is the order of steps. The first design released the product first. This design works out the change before the release. So the reasons support the decision that moved.

The instruction asks for the alternatives that were considered for each decision. The first design records none. The second records two, both under its second decision, and none under its first. A file with no alternative does not say whether one was open. So a reviewer cannot tell a decision from a default. The reviewer's question is which alternative someone would actually have chosen. The two alternatives in the second design are the two that keep the first design's order, and those are the ones that matter. The instruction asks for alternatives that were considered, not for every alternative that could be imagined. Section 4.11 sets out what each rejected alternative gave up.

## 7.6 Risks and what they cost

The file is `design.md` in the change `give-exact-change`. Its Risks / Trade-offs reads as archived:

```markdown
## Risks / Trade-offs

- The stock of coins shrinks with each purchase, and nothing in this design refills it.
  → Refilling is outside this change; the design assumes a stocked machine.
```

A risk names what could go wrong and what is done about it. The instruction writes this as an arrow from the risk to its mitigation, and the first design follows that form. The risk is that the stock shrinks with each purchase and nothing refills it. The mitigation is that refilling is outside the change. The risk names its cause. But it does not name what the machine does once the stock has run down. That is the case the first design set aside in its Goals / Non-Goals. A reviewer reads the arrow to see whether the mitigation is a decision or a deferral. Here it is a deferral, and the design states it.

The file is `design.md` in the change `refuse-without-exact-change`. Its Risks / Trade-offs reads as archived:

```markdown
## Risks / Trade-offs

- The stock of coins shrinks with each purchase, so refusals become more likely as the
  stock runs down. → Refilling the stock is outside this change; the design does not
  mitigate it.
```

The second design has the same cause and names a consequence: refusals become more likely as the stock runs down. Its mitigation is again outside the change. The design says that it does not mitigate the risk. An unmitigated risk is a decision once it is stated, and a reviewer can judge whether the consequence is acceptable. Section 4.11 says what changed between the two risks.

## 7.7 What the template leaves out

The instruction for the design asks for two parts that the template does not have. Migration Plan asks for the steps to deploy and the rollback strategy, if one applies. Open Questions asks for unknowns that can be answered later without changing the specifications, the approach or the task breakdown. It says that a question which would change any of them is resolved now. The instruction for the tasks adds a step. The agent reads the design's Open Questions and resolves with the user any question that would change what gets built. Neither example design has either part, so this chapter names them and shows neither. The Findings section that the example adds to its designs is not in the template either. Section 4.4 explains why the example keeps it. Section 5.7 already says where an unknown that can wait is recorded, and this chapter does not repeat it.

## 7.8 Reviewing a design

A design is reviewed after the delta is reviewed and before the tasks are written from it. The tasks are written from the design. So a decision that nobody traced becomes a task that nobody can check. The review has four passes. Intent asks whether the design serves the behaviour that the delta states. Reasons asks whether each decision's reason can be checked. Where the delta leaves a choice open, Reasons also asks whether an alternative was recorded. Trace asks whether each scenario can be walked through the decisions to the outcome it states, as section 4.7 walks one. Boundaries asks whether each non-goal is a case that no scenario tests. It also asks whether each risk says what happens when it occurs. Trace and boundaries matter most, because the tool cannot see either of them. Also, chapter 6 passed to the design the cases it must meet.

A trace tests the design against the cases that exist, and it cannot supply a case. A trace walks one scenario through the decisions by hand. The WHEN gives the inputs. The decisions are applied in order. The result is compared with the THEN. The example's designs record their traces, and its tasks cite them, in sections 4.5 and 4.12. The second design traces all three of its scenarios, as section 4.11 shows. These include the two that the first design had passed. A trace can find a decision that contradicts a scenario. It cannot find a case that no scenario names. Chapter 6 found the stock case by writing a scenario for it first. Only then was the design traced against it, as section 4.7 shows.

The table is one checklist. Its rows follow the order in which the file is read. The column names use the artifact's name, which here is the design.

| Check | The design passes when | How a draft can fail |
|---|---|---|
| The request is answered as meant | The design serves the behaviour the delta states. Nothing in it answers an assumption that the agent made instead | The design decides a behaviour the delta does not state, and the tasks are written from it |
| Context | It says what a reader needs to follow the decisions, and points to the proposal and the delta for the rest | It restates the proposal or the requirement at length, or it describes what the design will do rather than the state it starts from |
| Goals | Each goal is a behaviour the delta states, in the design's words | A goal restates the proposal's scope, or it states a method the delta leaves open as if the delta required it |
| Non-Goals | Each non-goal is a case that no scenario tests, or the scenario that tests it is named and the non-goal is removed | A non-goal is a case that a scenario tests, or a case the requirement's wording covers, and no one has decided it |
| Decisions: reason | Each reason can be checked against the delta, a constraint or a stated preference | A reason is only the design's convenience, and nothing could contradict it |
| Decisions: alternative | Where the delta leaves a choice open, the rejected alternatives are recorded, and each is one that someone would choose | No alternative is recorded for a decision that could have gone another way. So a reviewer cannot tell a decision from a default |
| Risks / Trade-offs | Each risk names its cause, its consequence and what is done about it | A risk names a cause and no consequence, or its mitigation is one the design cannot keep |
| Trace | Each scenario of the delta can be walked through the decisions to the outcome it states | A trace covers only the scenarios that existed when the design was written. A scenario added later is never traced |
| Downstream | The tasks can be written from the design, and each decision has a check that can mark it done | A decision is one that no task can check, or a task asks for something the design does not decide |

The table is a memory aid, and no part of the tool reads it. A row that passes records a person's judgement, not a machine's check. The last two rows are the only ones that are not about the file on its own. A design is finished when it can be traced, not when its parts are filled. A design that passes every other row but leaves a scenario untraced is not finished.

## 7.9 Changing a design after review

When the review finds a fault, two decisions follow: what the revision covers, and who makes it. The first decision depends on how much of the change exists.

| What exists | What the revision covers |
|---|---|
| Only the design | The part, and the parts coupled to it. A changed decision can affect the goal it served, the risk it created and the traces. So every scenario is walked again, not only the one that caused the change. |
| The design, with the tasks written from it | Those too, because the tasks were written from the decisions that changed. |
| An archived change | Nothing in the archive. A later gap goes into a new change. The design of that change names, in its Context, the design it replaces. |

The archive keeps the decisions as they were made. Section 5.9 says this of the proposal, and the same reason applies here. The example shows the bottom row and not the middle one. The second change's design is a new design in a new change. It names the first design in its Context, replaces the order of steps, and traces all three scenarios again, as section 4.11 shows. The first design is not touched. The middle row, a design revised while its tasks exist, has no case in the archive. Chapter 5 gives the reason: the second change was written after the first was archived, from a finding.

A revision can be made in two ways. The developer can edit the file, or the developer can ask the agent to change it. The choice depends on whether the replacement is known. The developer edits when the decision is already worked out. The developer asks the agent when the decision has to be worked out from the delta and the other decisions. The table compares the two ways on four points.

| | The developer edits the file | The agent is asked to revise it |
|---|---|---|
| Right when | The replacement is known, and the fault is in one decision or one reason | The decision has to be worked out from the delta, the other decisions or the traces |
| What it costs | A minute with the file open, and a diff that shows one change | A request with three parts, a whole file to read again, and a diff so large that it hides what changed |
| How it goes wrong | An edit to one decision leaves its goal, its risk or its trace no longer consistent with it | A request for a clearer decision returns a rewrite that changes what was decided |
| What to check afterwards | The goals, risks and traces that the decision touches | The whole file, including the decisions that nobody meant to change |

Suppose that the second reason of the first design had said that the method is the usual one. The developer knows the sentence that the archive holds: the method is short to state and easy to trace by hand. One sentence changes. Nothing else needs to change, because the wording of a reason is not an input to any trace. The diff shows that sentence and nothing else.

Suppose instead that a design, not one of the example's, records one decision with no alternative. The developer cannot yet say what was open. The request to the agent names that decision. It says that no alternative is recorded for it. It also says that the decision's text, its reason, the other decisions and the traces must not change. The agent proposes alternatives from the delta and the design's other decisions. The developer decides which of them anyone would have chosen. Without the third part, the agent may rewrite the whole Decisions part. The rewrite may change decisions that nobody asked about.

Both ways end in the same reading. An edit is checked by its diff. A revision made by asking the agent is a rewrite. So the whole design is read again as a new draft, using the four passes of section 7.8. Chapter 6 said that the tool catches a scenario dropped from a MODIFIED block. It does not catch a scenario whose text changed. A design has no such check. A decision can be dropped, or its reason changed, and `validate` still passes, because it never opens the file. The trace is what notices. It notices only for the scenarios that exist.

## 7.10 What the design passes on

The design passes to the tasks the decisions to check and the traces that have been done. The tasks are written from the design. Section 4.5 shows the first two tasks of the example, which are traces of its two scenarios. The design also passes on any open question. The instruction for the tasks asks for such a question to be resolved before the tasks are written. What the delta passed to the design, the design now holds as decisions. Each decision has its reason and, where an alternative was open, that alternative.

The tasks do not say what the system must do, and they do not decide how it works. They say how each decision is checked. They turn those checks into items that can be marked done. A command and a workflow that are not files close the change: `validate` and archive. Chapter 8 discusses the tasks and outlines what follows them. Chapters 11 and 12 describe them in full.

A design is the decisions that meet the cases. An agent drafts it. A program reads none of it. A person judges it by tracing the cases through it. The agent supplies the four parts and the form that the instruction asks for. The developer decides whether a design is needed and whether each reason holds. The tool checks none of the four parts, so the review is the whole of the check. A reason that can be compared with a requirement can be checked. A reason that is only convenience cannot. A non-goal is a statement that the review reads against the scenarios. A trace is the pass that finds a decision in conflict with a case. The reader should remember that a design is judged by two things: whether its scenarios can be traced through it, and whether what it leaves out is honest. A design that the tool accepts can still leave a scenario untraced, and finding that scenario is the reviewer's work.
