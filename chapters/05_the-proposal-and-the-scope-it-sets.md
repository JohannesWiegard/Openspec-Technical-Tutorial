# 5. The Proposal and the Scope It Sets

Chapter 4 followed one requirement through two changes, and in both of them the proposal came first. It showed what a proposal contains and quoted two of them in full. This chapter stays with that first artifact and asks the questions the overview could not: who actually writes the file, which of its parts a reader has to get right, how a reviewer decides that it is finished, and what happens when the review finds something wrong. The example is the same vending machine and the same two changes. Nothing new is decided about the machine here.

The table shows the files of a change and the paths of its specifications. The rows this chapter discusses are in bold.

| Item | File | What it says | Discussed in |
|---|---|---|---|
| Change | `openspec/changes/<change>/` | The folder of one change. | Chapter 4 |
| **Proposal** | **`proposal.md`** | **Why the change exists and what it changes.** | **Chapters 4 and 5** |
| Capability | `specs/<capability>/` | The folder for one area of behaviour, such as `purchase`. | Chapters 4 and 6 |
| Specification | `specs/<capability>/spec.md` | What one change adds, modifies or removes. | Chapters 4 and 6 |
| Main specification | `openspec/specs/<capability>/spec.md` | The system as it stands. | Chapters 4 and 6 |
| Design | `design.md` | How the work is done. | Chapters 4 and 7 |
| Tasks | `tasks.md` | The checks that turn the design into work. | Chapters 4 and 8 |
| Schema marker | `.openspec.yaml` | The schema the change follows, and `skip_specs` when it has no deltas. | Chapter 4 |

## 5.1 Who writes the proposal

A coding agent drafts the first version of the file. In an OpenSpec project the agent reads the change's schema — the template for the artifact and the instruction attached to it — together with the specifications the repository already has and the request as the developer phrased it, and it drafts `proposal.md`. The developer does not begin from a blank file. What the agent supplies is form and the state of the repository: the parts the project's schema asks for, and which capabilities already exist. What it cannot supply is intent. Whether the problem is the right problem, whether the change is the smallest one that answers it, and whether two requests are really one change are decisions about the work, and the agent has nothing to decide them from.

So the developer's part is not to proofread generated text. It is to say what the change is for, to refuse the version that has restated a solution, and to accept responsibility for the scope the file sets. Chapter 2 called human control the cornerstone that no convention carries, and chapter 3 described the division of work as a model that writes, a program that verifies and a person who approves. The proposal is the earliest artifact at which that division becomes visible, because nothing written after it can be checked until the problem is settled. A draft that reads well is therefore the weakest signal available: the agent produces text that satisfies the schema and the sentences of the request, which is exactly what it was asked to produce, and that is not the same thing as a proposal that is right.

## 5.2 The parts of a proposal

Both example proposals answer four questions, and the default template asks for exactly those four parts.

| Part | What the tool checks | The question it answers |
|---|---|---|
| Why | Nothing at validation. At `archive`, a warning if it is under 50 or over 1,000 characters. | Why is this change needed, and why now? |
| What Changes | Nothing at validation. At `archive`, a warning if it is empty. | What will the system do, or say about itself, that it does not today? |
| Capabilities | Nothing. | Which specification does the change create or modify? |
| Impact | Nothing. | What else is expected to be touched? |

`openspec validate` reads the delta specifications, and opens the main ones only to check the capabilities a delta modifies or removes. It never opens `proposal.md`. `openspec archive` opens the file and prints the two warnings the table names, calling them non-blocking, and archives the change anyway. Two of the four parts are therefore checked by no program, and the other two by a warning a developer can ignore. Everything else in the proposal is judged by the person reviewing it, which is the reason section 5.8 exists.

