# 2. The Cornerstones of Spec-Driven Development

The conversation in chapter 1 settled the intent, and when it ended, nothing
had been written down. A good discussion is not a durable record. This chapter
takes the next step: it names the principles that make a record durable enough
to guide work. Spec-driven development (SDD) is a disciplined way to build
software in which an explicit, versioned specification steers planning,
implementation, testing and maintenance. It is not a programming language, and
it does not replace engineering judgment. It is a way to make intent available
to the people and tools that have to act on it.

## 2.1 What software development already solved

The gap between an idea and a working system is old, and software development has
built practices to close it:

- requirements engineering captures what a system should do, for whom, and under
  which constraints, and separates functional behaviour from quality attributes
  such as performance, security and usability;
- architecture and design describe the system's structure, its components and
  responsibilities, its interfaces and its important trade-offs;
- version control records how the code evolved, enables parallel work and makes a
  change reviewable;
- issue trackers explain why work is needed, who owns it and which need it
  serves;
- automated tests encode expected behaviour and guard against regressions;
- code review brings a second pair of eyes to correctness, security and
  maintainability;
- documentation carries knowledge beyond the conversation that produced it,
  though it often goes stale when it is written after implementation.

These practices remain valuable. SDD does not discard them or pretend to have
invented them. It changes what organizes them: instead of a specification that is
written once and then left behind, the specification remains active while the
work is planned, implemented, tested and maintained. The change is in the
organizing principle, not in the list of practices.

## 2.2 What AI changed

Chapter 1 described what happens when a model can turn a sentence into a
plausible implementation. The consequence for this chapter is narrower. A human
writing code carries a great deal of context implicitly: experience, project
conventions, architectural constraints and a sense of the users. When a model
generates code, that context has to be made explicit or the model will fill the
gap with a guess. The faster the code arrives, the more expensive a wrong
assumption becomes.

The guess is not made in a vacuum. A harness is everything around a language model
that turns it into an agent: the loop that feeds results back to the model, the
tools it can call, the context and instructions it receives, and the permissions
that limit what it may do. In a coding agent, the model proposes an edit; the
harness applies it, runs the tests and returns the output for the next step.
People use the word more narrowly for a product, and more broadly for everything a
team assembles around one; this chapter uses it for the whole runtime that couples
the model to the work. What the harness supplies decides how much of the gap
remains.

A single plausible answer is not the same as the right answer. A model can
generate several, and it cannot know which one matches the team's intent unless
that intent is available. Two sessions can follow different conventions: one may
use the pattern the project already has, and the next may invent a new one. The
response is not a better prompt. It is a shared, explicit reference:
requirements, constraints, acceptance criteria and project context become
first-class artifacts. The specification is that reference for intent.

## 2.3 Why the order of work changes

Traditional documentation often describes a system after it has been built, or it
describes a plan that is never updated once implementation begins. In an
AI-assisted workflow, that weakness is more visible: an agent may use outdated or
incomplete context and produce code that fits the document rather than the
system. The problem is not new, but the cost of discovering it late is higher.

SDD changes the order of work:

1. Describe the problem and the desired outcome.
2. Specify behaviour, constraints and acceptance criteria.
3. Plan the technical approach.
4. Break the work into reviewable tasks.
5. Implement with AI and human collaboration.
6. Validate the implementation against the specification.
7. Update the specification so it continues to describe the system accurately.

The order is a discipline, not a claim that the intent is complete before the
first line of code exists. What a specification is missing often becomes clear
only while the work is under way, which is why the last step is part of the method
rather than an afterthought.

The order creates a feedback loop between intent and implementation. Code is no
longer the only reliable record of what the system does; the specification
becomes a living description of expected behaviour, while code, tests and
documentation stay aligned with it. The loop is not automatic. Someone has to
notice that the implementation taught something new and carry it back into the
specification.

## 2.4 The cornerstones

SDD frameworks differ in terminology and workflow, but most share a small set of
foundational ideas. These are the cornerstones: principles that hold regardless
of the tool or the names a team uses. They are not a product feature list.
Chapter 1 derived ten needs from the gaps left by direct generation and
conversation. The cornerstones are those needs restated as principles that a
workflow can be checked against. Three differences are deliberate. Proportionality
does not appear as a cornerstone, because it governs how much record to write
rather than what the record contains. Living documentation and human control do
appear, because chapter 1 stated them as rules of judgment rather than as needs,
and a workflow has to carry them.

| Cornerstone | Meaning | How it decays |
|---|---|---|
| Explicit intent | The purpose, scope, users and expected outcome of a change are written down before implementation. | Scope drifts from the work done. |
| Specification as shared reference | The specification describes what the system should do and is the shared reference for intent; code serves it. It is not infallible: it is reviewed, corrected and maintained. | Implementation detail goes stale under refactoring. |
| Current-state knowledge | The project describes the capabilities and behaviour it has today, not only the work it plans. | Behaviour changes; the description does not. |
| Change as a first-class unit | A modification has its own record: why it is needed, what changes, how it will be built and how the result is checked. | Later decisions made in code go unrecorded. |
| Separation of current and proposed state | The team can distinguish what the system does today from what a proposed change adds, modifies or removes. | Proposed changes merge into the description before they are built. |
| Shared project context | Conventions, constraints, architectural rules and quality expectations are available to every contributor and every AI session. | Conventions are not revisited; agents follow stale rules. |
| Traceability | Requirements connect to the design, tasks, tests and code that realize them. | Links go stale when code or tests move. |
| Reviewability | Intent and plan can be reviewed before code is written, not only afterward. | Review happens after code; intent is rebuilt from the diff. |
| Validation | Acceptance criteria and tests determine whether the implementation fulfils the specification. | Tests check written expectations, not every goal. |
| Living documentation | After a change is completed, the specification is updated so future work starts from an accurate picture. | Updates are skipped; the next change plans against stale text. |
| Human control | Humans decide what to build, review trade-offs, approve changes and remain accountable for the result. | Approval loses force when the judge produced the work. |

