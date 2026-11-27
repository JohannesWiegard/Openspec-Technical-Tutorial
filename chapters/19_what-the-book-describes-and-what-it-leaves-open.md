# 19. What the Book Describes, and What It Leaves Open

The book has followed one tool from its conventions to the commands that no workflow calls, and to a customization that goes beyond what it documents. This last chapter says what kind of book that makes it, what it found, and which questions it leaves for the reader to take further. It adds nothing about the tool that an earlier chapter did not establish.

## 19.1 What kind of book this is

The first two chapters are about the method, not the tool. Chapter 1 argued that work done with a model needs a record that outlives the conversation, and that the record has a cost that has to be earned. Chapter 2 named the cornerstones such a record must satisfy. OpenSpec appeared there as one implementation, and section 1.6 said that it is replaceable in the argument.

From chapter 3 on, the book is a technical description of one tool, OpenSpec, as one release of it behaves. It describes what the tool writes, what it reads, what it checks and what it leaves to the developer, and it describes it in the order a change meets it.

| Chapters | What they describe |
|---|---|
| 3 | How OpenSpec's conventions carry the cornerstones, and where they stop. |
| 4 to 8 | One change from request to archive, and each of its four artifacts: the proposal, the specification, the design and the tasks. |
| 9 to 12 | Seven of the twelve workflows, and the `validate` command, by who does the work in each. |
| 13 and 14 | Customizing the harness, and one customized change from fork to archive. |
| 15 to 17 | The five workflows outside the table, the two comparisons no check makes, and the commands no workflow calls. |
| 18 | A customization that no documented means carries, and on what it rests through an update. |

It is not a manual of every option the tool has. Nor is it a guide to practice. It says how the tool behaves when a developer uses it, and not how a team should organize its work around it.

## 19.2 The one finding

Chapter after chapter reached the same place. `validate` checks the form of a delta and the main specifications, and not whether the behaviour is the right one. The tasks are counted and not read, so a ticked box is a claim. No check opens the proposal or the design. The planning workflows are visible to the program only as files that exist. A customization is confirmed as well formed, and its effect is not. No check compares two changes with each other or a scenario with the code. The commands that no workflow calls read, check, connect and maintain, and none of them judges a change.

That is one finding, seen from every side: the program checks form and counts, and the developer judges content. Chapter 9 gave it the shape of a division of work, in which the agent writes, the program reports and checks, and the developer decides and reviews. Chapter 3 gave it its reason: human control is the one cornerstone the conventions cannot carry, because a tool can hold a decision and cannot make one. Everything the book said about reviewing an artifact, a workflow or a command is an application of that division to one part of the tool.

## 19.3 What the book leaves open

The questions below follow from what the book showed. Each names the chapter whose finding it extends, and none is answered here, because the book has no evidence to answer it with.

### Large projects

- **Where does a capability end?** The example has one capability, and section 5.5 showed how a proposal names the capability it changes. A system with dozens of them needs a rule for cutting behaviour into capabilities. The book has none to offer.
- **Who reads two changes against each other?** Chapter 16 showed that no check compares two changes that are open at the same time, and that the comparison is a reading of the main specification after the second archive. With one writer that reading is a habit. With many changes in flight it is a duty that someone has to own, at a time the process has to fix. The book does not say who, or when.
- **How is a specification shared?** Section 17.4 described stores: a repository of specifications that several code repositories can use, registered on each machine, never synchronized by OpenSpec, and marked as beta. It described the commands, not a practice. How a store is kept current, who may change it, and how a change to it is coordinated with the code it describes are not shown.
- **Who owns the record?** Chapter 5 said that a proposal is drafted by an agent and owned by a person. Sections 1.7 and 2.7 said that a team must settle what earns a record. The book has one owner throughout, and it does not show how a team settles either question.
- **How does a change meet a branch and a review?** The book never relates a change folder to a branch, a pull request or a code review, beyond the remark in section 3.4 that an abandoned change leaves no half-finished branch behind. Whether a change lives in one branch, who approves its artifacts and in which order they are reviewed against the code are not described.
- **What does automation check?** Chapter 11 showed what `validate` checks, and section 17.3 that `doctor` exits with status 0 on a warning. Whether either should stop a merge, and what a pipeline would need to read to stop it, are not described.

### Introducing and keeping it

- **How does a system without specifications get them?** Section 15.6 showed onboard doing one change on a real task in an existing project. Writing the main specifications of a system that has none, from code that already runs, is not shown.
- **How does a project move between releases?** While it was written, the book moved twice to a newer release. At each move it repeated its runs and noted the differences where they mattered, in sections 3.1, 9.2, 9.3 and 15.1. It does not show how a project with many changes carries its artifacts and its skills through a release.
- **How fast does a specification drift?** Section 2.6 said that a specification must be maintained, and section 3.7 that nothing checks afterwards whether the specification and the code still agree. The book observed no project for long enough to see drift happen.
- **What does it cost, and what does it return?** Sections 1.7 and 1.8 described the shape of the cost and said that the size of the return is not established. The book measured neither.

### Comparisons

- **Would another spec-driven tool behave differently?** Section 1.6 said that another tool may use different names, different artifacts and a different workflow, and chapter 3 that a different tool could arrange the same material and still serve the same principles. The book describes how OpenSpec divides the work between the agent, the program and the developer, and it does not show how another tool divides it.
- **Would another spec-driven tool check more?** The book compares OpenSpec with nothing. The finding of section 19.2 is a finding about the release the book describes, and whether another tool closes any part of it is open.

None of these questions is a defect found in the tool. Where OpenSpec has a mechanism for one of them, as it has stores for shared specifications, the book has described the mechanism. What it has not done is use the mechanism where many people, many changes and many months meet, and that is where these questions are decided.

The book has shown, for one release, what OpenSpec writes, what it checks and what it leaves to the developer, and the answer was the same in every chapter: the program checks form and counts, and the content is the developer's to judge. At that scale the book does not say what happens, and it hands the reader the questions that follow from its finding instead: who reads, who owns, what is shared, and what is checked. The tool will not answer them, because each turns on a reading of content, and that reading is the part of the work that stays with the developer.
