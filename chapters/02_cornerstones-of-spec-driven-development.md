# 2. The Cornerstones of Spec-Driven Development

The conversation in chapter 1 settled the intent. When it ended, nothing had been
written down. A good discussion is not a durable record. The next step is to name
the principles that make a record durable enough to guide work, and this chapter
does that. Spec-driven development (SDD) is a disciplined way to build software.
In SDD, an explicit, versioned specification steers planning, implementation,
testing and maintenance. It is not a programming language, and it does not
replace engineering judgment. It is a way to make intent available to the people
and tools that have to act on it.

## 2.1 What software development already solved

The gap between an idea and a working system is old. Software development has
built practices to close it:

- requirements engineering describes what a system should do, for whom, and under
  which constraints. It separates functional behaviour from quality attributes
  such as performance, security and usability;
- architecture and design describe the system's structure, its components and
  their responsibilities, its interfaces and its important trade-offs;
- version control records how the code changed. It allows parallel work and makes
  a change reviewable;
- issue trackers explain why work is needed, who owns it and which need it
  serves;
- automated tests encode expected behaviour and protect against regressions;
- code review adds a second reader, who checks correctness, security and
  maintainability;
- documentation keeps knowledge after the conversation that produced it has
  ended. It often becomes outdated when it is written after implementation.

These practices remain valuable. SDD does not discard them, and it does not
pretend to have invented them. It changes what organizes them. The specification
is not written once and then left unused. It stays active while the work is
planned, implemented, tested and maintained. The change is in the organizing
principle, not in the list of practices.

## 2.2 What AI changed

Chapter 1 described what happens when a model can turn a sentence into a
plausible implementation. This chapter draws a narrower consequence from it. A
human who writes code carries a lot of context without stating it: experience,
project conventions, architectural constraints and a sense of the users. When a
model generates code, that context has to be made explicit. Otherwise the model
fills the gap with a guess. The faster the code arrives, the more a wrong
assumption costs.

The model does not guess without context. A harness is everything around a
language model that turns it into an agent. It includes the loop that feeds
results back to the model, the tools the model can call, the context and
instructions it receives, and the permissions that limit what it may do. In a
coding agent, the model proposes an edit. The harness applies the edit, runs the
tests and returns the output for the next step. Some people use the word more
narrowly, for a product. Others use it more broadly, for everything a team
assembles around one. This chapter uses it for the whole runtime that connects
the model to the work. What the harness supplies decides how much of the gap
remains.

A single plausible answer is not the same as the right answer. A model can
generate several plausible answers. It cannot know which one matches the team's
intent unless that intent is available. Two sessions can follow different
conventions. One may use the pattern that the project already has, and the next
may invent a new one. The response is not a better prompt. The response is a
shared, explicit reference: requirements, constraints, acceptance criteria and
project context are treated as artifacts of their own. The specification is that
reference for intent. It stays that reference only as long as it is reviewed and
corrected.

## 2.3 Why the order of work changes

Traditional documentation often describes a system after it has been built. Or it
describes a plan that nobody updates once implementation begins. In an
AI-assisted way of working, this weakness is more visible. An agent may use outdated or
incomplete context, and produce code that fits the document rather than the
system. The problem is not new, but finding it late costs more.

SDD changes the order of work:

1. Describe the problem and the desired outcome.
2. Specify behaviour, constraints and acceptance criteria.
3. Plan the technical approach.
4. Break the work into reviewable tasks.
5. Implement with AI and human collaboration.
6. Validate the implementation against the specification.
7. Update the specification so it continues to describe the system accurately.

The order is a discipline. It does not claim that the intent is complete before
the first line of code exists. What a specification is missing often becomes
clear only while the work is in progress. That is why the last step is part of
the method, and not an extra added at the end.

The order creates a feedback loop between intent and implementation. Code is no
longer the only reliable record of what the system does. The specification
becomes a living description of expected behaviour, and code, tests and
documentation stay consistent with it. The loop is not automatic. Someone has to
notice that the implementation taught something new. That person then has to
carry it back into the specification.

## 2.4 The cornerstones

SDD frameworks differ in terminology and way of working, but most share a small set of
basic ideas. These ideas are the cornerstones. They are principles that hold
whatever tool or names a team uses. They are not a list of product features.
Chapter 1 derived ten needs from the gaps that direct generation and
conversation leave. The cornerstones are those needs, restated as principles
that a way of working can be checked against. Three differences are on purpose.
Proportionality is not a cornerstone, because it decides how much record to
write, not what the record contains. Living documentation and human control do
appear as cornerstones. The reason is that chapter 1 stated them as rules of
judgment rather than as needs, and a way of working has to carry them.

| Cornerstone | Meaning | How it decays |
|---|---|---|
| Explicit intent | The purpose, scope, users and expected outcome of a change are written down before implementation. | The work done no longer matches the scope. |
| Specification as shared reference | The specification describes what the system should do. It is the shared reference for intent, and code serves it. It can be wrong, so it is reviewed, corrected and maintained. | Implementation detail becomes outdated when the code is refactored. |
| Current-state knowledge | The project describes the capabilities and behaviour it has today, not only the work it plans. | Behaviour changes, but the description does not. |
| Change as a first-class unit | A modification has its own record: why it is needed, what changes, how it will be built and how the result is checked. | Later decisions are made in code and are not recorded. |
| Separation of current and proposed state | The team can tell what the system does today apart from what a proposed change adds, modifies or removes. | Proposed changes are merged into the description before they are built. |
| Shared project context | Conventions, constraints, architectural rules and quality expectations are available to every contributor and every AI session. | Conventions are not reviewed again, and agents follow outdated rules. |
| Traceability | Requirements are linked to the design, tasks, tests and code that implement them. | Links become outdated when code or tests move. |
| Reviewability | Intent and plan can be reviewed before code is written, not only afterward. | Review happens after the code exists. The reviewer rebuilds the intent from the diff. |
| Validation | Acceptance criteria and tests decide whether the implementation fulfils the specification. | Tests check the expectations that were written down, not every goal. |
| Living documentation | After a change is completed, the specification is updated so future work starts from an accurate picture. | Updates are skipped. The next change is planned against outdated text. |
| Human control | Humans decide what to build, review trade-offs, approve changes and remain accountable for the result. | Approval loses its force when the one who judges the work also produced it. |

