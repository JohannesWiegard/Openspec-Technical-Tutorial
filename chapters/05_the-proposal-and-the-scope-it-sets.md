# 5. The Proposal and the Scope It Sets

Chapter 4 followed one requirement through two changes, and in both changes the proposal came first. That chapter showed what a proposal contains and quoted two proposals in full. This chapter stays with that first artifact. It asks the questions that the overview could not answer. Who actually writes the file? Which of its parts must a reader get right? How does a reviewer decide that it is finished? What happens when the review finds something wrong? The example is the same vending machine with the same two changes. This chapter decides nothing new about the machine.

The table shows the files of a change and the paths of its specifications. The rows this chapter discusses are in bold.

| Item | File | What it says | Discussed in |
|---|---|---|---|
| Change | `openspec/changes/<change>/` | The folder of one change. Archive moves it into the archive. | Chapter 4 |
| **Proposal** | **`proposal.md`** | **Why the change exists and what it changes.** | **Chapters 4 and 5** |
| Capability | `specs/<capability>/` | The folder for one area of behaviour, such as `purchase`. | Chapters 4 and 6 |
| Specification | `specs/<capability>/spec.md` | What one change adds, modifies or removes. | Chapters 4 and 6 |
| Main specification | `openspec/specs/<capability>/spec.md` | The system as it stands. Archive writes it. | Chapters 4 and 6 |
| Design | `design.md` | How the work is done. | Chapters 4 and 7 |
| Tasks | `tasks.md` | The checks that turn the design into work. | Chapters 4 and 8 |
| Schema marker | `.openspec.yaml` | The schema the change follows. It also holds `skip_specs` when the change has no deltas. | Chapter 4 |

## 5.1 Who writes the proposal

The agent drafts the first version of the file. In an OpenSpec project, the agent reads the change's schema: the template for the artifact and the instruction attached to it. It also reads the specifications that the repository already has, and the request as the developer phrased it. Then it drafts `proposal.md`. The developer does not begin from a blank file. The agent supplies the form and the state of the repository: the parts that the project's schema asks for, and which capabilities already exist. The agent cannot supply intent. Three questions are decisions about the work. Is the problem the right problem? Is the change the smallest one that answers it? Are two requests really one change? The agent has nothing to decide them from.

So the developer's part is not to proofread generated text. The developer says what the change is for. The developer refuses the version that has restated a solution. The developer also accepts responsibility for the scope that the file sets. Chapter 2 called human control the cornerstone that no convention carries. Chapter 3 described the division of work as a model that writes, a program that verifies and a person who approves. The proposal is the earliest artifact at which that division becomes visible. The reason is that nothing written after it can be checked until the problem is settled. A draft that reads well is therefore the weakest signal available. The agent produces text that satisfies the schema and the sentences of the request. That is exactly what it was asked to produce. It is not the same thing as a proposal that is right.

## 5.2 The parts of a proposal

Both example proposals answer four questions. The default template asks for exactly those four parts.

| Part | What the tool checks | The question it answers |
|---|---|---|
| Why | Nothing at validation. At `archive`, a warning if it is under 50 or over 1,000 characters. | Why is this change needed, and why now? |
| What Changes | Nothing at validation. At `archive`, a warning if it is empty. | What will the system do, or say about itself, that it does not do today? |
| Capabilities | Nothing. | Which specification does the change create or modify? |
| Impact | Nothing. | What else is expected to be touched? |

`openspec validate` reads the delta specifications. It opens the main ones only to check the capabilities that a delta modifies or removes. It never opens `proposal.md`. `openspec archive` opens the file and prints the two warnings that the table names. It calls them non-blocking, and it archives the change anyway. So no program checks two of the four parts. Only a warning that a developer can ignore checks the other two. The person who reviews the proposal judges everything else in it, and that is the reason section 5.8 exists.

The four parts are the whole of the template. This is worth saying plainly, because proposals are not always written from it. An exclusion goes into the design instead, and section 5.7 says where. A project that wants a part that the template does not have adds it to the schema it forked. Chapter 3 described such a schema as a folder of files rather than a fixed format. The names in the table are the template's names, and a forked schema may rename them. What a part has to do is to answer a question that a reviewer needs answered. The file is finished only when each question has an answer that can be checked. The rest of the chapter quotes each of the four parts from both example proposals where it discusses them. So the reader can follow the artifact here without turning back to chapter 4.

