## Working on PRs

If I ask you to make some code changes, be sure to commit all your changes and push them to a PR (creating it if needed). Since you're running in a sandbox, I can't see your changes until they've been pushed.

Preface your own comments with "AGENT:" so it's clear those are your comments,
not mine.

Reply to each of my comments both so I know that you've seen and addressed each
of my comments and so that I understand your reasoning for any
deviations/workarounds you've employed when following my instructions. Otherwise
I might think you just didn't understand my instructions. If I ask you a
question in one of my PR comments, that's not rhetorical: I want you to reply to
the comment and answer the question. I need to understand the reasoning behind
the choices you make.

We control all the "biff" library repositories. When you're working on Biff,
changes don't need to be limited to the current. It's better to open a PR to an
additional repo than to implement some workaround.

Use clojure-mcp-light to fix paren matching problems.

whenever you create a new branch, pull the latest commits for the target branch
(usually master) first.

If you notice pre-existing test failures, don't ignore them. try to fix them
even if they're unrelated to whatever else you're doing.

Don't worry about backwards compatibility unless I tell you to or if there's
actual code that's depending on the old implementation. In most cases when I
tell you to change e.g. a function to work a different way, I don't want to also
maintain support for the old way. It clutters up the logic making it harder to
understand.

When you're about to end a turn, check the issue/PR you've been working
on and see if there are any new comments. If so, go ahead and address them (and
then check for new comments again afterward, etc). Also take another look at all
unresolved comments on the PR (even if you've seen them before) and ensure
you've addressed them. DON'T mark the comments as resolved: I will do that once
I've verified you've addressed them.

When you're ready to finish, **make sure the new code actually works.** That
means you should run the code. If it's frontend code, use a playwright instance
to do so. If there are tests (and in most cases there should be), ensure they
all pass. Then (re)start the app so that I can try it. Ensure the app starts up
successfully.

If you're updating an existing PR, leave a final summary comment.

## Writing specs

Treat specs as behavioral contracts, not as reference docs. The spec should say
what the system must do, what constraints matter, what edge cases we care about,
what is out of scope, and what is still undecided. Reference docs can be written
later to describe how to use the finished thing.

When I ask you to write a spec, don't jump straight into drafting unless the
request is already precise. Start by interviewing me to clarify. Do spec
interviews conversationally in the normal chat interface: ask one topic at a
time, let me reply freely, and adapt based on my response. Do NOT use survey
forms, fixed-response questionnaires, or other rigid interview formats for spec
work.

Start by interviewing me to clarify:
- the problem we're trying to solve
- the surfaces/commands/features affected
- desired behavior
- defaults
- failure behavior
- compatibility constraints (if any)
- platform/environment assumptions
- explicit non-goals
- open questions or tradeoffs

Then draft a concise spec. Prefer small iterative specs over large up-front
specs. Start high-level and only add detail where the implementation or review
process keeps going wrong.

After drafting, critique the spec before implementing anything. Look for:
- ambiguity
- contradictions
- missing scenarios / edge cases
- places where the spec is really implementation detail in disguise
- places where the intended behavior is not testable/verifiable

Use RFC-style MUST/SHOULD/MAY language sparingly, only where it helps remove
real ambiguity.

For most Biff work, aim for spec-anchored rather than spec-as-source: keep the
spec around and update it with behavior changes, but don't assume humans should
stop reading or editing code.

If a behavior change lands without the corresponding spec update, treat the work
as incomplete. When we're discussing a spec interactively, update the spec files
as decisions are made so they don't get lost to context limits or compaction. If
there's already a branch/PR for the spec work, commit and push the updated spec
files as the conversation progresses instead of waiting until the very end.

A second-model pass can be useful for larger or riskier specs, but don't make it
part of the default workflow. First get value out of lightweight, reviewable
specs.


When a repo doesn't have specs yet, start with a simple top-level `spec/` folder.
A good default layout is:

```text
spec/
  README.md
  index.md
  <area-or-feature-1>.md
  <area-or-feature-2>.md
```

Use `spec/README.md` to explain what specs are for in that repo and how detailed
they should be. Use `spec/index.md` as a table of contents / map of the current
specs.

Keep the structure shallow. For a new or small set of specs, prefer flat files in
`spec/`. If the set grows, add at most one level of grouping, e.g.
`spec/<area>/<feature>.md`. Don't create a maze of nested folders unless there's
a clear payoff.

Organize specs by behavioral area or feature, not by individual source file, PR,
or tiny implementation task. In general, the spec should outlive the current PR
and stay useful when the code changes later.

If a repo is just starting out, prefer writing one or two strong specs for the
highest-value areas rather than trying to spec the whole codebase at once.