These cornerstones are not bureaucratic overhead. They are mechanisms that
preserve context. AI needs this context. Teams have always needed it too, but
they often kept it in informal conversations. A team that keeps the cornerstones
in place does not add ceremony for its own sake. It reduces the number of things
that people have to remember or guess.

## 2.5 Problems SDD solves

SDD is most effective where context is missing, temporary or inconsistent.
Chapter 1 showed ambiguity, lost context, drift and weak review in detail. Four
more consequences follow from the same gap:

- **Inconsistent AI output.** Shared conventions and constraints help agents
  produce results that fit the project, so that an agent does not invent a new
  pattern in every session.
- **Poor onboarding.** A new developer or agent can read the current
  specifications to understand the major capabilities and constraints. This
  reading is worth most where specifications pass between developers and other
  roles. In a team of developers only, it adds a document to read, and it changes
  less than the argument suggests.
- **Unclear scope.** Explicit requirements and exclusions make trade-offs
  visible. Without anyone noticing, chapter 1's CSV export request can gain a
  filter, a permission rule and a size limit that nobody asked for.
- **Fragmented knowledge.** Requirements, rationale, tasks and validation
  criteria are connected, and not scattered across chats, tickets, wikis and
  comments.

These are problems of communication and memory, not of coding skill. SDD
improves the record, not the ability to write code. A team that cannot write a
clear requirement does not become able to write one by adopting a framework. The
framework only makes the gap visible sooner.

## 2.6 Problems SDD does not solve

SDD does not solve every problem. It improves the quality of communication and
decision-making. But it cannot replace the responsibilities of software
engineering.

- It does not guarantee correct requirements. A precise specification of the
  wrong behaviour is still wrong.
- It does not remove the need for testing. Specifications define expected
  behaviour. Tests and verification still prove that the implementation behaves
  as intended.
- It does not make a passing result independent. Tests are often written by the
  same agent as the code, from the same reading of the requirement. So a passing
  run can confirm a misunderstanding that the tests and the code share.
- It does not remove architectural judgment. Choosing between designs, weighing
  trade-offs and understanding long-term consequences are still human work.
- It does not make bad product decisions good. SDD can make a decision clearer.
  It cannot decide business value, priorities or user needs by itself.
- It does not remove the need for code review. Generated code still needs
  inspection for correctness, security, performance, maintainability and fit
  with the system.
- It does not make every task worth specifying. Chapter 1 discussed how to judge
  when the cost is worth it. This list is about the limits that remain even then.
- It does not automatically stop specifications from decaying. Specifications
  must be maintained, or they become misleading documentation.

The limits are the limits of any written record, not a defect in the idea. A
record can be precise and still describe the wrong thing. Even a well-judged
record cannot decide what is worth building. It also cannot replace the judgment
that keeps it accurate.

Decay has a mechanism. That mechanism is the reason the cornerstone asks for what
rather than how. Implementation detail helps an agent that lacks context. It also
makes the record outdated as soon as the code changes. A named class, function or
library version changes when the code is refactored, while the behaviour it
produces does not. Well-structured detail improves what an agent produces, so the
answer is not less detail. The answer is to keep the detail apart from the
behaviour it serves, and to expect the detail to be replaced.

A passing test is a weak signal on its own. It can pass because the work is
right, or because the test never checks the claim. The result looks the same in
both cases. Evidence requires the possibility of failure. Only a test that could
have failed shows anything about the claim. Confirmation proves little. A failed
expectation is what shows that the test was looking at the claim.

A requirement that constrains a state does not say how a transition between two
states is carried out. The design records that decision. It also records why it
chose one order over another.

## 2.7 Why developers remain essential

AI changes the daily work of developers, but it does not remove the need for
them. Developers translate incomplete human goals into precise, testable intent.
They understand the organization around the system, evaluate risk and take
responsibility for what is delivered. A model can produce an implementation. It
cannot decide what should exist, why it should exist, or whether the result is
acceptable.

In an SDD way of working, developers spend more time on activities that require
judgment:

- understanding user and business problems;
- identifying constraints, risks and non-functional requirements;
- designing and reviewing architectural options;
- writing and reviewing specifications;
- questioning AI-generated plans and implementations;
- reviewing security, privacy, performance and maintainability;
- deciding what should be automated and what should remain manual;
- maintaining a coherent system rather than a collection of isolated generated
  fragments.

The developer's role shifts from typing every line to directing, reviewing and
integrating work. That is a change in emphasis, not a loss of relevance. AI can
make implementation faster, but humans remain responsible for deciding what
should exist, why, and whether the result is acceptable.

Whoever writes a record pays its cost. Its benefit goes to people who come later.
So a team must decide which work deserves a record.

SDD is best understood as a contract between the people who want a system, the
people who build it and the AI tools that help build it. It makes intent
explicit, keeps that intent available and connects it to implementation and
verification. That is what stops the model from guessing and the team from
relying on memory. The cornerstones are the terms of that contract. They name
what must be preserved, what must be reviewed and what remains human
responsibility. Something still has to carry those terms. The next chapter shows
one implementation that carries them, and what the conventions cannot carry.
