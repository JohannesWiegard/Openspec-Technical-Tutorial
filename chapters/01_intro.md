# 1. From AI-Assisted Coding to Spec-Driven Development

## 1.1 Starting with a prompt

More software work now begins with a description than with a blank file. You describe the behaviour you want, and a model returns code, a test, a documentation draft, or a refactoring suggestion. The request can be a sentence or a page; the response can be pasted into the project and tried. That is the new starting point, and it changes how quickly a first result appears.

The effect is largest when the task is bounded. A prototype, an isolated utility, a converter, or a small feature with a clear input and output gives the model enough context to produce something useful. The cost of trying an approach falls, so you try more approaches. That is a real gain, and it is not limited to trivial work. It is simply strongest where the boundaries are visible.

Speed is not the same as quality. Code that arrives quickly can still ignore the project's conventions, duplicate an abstraction that already exists, or solve the immediate request in a way that fits badly with the surrounding design. It may run and still be hard to maintain. Running is a low bar; whether the result is right is a separate question.

The first workflow is simple. You explain the feature, ask for an implementation, paste the result into the project, and try it. If it fails, you describe the failure and ask for another attempt. If it passes, you may keep it and move on. The loop is prompt, generate, paste, test, and repeat, and it is often enough to get a first version into view.

That loop is genuinely useful. It gives fast feedback and makes it easy to explore a library or an API before committing to a design. It is a good way to build a throwaway prototype, a small script, or a rough feature that you intend to rewrite.

The limitation is in the input. The result is only as good as the request and the assumptions the model brings to it. A missing behaviour is inferred rather than asked about. An unsuitable architecture is chosen because the model has no knowledge of the project's architecture, so it guesses from what it does know. Project conventions are ignored because they were never in the prompt. Nothing in the result distinguishes a guess from a decision. None of this requires the model to be careless; it follows from working with an incomplete description. Not all of the missing information is context that someone forgot to provide. A requirement can be correctly silent about things that are not requirements — the order of operations, the wording of a message, the internal structure of a component — and those silences are decisions waiting to be made. When a model fills one, the result is a guess embedded in code.

## 1.2 Talking before code

Direct generation remains legitimate, but it leaves no durable statement of intent. When the first result survives, the next improvement is a conversation about the implementation before any code is requested. You and the model discuss what the change should do, what it must fit into, and which trade-offs are acceptable. No code is written yet. The request becomes a shared proposal rather than a single instruction.

The conversation covers the decisions that code would otherwise make silently:

- what problem the change solves and what behaviour it should produce;
- what existing code, interfaces and constraints it has to fit;
- which design options exist and what each one trades away;
- which edge cases, failure modes and security concerns matter;
- what tests or acceptance criteria will show that it works;
- how the work should be sequenced into steps.

Discussing those decisions first turns a vague request into shared understanding. The point is to close the information gaps that would otherwise become guesses before the model fills them in. Ambiguity is exposed while it is still cheap to resolve. Assumptions can be challenged before they are embedded in source, and rework falls because the shape of the change is agreed before it is built. The gain depends on the quality of the conversation; a discussion that never reaches a decision is just a longer prompt.

Consider a request as ordinary as "add CSV export". Which records should be exported? Which columns? Does the current filter apply, or does export ignore it? How should dates, numbers and text be formatted? Who is allowed to export what? What happens when the result is too large to build in memory? What should the file be called, and should the same request produce the same file twice? The request is one sentence; the implementation is a set of decisions. The quality labels people reach for — *clear*, *testable*, *well-specified* — are adjectives, not diagnostics. The test of a requirement is whether a concrete question about it can be answered, or only discussed.

## 1.3 What the conversation forgets

The conversation is better than the prompt, but it is still a conversation. Its value lives in the chat, and it usually disappears when the chat ends. You may have produced an excellent plan, but the plan is hard to retrieve later, and the conversation is not a project artifact. The next person sees the code, not the reasoning that produced it.

A later reader needs information that the conversation held:

- why the change was made;
- which alternatives were rejected, and why;
- what was in scope and what was deliberately left out;
- which constraints and project rules applied;
- what must not break;
- how the result was validated.

The same developer a week later is also a later reader. Memory is not a reliable interface.

Without a stable description, the system drifts. Drift is the slow divergence between what the system is supposed to do and what its code, tests and documents now say. Each change is made from a local understanding of the system, and local understandings accumulate. A specification can serve as the reference against which drift is detected and corrected, but a stale reference makes drift harder to see, not easier.