The four parts are the whole of the template, and it is worth saying so plainly, because proposals are not always written from it. An exclusion goes into the design instead, and section 5.7 says where. A project that wants a part the template does not have adds it to the schema it forked, which chapter 3 described as a folder of files rather than a fixed format. The names in the table are the template's names, and a forked schema may rename them. What a part has to do is answer a question a reviewer needs answered, and the file is only finished when each question has an answer that can be checked. The rest of the chapter quotes each of the four parts from both example proposals where it discusses them, so the artifact can be followed here without turning back to chapter 4.

## 5.3 A problem, not a solution

The first proposal argues from a situation. The file is `proposal.md` in the change `give-exact-change`, and its Why reads as archived:

```markdown
## Why

A customer who pays more than the price of a product expects the difference back.
The machine holds coins, so it has to decide which coins make up the difference.
```

Two sentences, both about a customer and a machine. Neither names a denomination, an order of steps, a method for choosing coins, or anything about a stock that is too short for the difference owed. Each of those is decided later, in the specification and in the design, and section 4.2 shows the file in one piece.

A Why that names the method has already made the design's decision. Suppose the first proposal had said that the machine should work out the change by taking the largest coin that fits and repeating until nothing is owed. The problem would no longer be that a customer is owed money. It would be that the machine should use a particular method, and a reviewer who doubted the method would be arguing about the solution instead of about whether the machine should give change at all. The first Why leaves that argument open. The difference could be paid in any combination of coins from stock, returned before or after the product is released, chosen to keep the stock balanced or to use as few coins as possible. The design decided among those options, and section 4.4 shows which decision it made and why. Because the Why had not chosen first, the design had something to decide and the reviewer had something to challenge.

## 5.4 A reason can be evidence

The second proposal argues from a different place. Its Why does not begin with a customer; it begins with a finding. The file is `proposal.md` in the change `refuse-without-exact-change`, and its Why reads as archived:

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
```

The claims the second Why makes about the first version can be checked against a walkthrough that is in the archive. Section 4.7 shows the trace that makes the second symptom visible, and section 4.9 shows the file in one piece.

Both reasons are legitimate, and they are doing different jobs. A proposal written before anything has been built has no findings to cite; it can only argue from the use the change is meant to serve, which is what the first one does. A proposal written after a failed attempt can cite what the attempt showed, and it is stronger for it, but only because the evidence exists. Evidence is therefore not a mark of a better proposal. And a proposal that claims evidence without saying where it can be read is a wish written in the past tense. The useful question is not whether a Why cites something, but whether a reader can check the reason it gives.

## 5.5 What changes, and which capability

What Changes describes the difference the change makes to the system, not the work that produces it. The file is `proposal.md` in the change `give-exact-change`, and its What Changes and Capabilities read as archived:

```markdown
## What Changes

- Add a capability `purchase` with two requirements: the coins the machine holds,
  and the change it returns for a purchase.

## Capabilities

### New Capabilities

- `purchase`: the coins the machine holds, and the change it returns for a purchase.
```

One bullet, and a capability that says the same thing again, which is the split the template asks for: What Changes says what is added, and Capabilities says where it will be written down. Neither says that a delta will be written, then a design, then a task list. That order is the schema's, and chapter 3 is where it belongs. A What Changes that lists the artifacts, or the files to be edited, has recorded a plan.

The test is short: after reading the part, can a reader say what the system will do that it does not do now? If the answer describes activity rather than behaviour, the part has been written for the wrong artifact. The template puts two conditions on What Changes that neither example needs: a removal is stated as a removal, and a change that breaks existing behaviour is marked **BREAKING**, which is the schema instruction's own marker. Neither proposal removes anything, so neither has to say so.

Naming the capability is the part that binds the change to a file. The second proposal changes the same capability, so it names it under a different heading. The file is `proposal.md` in the change `refuse-without-exact-change`, and its What Changes and Capabilities read as archived:

```markdown
## What Changes

- The requirement "The machine gives change in coins from its stock" requires exact
  change. If the exact change cannot be made, the purchase is refused and the amount
  inserted is returned. No product is released.
