# 1. From AI-Assisted Coding to Spec-Driven Development

## 1.1 Starting with a prompt

More software work now begins with a description than with a blank file. You describe the behaviour you want, and a model returns code, a test, a documentation draft, or a refactoring suggestion. The request can be a sentence or a page. You can paste the response into the project and try it. That is the new starting point, and it changes how quickly a first result appears.

The effect is largest when the task is bounded. A prototype, an isolated utility, a converter, or a small feature with a clear input and output gives the model enough context to produce something useful. Trying an approach costs less, so you try more approaches. That is a real gain, and it is not limited to trivial work. It is only strongest where the boundaries are visible.

Speed is not the same as quality. Code that arrives quickly can still ignore the project's conventions. It can duplicate an abstraction that already exists. It can solve the immediate request in a way that fits badly with the surrounding design. It may run and still be hard to maintain. Running is a low standard. Whether the result is right is a separate question.

The first way of working is simple. You explain the feature, ask for an implementation, paste the result into the project, and try it. If it fails, you describe the failure and ask for another attempt. If it passes, you may keep it and continue with the next task. The loop is prompt, generate, paste, test, and repeat. It is often enough to produce a first version that you can look at.

That loop is really useful. It gives fast feedback and makes starting cheaper. It also makes it easy to explore a library or an API before you commit to a design. It is a good way to build a throwaway prototype, a small script, or a rough feature that you intend to rewrite. The speed is not a trick. It changes what you are willing to try.

The limitation is in the input. The result is only as good as the request and the assumptions that the model brings to it. The model infers a missing behaviour instead of asking about it. It chooses an unsuitable architecture because it has no knowledge of the project's architecture, so it guesses from what it does know. It ignores project conventions because they were never in the prompt. Nothing in the result shows which part is a guess and which part is a decision. Every piece of information that the request does not contain lets the model guess, and those guesses end up in the code. None of this requires the model to be careless. It follows from working with an incomplete description. Not all of the missing information is context that someone forgot to provide. A requirement can correctly say nothing about things that are not requirements — the order of operations, the wording of a message, the internal structure of a component. Each of those gaps is a decision that someone still has to make. When a model fills one, the result is a guess inside the code. When a developer resolves one in conversation, the answer is lost when the session ends.

## 1.2 Discussing the change before writing code

Direct generation is still a legitimate way of working, but it leaves no lasting statement of intent. When the first result survives, the next improvement is a conversation about the implementation before any code is requested. You and the model discuss what the change should do, what it must fit into, and which trade-offs are acceptable. No code is written yet. The request becomes a shared proposal instead of a single instruction.

The conversation covers the decisions that code would otherwise make without anyone noticing:

- what problem the change solves and what behaviour it should produce;
- what existing code, interfaces and constraints it has to fit;
- which design options exist and what each one gives up;
- which edge cases, failure modes and security concerns matter;
- what tests or acceptance criteria will show that it works;
- how the work should be ordered into steps.

When you discuss those decisions first, a vague request becomes shared understanding. The purpose is to close the information gaps before the model fills them with guesses. Ambiguity becomes visible while it is still cheap to resolve. You can question assumptions before they are built into the source. Rework falls because the shape of the change is agreed before it is built. The gain depends on the quality of the conversation. A discussion that never reaches a decision is only a longer prompt.

Consider a request as ordinary as "add CSV export". Which records should be exported? Which columns? Does the current filter apply, or does export ignore it? How should dates, numbers and text be formatted? Who is allowed to export what? What happens when the result is too large to build in memory? What should the file be called, and should the same request produce the same file twice? The request is one sentence, but the implementation is a set of decisions. People often describe a requirement as *clear*, *testable* or *well-specified*. These labels are adjectives, and they do not find a problem. A requirement passes the test when a concrete question about it can be answered, and not only discussed.

## 1.3 What the conversation loses

The conversation is better than the prompt, but it is still a conversation. Its value is in the chat, and it is usually lost when the chat ends. You may have produced an excellent plan, but the plan is hard to find again later, and the conversation is not a project artifact. The next person sees the code, not the reasoning that produced it.

A later reader needs information that only the conversation held:

- why the change was made;
- which alternatives were rejected, and why;
- what was in scope and what was left out on purpose;
- which constraints and project rules applied;
- what must not break;
- how the result was validated.

The same developer a week later is also a later reader. Memory is not a reliable interface.

Without a stable description, the system drifts. Drift is the slow growth of a difference between what the system is supposed to do and what its code, tests and documents now say. Each change is made from a local understanding of the system, and these local understandings add up. A specification can serve as the reference that shows drift so that it can be corrected. This works only if the specification itself is reviewed and maintained. An outdated reference makes drift harder to see, not easier.