## 5.3 A problem, not a solution

The first proposal argues from a situation. The file is `proposal.md` in the change `give-exact-change`. Its Why reads as archived:

```markdown
## Why

A customer who pays more than the price of a product expects the difference back.
The machine holds coins, so it has to decide which coins make up the difference.
```

The Why has two sentences, and both are about a customer and a machine. Neither names a denomination, an order of steps or a method for choosing coins. Neither says anything about a stock that is too short for the difference owed. Each of those is decided later, in the specification and in the design. Section 5.5 and section 5.6 quote the next two parts of the same file, and section 4.2 shows the file in one piece.

A Why that names the method has already made the design's decision. Suppose the first proposal had said how the machine should work out the change: take the largest coin that fits, and repeat until nothing is owed. Then the problem would no longer be that a customer is owed money. The problem would be that the machine should use a particular method. A reviewer who doubted the method would then argue about the solution. That reviewer would not argue about whether the machine should give change at all. The first Why leaves that argument open. The difference could be paid in any combination of coins from stock. It could be returned before or after the product is released. The coins could be chosen to keep the stock balanced, or to use as few coins as possible. The design decided among those options, and section 4.4 shows which decision it made and why. The Why had not chosen first. So the design had something to decide, and the reviewer had something to challenge.

## 5.4 A reason can be evidence

The second proposal argues from a different place. Its Why does not begin with a customer. It begins with a finding. The file is `proposal.md` in the change `refuse-without-exact-change`. Its Why reads as archived:

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

The second Why makes claims about the first version. A reader can check them against a walkthrough that is in the archive. Section 4.7 shows the trace that makes the second symptom visible. Section 5.5 and section 5.6 quote the rest of the file, and section 4.9 shows it in one piece.

Both reasons are legitimate, and they do different jobs. A proposal written before anything has been built has no findings to cite. It can only argue from the use that the change is meant to serve, and the first proposal does this. A proposal written after a failed attempt can cite what the attempt showed. It is stronger for it, but only because the evidence exists. Evidence is not a mark of a better proposal, because a first change has none to offer. A proposal that claims evidence without saying where a reader can read it is only a wish written in the past tense. The useful question is not whether a Why cites something. It is whether a reader can check the reason it gives.

## 5.5 What changes, and which capability

What Changes describes the difference that the change makes to the system. It does not describe the work that produces it. The file is `proposal.md` in the change `give-exact-change`. Its What Changes and Capabilities read as archived:

```markdown
## What Changes

- Add a capability `purchase` with two requirements: the coins the machine holds,
  and the change it returns for a purchase.

## Capabilities

### New Capabilities

- `purchase`: the coins the machine holds, and the change it returns for a purchase.
```

What Changes has one bullet, and Capabilities says the same thing again. This is the split that the template asks for: What Changes says what is added, and Capabilities says where it will be written down. The bullet says that the change adds a capability called `purchase` with two requirements: the coins the machine holds, and the change it returns for a purchase. It does not say that a delta will be written, then a design, then a task list. That order is the schema's, and it belongs in chapter 3. A What Changes that lists the artifacts, or the files to be edited, has recorded a plan.

The test is short. After reading the part, can a reader say what the system will do that it does not do now? If the answer describes activity rather than behaviour, the part has been written for the wrong artifact. The template puts two conditions on What Changes that neither example needs. A removal is stated as a removal. A change that breaks existing behaviour is marked **BREAKING**, which is the schema instruction's own marker. Neither proposal removes anything, so neither has to say so.

Naming the capability is the part that links the change to a file. The second proposal changes the same capability, so it names it under a different heading. The file is `proposal.md` in the change `refuse-without-exact-change`. Its What Changes and Capabilities read as archived:

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

