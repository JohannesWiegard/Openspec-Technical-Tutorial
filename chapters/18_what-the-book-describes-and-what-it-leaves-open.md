# 18. What the Book Describes, and What It Leaves Open

The book has followed one tool from its conventions to the commands that no workflow calls. This last chapter says what kind of book that makes it and what it found. It also names the questions it leaves for the reader to continue. It adds nothing about the tool that an earlier chapter did not establish. It answers none of the questions it names.

## 18.1 What kind of book this is

The first two chapters are about the method, not the tool. Chapter 1 argued that work done with a model needs a record that outlives the conversation. It also argued that the record has a cost, and that the record must be worth that cost. Chapter 2 named the cornerstones that such a record must satisfy. OpenSpec appeared there as one implementation, and section 1.6 said that it is replaceable in the argument.

From chapter 3 on, the book is a technical description of one tool in one release, OpenSpec 2.2.0. It describes what the tool writes, what it reads, what it checks and what it leaves to the developer. It describes these in the order in which a change meets them.

| Chapters | What they describe |
|---|---|
| 3 | How OpenSpec's conventions carry the cornerstones, and where they stop. |
| 4 to 8 | One change from request to archive, and each of its four artifacts: the proposal, the specification, the design and the tasks. |
| 9 to 12 | Seven of the twelve workflows, and the `validate` command, ordered by who does the work in each. |
| 13 and 14 | Customizing the harness, and one customized change from fork to archive. |
| 15 to 17 | The five workflows outside the table, the two comparisons that no check makes, and the commands that no workflow calls. |

It is not a manual of every option the tool has. It is not a guide to practice either. It says how the tool behaves when a developer uses it. It does not say how a team should organise its work around the tool.

## 18.2 The one finding

Chapter after chapter reached the same result. `validate` checks the form of a delta and of the main specifications. It does not check whether the behaviour is the right one. The program counts the tasks and does not read them, so a ticked box is a claim. No check opens the proposal or the design. The program sees the planning workflows only as files that exist. The program confirms that a customization is well formed, but it does not confirm its effect. No check compares two changes with each other, or a scenario with the code. The commands that no workflow calls read, check, connect and maintain. None of them judges a change.

That is one finding, seen from every side: the program checks form and counts, and the developer judges content. Chapter 9 described it as a division of work. In that division, the agent writes, the program reports and checks, and the developer decides and reviews. Chapter 3 gave the reason for it. Human control is the one cornerstone that the conventions cannot carry, because a tool can hold a decision but cannot make one. Everything the book said about reviewing an artifact, a workflow or a command applies that division to one part of the tool.

## 18.3 What the book leaves open

The questions below follow from what the book showed. Each names the chapter whose finding it extends. None is answered here, because the book has no evidence to answer it with.

### Large projects

- **Where does a capability end?** The example has one capability, and section 5.5 showed how a proposal names the capability it changes. A system with dozens of capabilities needs a rule for dividing behaviour into capabilities. The book has no such rule to offer.
- **Who reads two changes against each other?** Chapter 16 showed that no check compares two changes that are open at the same time. It also showed that the comparison is a reading of the main specification after the second archive. With one writer, that reading is a habit. With many active changes, it is a duty that someone has to own, at a time that the process has to fix. The book does not say who, or when.
- **How is a specification shared?** Section 17.4 described stores. A store is a repository of specifications that several code repositories can use. It is registered on each machine, OpenSpec never synchronises it, and it is marked as beta. The section described the commands, not a practice. The book does not show how a store is kept current or who may change it. It also does not show how a change to a store is coordinated with the code that the store describes.
- **Who owns the record?** Chapter 5 said that an agent drafts a proposal and a person owns it. Sections 1.7 and 2.7 said that a team must decide what is worth a record. The book has one owner throughout. It does not show how a team settles either question.
- **How does a change meet a branch and a review?** The book never relates a change folder to a branch, a pull request or a code review. The only exception is the remark in section 3.4 that an abandoned change leaves no half-finished branch behind. The book does not describe whether a change is in one branch. It also does not describe who approves its artifacts, or in which order they are reviewed against the code.
- **What does automation check?** Chapter 11 showed what `validate` checks. Section 17.3 showed that `doctor` exits with status 0 on a warning. The book does not describe whether either should stop a merge. It also does not describe what a pipeline would need to read to stop it.

### Introducing and keeping it

- **How does a system without specifications get them?** Section 15.6 showed onboard doing one change on a real task in an existing project. The book does not show how to write the main specifications of a system that has none, from code that already runs.
- **How does a project move between releases?** The book moved from 2.0.0 to 2.1.1, and then to 2.2.0. At each move it repeated its runs. It noted the differences where they mattered, in sections 3.1, 9.2, 9.3 and 15.1. It does not show how a project with many changes moves its artifacts and its skills through a release.
- **How fast does a specification drift?** Section 2.6 said that a specification must be maintained. Section 3.7 said that nothing checks afterwards whether the specification and the code still agree. The book observed no project for long enough to see drift happen.
- **What does it cost, and what does it return?** Sections 1.7 and 1.8 described the shape of the cost. They said that the size of the return is not established. The book measured neither.

### Comparisons

- **Would another spec-driven tool behave differently?** Section 1.6 said that another tool may use different names, different artifacts and a different way of working. Chapter 3 said that a different tool could arrange the same material and still serve the same principles. The book describes how OpenSpec divides the work between the agent, the program and the developer. It does not show how another tool divides it.
- **Would another spec-driven tool check more?** Section 1.6 said that OpenSpec is replaceable in the argument, and the book compares it with nothing. The finding of section 18.2 is a finding about OpenSpec 2.2.0. Whether another tool closes any part of that gap is open.

None of these questions is a defect found in the tool. Where OpenSpec has a mechanism for one of them, the book has described the mechanism. An example is stores for shared specifications. What the book has not done is use the mechanism where many people, many changes and many months meet. That is where these questions are decided.

The book has shown what OpenSpec writes, what it checks and what it leaves to the developer, for one release. The answer was the same in every chapter: the program checks form and counts, and the developer judges the content. The book does not say what happens where many people, many changes and many months meet. Instead, it passes to the reader the questions that follow from its finding: who reads, who owns, what is shared, and what is checked. The tool will not answer them, because each depends on a reading of content. That reading is the part of the work that stays with the developer.