Review weakens under the same pressure. A reviewer sees a diff: lines added, lines removed, tests changed. What the reviewer does not see is the intent behind the change. Without a durable statement of purpose, they reconstruct it from the code, the commit message or memory. Deliberate exclusions are especially invisible: the reviewer cannot tell whether something was omitted on purpose or forgotten. The review becomes a check on the implementation rather than on the change. Recording the exclusion is the only way to make the difference visible, because an exclusion written into an artifact can be seen, challenged, and maintained.

Direct generation answers a narrow question: can we do this? It does not answer what should work, why it should work that way, how the work should be approached, which constraints apply, or what behaviour is acceptable and how it will be verified. Those answers are not a better prompt. They are a durable, reviewable record of intent. Different technologies and practices can supply that record, and the next paragraphs examine attempts to improve generation before asking what such a record must do.

## 1.4 Better context is not enough

Several techniques can improve the context available to direct generation:

- retrieval over design decisions, specifications, code and past changes;
- tool servers or protocols, such as MCP, that expose repositories, issue trackers, CI and monitoring;
- persistent project instruction files, such as `AGENTS.md`, that are read at the start of a session;
- repository search and dependency context;
- automated tests, linters and type checks whose results are fed back into the loop.

Each technique gives the model more to work with. None of them, by itself, decides what the work should be.

These techniques are worth using. The instruction file is the one whose value is most often assumed. It tells an agent what the project expects, but where such files have been compared against none, the work has come out no better: what changed was how the agent worked, not what it produced. A context file passes on what a team already knows; it is not a lever on quality. Retrieval sees only what someone stored, and only in the form they stored it. Tool access gives current state, not durable intent. Session context is a selection, not the whole history. Files can preserve what the session loses, and written records are the foundation of the workflow that follows. But a hand-built collection of files will not match a framework that defines the artifacts, their relationships and their checks.

A specification is one such written reference. It is something tools, agents and people can work from, and it can be reviewed and corrected. A wrong specification is a defect to fix, not a truth to obey. The question is therefore not whether a document exists, but whether it preserves the intent the work needs and whether the team keeps it honest.

## 1.5 What the work needs

These failures suggest a set of needs, not a feature list. The first group is about preserving intent and context. A durable record should persist the intent of a change: why it is needed, what it should achieve, and what is excluded. It should make key information available later without requiring the old transcript. It should capture the general rules that apply to change, such as architecture, standards, testing, security, accessibility and error handling. It should describe the complete application, not only the part being changed. And it should separate current behaviour from the proposed change.

The second group is about how the work is reviewed, traced, delivered and validated. The record should be reviewable as an artifact, not only as a conversation. It should support traceability from a requirement to design decisions, tasks, tests and implementation. It should enable incremental delivery, so work can be split into reviewable changes. It should support validation, not just generation: acceptance criteria and tests need a basis for checking the result. The tests are not that basis on their own. A test can pass and still measure nothing that was asked for, because no test states which claim it is meant to decide. Only a requirement written down beforehand gives a test something to be measured against, and says what passing is supposed to mean. And it should remain lightweight and proportional, because a record that costs more than the change it describes will be abandoned.

## 1.6 From needs to spec-driven development

One family of practices responds to those needs by making intent explicit and treating the specification as an active artifact. In spec-driven development (SDD), requirements, constraints, acceptance criteria and validation are made explicit before and during implementation. The specification guides planning, implementation, testing and validation. It is a living reference rather than a project history, and it is expected to change when the work teaches something new.

One concrete implementation is OpenSpec. It organizes work as a change proposal, capability specifications, a design and a task list. Its `specs/` directory holds the current behaviour of the system; its `changes/` directory holds proposed modifications and the artifacts that describe them. Those are conventions, not requirements of spec-driven development.

The needs, not the tool, are the test. Another spec-driven tool or a team's own practice may use different names, different artifacts and a different file layout; what counts is whether it meets the needs of section 1.5, and the names matter less than the record. OpenSpec is replaceable in this argument.

## 1.7 What SDD costs

The cost of a record cannot be priced exactly, but its shape is not in doubt, and it arrives before anything is paid back. Planning takes time and tokens, and the attention it demands competes with the attention the rest of the work needs. The record is work of its own: it has to be read, reviewed and kept current, and every hour on it is an hour not spent on something else.

Most of the cost is not the writing. It is the deciding: the questions a record has to answer are the questions the work would otherwise have left to whoever implemented it, and answering them takes judgment. A page of prose is cheap; the hour spent settling what the page should say is the expensive part, and that hour is spent whether or not the page is ever written.

What it saves is rework that did not happen, which is why the saving is hard to see. A change that goes well leaves no trace of the version that would have gone wrong, so the benefit never appears as a line anyone can point at. The cost does: it sits in the session, in the review and in the record.