The second proposal's What Changes is less clean than the first, and it is worth reading closely. The first bullet carries the change. The requirement now demands exact change, and the bullet says what happens when exact change cannot be made. The second bullet names a scenario, and a scenario is the specification's artifact rather than behaviour. The third bullet states the order in which the design works, and chapter 4's section 4.4 gives that order to the design. Both of these bullets read as a plan. The part still works, because the first bullet does the work: a reader can still answer what the system will do.

A capability is an area of behaviour, and its specification is stored under that name. The first proposal creates `purchase`. The second modifies the same one, which is why its Capabilities part uses the Modified heading. Section 4.9 shows the file in one piece. The template asks for a path, so a capability can be inside an area rather than directly under the root. Every segment that the change introduces is written in kebab-case.

The name is a boundary decision, and it has a cost on both sides. A capability that is too coarse puts unrelated requirements into a single file. Then every later change to either of them modifies the same document, and a reader cannot tell which requirements belong together. A capability that is too fine splits a behaviour across files. Then a change that touches one behaviour has to open three. There is a case for putting the coins and the change in one capability, since neither is meaningful alone. A stock of coins exists in order to make change, and change is made from a stock. Impact is where the consequence is stated, because the capability's name is the path of the file that the change will write.

## 5.6 Impact is a forecast

Impact is a forecast of what the change will touch. It is also the part that is easiest to write as an inventory. The file is `proposal.md` in the change `give-exact-change`. Its Impact reads as archived:

```markdown
## Impact

- `openspec/specs/purchase/spec.md` — created when this change is archived.
```

The second proposal names the same file and one thing that changes about it. The file is `proposal.md` in the change `refuse-without-exact-change`. Its Impact reads as archived:

```markdown
## Impact

- `openspec/specs/purchase/spec.md` — the change requirement is modified when this
  change is archived.
```

Each Impact is one line. It names one file and says whether the file will appear or change. Neither lists the change's own design or task list. Every change has those, so naming them says nothing about this one.

The part is for the reader who wants the size of the change before reading the delta. That reader wants to know which capability is affected and whether an existing description changes or a new one appears. The reader also wants to know whether anything else moves: code, an interface, a dependency or a system outside the repository. An honest guess serves that reader better than a list that looks complete. The reason is that the design does not exist yet, so nobody can know the files it will touch. An Impact that is wrong costs a sentence to correct. An Impact that is missing hides the cost of the change until the cost has been paid.

## 5.7 What the template does not contain

The template has no part for what the change will not do. Exclusions are worth writing down. They stop the scope from growing, and they tell a reviewer which absences are decisions rather than oversights. But the default schema records them somewhere else. The design has a Goals / Non-Goals part, and that part is beside the decisions that those goals and non-goals constrain. That part is the design's artifact, not the proposal's, and chapter 7 discusses it there. An unknown that can wait does not belong here either. The schema's instruction gives the design an Open Questions part for those, and the proposal has none. A question that cannot wait is settled before the proposal is written. Otherwise it stays a conversation until it can be settled.

## 5.8 Reviewing a proposal

Reviewing a proposal is a single reading of one file. It is done at the only moment when the reading is still cheap: after the draft exists and before anything is generated from it. The reading has three passes:

1. Intent: does the draft answer the request as the developer meant it, or does it answer an assumption that the agent made while drafting?
2. Size: is it one change? Two unrelated requests in one proposal produce a delta that modifies two capabilities for no reason they share. The split is far easier here than after the specification exists.
3. Claims: is each capability that the file names as Modified a file that already exists under `openspec/specs/`? Is each one that it names as new absent from there?

The first two passes come first, because nothing written after the proposal can find what they find. Every later artifact faithfully answers a draft that answers the wrong problem. A draft that holds two changes produces a specification that serves neither of them.

Waiting until the delta and the design exist does not make this reading unnecessary. It makes it a reading of three files that were written from one wrong premise. That is the most expensive reading there is.

Each part fails in ways that a drafting agent produces readily. The table below puts those failures beside the check that catches them. The rows follow the order in which the file is read: first the request as a whole, then each part in the template's order, then what follows the proposal.