Review becomes weaker under the same pressure. A reviewer sees a diff: lines added, lines removed, tests changed. The reviewer does not see the intent behind the change. Without a lasting statement of purpose, the reviewer reconstructs it from the code, the commit message or memory. Exclusions made on purpose are especially hard to see: the reviewer cannot tell whether something was left out on purpose or forgotten. The review then checks the implementation instead of the change. Only a record of the exclusion makes the difference visible. A scope boundary stated in a conversation is lost when the conversation ends. A scope boundary written into an artifact can be seen, questioned, and maintained.

Direct generation answers a narrow question: can we do this? It does not answer what should work or why it should work that way. It does not answer how the work should be approached or which constraints apply. It does not answer what behaviour is acceptable and how that behaviour will be verified. Those answers are not a better prompt. They are a lasting record of intent that can be reviewed. Different technologies and practices can supply that record. The next paragraphs examine attempts to improve generation, and then ask what such a record must do.

## 1.4 Why better context is not enough

Several techniques can improve the context available to direct generation:

- retrieval over design decisions, specifications, code and past changes;
- tool servers or protocols, such as MCP, that expose repositories, issue trackers, CI and monitoring;
- persistent project instruction files, such as `AGENTS.md`, that are read at the start of a session;
- repository search and dependency context;
- automated tests, linters and type checks whose results are fed back into the loop.

Each technique gives the model more to work with. None of them, alone, decides what the work should be.

These techniques are worth using, but alone they do not solve the main problem. People most often assume that the instruction file is valuable. It tells an agent what the project expects. But where such files have been compared with having none, the work has not become better: what changed was how the agent worked, not what it produced. A context file passes on what a team already knows. It does not raise quality. Retrieval sees only what someone stored, and only in the form in which they stored it. Tool access gives the current state, not lasting intent. Session context is a selection, not the whole history. The conversation, the assumptions and the rejected alternatives are still lost when the session closes, unless someone writes them down. Files can keep what the session loses, and written records are the basis of the way of working that follows. But a collection of files built by hand will not match a framework that defines the artifacts, their relationships and their checks.

A specification can serve as that written reference. Tools, agents and people can work from it, and it can be reviewed and corrected. It is not an authority that is always right. A wrong specification is a defect to fix, not a truth to obey. So the question is not whether a document exists. The question is whether it keeps the intent that the work needs, and whether the team keeps it correct.

## 1.5 What the work needs

These failures suggest a set of needs, not a feature list. The first group is about keeping intent and context. A lasting record should keep the intent of a change: why it is needed, what it should achieve, and what is excluded. It should make key information available later without the old transcript. It should capture the general rules that apply to change, such as architecture, standards, testing, security, accessibility and error handling. It should describe the complete application, not only the part being changed. And it should keep current behaviour separate from the proposed change.

The second group is about how the work is reviewed, traced, delivered and validated. The record should be reviewable as an artifact, not only as a conversation. It should support traceability from a requirement to design decisions, tasks, tests and implementation. It should allow incremental delivery, so that work can be split into changes that can be reviewed. It should support validation, not only generation: acceptance criteria and tests need a basis for checking the result. The tests alone are not that basis. A test can pass and still measure nothing that was asked for, because no test states which claim it is meant to decide. Only a requirement written down beforehand gives a test something to be measured against. Only such a requirement says what passing is supposed to mean. And the record should stay lightweight and in proportion to the change, because people abandon a record that costs more than the change it describes.

## 1.6 From needs to spec-driven development

One family of practices responds to those needs. It makes intent explicit and treats the specification as an active artifact. In spec-driven development (SDD), requirements, constraints, acceptance criteria and validation are made explicit before and during implementation. The specification guides planning, implementation, testing and validation. It is a living reference, not a project history, and it is expected to change when the work teaches something new.

OpenSpec is one concrete implementation. It organizes work as a change proposal, capability specifications, a design and a task list. Its `specs/` directory holds the current behaviour of the system. Its `changes/` directory holds proposed modifications and the artifacts that describe them. Those are conventions, not requirements of spec-driven development. Another implementation could use different names and a different file layout and still do the same work.

The needs are the test, not the tool. Another spec-driven tool or a team's own practice may use different names, different artifacts and a different way of working. The question to ask is whether it does these things: keeps intent, makes information available, captures general rules, describes the system, and keeps current behaviour separate from proposed change. It must also support review, traceability, incremental delivery and validation, and stay in proportion to the change. In this argument, OpenSpec can be replaced. If a practice meets the needs, the names matter less than the record.

## 1.7 What SDD costs

The cost of a record cannot be calculated exactly, but its form is clear, and the cost comes before anything is paid back. Planning takes time and tokens. The attention it needs competes with the attention that the rest of the work needs. The record is work of its own: it has to be read, reviewed and kept current. Every hour spent on it is an hour not spent on something else.