- A scenario is added for a stock that cannot make the change.
- The design works out the change before the product is released.

## Capabilities

### Modified Capabilities

- `purchase`: the requirement "The machine gives change in coins from its stock" changes to require exact change.
```

The second proposal's What Changes is less clean than the first, and it is worth reading closely. The first bullet carries the change: the requirement now demands exact change and says what happens when it cannot be made. The second names a scenario, which is the specification's artifact rather than behaviour. The third states the order in which the design works, and chapter 4's section 4.4 gives that order to the design. Both of them read as a plan, and the part survives because the first bullet is doing the work: a reader can still answer what the system will do.

A capability is an area of behaviour, and its specification lives at that name. The template asks for a path, so a capability can sit inside an area rather than directly under the root, and every segment the change introduces is written in kebab-case.

The name is a boundary decision with a cost on both sides. One capability too coarse puts unrelated requirements into a single file, so every later change to either of them modifies the same document and a reader cannot tell which requirements belong together. One capability too fine fragments a behaviour across files, so a change that touches one behaviour has to open three. There is a case for putting the coins and the change in one capability, since neither is meaningful alone: a stock of coins exists in order to make change, and change is made from a stock. Impact is where the consequence is stated, because the capability's name is the path of the file the change will write.

## 5.6 Impact is a forecast

Impact is a forecast of what the change will touch, and it is the part easiest to write as an inventory. The file is `proposal.md` in the change `give-exact-change`, and its Impact reads as archived:

```markdown
## Impact

- `openspec/specs/purchase/spec.md` — created when this change is archived.
```

The second proposal names the same file and one thing that changes about it. The file is `proposal.md` in the change `refuse-without-exact-change`, and its Impact reads as archived:

```markdown
## Impact

- `openspec/specs/purchase/spec.md` — the change requirement is modified when this
  change is archived.
