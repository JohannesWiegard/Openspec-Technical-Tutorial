# 18. A Customization Beyond the Documented Means, and What It Rests On

Chapters 13 and 14 customized OpenSpec through the files it documents: the profile, the project configuration and the schema. This chapter takes a need that none of those files meets, and a customization that a project built for it anyway. It asks which documented means were tried and why each fell short, what was used instead, on what each part of it rests, and why it is still there after `openspec update`. The example is a customization made for one use case, and the chapter shows it as far as the reader needs it to follow, and no further.

## 18.1 A state that outlives the conversation

Explore keeps what it finds in the conversation. The skill `openspec-explore` says so in one of its rules: "Track decisions in the conversation, not in files." Section 10.1 showed the consequence: explore leaves nothing unless the developer asks for it to be captured as a change.

That is enough for an exploration that ends in one sitting. It is not enough for one that is carried out over several sittings, or that moves to a new session, because a new session begins without the conversation of the last one. What was decided, what is still open and what was rejected are then held by the developer's memory, or by nobody.

The customization keeps that state in a file. The file holds the latest state of one topic: its decisions, its open questions, the options it rejected and its next step. It is not a transcript, and it is not an artifact of a change. It exists before any change does, and it is removed once the change it led to has been proposed.

## 18.2 What the documented means cannot reach

The first question of section 13.1 is which kind a need belongs at. For this need the answer is none of them, and the table says why for each means that was considered.

| Means | What it reaches | Why it cannot carry the rule |
|---|---|---|
| An edit to the generated skill `openspec-explore` | The text the agent reads in explore | `openspec update` writes the skill back. In the scratch project, a line added to it was gone after the update, which reported that the "skill files differ from the generated content". |
| `operations` in the configuration | Advice for apply and archive | The documentation names `operations.apply.guidance` and `operations.archive.guidance`, and nothing for explore. A run showed that an entry for explore is ignored with a warning. |
| `rules` in the configuration | The instruction of the artifact whose id matches | Explore writes no artifact while it explores, so no rule is ever read for it. |
| A schema, or a fork of one | The artifacts of a change, their order, and what the agent is told when it writes each | A schema has no place for an instruction that holds while a conversation goes on. |
| The profile | Which workflows are installed | It selects workflows and changes none. |

Of the five, the schema needs a closer look, because chapters 13 and 14 used one to add a file to every change, and that seems the obvious way to add a file here too.

A schema describes a change: which files it has, in which order they are written, and what the agent is told when it writes each one. Explore comes into contact with a schema only where there is a change. When the developer explores a change that already exists, the schema tells explore which files to read. When the developer asks for the exploration to be captured as a new change, the schema tells explore what to write.

The log is needed earlier than either. It is written while the developer and the agent are still talking, before any change exists, and at that point explore reads nothing from a schema. A fork would come too late. It could also only add a file to a change, and that file would stay in the change and go into the archive with it, which is the opposite of a note that is removed once a change has been proposed.

Chapter 14's trace shows the difference. The trace belongs to a change and is meant to be kept in the archive, so a fork was the right way to add it. The log belongs to the conversation before there is a change, so a fork is the wrong way, and the cost of keeping one up to date, which sections 13.5 and 14.7 describe, would buy nothing.

## 18.3 The configuration's context, and a text of the project's own

Two things carry the customization. The rule reaches explore through `context` in `openspec/config.yaml`, and the procedure is held in a text that the project wrote itself.

The documentation says that context "appears in ALL artifacts", and section 13.3 showed it returned with every instruction the agent asks for. That is the documented part. Explore is not an artifact, and the documentation does not say that explore reads `context`. The generated skill does: at its start it reads the project's `openspec/config.yaml` and treats `context` and `rules` as constraints to follow and not to copy. So the rule reaches explore because of what the skill does, not because of what the documentation promises.

This is the paragraph of `context` in the project's `openspec/config.yaml`, as the change `add-explore-log` left it. It is shown without its indentation, with its lines broken anew and split into paragraphs; the wording is unchanged.

```text
Explore log (owner, 27 November 2026): during an explore session, follow
the project skill explore-log (`.agents/skills/explore-log/SKILL.md`).

At the start of a new session, read the matching log before the first
checkpoint.

Keep the current state in openspec/.explore/log-<topic>.md, one file per
topic, written at checkpoints by a subagent.

This log write is the one explore write allowed without asking; every
other write keeps the confirmation rule.

The directory is ignored by git.

A standalone openspec-propose run deletes the matching log; ask when the
match is ambiguous. Explore's own capture leaves it in place.
```

The paragraph calls the text a project skill. The name says where the text is kept and what form it has: it is a `SKILL.md` in a folder of its own under `.agents/skills/`, beside the skills OpenSpec generates, and like them it begins with front matter that gives a name and a description. In this book a skill is the text through which OpenSpec delivers one workflow, as section 9.2 describes, or the router, which section 9.3 describes as the one skill that picks among the workflows instead. This text is neither. It delivers no workflow of its own; it adds rules to explore, which the generated skill `openspec-explore` delivers. OpenSpec does not generate it, and no documentation names such a text as a means of customization. This chapter therefore calls it the project's own text.