| Check | The proposal passes when | How a draft can fail |
|---|---|---|
| The request is answered as meant | A reviewer can say which request the draft answers. Nothing in it answers an assumption that the agent made instead | The draft serves a request nobody made. The agent took a solution named in the request as the problem, and every part after the Why follows it |
| The change is one change | A reviewer can name the single problem it answers. No part of the request would survive on its own | Two unrelated requests are in one folder. The delta modifies two capabilities for no reason they share |
| Why: the problem is stated without its solution | The Why names a situation or a finding. No method, data structure or requirement wording has been carried into it | The Why names a method, a data structure, a library or a requirement's wording. Or it describes the change rather than the problem, and reads as a summary of What Changes |
| Why: the reason can be checked | The claims in the Why can be confirmed from the request, an artifact or the running system | The Why cites evidence that a reader cannot follow to a file, or it names a failure without saying where it was found |
| What Changes: behaviour, not a plan | The part says what the system will do or say that it does not do today. It lists no artifact, file or step | The part lists artifacts to write, files to edit or steps to take. Three effects on three capabilities read like one change |
| What Changes: removals and breaking changes are visible | Anything that the change takes away, or breaks for an existing user of the system, is stated as such. A breaking change is marked **BREAKING** | A removal is written as an addition, or a breaking change is not marked. So the reader does not see what the change takes away |
| Capabilities: the boundary is deliberate | Each name is either an area of behaviour already under `openspec/specs/`, or genuinely new. The heading matches which one it is | The agent invents a capability name, or files a new one under Modified. Validation does not read the part (section 5.2), and `archive` refuses a Modified entry for a capability that is not there |
| Impact: the forecast is honest | The things that the change is expected to affect are named. Files that may be created are marked as such. Nothing is claimed that the design will have to contradict | The part is an inventory of files that do not exist yet, or it is empty |
| The scope stays open for later artifacts | Any case that the proposal leaves to the specification on purpose is visible to the next artifact, and is not lost between them | The boundary is drawn where the specification or the design cannot honour it. The disagreement is found after all three exist |

The table is a memory aid, not a gate. No part of the tool reads it, so a row that passes records a person's judgement and not a machine's check. The last row is the only one that is not about the file on its own. A proposal is finished when what follows can honour its boundary, not when its parts have been filled.

## 5.9 Changing a proposal after review

When the review finds something, two decisions follow: what has to change, and who changes it. The first decision depends on how much of the change exists:

| What exists | What the revision covers |
|---|---|
| Only the proposal | The part, and the parts coupled to it: Capabilities and Impact are written from What Changes, so a change to one can move the other two. A review that found two changes in one ends with two folders, not with a longer sentence. The file should be right rather than faithful to its first draft, and version control already holds the history worth keeping. |
| The delta, the design or the tasks | Those artifacts too, because they were written from the part that changed. A proposal that says one thing while the delta says another is worse than either alone. Somebody will find the disagreement later and will have to guess which of the two was meant. |
| An archived change | Nothing in the archive. The archive is the record of what was decided when it was decided, and editing it afterwards destroys the only account of how the current specification reached its form. A gap that appears later is argued in a new change whose Why cites the change that missed it. |

The example shows the bottom row and not the middle one. Its second change was written after the first was archived, from the failure that section 4.7 shows. Its artifacts were written together. So the archive holds no proposal that was revised while its delta, design or tasks existed. The bottom row is what `refuse-without-exact-change` does to `give-exact-change`. It argues the gap in a new change, and it does not revise the change that is closed.

The second decision is about the means, and there are two of them. The developer can open `proposal.md` and write the replacement. Or the developer can ask the agent to revise the part. The choice depends on one question: is the corrected text already known? A developer who can say the sentence before opening the file should write it. Opening the file in an editor costs a minute, and it leaves a diff that shows only what moved. A developer who knows only that something is wrong needs the right text to be worked out. Working it out means reading `openspec/specs/`, the request or the artifacts already written. That is the agent's part of the work, and it is the division that section 5.1 described. The two means differ in when they are right, in what they cost, and in how they go wrong:

