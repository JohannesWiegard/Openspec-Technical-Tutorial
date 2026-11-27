# 3. How OpenSpec Carries the Cornerstones

Chapter 1 introduced OpenSpec as one example of a spec-driven workflow and named
its artifacts in passing. Chapter 2 named the principles those artifacts have to
satisfy. This chapter shows how one set of conventions implements those
principles, and where the conventions stop.

It is a map, not a manual. One section gives the technical background, for the
reader who wants to know what the conventions run on; installation, commands
and configuration belong to the tool's own documentation. What matters here is
the shape of the record: where intent is written down, how a proposed change is
separated from the system as it is, and what keeps the two connected. A
different tool could arrange the same material under other names and still
serve the same principles. The question to carry through the chapter is not
what the tool does, but which principle each convention serves.

## 3.1 What the tool is made of

OpenSpec is a small program, not a platform. It is an open-source command-line
tool, MIT-licensed and maintained by Fission-AI, written in TypeScript and
distributed as an npm package or as a standalone binary that runs without
Node.js. It is installed once on a machine and used per project; there is no
service to sign up for and nothing to host. The project's own development is
planned with OpenSpec, so its repository is a working example of the
conventions this chapter describes.

All of a project's artifacts are Markdown in the repository. There is no server,
no daemon, no database and no API key: nothing the work depends on runs between
commands, and what the project plans and specifies lives in Markdown files and
nowhere else. The program does keep some state on the machine: the global
configuration with its profile, schemas a user shares across projects, skills
installed for every project, and stores registered as standalone OpenSpec
repositories. It also sends anonymous usage statistics, the command's name and the
release and nothing of the project, unless `OPENSPEC_TELEMETRY=0` or the
configuration turns them off. The `openspec/` tree is
plain files, versioned and shared by git like any other file. A project that
stops using the tool keeps files any editor can read: the format is Markdown,
and the tool operates on it rather than containing it.

The work is split between the agent and the program. The agent in the coding
tool drafts and edits the artifacts, because that part needs language and
judgment. The program does what should not depend on a model: it parses the
Markdown structure, checks the conventions, counts task checkboxes to compute
progress, and refuses a change that fails validation. The merge of a delta into
the main specifications at archive has two paths: the `openspec archive` command
makes it in the program, and the archive workflow has the agent make it,
following the rules of the sync workflow, and then validates the main
specifications. A later chapter describes both. Reporting commands can emit
machine-readable output, so the checks can run wherever checks belong. A model
writes, a program verifies, a person approves. A passing validation is a
structural fact, not a verdict on the requirements — chapter 2's limits apply
unchanged — and structure is exactly the part a program can be trusted with.

Integration with the coding tools is by generated files, not by a protocol. The
setup command, `openspec init`, writes OpenSpec's skills into one shared
directory, in whatever file format the tools expect. By default that directory
is `~/.agents/skills/`, shared by every project on the machine. With `--scope
project` it is the repository's own `.agents/skills/`, and the line
`skillsScope: project` in the project's configuration records that choice for
everyone who clones it. Every skill but one delivers one workflow, which is
OpenSpec's word for one action on a change, and a profile chooses which
workflows are installed. The exception is `openspec`, a router that picks the
right skill for a request, and every profile installs it alongside the rest.
A coding tool reads that directory, directly or through links of its own.
The current release writes no slash commands. The release this
description was checked against is named in the repository's README. The
`openspec update` command regenerates those files when the program changes, so
the instructions an agent sees stay in step with the program that checks its
work. No protocol stands between the program and the assistant — not an MCP
server, not an API — and no assistant is privileged. What the integration
moves is text, and text is the one thing every coding tool already reads.

The shape of a change is data. A schema is a folder of plain files: one YAML
file that declares each artifact a change produces — the file it generates,
what it requires first, and the instruction the agent receives when creating
it — and one Markdown template per artifact. A line in the project's
configuration names the schema to use. The default produces the four artifacts
this chapter walks through: proposal, delta specifications, design and tasks.
A project can fork a schema and edit it — drop an artifact, add one, rewrite
the instructions — and the program then enforces the project's schema as if
it had shipped that way. The dependencies between artifacts are enablers, not
phase gates: they say what becomes possible, not what must happen next. What
a change folder contains is fixed by the project, not by the tool, and the
tool checks whatever the project declared.

With the tool's nature stated, what remains to describe is what those files hold.

## 3.2 The shape of the record

The design is easier to hold when it is reduced to two locations in the
repository. One set of specifications describes the system as it is today. A
separate set of change folders describes work that is proposed or in progress.
Both live in a directory called `openspec/`, next to the code they describe.

Everything else in this chapter follows from that split. If the specifications
described only the work in progress, the project would have plans and no memory.
If they described only the current system, a change would have no place to say
what it intends. Keeping both in one repository is what lets a reader ask two
separate questions: what does this system do, and what is about to change?

## 3.3 The system as it is

The specifications under `openspec/specs/` are organized by capability. A
capability is a coherent area of behaviour, and each one holds requirements and
scenarios. A requirement states what must be true of the system. A scenario gives
one concrete case that shows the requirement being met or missed.

This is the cornerstone of current-state knowledge made concrete. A developer or
an agent who needs to know how the system behaves can read the capability
instead of reconstructing it from code, diagrams or memory. The specification is
not a summary of the code and it is not a design document. It states the
behaviour the code is supposed to have, which is why it can be used to judge the
code rather than merely describe it. That is what the convention asks for, and
it is not what most repositories contain: most specifications written this way
carry implementation detail, and the detail is there because it helps the agent
that reads it. The rule protects the part that has to outlive the code. That is
the cornerstone of the specification as shared reference.

## 3.4 A change as a folder

