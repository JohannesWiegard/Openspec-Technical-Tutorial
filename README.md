# Spec-Driven Development

*A book about learning it in practice*

by Johannes Wiegard

This book follows Spec-Driven Development from the first prompt to an archived
change, using OpenSpec as its one worked implementation. It explains how the
method is meant to work, and it records what worked in practice, what did not,
and where the method added effort of its own.

The book names no tool other than OpenSpec. It does not compare coding
assistants or recommend one.

## Reading the book

The book is published in several formats. All of them contain the same text.

| File | Format | Best for |
|---|---|---|
| [`dist/sdd-book-a4.pdf`](dist/sdd-book-a4.pdf) | PDF, A4 portrait, 154 pages | reading on screen or printing single sheets |
| [`dist/sdd-book-a5.pdf`](dist/sdd-book-a5.pdf) | PDF, A5, 244 pages | reading on a tablet |
| [`dist/sdd-book.epub`](dist/sdd-book.epub) | EPUB 3 | e-readers |
| [`dist/book.html`](dist/book.html) | single HTML page | reading in a browser |
| [`dist/sdd-booklet-a4.pdf`](dist/sdd-booklet-a4.pdf) | PDF, A5 pages imposed on A4 landscape, 122 sides | printing a folded booklet |

The Markdown source of every chapter is in [`chapters/`](chapters/). GitHub
renders those files directly, so the book can also be read chapter by chapter
here.

## Chapters

The two-digit prefix of each file is the reading order.

| | Chapter |
|---|---|
| 1 | [From AI-Assisted Coding to Spec-Driven Development](chapters/01_intro.md) |
| 2 | [The Cornerstones of Spec-Driven Development](chapters/02_cornerstones-of-spec-driven-development.md) |
| 3 | [How OpenSpec Carries the Cornerstones](chapters/03_openspec-conventions.md) |
| 4 | [One Change from Request to Archive](chapters/04_one-change-from-request-to-archive.md) |
| 5 | [The Proposal and the Scope It Sets](chapters/05_the-proposal-and-the-scope-it-sets.md) |
| 6 | [The Specification and the Cases That Decide It](chapters/06_the-specification-and-the-cases-that-decide-it.md) |
| 7 | [The Design and the Decisions That Can Be Traced](chapters/07_the-design-and-the-decisions-that-can-be-traced.md) |
| 8 | [The Tasks and the Evidence That a Check Was Made](chapters/08_the-tasks-and-the-evidence-that-a-check-was-made.md) |
| 9 | [The Workflows and Who Does the Work](chapters/09_the-workflows-and-who-does-the-work.md) |
| 10 | [The Planning Workflows and What Each Leaves Behind](chapters/10_the-planning-workflows-and-what-each-leaves-behind.md) |
| 11 | [Apply and Validate, and What a Tick and a Pass Show](chapters/11_apply-and-validate-and-what-a-tick-and-a-pass-show.md) |
| 12 | [Sync and Archive, and the Record They Leave](chapters/12_sync-and-archive-and-the-record-they-leave.md) |
| 13 | [Customizing the Harness, and What the Tool Checks](chapters/13_customizing-the-harness-and-what-the-tool-checks.md) |
| 14 | [A Customized Change, from Fork to Archive](chapters/14_a-customized-change-from-fork-to-archive.md) |
| 15 | [The Workflows Outside the Table](chapters/15_the-workflows-outside-the-table.md) |
| 16 | [What No Check Compares](chapters/16_what-no-check-compares.md) |
| 17 | [The Commands No Workflow Calls](chapters/17_the-commands-no-workflow-calls.md) |
| 18 | [A Customization Beyond the Documented Means, and What It Rests On](chapters/18_a-customization-beyond-the-documented-means.md) |
| 19 | [What the Book Describes, and What It Leaves Open](chapters/19_what-the-book-describes-and-what-it-leaves-open.md) |

## Printing the booklet

`dist/sdd-booklet-a4.pdf` is a saddle-stitched booklet: sheets nested inside
each other, folded once, and stapled on the fold. Print it with these settings:

- **double-sided**, flipping on the **short edge**;
- **A4**, with no scaling, because the sheets are already A4 landscape;
- plain paper, which folds and staples better than card.

Then fold the whole stack in half and staple it twice on the fold.

If the backs come out upside down, the printer driver is reading the
orientation the other way round. Choose the long edge and print again. One of
the two settings is always correct.

The booklet has 122 sides, so it needs 61 sheets. Any blank pages at the end
are padding that completes the last sheet.

## Versions

The book describes OpenSpec 2.2.0, as checked on 26 November 2026. Later
versions may behave differently. The date on each title page shows when that
edition was built.

## Licence

This book is a personal learning project. No licence has been granted yet, so
all rights are reserved by the author.