Most of the cost is not the writing. It is the deciding. The questions that a record has to answer are the questions that the work would otherwise have left to whoever implemented it, and answering them takes judgment. A page of prose is cheap. The expensive part is the hour spent deciding what the page should say, and that hour is spent whether or not anyone ever writes the page.

What a record saves is rework that did not happen, so the saving is hard to see. A change that goes well leaves no trace of the version that would have gone wrong. So the benefit never appears as a line that anyone can point at. The cost does appear: it is in the session, in the review and in the record.

The cost is not small. In comparisons where the two approaches were run side by side on the same tasks, one approach wrote a specification, a plan and a task list before implementing. It spent many times the tokens and the elapsed time of a single free-form request. Its gain in passing tests was real, and far smaller than that multiple. A benchmark is not a team, so the comparison does not set the exact price. It sets the order of magnitude. This is a purchase with a visible cost, not a small extra step.

A record comes in sizes, and the size sets the price. It can be a paragraph in a change description, a specification kept beside the code, or the artifact from which the code is generated. Each size needs more discipline than the one before, and has to stay correct for longer. So choosing a size means choosing what the work costs.

The person who pays for a record is usually not the person who gains from it. The effort falls on whoever writes it. The saving falls on whoever reads it later, and that reader never sees the hour it cost. For this reason, a practice can be worth keeping for one person and still meet resistance from the team around that person. A team that wants the saving has to say what deserves a record. If each person decides alone, the answers differ, and the record becomes a different thing in every change.

## 1.8 What SDD gives back

In return, three things are no longer lost. Rework is avoided: the decisions that implementation would have forced were made before it. Review gets something to review: the reviewer sees the intent and the exclusions, not only the diff. And the next change gets a starting point, because it begins from a written reference instead of from someone's memory of the last conversation.

The size of that return cannot be measured from the outside, and it should be read as an estimate. Part of it comes from the record. Part comes from the models being better at the same task than they were before. Part comes from stating the goal before delegating the work, which a careful conversation would also produce. What remains is a judgement: the record is worth its cost to the people who keep it, and the size of the return is not established.

That judgement is not a measurement, and the measurements that exist are discouraging. Specifications have been compared with no specifications across tens of thousands of changes. There, the difference in defects and in rework has been hard to find at all. The association that does appear is explained by the difficulty of the work that gets specified. Such a comparison sees specification documents as they are stored in repositories — a ticket reference, a page beside the code. It does not see the practice of writing one, and that practice is what this chapter argues for. So the comparison does not show that a record fails to help. It shows that the help has not been visible where people expected it to be easiest to see. That is an argument for choosing where to write a record, not for abandoning the practice.

## 1.9 When SDD is worth its cost

SDD is strong where intent, constraints and verification matter. Feature development, behavioural changes, integrations, refactors with risk, and security-sensitive work all benefit from a record. The record says what should happen and how it will be checked. Collaboration among humans and agents also benefits, because the record is the shared reference that both can work from. These are defaults, not a universal rule.

SDD is less useful when the specification costs more than the change is worth. A quick experiment, a one-off script, an exploratory spike, a trivial fix, or an early prototype may need only a conversation. The purpose of such a prototype is to learn what to build. Writing a full record for such work can slow the learning that the work exists to produce. The list is not complete, and simple work is not a defect.

None of this removes engineering judgment. A specification can be wrong, incomplete, too rigid or too abstract. The team still has to review the requirements, question the design, write meaningful tests, inspect the code and maintain the specification. SDD reduces guessing, but it does not move responsibility to a document or a tool. The human is still responsible for the artifacts being right.

SDD does not replace direct AI coding or conversational exploration. The chapter has described three ways of working: direct generation, explain mode — the conversation before code — and spec-driven development. Each has legitimate uses, and the situation should decide the choice, not an ideology. The table below gives a better default for several situations. Three questions produce it. How long does the result have to live? How many people or agents will work on it? What would a wrong guess cost? The three ways of working differ in whether a record is used. These questions decide how large that record should be. "Better default" does not mean the only option.

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

These three ways of working are not levels that you leave behind as you advance. They suit work that must last for different lengths of time. Direct generation is fastest when the result can be tried at once. Explain mode is better when the request has to be understood before code exists. Spec-driven development is worth its cost when intent has to survive the session, be reviewed by someone else, or be traced from a requirement to a test.

The three ways differ in how they treat the information that the model does not have. Direct generation leaves the model to guess. Explain mode resolves some of the gaps before code exists, but its answers stay in the conversation. A lasting record keeps those answers where a later session, reviewer or agent can find them, so the next change does not start from a partial memory. Understanding starts in the conversation, but it does not stay there. A specification, a change record and the tests that decide them are one way to keep that reference correct. So the rule is not "always specify" but "preserve enough context for the work". Use the lightest process that keeps the model from guessing about what matters, and that keeps the context needed to build, review and maintain the result.
