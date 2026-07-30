---
description: Flesh out a plan file and then implement it.
argument-hint: [path/to/spec.md]
---

# Plan and implement something

This skill takes a path to a plan file as input. Most input from the user will
come from this file. If it doesn't already exist, create an associated
"questions" file by replacing the `.md` extension with `.questions.md`. In both
the planning and implementing steps, use an async-ish communication approach:

- Whenever you finish a turn, start polling the plan file every 2 seconds to see
  if it's been modified.

- The plan file will be in its own git repo, separate from the git repo the code
  is in. Pay particular attention to unstaged changes in the plan file. The user
  will stage parts of the plan file that have been implemented to their
  satisfaction. Also, whenever you read the plan file you should copy it into a
  scratch space. Then when there are future changes you can use `diff` to see
  exactly what changed.

- Write your questions to the questions file as you go. The user will read them
  and then update the plan file. The questions file does not need to include
  instructions about how to use the file--the user already knows how.

- As you go, try to check the plan file at least once every couple minutes,
  since if the direction has changed significantly, whatever you're working on
  may no longer be needed.

- Never wait to receive answers to questions, especially in the implementation
  phase, except as described in this task. Do the best with the information you
  have, and you can always redo work later after the user updates the plan file.

- Put a "todo" section at the top of the questions file that has a brief
  bulleted list of what you're currently doing and what you'll be doing next.
  One line per bullet is sufficient. If all work is finished and you don't have
  any open questions, the questions file should be empty.

The user may still use the regular CLI prompt to ask questions/discuss things,
but instructions will come via the plan file.

## Plan

Interview me relentlessly about every aspect of this plan until we reach a
shared understanding. Walk down each branch of the design tree, resolving
dependencies between decisions one-by-one. For each question, provide your
recommended answer.

List the questions sequentially in the plan file. Revise your questions as the
plan file gets updated. When a question is answered fully, remove it from the
questions file.

If a fact can be found by exploring the codebase, look it up rather than asking
me.

Do not move on to implementation until I confirm we have reached a shared
understanding. At this point the questions file should be empty.

## Implement

As you implement, if additional questions arise, put them in the questions file.
Continue checking the plan file for changes, and delete your questions when
they're answered fully. Again, don't pause implementation work to wait for an
answer: make your best guess and keep going until the user gives you more
direction via the plan file.

Verify all your work. Don't leave any verification steps to the user.

The user will put feedback on your changes in the plan file as needed. They will
stage your code changes as they review, so you should never stage or commit any
code. You can still make additional changes to staged code as needed.

*Never* write comments or docstrings unless the user tells you to explicitly.
The user will do that later. And yes, I *really* mean this.

After you've finished implementation and verification, wait for the user to
confirm if implementation is done or if they have more updates for the plan.