The project's own text holds what the paragraph only names: when to write, how the topic of a file is chosen, what a new session does first, and what the file contains. The file has the same sections every time.

```markdown
# Explore log: <topic>

Last updated: <YYYY-MM-DD>

## Topic

## Current state

## Confirmed decisions

## Open questions

## Rejected options

## Next step
```

The text also says how the write is handed to a second agent in each coding tool the project uses. Those lines name the tools and are left out here.

## 18.4 The log, and the read its first version lacked

Each rule of the log answers one way in which a resumed session could start from the wrong state.

| Rule | What it prevents |
|---|---|
| One file per topic, under `openspec/.explore/` and outside `openspec/changes/` | A log read as a change: in a run, `openspec list` did not show it. |
| A topic suffix chosen at the first checkpoint and kept for the session; a new file only after the developer agrees | One topic's log overwritten by another's. |
| The whole file replaced at each write, never appended to | A file that keeps decisions which were later reversed. |
| A write at a checkpoint only: a decision confirmed, an open question opened or closed, a change of direction, the end of the session, or the developer's request | A write after every turn, which costs time and races the conversation. |
| The write handed to a second agent | The conversation stopping for a file. Whether it waits for the write depends on the coding tool. |
| The log write the one write explore makes without asking | A yes or no at every checkpoint, which the generated skill would otherwise require. |
| The standalone propose workflow removes the matching log; explore's own capture leaves it | A log that outlives the change it led to, or one removed while explore still needs it. |

The first version had every rule of the table and no rule for reading. It said when to write and how, and nowhere that a new session should look at what was already there. Its own checks passed, and it validated. Reading the rules against the use case, before the change was archived, showed the gap: a new session that chose the same suffix would replace the earlier state with its own at its first checkpoint, and a session that chose another would leave two logs for one topic. Either way, the case the customization was made for was the case it failed. The rule that closed it says that a new session lists `openspec/.explore/`, reads the log that matches its topic, and starts from that state before its first checkpoint. In a later run, a new session read a log seeded with a confirmed decision and wrote one that kept it.

A hook of the coding tool that runs when a session starts was considered as a way to make the read certain, and rejected. It runs before the developer has said what the session is about, so it cannot know which log matches, and it would have needed one implementation for each coding tool.

## 18.5 What survives an update, and on what grounds

`openspec update` rewrites the files it generates and leaves the rest. In the scratch project, created with `openspec init --scope project`, three things were changed by hand before the update: a line was added to the generated explore skill, a folder of the project's own was added to the skills folder, and a `context` entry was added to `openspec/config.yaml`. After the update, the line in the generated skill was gone, and the folder and the entry were as they had been.

That is why the customization was built from those two files and not from an edit to the generated skill. How far it can be relied on differs for each part.

| Part | What it rests on | What a later release could change |
|---|---|---|
| The `context` entry, and that it is returned with every instruction | The documentation, and the configuration being the project's file | Nothing that the documentation does not announce. |
| That explore reads `context` | The text of the generated explore skill | The skill is rewritten at every update, and a new text may read the configuration differently or not at all. |
| That `update` leaves a folder of the project's own in the skills folder | One run, on one release | Nothing promises it. The documentation says nothing about files that `update` does not manage. |

Only the first row is a promise. The other two are behaviour, and behaviour is checked again after each update rather than assumed. The project has a check program of its own for that, outside OpenSpec, which confirms after an update that the text is in place, that `context` still names the log's path and that the log's folder is still ignored by git. It confirms that the parts exist, which is the form of section 13.8, and not that explore still reads them.

## 18.6 What it costs, and where it stops

The customization has costs that no check reports. The `context` paragraph is returned with every instruction, so it is read when a proposal, a design or a task list is written, and at every apply and archive, where it has nothing to do. It also says again part of what the project's text says, so the same rule is written twice and the two can drift apart, which nothing would report. Whether the agent reads the log at the start of a new session depends on the model following the text, and a run shows that it did once, not that it always will.

It stops at one person. The log is ignored by git, so it exists only in one working copy, and another person on another machine never sees it. Two people exploring one topic in the same working copy would each replace the whole file. An exploration shared between people would need a log under version control, a rule for who commits it and when, and a way to merge two states of one topic, and the customization was kept to one person rather than take those on.

A need that no documented means meets can be met by pairing the one documented channel that reaches the workflow, the configuration's `context`, with a text of the project's own, and the pair survives an update because the update rewrites only what it generated. It survives only as far as its grounds go. What the documentation states holds; that explore reads the configuration and that the update leaves a foreign folder alone is behaviour, to be checked again at every update, and no check of the project's or of OpenSpec's says whether the customization still meets its use case. That was shown once already, when every check passed on a version that did not read its own log, and only trying the use case against the rules found it.