The bill is not small. Where the two routes have been run side by side on the same tasks, the one that wrote a specification, a plan and a task list before implementing spent many times the tokens and the elapsed time of a single free-form request, for a gain in passing tests that was real and far smaller than that multiple. A benchmark is not a team, so the comparison does not fix the price; it fixes the order of magnitude. This is a purchase with a visible bill, not a small extra step.

A record comes in sizes, and the size is what sets the price. It can be a paragraph in a change description, a specification kept beside the code, or the artifact from which the code is generated. Each size asks for more discipline than the one before and has to stay true for longer, so choosing a size is choosing what the work costs.

The person who pays for a record is usually not the person who gains by it. The effort falls on whoever writes it; the saving falls on whoever reads it later, who never sees the hour it cost. That is why a practice can be worth keeping for one person and still be resisted by the team around them. A team that wants the saving has to say what deserves a record: left to each person, the answers diverge and the record becomes a different thing in every change.

## 1.8 What it returns

In return, three things stop being lost. Rework is avoided: the decisions that implementation would have forced were settled before it. Review gains a subject: the reviewer sees the intent and the exclusions, not only the diff. And the next change gains a starting point, because it begins from a written reference rather than from someone's memory of the last conversation.

How large that return is cannot be measured from the outside, and it should be read as an estimate. Part of it comes from the record, part from the models being better at the same task than they were, and part from having stated the goal before delegating the work, which a careful conversation would produce as well. What remains is a judgment: the record is worth its cost to the people who keep it, and the size of the return is not established.

The measurements that exist are sobering. Where specifications have been compared against none across tens of thousands of changes, the difference in defects and in rework has been hard to find at all, and the association that does appear is explained by the difficulty of the work that gets specified. Such a comparison sees specification documents as they sit in repositories — a ticket reference, a page beside the code — and not the practice of writing one, which is what this chapter argues for. So it does not show that a record fails to help. It shows that the help has not been visible where it was expected to be easiest to see, which is an argument for choosing where to write a record rather than for abandoning the practice.

## 1.9 When SDD earns its cost

SDD is strong where intent, constraints and verification matter. Feature development, behavioural changes, integrations, refactors with risk, and security-sensitive work all benefit from a record that says what should happen and how it will be checked. So does collaboration among humans and agents, because the record is the shared reference they can both work from.

SDD is less useful when the cost of specification exceeds the value of the change. A quick experiment, a one-off script, an exploratory spike, a trivial fix, or an early prototype whose purpose is to learn what to build may need only a conversation. Writing a full record for such work can slow the learning that the work exists to produce. The list is not exhaustive, and simple work is not a defect.

None of this removes engineering judgment. A specification can also be incomplete, overly rigid or too abstract. The team still has to review the requirements, challenge the design, write meaningful tests, inspect the code and maintain the specification. SDD reduces guesswork; it does not transfer accountability to a document or a tool. The human remains responsible for the artifacts being right.

SDD does not replace direct AI coding or conversational exploration. The chapter has described three ways of working: direct generation, explain mode — the conversation before code — and spec-driven development. Each has legitimate uses, and the choice should follow the situation rather than an ideology. The table below gives a better default for several situations. Three questions generate it: how long the result has to live, how many people or agents will work on it, and what a wrong guess would cost. The three ways of working differ in whether a record is used; these questions decide how large that record should be. "Better default" does not mean the only option.

| Situation | Better default |
|---|---|
| Explore an idea or learn an API | Direct generation or explain mode |
| Build a disposable prototype | Direct generation; keep light notes if it survives |
| Fix a small isolated bug | Explain mode; add a lightweight change record if the fix grows |
| Change user-facing behaviour | SDD |
| Work on a critical workflow or integration | SDD |
| Make an architectural decision | SDD, especially with recorded rationale |
| Work across multiple sessions, people or agents | SDD |
| Need reviewable intent and traceability | SDD |

These three ways of working are not stages to graduate from; they answer different durations. Direct generation is fastest when the result can be tried at once. Explain mode is better when the request has to be understood before code exists. Spec-driven development earns its cost when intent has to survive the session, be reviewed by someone else, or be traced from a requirement to a test.

The three ways differ in how they treat the information the model does not have. Direct generation leaves the model to guess. Explain mode resolves some of the gaps before code exists, but its answers stay in the conversation. A durable record keeps those answers where a later session, reviewer or agent can find them, so the next change does not start from a partial memory. The conversation is where understanding starts, but it is not where it stays. A specification, a change record and the tests that decide them are one way to keep that reference honest. The rule is therefore not "always specify" but "preserve enough context for the work": use the lightest process that keeps the model from having to guess about what matters, and that preserves the context needed to build, review and maintain the result.