These cornerstones are not bureaucratic overhead. They are mechanisms for
preserving the context that AI needs and that teams have always needed but often
kept in informal conversations. A team that keeps them in place does not add
ceremony for its own sake; it reduces the number of things that have to be
remembered or guessed.

## 2.5 Problems SDD solves

SDD is most effective where context is missing, temporary or inconsistent.
Chapter 1 showed ambiguity, lost context, drift and weak review in detail. Four
further consequences follow from the same gap:

- **Inconsistent AI output.** Shared conventions and constraints help agents
  produce results that fit the project instead of inventing a pattern in every
  session.
- **Poor onboarding.** A new developer or agent can read the current
  specifications to understand the major capabilities and constraints. Where
  specifications pass between developers and other roles, that reading pays most;
  in a team of developers only, it adds a document to read and changes less than
  the argument suggests.
- **Unclear scope.** Explicit requirements and exclusions make trade-offs
  visible. Chapter 1's CSV export request can quietly grow a filter, a permission
  rule and a size limit that nobody asked for.
- **Fragmented knowledge.** Requirements, rationale, tasks and validation
  criteria are connected instead of scattered across chats, tickets, wikis and
  comments.

These are problems of communication and memory, not of coding skill. A team that cannot write a
clear requirement will not become able to do so because it adopts a framework;
the framework only makes the gap visible sooner.

## 2.6 Problems SDD does not solve

SDD is not a cure-all. It improves the quality of communication and
decision-making, but it cannot replace the responsibilities of software
engineering.

- It does not guarantee correct requirements. A precise specification of the
  wrong behaviour is still wrong.
- It does not eliminate testing. Specifications define expected behaviour; tests
  and verification still prove that the implementation behaves as intended.
- It does not make a green result independent. Tests are often written by the same
  agent as the code, from the same reading of the requirement, so a passing run
  can confirm a shared misunderstanding.
- It does not remove architectural judgment. Choosing between designs, evaluating
  trade-offs and understanding long-term consequences remain human work.
- It does not make bad product decisions good. SDD can clarify a decision; it
  cannot decide business value, priorities or user needs by itself.
- It does not remove the need for code review. Generated code still needs
  inspection for correctness, security, performance, maintainability and fit
  with the system.
- It does not make every task worth specifying. Chapter 1 covered how to judge
  when the cost is worth it; this list is about the limits that remain even then.
- It does not prevent specification rot automatically. Specifications must be
  maintained, or they become misleading documentation.

The limits are the limits of any written record, not a defect in the idea.

Decay has a mechanism, and it is the reason the cornerstone asks for what rather
than how. Implementation detail helps an agent that lacks context, and it dates
the record as soon as the code moves: a named class, function or library version
changes under refactoring while the behaviour it produces does not. Detail that is
structured well improves what an agent produces, so the answer is not less detail.
It is to keep the detail apart from the behaviour it serves, and to expect the
detail to be replaced.

A green test is a weak signal on its own. It can pass because the work is right or
because the test never looks, and the result looks identical either way. Evidence
requires the possibility of failure: only a test that could have gone the other
way shows anything about the claim.

A requirement that constrains a state does not say how a transition between two
states is carried out. The design records that decision, and the reason it chose
one order over another.

## 2.7 Why developers remain essential

AI changes the daily work of developers, but it does not remove the need for
them. Developers translate incomplete human goals into precise, testable intent.
They understand the organization around the system, evaluate risk and take
responsibility for what is delivered. A model can produce an implementation; it
cannot decide what should exist, why it should exist, or whether the result is
acceptable.

In an SDD workflow, developers spend more time on activities that require
judgment:

- understanding user and business problems;
- identifying constraints, risks and non-functional requirements;
- designing and reviewing architectural options;
- writing and reviewing specifications;
- challenging AI-generated plans and implementations;
- reviewing security, privacy, performance and maintainability;
- deciding what should be automated and what should remain manual;
- maintaining a coherent system rather than a collection of isolated generated
  fragments.

The developer's role shifts from typing every line to directing, reviewing and
integrating work. That is a change in emphasis, not a loss of relevance.

Whoever writes a record bears its cost, while its benefit goes to people who
arrive later, so a team must settle what earns one.

SDD is best understood as a contract between the people who want a system, the
people who build it and the AI tools that help build it. It makes intent
explicit, keeps that intent available and connects it to implementation and
verification. That is what stops the model from guessing and the team from
relying on memory. The cornerstones are the terms of that contract: they
name what must be preserved, what must be reviewed and what remains human
responsibility. Those terms still have to be carried by something. The next
chapter shows one implementation that carries them, and what the conventions
cannot carry.