A proposed modification lives in `openspec/changes/<change-name>/`. The folder is
self-contained: it holds the four artifacts the default schema produces, and the
point here is that they sit together.

That grouping is the cornerstone of a change as a first-class unit, and it is the
cornerstone of reviewability. A reviewer can read the intent,
the expected behaviour and the plan before any code exists, instead of
reconstructing them from a diff. It is also what makes a change a unit of work
rather than a side effect of version control: it can be reviewed, revised or
abandoned without leaving a half-finished branch behind.

Chapter 1 used the request "add CSV export" to show how much a single
sentence leaves undecided. The same request shows what a change folder has to
hold. As a change it becomes `add-csv-export/`, and the folder has to answer the
questions the sentence left open: which records are exported, which columns,
whether the current filter applies, how dates and numbers are formatted, and who
is permitted to export what. The illustration is not a change in this repository. Its value is that the request is small enough to hold
in mind while the conventions are introduced.

A delta specification does not repeat the whole system specification. It states
only what the change does to it, using explicit operations: a requirement can be
added, modified, removed or renamed. OpenSpec names the four ADDED, MODIFIED,
REMOVED and RENAMED, so the kind of change is part of the record rather than something a reader has to
infer. The CSV export change adds a requirement that describes export. It may also
modify a requirement about who may see which records, because exporting is one way
of seeing them. The rest of the capability is left alone.

The effect is that the behavioural impact of a change is visible in one place. A
reviewer sees both the new behaviour and its effect on existing behaviour without
holding two versions of the whole specification side by side. This is the
cornerstone of separation of current and proposed state, expressed as an operation
rather than as advice about where to write things. The same record names what the
change leaves alone: an exclusion written down is a decision, not a gap a later
reader has to guess at.

## 3.5 The rules that apply to all work

The repository also holds the rules that apply to every change: how the project
is structured, which standards apply, what must not break. They live in the
instruction files an agent reads when a session opens — `AGENTS.md`, which is
also the one such file several tools read — and in the project context the tool
loads before planning. Because those rules live with the code, the same material
is available to a developer, a reviewer and an agent.

That is the cornerstone of shared project context. It does not follow that an
agent reads the rules automatically. It follows that the rules have a place where
they can be found, and that a session which consults them starts from the
project's conventions rather than from a generic default.

## 3.6 From intent to a merged specification

The artifacts form a path. The proposal says why the work is needed — explicit
intent, written down before anything is built. The delta
says what behaviour changes. The design says how the work will be approached. The
tasks connect the design to implementation steps. Each step can be checked against
the one before it, so a disagreement between intent and plan becomes visible
before it becomes a disagreement between plan and code.

That path is the cornerstone of traceability, and it is deliberately short. A
change does not have to fill every artifact to be traceable. It has to be possible
to follow the reasoning from the request to the code without guessing which
decision came from where.

A requirement is identified by its own title. The identifier travels with design
decisions and tasks, and the specification holds the wording. Everything else
points at it: a chapter or an artifact that wants to discuss what the requirement
says uses the name and leaves the sentence where it is. Carrying the wording
along is how a second copy of a rule appears in a document edited on a different
schedule, and two copies of one rule can disagree.

Validation is the check at the end of the path. That check is the cornerstone of
validation. Acceptance criteria and tests
decide whether the implementation satisfies the specification, and the
specification is the reference for that decision rather than the implementation
being its own judge. This is what keeps a written record from becoming a
description written after the fact. If the code decides what counts as correct,
the specification records the outcome of the work. If the specification decides,
the work can fail to meet it, and the failure is visible.

Completion is what keeps the record alive. When the work is finished,
the delta is merged into the capability specification, so the description of the
system matches the system again. The change folder then moves into a dated
archive, where it keeps the record of what changed and the design that went with
it.

That is the cornerstone of living documentation, and it is the difference
between a specification written before coding and one that is maintained. The
current specification is updated because the work changed, not because someone
remembered to update it. The archive is not a backup; it is the record of how
the current description reached its form. A decision that was settled in a
conversation and never written into the change is not in it, and nothing later
can recover it.

## 3.7 What the conventions leave to people

None of this decides what to build. The conventions give intent a place, a shape
and a check; they do not supply the intent. A change folder can hold a proposal
that argues for the wrong feature, a delta that specifies the wrong behaviour and
tasks that implement it carefully. The record does not prevent that. It makes the
decision visible, which is what allows it to be challenged before it is built.

That is the last cornerstone, human control, and it is the one the conventions
cannot carry. A tool can hold a decision. It cannot make one.

Validation happens at the end of the change, and nothing checks afterwards
whether the specification and the code still agree. A later change can satisfy
its own requirement, pass its own tests and quietly break a constraint from an
earlier one; no tool in the sample was shown to look for that, and the
practitioners who wanted it had to build checks of their own. A check would show
a disagreement, not which of the two is wrong.

Most people who work this way read a specification in part rather than in full,
or hand the review to another agent. Partial reading is partly what the record
is for: the problem, the decisions and the acceptance criteria carry the intent,
and the rest is context for whoever implements. Delegating the review is the
risk, because it removes the one point at which a person decides what the system
should do. The record does not help there either: it shows the path that was
taken, and a rejected alternative survives only if someone wrote it down.

The conventions are worth reading as answers to the cornerstones rather than as a
directory layout. Ten of the eleven cornerstones have a convention in this chapter
that carries them; human control is the limit named above. The split between what
the system is and what is about to change carries most of the principles; the rest
are carried by where the material lives, by the path from proposal to tasks, and by
the fact that the specification rather than the code is what the work is checked
against. The next chapter takes one requirement through this path, from a sentence
that looks complete to the constraint that settles it.