| | The developer edits the file | The agent is asked to revise it |
|---|---|---|
| Right when | The replacement is already known, and the fault is in one part | The correct text has to be worked out from the repository, or from a request that the developer can describe but not yet phrase |
| What it costs | A minute with the file open, and a diff that shows one sentence | A request that has to be specific, a whole file to read back, and a diff that may show more than was asked for |
| How it goes wrong | The named part is fixed and the parts coupled to it are not. So the file contradicts itself further down | A request that names a symptom, such as asking for the Why to be clearer, returns a rewrite whose scope has moved. The size of the diff hides it |
| What to check afterwards | The coupled parts listed in the earlier table | The whole file, including the parts that were not meant to move |

The first case is small. Suppose the first draft's What Changes had listed the specification among the things to write, which section 5.5 warns against. The review finds a task in a part that describes behaviour. The developer can write the replacement sentence without help: the machine holds coins, and it returns the difference between what was inserted and the price. Nothing else needs to move. Capabilities already names `purchase`. Impact already names the file that will carry the requirement. The Why never mentioned the specification at all. One sentence is wrong, and its replacement is known. The diff should show nothing but that sentence.

In the second case, the answer is not in the developer's head. Suppose the draft had filed the change under a new capability called `change-giving`, while `openspec/specs/purchase/spec.md` already holds the requirement that changes. The name in the file has to be the name that the repository uses. Correcting it moves three places at once: the heading that says whether the capability is new or modified, the bullet beneath it, and the Impact line that names the file. A request for that revision works when it says three things:

1. which part to revise;
2. what is wrong with it: `change-giving` is not a capability under `openspec/specs/`, and the capability that is already there is `purchase`;
3. what must not move: here, the Why and the What Changes, because the review has already passed them.

A request that leaves out the third part invites a rewrite of the file. An agent has no reason to keep what it was not told to keep.

Both means end in the same reading, and that reading decides whether the proposal is approved. An edit is checked by its diff. The diff shows what moved, and anything outside the coupled parts is a mistake to revert. A revision made by asking is a rewrite, not an edit, so the whole file is read as a new draft. A moved boundary hides in the parts that nobody asked about. The reading consists of the passes from section 5.8. The file is ready again only when each pass holds for the text that is now in it.

## 5.10 What the proposal passes on

The proposal does not make every decision that the change needs. The sections above named the artifact that takes each decision it leaves. The cases that a requirement must satisfy go to the specification, which the next chapter discusses. The proposal says what the system will do. The specification says it as a requirement with scenarios that decide it case by case. Three things go to the design: the order in which the system works, the method it uses, and what the change will not do on purpose. The design also holds the alternatives that were rejected. An unknown that can wait goes there too, as section 5.7 said.

The proposal keeps the problem and the scope that answers it. That is why its four parts stop where they do. Why names a situation or a finding. What Changes says what the system will do that it does not do now. Capabilities says where that will be written down. Impact says what else is expected to move. Each of the four is checked against an artifact that comes later, and the proposal is the cheapest place to correct any of them.

The proposal leaves this chapter at the point where its promise becomes testable. Everything so far has been about the argument: why the change exists, what it changes, and whether the boundary it draws is honest. The next artifact is not an argument. It is a requirement that the system must satisfy, with a set of scenarios by which that requirement can be decided. The case that the example's first requirement left open is found there. It is found when a scenario is written for a stock that the first requirement did not mention.

A proposal is drafted by an agent and owned by a person, and the review exists for that ownership. The file asks four questions, and the tool checks almost none of the answers. Validation never opens the file. Archive warns about the length of one part and the emptiness of another. The rest is a person's judgement. A reason can come from the situation that a change serves, or from the evidence that a failed attempt left, and neither is the better kind. The parts that are easy to get wrong are the ones that describe a solution, a plan or a complete inventory. A drafting agent produces those most fluently. The review is one reading, written out as a checklist in the file's own order. The two checks that come first are the ones that nothing later can repair. When the review finds something, the first question is how much of the change already exists. The second is whether the replacement is known. An edit is cheaper when it is known, and a request to the agent is the way when it is not. What the change will not do belongs to the design. Which cases a requirement must satisfy belongs to the specification. So the proposal is the statement that is made first and revised most cheaply. A reader should therefore carry away a habit, not a template. Treat the proposal as the first place where a boundary is stated. Review it before anything is built from it. Expect the artifacts that follow to hold it to what it opened.