```

One line each, naming one file and saying whether it will appear or change. Neither lists the change's own design or task list, because every change has those and naming them says nothing about this one.

What the part is for is the reader who wants the size of the change before reading the delta: which capability is affected, whether an existing description changes or a new one appears, and whether anything else moves — code, an interface, a dependency or a system outside the repository. That reader is better served by an honest guess than by a complete-looking list, because the design does not exist yet and the files it will touch cannot be known. An Impact that is wrong costs a sentence to correct. An Impact that is missing hides the cost of the change until it has been paid.

## 5.7 What the template does not carry

The template has no part for what the change will not do. Exclusions are worth writing down, because they stop the scope growing and tell a reviewer which absences are decisions rather than oversights, but the default schema records them somewhere else: the design has a Goals / Non-Goals part, and it sits beside the decisions those goals and non-goals constrain. That is the design's artifact, not the proposal's, and chapter 7 takes it up there. An unknown that can wait does not belong here either: the schema's instruction gives the design an Open Questions part for those, and the proposal has none. A question that cannot wait is settled before the proposal is written, or it stays a conversation until it can be.

## 5.8 Reviewing a proposal

Reviewing a proposal is a single reading of one file, done at the only moment when it is still cheap: after the draft exists and before anything is generated from it. The reading has three passes:

1. Intent: does the draft answer the request as the developer meant it, or an assumption the agent made while drafting?
2. Size: is it one change? The split is far easier here than after the specification exists.
3. Claims: is each capability the file names as Modified a file that already exists under `openspec/specs/`, and is each one it names as new absent from there?

The first two passes come first, because nothing written after the proposal can find what they find. A draft that answers the wrong problem is answered faithfully by every later artifact, and a draft that holds two changes produces a specification that serves neither of them.

Waiting until the delta and the design exist does not make this reading unnecessary. It makes it a reading of three files that were written from one wrong premise, which is the most expensive reading there is.

Each part fails in ways a drafting agent produces readily, and the table below puts those failures beside the check that catches them. It is ordered the way the file is read: the request as a whole first, then each part in the template's order, then what follows the proposal.

| Check | The proposal passes when | How a draft can fail |
|---|---|---|
| The request is answered as meant | A reviewer can say which request the draft answers, and nothing in it answers an assumption the agent made instead | The draft serves a request nobody made, because the agent took a solution named in the request as the problem, and every part after the Why follows it |
| The change is one change | A reviewer can name the single problem it answers, and no part of the request would survive on its own | Two unrelated requests sit in one folder, and the delta modifies two capabilities for no reason they share |
| Why: the problem is stated without its solution | The Why names a situation or a finding, and no method, data structure or requirement wording has been carried into it | The Why names a method, a data structure, a library or a requirement's wording, or it describes the change rather than the problem and reads as a summary of What Changes |
| Why: the reason can be checked | The claims in the Why can be confirmed from the request, an artifact or the running system | The Why cites evidence a reader cannot follow to a file, or names a failure without saying where it was found |
| What Changes: behaviour, not a plan | The part says what the system will do or say that it does not today, and lists no artifact, file or step | The part lists artifacts to write, files to edit or steps to take, and three effects on three capabilities read like one change |
| What Changes: removals and breaking changes are visible | Anything the change takes away, or breaks for an existing user of the system, is stated as such, and a breaking change is marked **BREAKING** | A removal is written as an addition, or a breaking change is not marked, so the reader does not see what the change takes away |
| Capabilities: the boundary is deliberate | Each name is either an area of behaviour already under `openspec/specs/`, or genuinely new, and the heading matches which one it is | The agent invents a capability name, or files a new one under Modified; validation does not read the part (section 5.2), and `archive` refuses a Modified entry for a capability that is not there |
| Impact: the forecast is honest | The expected blast radius is named, files that may be created are marked as such, and nothing is claimed that the design will have to contradict | The part is an inventory of files that do not exist yet, or it is empty |
| The scope stays open downstream | Any case the proposal deliberately leaves to the specification is visible to the next artifact rather than lost between them | The boundary is drawn where the specification or the design cannot honour it, and the disagreement is found after all three exist |

The table is a memory aid rather than a gate: no part of the tool reads it, so a row that passes records a person's judgment and not a machine's check. The last row is the only one that is not about the file on its own. A proposal is finished when its boundary can be honoured by what follows, not when its parts have been filled.

## 5.9 Changing a proposal after review

When the review finds something, two decisions follow: what has to change, and who changes it. The first depends on how much of the change exists:

| What exists | What the revision covers |
|---|---|
| Only the proposal | The part, and the parts coupled to it: Capabilities and Impact are written from What Changes, so a change to one can move the other two. A review that found two changes in one ends with two folders rather than with a longer sentence. The file should be right rather than faithful to its first draft, and version control already holds the history worth keeping. |
| The delta, the design or the tasks | Those artifacts too, because they were written from the part that changed. A proposal that says one thing while the delta says another is worse than either alone, and the disagreement will be found later by somebody who has to guess which of the two was meant. |
| An archived change | Nothing in the archive. The archive is the record of what was decided when it was decided, and editing it afterwards destroys the only account of how the current specification reached its form. A gap that appears later is argued in a new change whose Why cites the change that missed it. |

The example shows the bottom row and not the middle one. Its second change was written after the first was archived, from the failure that section 4.7 shows, and its artifacts were written together, so the archive holds no proposal that was revised while its delta, design or tasks existed. The bottom row is what `refuse-without-exact-change` does to `give-exact-change`: it argues the gap in a new change rather than revising the one that is closed.

The second decision is about the means, and there are two of them. The developer can open `proposal.md` and write the replacement, or the developer can ask the agent to revise the part. The choice turns on one question: is the corrected text already known? A developer who can say the sentence before opening the file should write it, because the file open in an editor costs a minute and leaves a diff that shows only what moved. A developer who knows only that something is wrong has to have the right text worked out, and working it out means reading `openspec/specs/`, the request or the artifacts already written. That is the agent's part of the work, and it is the division section 5.1 described. The two means differ in when they are right, in what they cost, and in how they go wrong:

| | The developer edits the file | The agent is asked to revise it |
|---|---|---|
| Right when | The replacement is already known, and the fault sits in one part | The correct text has to be worked out from the repository, or from a request the developer can describe but not yet phrase |
| What it costs | A minute with the file open, and a diff that shows one sentence | A request that has to be specific, a whole file to read back, and a diff that may show more than was asked for |
| How it goes wrong | The named part is fixed and the parts coupled to it are not, so the file contradicts itself further down | A request that names a symptom — asking for the Why to be clearer — returns a rewrite whose scope has moved, and the size of the diff hides it |
| What to check afterwards | The coupled parts listed in the earlier table | The whole file, including the parts that were not meant to move |

The first case is small. Suppose the first draft's What Changes had listed the specification among the things to write, as section 5.5 warns against. The review finds a task in a part that describes behaviour, and the replacement is a sentence the developer can write without help: that the machine holds coins, and that it returns the difference between what was inserted and the price. Nothing else needs to move. Capabilities already names `purchase`, Impact already names the file that will carry the requirement, and the Why never mentioned the specification at all. One sentence is wrong, its replacement is known, and the diff should show nothing but that sentence.

The second case is where the answer is not in the developer's head. Suppose the draft had filed the change under a new capability called `change-giving`, while `openspec/specs/purchase/spec.md` already holds the requirement that changes. The name in the file has to be the name the repository uses, and correcting it moves three places at once: the heading that says whether the capability is new or modified, the bullet beneath it, and the Impact line that names the file. A request for that revision works when it says three things:

1. which part to revise;
2. what is wrong with it, namely that `change-giving` is not a capability under `openspec/specs/`, and that the capability already there is `purchase`;
3. what must not move, which here is the Why and the What Changes, because the review has already passed them.

A request that leaves out the third part invites a rewrite of the file, and an agent has no reason to keep what it was not told to keep.

Both means end in the same reading, and the reading is what decides whether the proposal is approved. An edit is checked by its diff: the diff shows what moved, and anything outside the coupled parts is a mistake to revert. A revision made by asking is a rewrite rather than an edit, so the whole file is read as a new draft, and the parts nobody asked about are where a moved boundary hides. The passes from section 5.8 are what that reading consists of, and the file is ready again only when each of them holds for the text that is now in it.

## 5.10 What the proposal hands on

The proposal does not make every decision the change needs, and the sections above named the artifact that takes each one it leaves. The cases a requirement must satisfy go to the specification, which the next chapter takes: the proposal says what the system will do, and the specification says it as a requirement with scenarios that decide it case by case.

What the proposal keeps is the problem and the scope that answers it. Each of its four parts is checked against an artifact that comes later, and the proposal is the cheapest place to correct any of them.

The proposal leaves this chapter at the point where its promise becomes testable. Everything so far has been about the argument: why the change exists, what it changes, and whether the boundary it draws is honest. The next artifact is not an argument. It is a requirement the system must satisfy and a set of scenarios by which that requirement can be decided, and the case the example's first requirement left open is found at that step, when a scenario is written for a stock the first requirement did not mention.

A proposal is drafted by an agent and owned by a person, and that ownership is what the review exists for. The file asks four questions, and the tool checks almost none of the answers. The parts that are easy to get wrong are the ones that describe a solution, a plan or a complete inventory, because those are what a drafting agent produces most fluently. The review is one reading, written out as a checklist in the file's own order, and the two checks that come first are the ones nothing later can repair. When the review finds something, the question is how much of the change already exists, and then whether the replacement is known: an edit is cheaper when it is, and a request to the agent is the way when it is not. The proposal is the statement made first and revised most cheaply. What a reader should carry away is therefore not a template but a habit. Treat the proposal as the first place a boundary is stated, review it before anything is built from it, and expect the artifacts that follow to hold it to what it opened.
